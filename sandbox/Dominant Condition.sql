SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, c.cokey/1 AS COKEY,  compname, comppct_r, 
 
 (SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' GROUP BY interphrc, interphr, comppct_r
ORDER BY SUM (comppct_r) over(partition by interphrc) DESC)as dom_comp_rating,

interphrc AS com_interp,

(SELECT TOP 1 interphrc
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' 
GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as dom_comp_class

FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'TN610' 
INNER JOIN  component AS c ON c.mukey = mu.mukey 
INNER JOIN  cointerp ON c.cokey = cointerp.cokey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)'
GROUP BY areasymbol, musym, muname, mu.mukey, c.cokey,  compname, comppct_r, interphrc
ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC, c.cokey

