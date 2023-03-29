SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #main;
DROP TABLE IF EXISTS #perched;
DROP TABLE IF EXISTS #last_step_a;
DROP TABLE IF EXISTS #last_step_p;
DROP TABLE IF EXISTS #apparent;

--Define the area
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;


-- Soil Data Access
--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 
--~DeclareINT(@area_type)~ 
-- End soil data access
SELECT @area= 'WA063'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025

SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area

SELECT areasymbol, LEFT((areasymbol), 2) as state, areaname, l.lkey,  musym, m.mukey, compname, comppct_r, c.cokey, drainagecl, cm.comonthkey, cs.cosoilmoistkey
INTO #main
FROM legend l inner join mapunit m left outer join component c left outer join comonth cm left outer join cosoilmoist cs
	ON cm.comonthkey = cs.comonthkey
	ON c.cokey = cm.cokey
    	ON m.mukey = c.mukey
    	ON l.lkey = m.lkey
		
WHERE --CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area
 c.majcompflag IN ('yes') AND m.mukey =  85953


--PERCHED QUERY --Perched
select comonthkey
  into #perched
from COSOILMOIST as t_source
CROSS APPLY (
    select soimoiststat, soimoistdept_r 
    from COSOILMOIST
    where comonthkey = t_source.comonthkey
) topApply
CROSS APPLY (
    select soimoiststat, soimoistdept_r 
    from COSOILMOIST
    where comonthkey = t_source.comonthkey
) bottomApply
where
    bottomApply.soimoistdept_r > topApply.soimoistdept_r and
    (topApply.soimoiststat = 'Wet' and (ISNULL (bottomApply.soimoiststat,'Moist')  IN ('Moist', 'Dry')))



--APPARENT QUERY
select comonthkey, a_topApply.soimoiststat AS topApply_soimoiststat, a_topApply.soimoistdept_r AS topApply_soimoistdept_r --, bottomApply.soimoiststat AS bottomApply_soimoiststat, bottomApply.soimoistdept_r AS bottomApply_soimoistdept_r  
  INTO #apparent
from COSOILMOIST as a_source
CROSS APPLY (
    select soimoiststat, soimoistdept_r 
    from COSOILMOIST
    where comonthkey = a_source.comonthkey
) a_topApply

where
    --a_bottomApply.soimoistdept_r > a_topApply.soimoistdept_r and
    (a_topApply.soimoiststat = 'Wet');

SELECT * 
FROM #apparent
LEFT OUTER JOIN #perched ON #apparent.comonthkey = #perched.comonthkey
WHERE #apparent.comonthkey != #perched.comonthkey

--LAST STEP QUERY PERCHED
SELECT DISTINCT #main.areasymbol,  #main.areaname, #main.lkey,  #main.musym, #main.mukey, #main.compname, #main.comppct_r,
 #main.cokey, #main.drainagecl, 'Perched' AS perched
INTO #last_step_p
FROM #main 
INNER JOIN  #perched on #main.comonthkey = #perched.comonthkey ORDER BY #main.areasymbol,  #main.musym 

--LAST STEP QUERY APPARENT
SELECT DISTINCT #main.areasymbol,  #main.areaname, #main.lkey,  #main.musym, #main.mukey, #main.compname, #main.comppct_r,
 #main.cokey, #main.drainagecl, 'Apparent' AS apparent
INTO #last_step_a
FROM #main 
INNER JOIN  #perched on #main.comonthkey = #perched.comonthkey ORDER BY #main.areasymbol,  #main.musym 


SELECT DISTINCT  
#main.areasymbol,  
#main.areaname, 
#main.lkey,  
#main.musym, 
#main.mukey, 
#main.compname,
#main.comppct_r,
#main.cokey, 
#main.drainagecl, 
 CASE WHEN #main.drainagecl IS NULL THEN NULL
 WHEN perched = 'perched' THEN perched
 WHEN apparent = 'apparent' THEN apparent ELSE 'not rated' END AS perched_apparent, perched, apparent

FROM #main 
INNER JOIN  #last_step_p on #main.cokey = #last_step_p.cokey 
INNER JOIN   #last_step_a on #main.cokey = #last_step_a.cokey 
ORDER BY #main.areasymbol,  #main.musym 



DROP TABLE IF EXISTS #main;
DROP TABLE IF EXISTS #perched;
DROP TABLE IF EXISTS #last_step_a;
DROP TABLE IF EXISTS #last_step_p;
DROP TABLE IF EXISTS #apparent;

SET STATISTICS IO OFF