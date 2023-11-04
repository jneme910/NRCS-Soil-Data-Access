DROP TABLE IF EXISTS #comp
DROP TABLE IF EXISTS #comp2
DROP TABLE IF EXISTS #comp3
DROP TABLE IF EXISTS #last2 

CREATE TABLE #comp
    (  MLRA  VARCHAR(40) , 
	MLRA_Name VARCHAR(254) , 
	muacres DECIMAL ,
    MU_pct INT,
    mukey INT ,
   comppct_r INT, 
   compname  VARCHAR(254) , 
   cokey INT);

INSERT INTO #comp (MLRA, MLRA_Name, muacres, MU_pct,  mukey,  comppct_r, compname, cokey)
SELECT  lao.areasymbol AS MLRA, lao.areaname AS MLRA_Name,
 muacres, 
SUM (comppct_r) over(partition by m.mukey) as MU_pct, m.mukey,  comppct_r, compname, c.cokey

FROM legend AS l
INNER JOIN laoverlap AS lao ON l.lkey = lao.lkey  AND lao.areasymbol = '122' 
AND l.areasymbol <> 'US'
INNER JOIN muaoverlap AS mua ON mua.lareaovkey = lao.lareaovkey AND lao.areatypename='mlra' 
INNER JOIN mapunit AS m ON m.lkey=l.lkey 
INNER JOIN component AS c ON c.mukey=m.mukey AND hydricrating = 'Yes'

WHERE CASE WHEN muacres IS NULL THEN 1 
WHEN comppct_r IS NULL THEN 1 ELSE 2 END = 2;


CREATE TABLE #comp2
    ( MLRA  VARCHAR(40) , 
	MLRA_Name VARCHAR(254) , 	
	muacres REAL ,
    MU_pct REAL,
    mukey INT ,
   comppct_r REAL, 
   compname  VARCHAR(254) , 
   cokey INT,
   component_acres  REAL,
   pct REAL);
INSERT INTO #comp2 (MLRA, MLRA_Name, muacres, MU_pct,  mukey,  comppct_r, compname, cokey, pct   )
Select  MLRA, MLRA_Name, muacres, MU_pct, mukey , comppct_r,   compname, cokey,  CAST (comppct_r AS decimal)/CAST (MU_pct AS decimal) AS pct 
From #comp
WHERE CASE WHEN comppct_r IS NULL THEN 1
WHEN comppct_r = 0 THEN 1
WHEN MU_pct  IS NULL THEN 1
WHEN MU_pct  = 0 THEN 1 ELSE 2 END = 2

CREATE TABLE #comp3
    ( MLRA  VARCHAR(40) , 
	MLRA_Name VARCHAR(254) , 
	muacres REAL ,
    MU_pct REAL,
    mukey INT ,
   comppct_r REAL, 
   compname  VARCHAR(254) , 
   cokey INT,
   pct REAL,
   component_acres  REAL);

INSERT INTO #comp3 (MLRA, MLRA_Name, muacres, MU_pct,  mukey,  comppct_r, compname, cokey, pct , component_acres  )
Select DISTINCT MLRA, MLRA_Name,  muacres, MU_pct, mukey , comppct_r,  compname, cokey,  pct, ROUND (muacres*pct, 2) AS component_acres
From #comp2
ORDER BY component_acres DESC, compname

CREATE TABLE #last2
    (  MLRA  VARCHAR(40) , 
	MLRA_Name VARCHAR(254) , 
   compname  VARCHAR(254) , 
   component_acres  REAL);

INSERT INTO #last2 (MLRA, MLRA_Name, compname, component_acres  )
SELECT DISTINCT MLRA, MLRA_Name, compname, ROUND( SUM(component_acres) over(partition by compname),2) as SUM_component_acres
FROM #comp3 

SELECT  compname AS [Component Name], FORMAT (ROUND (component_acres,0) , '#,###,##0') AS [Component Acres]
FROM #last2 
ORDER BY component_acres DESC, compname