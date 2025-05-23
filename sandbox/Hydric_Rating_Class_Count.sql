DROP TABLE IF EXISTS main_query3;
 
 SELECT 
 areasymbol, 
 mu.musym, 
 mu.muname,
 mu.mukey/1  AS mukey, mu.farmlndcl, mua.drclassdcd,  mua.hydgrpdcd, mua.hydclprs,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey) AS comp_count,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND majcompflag = 'Yes') AS count_maj_comp,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND hydricrating = 'Yes' ) AS all_hydric,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND majcompflag = 'Yes' AND hydricrating = 'Yes') AS maj_hydric,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND majcompflag = 'Yes' AND hydricrating != 'Yes') AS maj_not_hydric,
  (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND majcompflag != 'Yes' AND hydricrating  = 'Yes' ) AS hydric_inclusions,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND hydricrating  != 'Yes') AS all_not_hydric, 
  (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey AND mapunit.mukey = mu.mukey
 AND hydricrating  IS NULL ) AS hydric_null 
 INTO #main_query3
 FROM legend  AS l
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND  LEFT(l.areasymbol,2) LIKE 'WI'
 INNER JOIN muaggatt AS mua ON mua.mukey=mu.mukey
 
 
SELECT  areasymbol, musym, 
 muname,
mukey, farmlndcl,drclassdcd,hydgrpdcd, hydclprs,
CASE WHEN comp_count = all_not_hydric + hydric_null THEN  'Nonhydric' 
WHEN comp_count = all_hydric  THEN 'Hydric' 
WHEN comp_count != all_hydric AND count_maj_comp = maj_hydric THEN 'Predominantly Hydric' 
WHEN hydric_inclusions >= 0.5 AND  maj_hydric < 0.5 THEN  'Predominantly Nonydric' 
WHEN maj_not_hydric >= 0.5  AND  maj_hydric >= 0.5 THEN 'Partially Hydric' ELSE 'Error' END AS hydric_rating
FROM #main_query3

DROP TABLE IF EXISTS main_query3;