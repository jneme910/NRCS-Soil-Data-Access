

SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY,
(SELECT TOP 1 CASE WHEN ruledesign = 1 THEN 'limitation' 
WHEN ruledesign = 2 THEN 'suitability' END 
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)' 
GROUP BY mapunit.mukey, ruledesign) as design,
 
 ROUND ((SELECT SUM (interphr * comppct_r)
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)' 
GROUP BY mapunit.mukey),2) as rating,
 ROUND ((SELECT SUM (comppct_r)
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)' 
AND (interphr) IS NOT NULL GROUP BY mapunit.mukey),2) as sum_com
INTO #main
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'TN610' 
INNER JOIN  component AS c ON c.mukey = mu.mukey 
GROUP BY  areasymbol, musym, muname, mu.mukey


SELECT areasymbol, musym, muname, MUKEY, ISNULL (ROUND ((rating/sum_com),2), 99) AS rating, 
CASE WHEN rating IS NULL THEN 'Not Rated' 
	 WHEN design = 'suitability' AND  ROUND ((rating/sum_com),2) < = 0 THEN 'Not suited'
	 WHEN design = 'suitability' AND  ROUND ((rating/sum_com),2)  > 0.001 and  ROUND ((rating/sum_com),2)  <=0.333 THEN 'Poorly suited'
	 WHEN design = 'suitability' AND  ROUND ((rating/sum_com),2)  > 0.334 and  ROUND ((rating/sum_com),2)  <=0.666  THEN 'Moderately suited'
	 WHEN design = 'suitability' AND  ROUND ((rating/sum_com),2)  > 0.667 and  ROUND ((rating/sum_com),2)  <=0.999  THEN 'Moderately well suited'
	 WHEN design = 'suitability' AND  ROUND ((rating/sum_com),2)   = 1  THEN 'Well suited'
	 
	 WHEN design = 'limitation' AND  ROUND ((rating/sum_com),2) < = 0 THEN 'Not limited '
	 WHEN design = 'limitation' AND  ROUND ((rating/sum_com),2)  > 0.001 and  ROUND ((rating/sum_com),2)  <=0.333 THEN 'Slightly limited '
	 WHEN design = 'limitation' AND  ROUND ((rating/sum_com),2)  > 0.334 and  ROUND ((rating/sum_com),2)  <=0.666  THEN 'Somewhat limited '
	 WHEN design = 'limitation' AND  ROUND ((rating/sum_com),2)  > 0.667 and  ROUND ((rating/sum_com),2)  <=0.999  THEN 'Moderately limited '
	 WHEN design = 'limitation' AND  ROUND ((rating/sum_com),2)  = 1 THEN 'Very limited' END AS class
FROM #main

