USE SDW

--DECLARE  @AreaSym VARCHAR (20) = 'M%'

------------------------------------------------------------------------------
----1. CREATE NEW TABLE THAT REMOVES NULL VALUES FROM TABULARVERSION FIELD----
------------------------------------------------------------------------------

DECLARE @saversion2 TABLE (areasymbol VARCHAR (max), areaname VARCHAR (MAX), saverest DATE, saverret DATE, saversion INT, tabularversion INT, spatialversion INT)

INSERT INTO @saversion2(areasymbol, areaname, saverest, saverret, saversion, tabularversion, spatialversion)

SELECT
areasymbol,
areaname,
saverest, 
saverret, 
saversion,
tabularversion,
spatialversion
FROM SAVERSION WITH (NOLOCK)
WHERE AREASYMBOL != 'US'--LIKE @Areasym
and tabularversion = 1

-------------------------------------------------------------------------------------------------------------------------------
----2. CREATE SECOND NEW TABLE BY JOINING FIRST NEW TABLE TO SAPOLYGON AND ONLY INCLUDE FIRST SAVERSION AND SAPATIALVERSION----
-------------------------------------------------------------------------------------------------------------------------------

DECLARE @saversapoly TABLE (areasymbol VARCHAR (max), areaname VARCHAR (MAX), saverest DATE, saverret DATE, saversion INT, tabularversion INT, spatialversion INT, sapolygonareasymbol VARCHAR (max), lkey INT)


INSERT INTO @saversapoly (areasymbol, areaname, saverest, saverret, saversion, tabularversion, spatialversion, sapolygonareasymboL, lkey)


SELECT distinct
saversion2.areasymbol,
saversion2.areaname,
MIN (saversion2.saverest) OVER (partition by saversion2.areasymbol) as saverestover,
MIN (saversion2.saverret) OVER (partition by saversion2.areasymbol) as saverret,
MIN (saversion2.saversion) OVER (partition by saversion2.areasymbol) as saversion,
saversion2.tabularversion,
MIN (saversion2.spatialversion) over (partition by saversion2.areasymbol) as sapatialversion,
sapolygon.areasymbol,
sapolygon.lkey
from @saversion2 saversion2
JOIN sapolygon ON saversion2.areasymbol = sapolygon.areasymbol and saversion2.spatialversion = sapolygon.spatialversion

-------------------------------------------------------------------------------------------------------------------------------
----3. CREATE THIRD TABLE BY JOINING SECOND TABLE TO THE LEGEND AND PULLING DATA FROM THE MAPUNITS, DUMS, AND COMPONENTS------
-------------------------------------------------------------------------------------------------------------------------------

DECLARE @finaltable TABLE (areasymbol VARCHAR (max), areaname VARCHAR (max), saverest DATE, saverret DATE, saversion INT, tabularversion INT, spatialversion INT, sapolygonareasymbol VARCHAR (max), lkey INT, legendlkey INT,
liid INT, cordate DATE, musym VARCHAR (max), muname VARCHAR (max), mustatus VARCHAR (max),farmlndcl VARCHAR (max), farmlndclsec int, muhelcl VARCHAR (max), muwathelcl VARCHAR (max), muwndhelcl VARCHAR (max),
compname VARCHAR (max), compkind VARCHAR (max), comppct_r smallint ,slope_l float, slope_r float, slope_h float, slopelenusle_l smallINT, slopelenusle_r smallINT, slopelenusle_h smallINT,
tfact INT, wei varchar (max), weg varchar (max), hzname VARCHAR (max), hzdept_r INT, kwfact varchar (max),  kffact varchar (max), surfacetexture VARCHAR (max), mukey INT, lmapunitiid INT)


INSERT INTO @finaltable (areasymbol, areaname, saverest, saverret, saversion, tabularversion, spatialversion, sapolygonareasymboL, lkey, legendlkey,
liid, cordate, musym, muname, mustatus, farmlndcl,farmlndclsec, muhelcl, muwathelcl, muwndhelcl, compname, compkind, comppct_r, slope_l, slope_r, slope_h, slopelenusle_l, slopelenusle_r,slopelenusle_h,
tfact, wei, weg, hzname, hzdept_r, kwfact,  kffact, surfacetexture, mukey, lmapunitiid)



