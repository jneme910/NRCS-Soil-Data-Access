DROP TABLE IF EXISTS  #comp2262;
DROP TABLE IF EXISTS  #comp226;
DROP TABLE IF EXISTS  #comp2263;
DROP TABLE IF EXISTS #comp2263;
DROP TABLE IF EXISTS #last;
DROP TABLE IF EXISTS #sa;
DROP TABLE IF EXISTS #last2;

CREATE TABLE #comp2262
    ( state_sym  VARCHAR(10),
muacres DECIMAL ,
    MU_pct INT,
    mukey INT ,
   comppct_r INT, 
   taxorder VARCHAR(254) , 
   cokey INT
)
;
 
INSERT INTO #comp2262 (state_sym, muacres, MU_pct,  mukey,  comppct_r, taxorder, cokey)

SELECT  
LEFT (areasymbol,2) AS state_sym, muacres, 
SUM (comppct_r) over(partition by m.mukey) as MU_pct, m.mukey,  comppct_r, taxorder, c.cokey
 
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey AND areasymbol <>   'US'
INNER JOIN component AS c ON c.mukey=m.mukey --AND taxorder = 'Alfisols' --AND majcompflag = 'Yes'
WHERE CASE WHEN muacres IS NULL THEN 1 
WHEN comppct_r IS NULL THEN 1 ELSE 2 END = 2
;


CREATE TABLE #comp226
    ( state_sym VARCHAR(10),
	muacres REAL ,
    MU_pct REAL,
    mukey INT ,
   comppct_r REAL, 
   taxorder VARCHAR(254) , 
   cokey INT,
   component_acres  REAL,
   pct REAL
)
;
INSERT INTO #comp226 (state_sym, muacres, MU_pct,  mukey,  comppct_r, taxorder, cokey, pct   )



Select state_sym, muacres, MU_pct, mukey , comppct_r,   taxorder, cokey,  CAST (comppct_r AS decimal)/CAST (MU_pct AS decimal) AS pct 
From #comp2262
WHERE CASE WHEN comppct_r IS NULL THEN 1
WHEN comppct_r = 0 THEN 1
WHEN MU_pct  IS NULL THEN 1
WHEN MU_pct  = 0 THEN 1 ELSE 2 END = 2
 
CREATE TABLE #comp2263
    ( state_sym VARCHAR(10),
muacres REAL ,
    MU_pct REAL,
    mukey INT ,
   comppct_r REAL, 
   taxorder  VARCHAR(254) , 
   cokey INT,
   pct REAL,
   component_acres  REAL
)
;

 
INSERT INTO #comp2263 (state_sym, muacres, MU_pct,  mukey,  comppct_r, taxorder, cokey, pct , component_acres  )

Select DISTINCT state_sym, muacres, MU_pct, mukey , comppct_r,  taxorder, cokey,  pct, ROUND (muacres*pct, 2) AS component_acres
From #comp226
ORDER BY component_acres DESC, taxorder;


CREATE TABLE #last
    (  
state_sym VARCHAR(10),
   taxorder  VARCHAR(254) , 
   SUM_taxorder_acres  REAL
)
;
INSERT INTO #last (state_sym, taxorder, SUM_taxorder_acres )
SELECT DISTINCT state_sym, taxorder , ROUND( SUM(component_acres) over(partition by state_sym, taxorder),2) as SUM_taxorder_acres
FROM #comp2263 
 

CREATE TABLE #last2
    (  
state_sym VARCHAR(10),
   taxorder  VARCHAR(254) , 
   SUM_taxorder_acres  REAL
)
;
INSERT INTO #last2 (state_sym, taxorder, SUM_taxorder_acres )

--SELECT state_sym, taxorder, FORMAT( SUM_taxorder_acres , '#,#') AS SUM_taxorder_acres
SELECT state_sym, taxorder,  SUM_taxorder_acres 
FROM #last 
ORDER BY state_sym ASC,  SUM_taxorder_acres DESC 



CREATE TABLE #sa
    (  
state_sym VARCHAR(10),
   SUM_state_acres REAL
)
;
INSERT INTO #sa(state_sym,  SUM_state_acres )
SELECT DISTINCT LEFT(areasymbol,2) AS state_sym,   ROUND( SUM(muacres) over(partition by LEFT(areasymbol,2) ),2) as SUM_state_acres
FROM legend
INNER JOIN mapunit ON mapunit.lkey=legend.lkey AND areasymbol <> 'US'
ORDER BY LEFT(areasymbol,2) ASC


SELECT #last2.state_sym, statename, taxorder, FORMAT( SUM_taxorder_acres , '#,#') AS SUM_taxorder_acres,FORMAT(  SUM_state_acres, '#,#') AS SUM_state_acres
FROM #sa
INNER JOIN #last2  ON #last2.state_sym=#sa.state_sym
INNER JOIN state  ON state.stateid=#sa.state_sym
ORDER BY #last2.state_sym ASC, taxorder ASC