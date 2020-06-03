DROP TABLE IF EXISTS #b
DROP TABLE IF EXISTS #c

CREATE TABLE #b
    (areasymbol VARCHAR(15), areaname VARCHAR(250), mukey INT, muname VARCHAR(250), compname VARCHAR(250), drainagecl VARCHAR(30),hydgrp VARCHAR(5), muacres INT, comppct_r SMALLINT, mu_pct_sum SMALLINT)

INSERT INTO #b (areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r,mu_pct_sum)

SELECT areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r, 
(SELECT SUM (comppct_r)
FROM mapunit AS MM2
INNER JOIN component AS CCO ON CCO.mukey = MM2.mukey AND CCO.mukey = s.mukey ) AS  mu_pct_sum
FROM (SELECT   areasymbol, areaname, mapunit.mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r
FROM legend 
       INNER JOIN mapunit ON mapunit.lkey=legend.lkey AND LEFT (areasymbol, 2) <> 'US'
	   
              INNER JOIN component ON component.mukey=mapunit.mukey
			 -- AND majcompflag = 'Yes' 
              AND compkind = 'Series' AND  hydgrp = 'D' AND drainagecl ='Moderately well drained'
              AND majcompflag = 'Yes' GROUP BY areasymbol, areaname, mapunit.mukey, muname, compname, drainagecl,hydgrp, muacres, comppct_r) AS s 


CREATE TABLE #c
    (areasymbol VARCHAR(15), areaname VARCHAR(250), mukey INT, muname VARCHAR(250), compname VARCHAR(250), drainagecl VARCHAR(30),hydgrp VARCHAR(5), muacres INT, comppct_r SMALLINT, mu_pct_sum SMALLINT, adj_comp_pct REAL)

INSERT INTO #c (areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r,mu_pct_sum, adj_comp_pct)

SELECT areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r, mu_pct_sum, 
LEFT(ROUND((1.0 * comppct_r / NULLIF(mu_pct_sum, 0)),2),4) AS adj_comp_pct
FROM #b

SELECT areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r,mu_pct_sum, adj_comp_pct, 
component_acres= adj_comp_pct*muacres
FROM #c
ORDER BY areasymbol ASC, muname ASC

CREATE INDEX IX_TableName_Col1
    ON dbo.TableName
    (column_1)

