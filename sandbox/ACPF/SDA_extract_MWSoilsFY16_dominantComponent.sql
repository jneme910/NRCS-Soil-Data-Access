SELECT 
mapunit.mukey,
cokey,
compname,
comppct_r   
FROM (legend INNER JOIN (mapunit INNER JOIN component ON mapunit.mukey = component.mukey AND majcompflag = 'yes') ON legend.lkey = mapunit.lkey AND LEFT (legend.areasymbol,2) = 'WI' 
AND component.cokey = 
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit AS c ON c1.mukey=c.mukey AND c.mukey=mapunit.mukey ORDER BY c1.comppct_r DESC, CASE WHEN LEFT (muname,2)= LEFT (compname,2) THEN 1 ELSE 2 END ASC, c1.cokey)) 
