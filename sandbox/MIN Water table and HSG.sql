DROP TABLE IF EXISTS #b;
DROP TABLE IF EXISTS #c;

CREATE TABLE #b
    (areasymbol VARCHAR(15), areaname VARCHAR(250), mukey INT, muname VARCHAR(250), compname VARCHAR(250), cokey INT, drainagecl VARCHAR(30),hydgrp VARCHAR(5), muacres INT, comppct_r SMALLINT, mu_pct_sum SMALLINT, min_soimoistdept_r SMALLINT)

INSERT INTO #b (areasymbol, areaname, mukey, muname, compname, cokey,  drainagecl, hydgrp, muacres, comppct_r,mu_pct_sum, min_soimoistdept_r)

SELECT areasymbol, areaname, mukey, muname, compname, cokey, drainagecl, hydgrp, muacres, comppct_r, 
(SELECT SUM (comppct_r)
FROM mapunit AS MM2
INNER JOIN component AS CCO ON CCO.mukey = MM2.mukey AND CCO.mukey = s.mukey ) AS  mu_pct_sum, 
 (SELECT  MIN(soimoistdept_r)  FROM component AS c2 
INNER JOIN comonth ON c2.cokey=comonth.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey

AND c2.cokey=s.cokey 
AND soimoiststat = 'wet'  GROUP BY c2.cokey) AS min_soimoistdept_r
FROM (SELECT   areasymbol, areaname, mapunit.mukey, muname, component.cokey, compname, drainagecl, hydgrp, muacres, comppct_r
FROM legend 
       INNER JOIN mapunit ON mapunit.lkey=legend.lkey AND LEFT (areasymbol, 2) <> 'US'
                 
              INNER JOIN component ON component.mukey=mapunit.mukey
               AND majcompflag = 'Yes' 
              --AND compkind = 'Series' 
              AND majcompflag = 'Yes' GROUP BY areasymbol, areaname, mapunit.mukey, muname, compname, drainagecl,hydgrp, muacres, comppct_r, component.cokey) AS s 


CREATE TABLE #c
    (areasymbol VARCHAR(15), areaname VARCHAR(250), mukey INT, muname VARCHAR(250), compname VARCHAR(250), drainagecl VARCHAR(30),hydgrp VARCHAR(5), muacres INT, comppct_r SMALLINT, mu_pct_sum SMALLINT, adj_comp_pct REAL, min_soimoistdept_r SMALLINT)

INSERT INTO #c (areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r,mu_pct_sum, adj_comp_pct, min_soimoistdept_r )

SELECT areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r, mu_pct_sum, 
LEFT(ROUND((1.0 * comppct_r / NULLIF(mu_pct_sum, 0)),2),4) AS adj_comp_pct, min_soimoistdept_r 
FROM #b

SELECT areasymbol, areaname, mukey, muname, compname, drainagecl, hydgrp, muacres, comppct_r,mu_pct_sum, adj_comp_pct, 
component_acres= adj_comp_pct*muacres, min_soimoistdept_r 
FROM #c