--JOIN SECOND NEW TABLE TO LEGEND AND BRING ALL LEGEND MAPUNITS, MAPUINITS, DATAMAPUNITS, AND COMPONENTS BASED ON UNIQUE LIID
SELECT 
saversapoly.areasymbol, 
saversapoly.areaname, 
saversapoly.saverest, 
saversapoly.saverret, 
saversapoly.saversion, 
saversapoly.tabularversion, 
saversapoly.spatialversion, 
saversapoly.sapolygonareasymboL, 
saversapoly.lkey,
legend.lkey as legendlkey,
legend.liid,
cordate,
musym, 
muname,
CASE WHEN lmapunit.mustatus = 1 THEN 'provisional'   
       WHEN lmapunit.mustatus = 2 THEN 'approved' 
       WHEN lmapunit.mustatus = 3 THEN 'correlated' 
       WHEN lmapunit.mustatus = 4 THEN 'additional' ELSE '' END AS mustatus,
CASE WHEN farmlndcl = 1 THEN 'Not prime farmland'
       WHEN farmlndcl = 2 THEN 'All areas are prime farmland'
       WHEN farmlndcl = 3 THEN 'Prime farmland if drained'
       WHEN farmlndcl = 4 THEN 'Prime farmland if protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 5 THEN 'Prime farmland if irrigated'
       WHEN farmlndcl = 6 THEN 'Prime farmland if drained and either protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 7 THEN 'Prime farmland if irrigated and drained'
       WHEN farmlndcl = 8 THEN 'Prime farmland if irrigated and either protected froM flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 9 THEN 'Prime farmland if subsoiled, completely removing the root inhibiting soil layer'
       WHEN farmlndcl = 10 THEN 'Prime farmland if irrigated and the product of I (soil erodibility) x C (climate factor) does not exceed 60'
       WHEN farmlndcl = 11 THEN 'Farmland of statewide importance'
       WHEN farmlndcl = 12 THEN 'Farmland of local importance'
       WHEN farmlndcl = 13 THEN 'Farmland of unique importance'
       WHEN farmlndcl = 14 THEN 'Prime farmland if irrigated and reclaimed of excess salts and sodium'
       WHEN farmlndcl = 15 THEN 'Farmland of statewide importance, if drained'
       WHEN farmlndcl = 16 THEN 'Farmland of statewide importance, if protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 17 THEN 'Farmland of statewide importance, if irrigated'
       WHEN farmlndcl = 18 THEN 'Farmland of statewide importance, if drained and either protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 19 THEN 'Farmland of statewide importance, if irrigated and drained'
       WHEN farmlndcl = 20 THEN 'Farmland of statewide importance, if irrigated and either protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 21 THEN 'Farmland of statewide importance, if drained or either protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 22 THEN 'Farmland of statewide importance, if warm enough, and either drained or either protected from flooding or not frequently flooded during the growing season'
       WHEN farmlndcl = 23 THEN 'Farmland of statewide importance, if warm enough'
       WHEN farmlndcl = 24 THEN 'Farmland of statewide importance, if thawed'
       WHEN farmlndcl = 25 THEN 'Farmland of local importance, if irrigated'
       WHEN farmlndcl = 26 THEN 'Farmland of statewide importance, if subsoiled, completely removing the root inhibiting soil layer'
       WHEN farmlndcl = 27 THEN 'Farmland of statewide importance, if irrigated and the product of I (soil erodibility) x C (climate factor) does not exceed 60'
       WHEN farmlndcl = 28 THEN 'Farmland of statewide importance, if irrigated and reclaimed of excess salts and sodium' ELSE '' END AS farmlndcl,
farmlndclsec,
CASE WHEN muhelcl = 1 THEN 'highly erodible'   
        WHEN muhelcl = 2 THEN 'potentially highly erodible' 
        WHEN muhelcl = 3 THEN 'not highly erodibled' ELSE '' END AS muhelcl,
