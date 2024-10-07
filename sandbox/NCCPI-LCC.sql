SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #map;
DROP TABLE IF EXISTS #map2;
DROP TABLE IF EXISTS #map3;

--Define the area
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @domc INT ;

-- Soil Data Access
--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 
--~DeclareINT(@area_type)~ 
-- End soil data access
SELECT @area= 'NE'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025


SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area



 SELECT l.areaname, l.areasymbol, musym, mu.mukey, muname, compname, comppct_r, c.cokey, 
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 3.0)' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as NCCPI_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 3.0)'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as NCCPI_class,
 c.nirrcapcl, c.nirrcapscl, 
 CASE WHEN  c.nirrcapcl  IS NULL THEN  'NR'
 WHEN  c.nirrcapcl  = '1' THEN  '1'
 WHEN  c.nirrcapcl  = '8' THEN  '8'
 WHEN c.nirrcapscl IS NULL THEN  c.nirrcapcl 
 
 ELSE CONCAT ( c.nirrcapcl, c.nirrcapscl) END AS lcc,
 CONCAT ([SC].[areasymbol] , ' ' , FORMAT ( [SC].[saverest], 'dd-MM-yy')) AS datestamp 
 FROM sacatalog SC 
 INNER JOIN legend  AS l ON l.areasymbol = SC.areasymbol
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND  CASE WHEN @area_type = 2 THEN LEFT (l.areasymbol, 2) ELSE l.areasymbol END = @area
 INNER JOIN  component AS c ON c.mukey = mu.mukey AND majcompflag = 'yes'  AND c.cokey = (SELECT TOP 1 c1.cokey FROM component AS c1
 INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY CASE WHEN compkind = 'Miscellaneous area' THEN 2
WHEN LEFT (mapunit.muname, 3) = LEFT (c1.compname, 3) THEN 1 ELSE 2 END ASC, c1.comppct_r DESC, 
c1.cokey)
 ORDER BY l.areasymbol, musym, muname, mu.mukey