
/** SDA Query application="ArcMap" rule="Sample Points" version="0.1" **/
-- 2021-01-19 T13:52:12
-- Declare all variables here
~DeclareGeometry(@wktGeom)~
-- Create table for input point geometry. 
-- As this query is written, coordinate system must be WGS1984 (EPSG 4326)
CREATE TABLE #poiTable
    ( id INT IDENTITY (1, 1),
    FID VARCHAR(30),
    pointgeom GEOMETRY )
;
 
-- #IntersectedSoils table will contain intersected soil polygon table (but no geometry)
CREATE TABLE #IntersectedSoils
    ( polyid INT IDENTITY (1, 1),
    FID VARCHAR(30),
    mukey INT)
;
 
-- #MapunitTbl table will contain soil mapunit information
CREATE TABLE #MapunitTbl
    ( mukey INT,
    musym VARCHAR(6),
    muname VARCHAR(240),
    mukind VARCHAR(254),
    farmlndcl VARCHAR(254),
    areasymbol VARCHAR(20),
    lkey INT )
;
 
-- #CompHz table will contain soil component and soil horizon-level information 
CREATE TABLE #CompHz
(   mukey INT,
    cokey INT,
    compname VARCHAR(60),
    compkind VARCHAR(40),
    comppct_r INT,
    majcompflag VARCHAR(3),
    localphase VARCHAR(40),
    hzname VARCHAR(40),
    hzdept_r INT,
    hzdepb_r INT,
    sandtotal_r FLOAT,
    silttotal_r FLOAT,
    claytotal_r FLOAT,
    om_r FLOAT,ec_r FLOAT, 
    dbthirdbar_r FLOAT,
    ksat_r FLOAT,
    awc_r FLOAT,
    kwfact VARCHAR(254),
    ph1to1h2o_r FLOAT,
    texdesc VARCHAR(254)
    )
;
 
-- #PublicationDate table to store survey area datestamps (sacatalog.saverest)
CREATE TABLE #PublicationDate
    (mukey INT,
   published VARCHAR(32) )
;
 
SELECT @wktGeom = GEOMETRY::STGeomFromText('POINT (-78.37884712 43.30249251)', 4326); 
INSERT INTO #poiTable ( FID, pointgeom )  
VALUES ('322', @wktGeom); 
SELECT @wktGeom = GEOMETRY::STGeomFromText('POINT (-78.35685726 43.30179718)', 4326); 
INSERT INTO #poiTable ( FID, pointgeom )  
VALUES ('334', @wktGeom); 
SELECT @wktGeom = GEOMETRY::STGeomFromText('POINT (-78.37303361 43.32368597)', 4326); 
INSERT INTO #poiTable ( FID, pointgeom )  
VALUES ('1813', @wktGeom);
-- End of AOI geometry section
 
-- Populate #IntersectedSoils table with mukeys from soil polygons and original point ids
INSERT INTO #IntersectedSoils (FID, mukey)
    SELECT A.FID, M.mukey
    FROM mupolygon M, #poiTable A
    WHERE mupolygongeo.STIntersects(A.pointgeom) = 1
;
 
-- Populate #MapunitTbl table with mapunit information for the selected mukeys
INSERT INTO #MapunitTbl ( mu.mukey, musym, muname, mukind, farmlndcl, areasymbol, mu.lkey )
    SELECT DISTINCT mu.mukey, musym, muname, mukind, farmlndcl, areasymbol, mu.lkey
    FROM mapunit mu
    INNER JOIN #IntersectedSoils AS AOIS ON mu.mukey = AOIS.mukey
    INNER JOIN legend AS L ON mu.lkey = L.lkey
    ORDER BY areasymbol, mukey
;
 
-- Populate #CompHz using dominant component, surface horizon only
INSERT INTO #CompHz
SELECT M.mukey, C.cokey, C.compname, C.compkind, C.comppct_r, C.majcompflag, C.localphase, 
H.hzname, H.hzdept_r, H.hzdepb_r, H.sandtotal_r, H.silttotal_r, H.claytotal_r,
H.om_r, H.ec_r, H.dbthirdbar_r, H.ksat_r, H.awc_r, H.kwfact, H.ph1to1h2o_r, TG.texdesc
FROM #MapunitTbl M
LEFT OUTER JOIN component C ON M.mukey = C.mukey AND C.cokey = 
(SELECT TOP 1 CO.cokey FROM component CO WHERE M.mukey = CO.mukey ORDER BY CO.comppct_r DESC, CO.tfact DESC) 
LEFT OUTER JOIN chorizon H ON C.cokey = H.cokey AND H.hzdept_r = 0
LEFT OUTER JOIN chtexturegrp TG ON H.chkey = TG.chkey AND TG.rvindicator = 'Yes'
ORDER BY M.mukey, C.comppct_r DESC, H.hzdept_r ASC
;
 
-- Populate #PublicationDate with Web Soil Survey publication dates (saverest) for each soil mapunit
-- Using dominant component and surface horizon only
INSERT INTO #PublicationDate
    SELECT M.mukey, (CONVERT(VARCHAR(32),[SC].[saverest],120) ) AS published
    FROM #MapunitTbl M
    INNER JOIN legend LG ON M.lkey = LG.lkey
    INNER JOIN sacatalog SC ON Lg.areasymbol = SC.areasymbol
;
 
-- Return the final summary table. Python script assumes the last column is WKT POINT geometry.
SELECT A.FID,  M.areasymbol, M.musym, M.muname, M.mukind, M.farmlndcl,
C.compname, C.comppct_r, C.compkind, C.localphase, C.hzname, C.hzdept_r, C.hzdepb_r,  C.ph1to1h2o_r,
C.om_r, C.sandtotal_r,  C.silttotal_r,  C.claytotal_r,  C.dbthirdbar_r,  C.ksat_r,  C.kwfact, 
C.texdesc, DS.published, S.mukey, A.pointgeom
FROM #poiTable A
LEFT OUTER JOIN #IntersectedSoils S ON A.FID = S.FID
LEFT OUTER JOIN #MapunitTbl M ON S.mukey = M.mukey
LEFT OUTER JOIN #PublicationDate DS ON M.mukey = DS.mukey
LEFT OUTER JOIN #CompHz C ON M.mukey = C.mukey
ORDER BY A.FID, M.mukey, C.comppct_r DESC, C.cokey, C.hzdept_r ASC
;
 
 