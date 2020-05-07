use sdmOnline
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;

--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 

SELECT @area= 'NE'; --Enter State Abbreviation or Soil Survey Area
SELECT @area_type = LEN (@area); --Enter 

SELECT  m.mukey, c.cokey, slope_r, compname, comppct_r
FROM legend AS l
INNER JOIN mapunit AS m ON  m.lkey=l.lkey AND  CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area
INNER JOIN component AS c ON c.mukey=m.mukey AND majcompflag = 'Yes' WHERE (SELECT IIF ( 45 > 30, 'TRUE', NULL )