CASE WHEN muwathelcl = 1 THEN 'highly erodible'   
        WHEN muwathelcl = 2 THEN 'potentially highly erodible' 
        WHEN muwathelcl = 3 THEN 'nott highly erodibled' ELSE '' END AS muwathelcl,
CASE WHEN muwndhelcl = 1 THEN 'highly erodible'   
        WHEN muwndhelcl = 2 THEN 'potentially highly erodible' 
        WHEN muwndhelcl = 3 THEN 'nott highly erodibled' ELSE '' END AS muwndhelcl,
compname,
CASE WHEN compkind = 1 THEN 'family'   
     WHEN compkind= 2 THEN 'taxon above family'
        WHEN compkind= 3 THEN 'miscellaneous area'
       WHEN compkind= 4 THEN 'series'
       WHEN compkind= 5 THEN 'taxadjunct'
       WHEN compkind= 6 THEN 'variant' ELSE '' END AS compkind,
comppct_r,
slope_l,
slope_r,
slope_h,
slopelenusle_l,
slopelenusle_r,
slopelenusle_h,
tfact,
CASE WHEN wei = 1 THEN '0'   
     WHEN wei= 2 THEN '38'
        WHEN wei= 3 THEN '48'
       WHEN wei= 4 THEN '56'
       WHEN wei= 5 THEN '86'
       WHEN wei= 6 THEN '134'
       WHEN wei= 7 THEN '160'
       WHEN wei= 8 THEN '180'
       WHEN wei= 9 THEN '220'
       WHEN wei= 10 THEN '250'
       WHEN wei= 11 THEN '310' ELSE '' END AS wei,
CASE WHEN weg = 1 THEN '1'   
     WHEN weg= 2 THEN '2'
        WHEN weg= 3 THEN '3'
       WHEN weg= 4 THEN '4'
       WHEN weg= 5 THEN '4L'
       WHEN weg= 6 THEN '5'
       WHEN weg= 7 THEN '6'
       WHEN weg= 8 THEN '7'
       WHEN weg= 9 THEN '8' ELSE '' END AS weg,
hzname,
hzdept_r,
CASE WHEN kwfact= 1 THEN '0.02'   
     WHEN kwfact= 2 THEN '0.05'
        WHEN kwfact= 3 THEN '0.10'
       WHEN kwfact= 4 THEN '0.15'
       WHEN kwfact= 5 THEN '0.17'
       WHEN kwfact= 6 THEN '0.20'
       WHEN kwfact= 7 THEN '0.24'
       WHEN kwfact= 8 THEN '0.28'
       WHEN kwfact= 9 THEN '0.32'
       WHEN kwfact= 10 THEN '0.37'
       WHEN kwfact= 11 THEN '0.43'
       WHEN kwfact= 12 THEN '0.49'
       WHEN kwfact= 13 THEN '0.55'
       WHEN kwfact= 14 THEN '0.64' ELSE '' END AS kwfact,
CASE WHEN kffact= 1 THEN '0.02'   
     WHEN kffact= 2 THEN '0.05'
        WHEN kffact= 3 THEN '0.10'
       WHEN kffact= 4 THEN '0.15'
       WHEN kffact= 5 THEN '0.17'
       WHEN kffact= 6 THEN '0.20'
       WHEN kffact= 7 THEN '0.24'
       WHEN kffact= 8 THEN '0.28'
       WHEN kffact= 9 THEN '0.32'
       WHEN kffact= 10 THEN '0.37'
       WHEN kffact= 11 THEN '0.43'
       WHEN kffact= 12 THEN '0.49'
       WHEN kffact= 13 THEN '0.55'
       WHEN kffact= 14 THEN '0.64' ELSE '' END AS kffact,
texture AS 'surface texture',
mukey,
lmapunitiid


FROM @saversapoly saversapoly 
JOIN legend ON saversapoly.lkey = legend.lkey 
       AND saversapoly.tabularversion = legend.tabularversion
INNER JOIN lmapunit ON lmapunit.liidref =legend.liid
INNER JOIN mapunit ON mapunit.muiid = lmapunit.muiidref
INNER JOIN correlation ON mapunit.muiid = correlation.muiidref 
       AND correlation.repdmu =1
