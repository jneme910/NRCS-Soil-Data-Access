SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, (SELECT TOP 1 interphrc
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)' 
GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as dom_comp_rating
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'TN610' 
INNER JOIN  component AS c ON c.mukey = mu.mukey 
AND c.cokey =
ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC, c.cokey

