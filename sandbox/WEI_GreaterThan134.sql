SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, c.cokey AS COKEY, compname, 
 comppct_r, WEI

FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND LEFT (l.areasymbol,2) = 'WI' 
INNER JOIN  component AS c ON c.mukey = mu.mukey  AND wei >=134 AND majcompflag = 'Yes' 
AND c.cokey =
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey AND wei >=134 AND majcompflag = 'Yes'  ORDER BY c1.WEI DESC, c1.comppct_r DESC, c1.cokey) ---GRABS THE MAX WEI FOR THE MAJOR COMPONENT IN THE MAP UNIT 
ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC , compname, cokey