INNER JOIN datamapunit ON correlation.dmuiidref = datamapunit.dmuiid
INNER JOIN component ON datamapunit.dmuiid = component.dmuiidref 
       AND majcompflag =  1
LEFT OUTER JOIN chorizon ON component.coiid = chorizon.coiidref  
---RETURNS THE FIRST MINERAL OR WET ORGANIC HORIZON TO THE QUERY
       AND chorizon.chiid = 
       (SELECT TOP 1 chiid FROM component component2 
                     JOIN chorizon  on component2.coiid = component.coiid and component2.coiid=chorizon.coiidref 
                     JOIN chtexturegrp ON chtexturegrp.chiidref = chorizon.chiid 
                           AND chtexturegrp.rvindicator = 1  
                           AND texture NOT LIKE '%SPM%' 
                           AND texture NOT LIKE '%MPM%' 
                           AND texture NOT LIKE '%HPM%' ORDER BY hzdept_r ASC)
LEFT OUTER JOIN chtexturegrp ON chtexturegrp.chiidref = chorizon.chiid and chtexturegrp.rvindicator = 1

ORDER BY areasymbol, musym, comppct_r DESC, hzdept_r ASC


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----4. CREATE LAST TABLE THAT ADDS IN THE RAINFALL AND CLIMATE FACTORS FROM THE OVERLAP TABLES.  PROBABLY COULD ADD THIS TO THIRD TABLE BUT I WAS HAVING PROBLEMS.------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT distinct finaltable.areasymbol, finaltable.areaname, finaltable.saverest, finaltable.saverret, finaltable.saversion, finaltable.tabularversion, finaltable.spatialversion, finaltable.sapolygonareasymboL, finaltable.lkey, finaltable.legendlkey,
finaltable.liid,  finaltable.cordate, finaltable.musym, finaltable.muname, finaltable.mustatus, finaltable.farmlndcl,finaltable.farmlndclsec, finaltable.muhelcl, finaltable.muwathelcl, finaltable.muwndhelcl, finaltable.compname, finaltable.compkind, comppct_r, slope_l, slope_r, slope_h, slopelenusle_l, slopelenusle_r,slopelenusle_h,
tfact, wei, weg, hzname, hzdept_r, kwfact,  kffact, surfacetexture, finaltable.mukey, finaltable.lmapunitiid ,lmuaoverlap.lmapunitiidref, lmuaoverlap2.lmapunitiidref, area2.areasymbol as 'rainfall factor area', area3.areasymbol as 'climate factor area'

FROM  @finaltable finaltable 
LEFT OUTER JOIN lmuaoverlap ON finaltable.lmapunitiid = lmuaoverlap.lmapunitiidref 
	AND lmuaoverlap.lareaoviidref IN 
		(SELECT lareaoviid 
			from laoverlap JOIN area area2 ON laoverlap.areaiidref = area2.areaiid AND area2.areaiid IN 
				(SELECT areaiid 
					from area join areatype ON areatypeiid = areatypeiidref and areatypename = 'Rainfall factor area')) 
LEFT OUTER JOIN laoverlap ON laoverlap.lareaoviid = lmuaoverlap.lareaoviidref
LEFT OUter join area area2 ON area2.areaiid =laoverlap.areaiidref 

LEFT OUTER JOIN lmuaoverlap lmuaoverlap2 ON finaltable.lmapunitiid = lmuaoverlap2.lmapunitiidref 
	AND lmuaoverlap2.lareaoviidref IN 
		(SELECT lareaoviid 
			from laoverlap JOIN area area2 ON laoverlap.areaiidref = area2.areaiid AND area2.areaiid IN 
				(SELECT areaiid 
					from area join areatype ON areatypeiid = areatypeiidref and areatypename = 'Climate factor area')) 
LEFt OUTER JOIN laoverlap laoverlap2 ON laoverlap2.lareaoviid = lmuaoverlap2.lareaoviidref
LEFT OUter join area area3 ON area3.areaiid =laoverlap2.areaiidref 




			