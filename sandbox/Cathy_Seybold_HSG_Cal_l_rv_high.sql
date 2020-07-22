SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #HSG;
DROP TABLE IF EXISTS #HSG_2nd_calc;
DROP TABLE IF EXISTS #HSG_calc;

DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @comp VARCHAR(254);
DECLARE @min_ks SMALLINT;
DECLARE @min_ks2 SMALLINT;
DECLARE @min_ks60 SMALLINT;
DECLARE @water_restrc SMALLINT;
DECLARE @water_table_depth SMALLINT;

-- Soil Data Access
~DeclareChar(@area,20)~  
~DeclareINT(@area_type)~ 
~DeclareChar(@comp,254)~  
--~DeclareSmallint(@min_ks)~ 
--~DeclareSmallint(@min_ks2)~ 
--~DeclareSmallint(@min_ks60)~ 
--~DeclareSmallint(@water_restrc)~ 
--~DeclareSmallint(@water_table_depth)~ 

-- Enter parameter soil data access
SELECT @area = 'ME'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025
SELECT @comp = 'Peru'; --Enter Component Name
SELECT @min_ks = 12;
SELECT  @min_ks2 = 12;
SELECT  @min_ks60 = 12;
SELECT  @water_restrc = 200;
SELECT @water_table_depth = 200;
--END


SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area
--creates the temp table for map unit and legend

-- Hydrologic Soil Group (HSG) is calculated from user inputs.
SELECT m.mukey, c.cokey, areasymbol, areaname, muname, compname, comppct_r, hydgrp,

-- gets ksat of least transmissive layer that is within a depth of 50 cm.
(SELECT  MIN(ksat_r) FROM chorizon
INNER join component ON chorizon.cokey=component.cokey 
AND c.cokey=component.cokey
and hzdept_r <= 50) as min_ks,

-- gets ksat of least transmissive layer that is within a depth of 100 cm.
(SELECT  MIN(ksat_r) FROM chorizon
INNER join component ON chorizon.cokey=component.cokey 
AND c.cokey=component.cokey
and hzdept_r <= 100) as min_ks2,

-- gets ksat of least transmissive layer that is within a depth of 60 cm; used in dual HSG group assignment.
(SELECT MIN(ksat_r)FROM chorizon
INNER join component ON chorizon.cokey=component.cokey
AND c.cokey=component.cokey
and hzdept_r <= 60) as min_ks60,

-- gets months when soil moisture is "wet" above 100 cm.
(SELECT count(month) FROM comonth  
INNER join component ON comonth.cokey=component.cokey
INNER join cosoilmoist ON comonth.comonthkey=cosoilmoist.comonthkey 
AND c.cokey=component.cokey
and soimoiststat = 'wet' and soimoistdept_r <= 100) as month1,

-- gets months when soil moisture is "wet" above 60 cm. 
(SELECT count(month) FROM comonth
INNER join component ON comonth.cokey=component.cokey
INNER join cosoilmoist ON comonth.comonthkey=cosoilmoist.comonthkey
AND c.cokey=component.cokey
and soimoiststat = 'wet' and soimoistdept_r < 60) as mnth,

(SELECT  MIN(soimoistdept_r)  FROM component AS c2 
INNER JOIN comonth ON c2.cokey=comonth.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey
AND c.cokey=c2.cokey
AND soimoiststat = 'wet'  GROUP BY c2.cokey) AS min_soimoistdept_r,


-- gets depth to component restriction
(SELECT MIN(resdept_r) FROM corestrictions
INNER join component ON corestrictions.cokey=component.cokey
AND c.cokey=component.cokey
and reskind in ('fragipan', 'duripan', 'petrocalcic', 'ortstein', 'petrogypsic', 'cemented horizon', 'densic material', 'placic', 'bedrock, paralithic', 'bedrock, lithic', 'bedrock, densic', 'permafrost')) as resdept_r,

-- gets depth to water impermeable layer (ksat < 0.01 micrometers/s)
(SELECT MIN(hzdept_r) FROM chorizon
INNER join component ON chorizon.cokey=component.cokey
AND c.cokey=component.cokey
and ksat_r < 0.01) as hzdpt

INTO #HSG

FROM legend l
INNER JOIN mapunit m on l.lkey=m.lkey AND  CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area
INNER JOIN component c on m.mukey=c.mukey AND majcompflag = 'Yes' and compname = @comp 
and c.cokey = (SELECT TOP 1 component.cokey FROM component WHERE component.mukey=m.mukey ORDER BY CASE WHEN LEFT (compname, 3) = LEFT (muname, 3) THEN 1 ELSE 2 END ASC, component.comppct_r DESC, component.cokey) 
ORDER by mukey, comppct_r desc

