
DROP TABLE IF EXISTS #comp2262
DROP TABLE IF EXISTS #comp226
DROP TABLE IF EXISTS #comp2263
DROP TABLE IF EXISTS #last

CREATE TABLE #comp2262
    ( muacres DECIMAL ,
    MU_pct INT,
    mukey INT ,
   comppct_r INT, 
   compname  VARCHAR(254) , 
   cokey INT
 )
;

INSERT INTO #comp2262 (muacres, MU_pct,  mukey,  comppct_r, compname, cokey)
SELECT  
 muacres, 
SUM (comppct_r) over(partition by m.mukey) as MU_pct, m.mukey,  comppct_r, compname, c.cokey

FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey AND areasymbol <>  'US'
INNER JOIN component AS c ON c.mukey=m.mukey --AND majcompflag = 'Yes'
WHERE CASE WHEN muacres IS NULL THEN 1 
WHEN comppct_r IS NULL THEN 1 ELSE 2 END = 2
;


CREATE TABLE #comp226
    ( muacres REAL ,
    MU_pct REAL,
    mukey INT ,
   comppct_r REAL, 
   compname  VARCHAR(254) , 
   cokey INT,
   component_acres  REAL,
   pct REAL
 )
;
INSERT INTO #comp226 (muacres, MU_pct,  mukey,  comppct_r, compname, cokey, pct   )
Select  muacres, MU_pct, mukey , comppct_r,   compname, cokey,  CAST (comppct_r AS decimal)/CAST (MU_pct AS decimal) AS pct 
From #comp2262
 WHERE CASE WHEN comppct_r IS NULL THEN 1
WHEN comppct_r = 0 THEN 1
WHEN MU_pct  IS NULL THEN 1
WHEN MU_pct  = 0 THEN 1 ELSE 2 END = 2
 
CREATE TABLE #comp2263
    ( muacres REAL ,
    MU_pct REAL,
    mukey INT ,
   comppct_r REAL, 
   compname  VARCHAR(254) , 
   cokey INT,
   pct REAL,
   component_acres  REAL
 )
;

INSERT INTO #comp2263 (muacres, MU_pct,  mukey,  comppct_r, compname, cokey, pct , component_acres  )
Select DISTINCT  muacres, MU_pct, mukey , comppct_r,  compname, cokey,  pct, ROUND (muacres*pct, 2) AS component_acres
From #comp226
ORDER BY component_acres DESC, compname

CREATE TABLE #last
    (  
   compname  VARCHAR(254) , 
   component_acres  REAL
 )
;

INSERT INTO #last (compname, component_acres  )
SELECT DISTINCT compname, ROUND( SUM(component_acres) over(partition by compname),2) as SUM_component_acres
FROM #comp2263 

SELECT compname, component_acres
FROM #last 
ORDER BY component_acres DESC, compname

--CASE WHEN CASE WHEN   muacres IS NULL THEN 0
--WHEN  muacres  = 0 THEN 0 
--WHEN  comppct_r IS NULL THEN 0
--WHEN comppct_r = 0 THEN 0
-- ELSE
 






