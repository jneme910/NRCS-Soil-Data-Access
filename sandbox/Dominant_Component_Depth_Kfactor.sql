--Define the area

DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @InRange INT;


SELECT @area =  ('WI025'); --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025
SELECT @InRange = 0;
---
SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area
---




SELECT areasymbol, musym, muname, mu.mukey, kwfact
 FROM legend  AS l
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol <> 'US' --CASE  WHEN @area_type = 2 THEN LEFT (l.areasymbol, 2) ELSE l.areasymbol END  = @area 
 INNER JOIN  component AS c ON c.mukey = mu.mukey  AND c.cokey = (SELECT TOP 1 c1.cokey FROM component AS c1
 INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY CASE WHEN compkind = 'Miscellaneous area' THEN 2
WHEN LEFT (mapunit.muname, 3) = LEFT (c1.compname, 3) THEN 1 ELSE 2 END ASC, c1.comppct_r DESC, 
c1.cokey)
INNER JOIN (SELECT kwfact, cokey FROM chorizon WHERE @InRange BETWEEN hzdept_r AND hzdepb_r ) ch ON ch.cokey=c.cokey