-- 2nd Query Calc
CREATE TABLE #HSG_2nd_calc 
   ( areasymbol VARCHAR (20), areaname VARCHAR (255), mukey INT, cokey INT, muname VARCHAR (250), compname VARCHAR (250), comppct_r SMALLINT, hydgrp VARCHAR (20), 
   min_ks SMALLINT, min_ks2 SMALLINT, min_ks60 SMALLINT, water_restrc INT, water_table_depth INT, min_soimoistdept_r SMALLINT, resdept_r SMALLINT, hzdpt SMALLINT)

INSERT INTO #HSG_2nd_calc (areasymbol, areaname, mukey, cokey, muname, compname, comppct_r, hydgrp, min_ks, min_ks2, min_ks60, water_restrc, water_table_depth, min_soimoistdept_r, resdept_r, hzdpt) 

SELECT areasymbol, areaname, mukey, cokey, muname, compname, comppct_r, hydgrp, min_ks, min_ks2, min_ks60, 
CASE when resdept_r is null THEN hzdpt
when hzdpt is null THEN resdept_r
when resdept_r <= hzdpt THEN resdept_r
ELSE hzdpt END as water_restrc,
CASE when mnth is null then 999 end as water_table_depth, min_soimoistdept_r, resdept_r, hzdpt
FROM #HSG

SELECT
CASE when min_soimoistdept_r = 999 then '-'
when (min_soimoistdept_r < 60 and min_soimoistdept_r is not null) OR (water_restrc is not null AND water_restrc < 50) THEN 'D'
when ((min_soimoistdept_r <= 100 and min_soimoistdept_r is not null) OR (water_restrc is not null AND water_restrc <= 100)) AND (min_ks <= 1.0 AND min_ks is not null) THEN 'D'
when ((min_soimoistdept_r <= 100 and min_soimoistdept_r is not null) OR (water_restrc is not null AND water_restrc <= 100)) AND (min_ks <= 10 AND min_ks is not null) THEN 'C'
when ((min_soimoistdept_r <= 100 and min_soimoistdept_r is not null) OR (water_restrc is not null AND water_restrc <= 100)) AND (min_ks <= 40 AND min_ks is not null) THEN 'B'
when ((min_soimoistdept_r <= 100 and min_soimoistdept_r is not null) OR (water_restrc is not null AND water_restrc <= 100)) AND (min_ks > 40 AND min_ks is not null) THEN 'A'
		
when (min_ks2 <= 0.4 AND min_ks2 is not null AND (water_restrc > 100 OR water_restrc is null) AND min_soimoistdept_r > 100) THEN 'D'
when min_soimoistdept_r > 100 AND ((water_restrc is not null AND water_restrc > 100) OR water_restrc is null) AND (min_ks2 <= 4.0 AND min_ks2 is not null) THEN 'C'
when min_soimoistdept_r > 100 AND ((water_restrc is not null AND water_restrc > 100) OR water_restrc is null) AND (min_ks2 <= 10.0 AND min_ks2 is not null) THEN 'B'
when min_soimoistdept_r > 100 AND ((water_restrc is not null AND water_restrc > 100) OR water_restrc is null) AND (min_ks2 > 10 AND min_ks2 is not null) THEN 'A'
ELSE null END as HSG_calculated,

CASE when min_soimoistdept_r = 999 then '-'
when min_soimoistdept_r < 60 and min_soimoistdept_r is not null AND water_restrc is not null AND water_restrc <= 100 AND min_ks60 > 40 AND min_ks60 is not null THEN 'A/D'
when min_soimoistdept_r < 60 and min_soimoistdept_r is not null AND water_restrc is not null AND water_restrc <= 100 AND min_ks60 > 10.0 AND min_ks60 is not null THEN 'B/D'
when min_soimoistdept_r < 60 and min_soimoistdept_r is not null AND water_restrc is not null AND water_restrc <= 100 AND min_ks60 > 1.0 AND min_ks60 is not null THEN 'C/D'

when min_soimoistdept_r < 60 and min_soimoistdept_r is not null AND ((water_restrc is not null AND water_restrc > 100) OR water_restrc is null) AND min_ks2 > 10 AND min_ks2 is not null THEN 'A/D'
when min_soimoistdept_r < 60 and min_soimoistdept_r is not null AND ((water_restrc is not null AND water_restrc > 100) OR water_restrc is null) AND min_ks2 > 4.0 AND min_ks2 is not null THEN 'B/D'
when min_soimoistdept_r < 60 and min_soimoistdept_r is not null AND ((water_restrc is not null AND water_restrc > 100) OR water_restrc is null) AND min_ks2 > 0.4 AND min_ks2 is not null THEN 'C/D'
ELSE '-' END as HSG_dual
INTO #HSG_calc
FROM #HSG_2nd_calc

SELECT distinct areasymbol, areaname, mukey, cokey, muname, compname, comppct_r, hydgrp as HSG, HSG_calculated, HSG_dual,min_ks, 
min_ks2, min_ks60,  min_soimoistdept_r, resdept_r, hzdpt
FROM #HSG, #HSG_calc
Where HSG_calculated not like '-'
ORDER by areasymbol, areaname, mukey, cokey, muname, compname, comppct_r