-- Dominant Component. Weighted Average Property MIN MAX

SELECT 
 areasymbol, musym, muname, mu.mukey  AS MUKEY, 
 
(SELECT TOP 1 MIN (chm1.ph1to1h2o_r) FROM  component AS cm1
INNER JOIN chorizon AS chm1 ON cm1.cokey = chm1.cokey AND cm1.cokey = c.cokey
AND CASE WHEN chm1.hzname LIKE  '%O%' AND hzdept_r <10 THEN 2
		 WHEN chm1.hzname LIKE  '%r%' THEN 2 
		 WHEN chm1.hzname LIKE  '%'  THEN  1 ELSE 1 END = 1
		 ) AS dom_comp_property
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'WI025'

INNER JOIN  component AS c ON c.mukey = mu.mukey  AND c.cokey =
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY c1.comppct_r DESC, c1.cokey) 

