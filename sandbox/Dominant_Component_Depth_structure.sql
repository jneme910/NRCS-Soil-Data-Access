--Define the area

DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @InRange INT;


SELECT @area =  ('WI025'); --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025
SELECT @InRange = 150;  --0,5,15,30,60,100,150
---
SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area
---
/*
1= very fine granular, single grain
2=fine granular
3= med OR coarse granular
4= blocky, platy OR massive
*/


SELECT areasymbol, musym, muname, mu.mukey, structgrpname, 
CASE WHEN structgrpname LIKE '%Very fine granular%' THEN 1
WHEN structgrpname LIKE '%Very fine and fine granular%' THEN 1
WHEN structgrpname LIKE '%single grain%' THEN 1
WHEN structgrpname LIKE '%Fine%' AND structgrpname LIKE '%granular%' THEN 2
WHEN structgrpname LIKE '%crumb%'  THEN 2
WHEN structgrpname LIKE '%medium%' AND structgrpname LIKE '%granular%' THEN 3
WHEN structgrpname LIKE '%coarse%' AND structgrpname LIKE '%granular%' THEN 3
WHEN structgrpname LIKE '%blocky%' THEN 4
WHEN structgrpname LIKE '%platy%' THEN 4
WHEN structgrpname LIKE '%massive%' THEN 4
WHEN structgrpname LIKE '%prismatic%' THEN 4
WHEN structgrpname LIKE '%columnar%' THEN 4
WHEN structgrpname LIKE '%lenticular%' THEN 4 
WHEN structgrpname LIKE '%cloddy%' THEN 4 
WHEN structgrpname LIKE '%wedge%' THEN 4 
WHEN muname LIKE '%silt%' THEN 4
WHEN muname LIKE '%clay%' THEN 4
ELSE 5 END structure_b_value

 FROM legend  AS l
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol <> 'US' 
 --AND CASE  WHEN @area_type = 2 THEN LEFT (l.areasymbol, 2) ELSE l.areasymbol END  = @area 
 INNER JOIN  component AS c ON c.mukey = mu.mukey  AND c.cokey = (SELECT TOP 1 c1.cokey FROM component AS c1
 INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY CASE WHEN compkind = 'Miscellaneous area' THEN 2
WHEN LEFT (mapunit.muname, 3) = LEFT (c1.compname, 3) THEN 1 ELSE 2 END ASC, c1.comppct_r DESC, 
c1.cokey)
INNER JOIN (SELECT structgrpname, cokey FROM chorizon 
INNER JOIN dbo.chstructgrp ON chstructgrp.chkey = chorizon.chkey AND rvindicator = 'Yes'
AND @InRange BETWEEN hzdept_r AND hzdepb_r ) ch ON ch.cokey=c.cokey