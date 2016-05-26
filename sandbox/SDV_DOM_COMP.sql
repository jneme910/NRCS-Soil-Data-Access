SELECT 
 areasymbol, musym, muname, mu.mukey  AS MUKEY,
(SELECT interphr FROM component INNER JOIN cointerp ON component.cokey = cointerp.cokey AND component.cokey = c.cokey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)') as dom_comp_rating,
(SELECT interphrc FROM component INNER JOIN cointerp ON component.cokey = cointerp.cokey AND component.cokey = c.cokey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)') as dom_comp_class
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'TN610'
--INNER JOIN  muaggatt AS mt on mu.mukey=mt.mukey
INNER JOIN  component AS c ON c.mukey = mu.mukey  AND c.cokey =
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY c1.comppct_r DESC, c1.cokey) 
