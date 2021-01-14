 DROP TABLE IF EXISTS #AoiTablePoint
 DROP TABLE IF EXISTS #AoiSoilsPoint
 
 DECLARE @aoiGeom Geometry;
 DECLARE @aoiGeomFixed Geometry;

-- Create AOI table with polygon geometry. Coordinate system must be WGS1984 (EPSG 4326)
CREATE TABLE #AoiTablePoint
    ( aoiid INT IDENTITY (1,1),
    pedlabsampnum CHAR(20),
    aoigeom GEOMETRY )

	-- #AoiSoils table contains intersected soil polygon table with geometry
CREATE TABLE #AoiSoilsPoint
    ( polyid INT IDENTITY (1,1),
    aoiid INT,
    landunit CHAR(20),
    mukey INT,
    soilgeom GEOMETRY )

SELECT @aoiGeom = geometry::STGeomFromText('MULTIPOINT((-91.5366669 45.3494453))', 4326);  
SELECT @aoiGeomFixed = @aoiGeom.MakeValid().STUnion(@aoiGeom.STStartPoint()); 
INSERT INTO #AoiTablePoint ( pedlabsampnum, aoigeom ) 
VALUES ('92P0439', @aoiGeomFixed);


-- Populate #AoiSoils table with intersected soil polygon geometry
--INSERT INTO #AoiSoils (aoiid, landunit, mukey, soilgeom)
    SELECT A.aoiid, A.landunit, M.mukey, M.mupolygongeo.STIntersection(A.soilgeom ) AS soilgeom
    FROM mupolygon M, #AoiSoilsPoint A
    WHERE mupolygongeo.STIntersects(A.soilgeom) = 1
/*
Soil suborder groups:
 
S1: Fribists, Folists, Hemists, Histels, Saprists, Wassists
 
S2: Aquands, Aquents, Aquepts, Aquods, Aquoxs, Cryods, Humods, Orthels, Peroxs,
Torrands, Tropepts, Turbels, Udands, Udoxs, Ustands
 
S3: Albolls, Andepts, Aquolls, Aquults, Cryands, Cryepts, Cryolls, Gelepts, Gelolls,
Humults, Rendolls, Umbrepts, Ustoxs, Vitrands, Wassents, Xerands
 
S4: Aqualfs, Aquerts, Boralfs, Borolls, Cryalfs, Ochrepts, Orthods, Orthoxs, Udalfs, Udepts,
Uderts, Udolls, Usterts, Ustolls, Xeralfs, Xerepts, Xerolls, Xerults
 
S5: Arents, Argids, Calcids, Cambids, Cryerts, Cryids, Durids, Fluvents, Gypsids, Orthents,
Orthids, Psamments, Salids, Torrerts, Torroxs, Udults, Ustalfs, Ustepts, Ustults, Xererts
 
Texture Groups:
	• Class T1 sand, loamy sand, sandy loam (with <8% clay)
	• Class T2 sandy loam (with clay >8%), sandy clay loam, loam
	• Class T3 silt loam, silt
	• Class T4 sandy clay, clay loam, silty clay loam, silty clay, clay (<60%)
	• Class T5 clay (>60%)
*/

SELECT MU.mukey, MU.musym, MU.nationalmusym, MU.muname 
FROM SDA_Get_Mupolygonkey_from_intersection_with_WktWgs84('POINT(-91.5366669 45.3494453)') as S 
INNER JOIN mupolygon MUP on MUP.mupolygonkey= S.mupolygonkey 
INNER JOIN mapunit MU on MU.mukey = MUP.mukey; 


SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS mukey, c.cokey AS COKEY, chorizon.chkey/1 AS CHKEY, compname, hzname, hzdept_r, hzdepb_r, 
CAST (ISNULL (om_r, 0) AS decimal (5,2))AS om_r,  texture

FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND mu.mukey = 625013
INNER JOIN  component AS c ON c.mukey = mu.mukey  
INNER JOIN(chorizon INNER JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey) ON c.cokey = chorizon.cokey
AND (((chorizon.hzdept_r)=(SELECT Min(chorizon.hzdept_r) AS MinOfhzdept_r
FROM chorizon INNER JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey
AND chtexturegrp.texture Not In ('SPM','HPM', 'MPM') AND chtexturegrp.rvindicator='Yes' AND c.cokey = chorizon.cokey ))AND ((chtexturegrp.rvindicator)='Yes'))
ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC, cokey,  hzdept_r, hzdepb_r
