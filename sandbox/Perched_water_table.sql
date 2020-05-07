SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #main;
DROP TABLE IF EXISTS #perched;
DROP TABLE IF EXISTS #last_step_a;
DROP TABLE IF EXISTS #last_step_p;
DROP TABLE IF EXISTS #apparent;

SELECT areasymbol, LEFT((areasymbol), 2) as state, areaname, l.lkey,  musym, m.mukey, compname, comppct_r, c.cokey, drainagecl, cm.comonthkey, cs.cosoilmoistkey
INTO #main
FROM legend l inner join mapunit m left outer join component c left outer join comonth cm left outer join cosoilmoist cs
	ON cm.comonthkey = cs.comonthkey
	ON c.cokey = cm.cokey
    	ON m.mukey = c.mukey
    	ON l.lkey = m.lkey
WHERE  areasymbol ='WI003'
  --LEFT((areasymbol), 2) IN ('WI') 
AND c.majcompflag IN ('yes')


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
    (topApply.soimoiststat = 'Wet' and (bottomApply.soimoiststat IN ('Moist', 'Dry') OR bottomApply.soimoiststat  IS NULL));


--APPARENT QUERY
select comonthkey 
  INTO #apparent
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
    (topApply.soimoiststat = 'Wet' and  bottomApply.soimoiststat = 'Wet');

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


SELECT DISTINCT  #main.areasymbol,  #main.areaname, #main.lkey,  #main.musym, #main.mukey, #main.compname, #main.comppct_r,
 #main.cokey, #main.drainagecl, 
 CASE WHEN #main.drainagecl IS NULL THEN NULL
 WHEN apparent IS NOT NULL THEN apparent
 WHEN perched IS NOT NULL THEN perched ELSE 'not rated' END AS perched_apparent 
FROM #main 
LEFT OUTER JOIN #last_step_p on #main.cokey = #last_step_p.cokey 
LEFT OUTER JOIN #last_step_a on #main.cokey = #last_step_a.cokey 
ORDER BY #main.areasymbol,  #main.musym 



DROP TABLE IF EXISTS #main;
DROP TABLE IF EXISTS #perched;
DROP TABLE IF EXISTS #last_step_a;
DROP TABLE IF EXISTS #last_step_p;
DROP TABLE IF EXISTS #apparent;

SET STATISTICS IO OFF