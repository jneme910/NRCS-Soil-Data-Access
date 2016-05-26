SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, 
 
 
(SELECT TOP 1 taxorder
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
AND mapunit.mukey = mu.mukey 
GROUP BY taxorder, comppct_r ORDER BY SUM(comppct_r) over(partition by taxorder) DESC) AS  dom_cond_order,
(SELECT TOP 1 SUM(comppct_r) over(partition by taxorder)
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
AND mapunit.mukey = mu.mukey 
GROUP BY taxorder, comppct_r ORDER BY SUM(comppct_r) over(partition by taxorder) DESC) AS  dom_cond_pct_order,

(SELECT TOP 1 taxsuborder
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
AND mapunit.mukey = mu.mukey 
GROUP BY taxsuborder, comppct_r ORDER BY SUM(comppct_r) over(partition by taxsuborder) DESC) AS dom_cond_suborder,

(SELECT TOP 1 SUM(comppct_r) over(partition by taxsuborder)
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
AND mapunit.mukey = mu.mukey 
GROUP BY taxsuborder, comppct_r ORDER BY SUM(comppct_r) over(partition by taxsuborder) DESC) AS  dom_cond_pct_suborder


FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND  LEFT (l.areasymbol,2) LIKE 'WI' 
INNER JOIN  component AS c ON c.mukey = mu.mukey 
AND c.cokey =
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY c1.comppct_r DESC, c1.cokey) 
GROUP BY areasymbol, musym, muname, mu.mukey, c.cokey,  compname, comppct_r
ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC, c.cokey

