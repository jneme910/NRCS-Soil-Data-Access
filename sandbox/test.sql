SELECT 
sacatalog.areasymbol AS AREASYMBOL, 
mapunit.mukey AS mukey, 
mapunit.musym AS MUSYM,
mapunit.muname AS MUNAME,

--P(HIGH PERMEABILITY - KSAT)
--From 590: High Permeability Soils (V.B) - Equivalent to drained hydrologic group A that meet both of the following criteria:
--1. KSAT LOW = 6 inches/hour or more in all parts of the upper 20 inches (50 centimeters) and
--2. KSAT LOW = 0.6 inches/hour or more in all parts of the upper 40 inches (100 centimeters) .
--3. Any major component
--Notes: Dats is recorded in micrometers per second. To convert micrometers per second to inches per hour, multiply micrometers per second by 0.1417. 
CASE WHEN 
(SELECT TOP 1 MIN (ksat_l * 0.1417)
FROM mapunit AS m_sl 
INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  AND m_sl.mukey=mapunit.mukey
AND majcompflag = 'Yes' 
AND hydgrp = 'A' 

INNER JOIN chorizon AS ch ON ch.cokey=c_sl.cokey AND CASE WHEN (ksat_l >= 42.34 AND hzdept_r < 50) THEN 1 
														  WHEN (ksat_l >= 4.23 AND hzdept_r < 100) THEN 1 
														  ELSE 0 END = 1
														  AND hzname NOT LIKE '%O%'
GROUP BY m_sl.mukey, ksat_l) 
IS NOT NULL THEN 'P' ELSE '' END
AS PERM_RATING,

--R (Bedrock)
--criteria:
-- Less than 24 inches (60 centimeters) to bedrock
-- Any major component
CASE WHEN (SELECT TOP 1  MIN (resdept_r) 
FROM mapunit AS m_sl 
INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  
AND majcompflag = 'Yes' 
AND m_sl.mukey=mapunit.mukey  
 INNER JOIN corestrictions ON corestrictions.cokey=c_sl.cokey AND resdept_r <60 AND reskind LIKE '%bedrock%' GROUP BY m_sl.mukey, resdept_r) 
 IS NOT NULL THEN 'R' ELSE '' END AS BEDROCK_RATING,
 
--W (Water Table)
-- criteria: 
-- Less than 24 inches (60 centimeters)to apparent water table 
-- Apparent Water Table (V.B) - Continuous saturated zone in the soil to a depth of at least 6 feet without an unsaturated zone below it.
-- Any major component
-- RV Value
CASE WHEN
 (SELECT TOP 1  MIN (soimoistdept_r) 
FROM mapunit AS m_sl 
INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  
AND majcompflag = 'Yes'   
AND m_sl.mukey=mapunit.mukey  
INNER JOIN comonth ON comonth.cokey=c_sl.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey 
AND (soimoiststat = 'Wet' AND soimoistdept_r <60) --AND (soimoiststat != 'Dry' AND soimoistdept_r >=60)
GROUP BY m_sl.mukey, soimoistdept_r) IS NOT NULL THEN 'W' ELSE '' END 
AS WATER_TABLE_RATING_WET,
CASE WHEN 

--LOOKING FOR SOIL MOISTURE STATUS DRY OR MOIST DEPTH GREATER THAN 60
--MAJOR COMPONENTS
(SELECT TOP 1  MIN (soimoistdept_r) 
FROM mapunit AS m_sl 
INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  
AND majcompflag = 'Yes'   
AND m_sl.mukey=mapunit.mukey  
INNER JOIN comonth ON comonth.cokey=c_sl.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey 
AND ((soimoiststat IN ('Dry', 'Moist') AND soimoistdept_r >=60)) --AND (soimoiststat != 'Dry' AND soimoistdept_r >=60)
GROUP BY m_sl.mukey, soimoistdept_r, soimoiststat) IS NOT NULL THEN 'D' ELSE '' END 
AS WATER_TABLE_RATING_DRY


INTO #NRCS590
FROM sacatalog 
INNER JOIN legend  ON legend.areasymbol = sacatalog.areasymbol ---AND sacatalog.areasymbol = 'WI007'
AND LEFT (sacatalog.areasymbol,2) = 'WI' -- SOIL SURVEYS 
INNER JOIN mapunit  ON mapunit.lkey = legend.lkey
--INNER JOIN component ON component.mukey=mapunit.mukey AND majcompflag = 'Yes'
--AND component.cokey =
--(SELECT TOP 1 c1.cokey FROM component AS c1 
--INNER JOIN mapunit AS c ON c.mukey=c.mukey AND c1.mukey=mapunit.mukey ORDER BY c1.comppct_r DESC, c1.cokey) 

SELECT AREASYMBOL, mukey, MUSYM, MUNAME, PERM_RATING, BEDROCK_RATING, WATER_TABLE_RATING_WET, WATER_TABLE_RATING_DRY, 
CONCAT (CASE WHEN WATER_TABLE_RATING_DRY != 'D' THEN WATER_TABLE_RATING_WET ELSE NULL END, PERM_RATING, BEDROCK_RATING) AS NRCS243 -- WHEN SOIL MOISTURE DEPTH IS GREATER THAN 60 AND IS DRY OR MOIST DONT INCLUDE ATER_TABLE_RATING_WET (W)
FROM #NRCS590