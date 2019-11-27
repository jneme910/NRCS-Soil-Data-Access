SELECT areasymbol, LEFT((areasymbol), 2) as state, areaname, l.lkey,  musym, m.mukey, compname, comppct_r, c.cokey, drainagecl, cm.comonthkey, cs.cosoilmoistkey
INTO #temp1
FROM legend l inner join mapunit m left outer join component c left outer join comonth cm left outer join cosoilmoist cs
	ON cm.comonthkey = cs.comonthkey
	ON c.cokey = cm.cokey
    	ON m.mukey = c.mukey
    	ON l.lkey = m.lkey
WHERE  ---areasymbol ='WI003'
  LEFT((areasymbol), 2) IN ('WI') 
and c.majcompflag IN ('YES')

select comonthkey
  into #temp2
from COSOILMOIST as t_source
cross apply (
    select soimoiststat, soimoistdept_r 
    from COSOILMOIST
    where comonthkey = t_source.comonthkey
) topApply
cross apply (
    select soimoiststat, soimoistdept_r 
    from COSOILMOIST
    where comonthkey = t_source.comonthkey
) bottomApply
where
    bottomApply.soimoistdept_r > topApply.soimoistdept_r and
    (topApply.soimoiststat = 'Wet' and (bottomApply.soimoiststat IN ('Moist', 'Dry') OR bottomApply.soimoiststat  IS NULL));


SELECT  distinct #temp1.areasymbol,  #temp1.areaname, #temp1.lkey,  #temp1.musym, #temp1.mukey, #temp1.compname, #temp1.comppct_r,
 #temp1.cokey, #temp1.drainagecl, 'Perched' AS perched
INTO #last_step
FROM #temp1 
inner  join  #temp2 on #temp1.comonthkey = #temp2.comonthkey ORDER BY #temp1.areasymbol,  #temp1.musym 

SELECT  distinct #temp1.areasymbol,  #temp1.areaname, #temp1.lkey,  #temp1.musym, #temp1.mukey, #temp1.compname, #temp1.comppct_r,
 #temp1.cokey, #temp1.drainagecl, CASE WHEN #temp1.drainagecl IS NULL THEN NULL
 WHEN perched IS NULL THEN 'Apparent' ELSE perched END AS perched_apparent 
FROM #temp1 
LEFT OUTER JOIN #last_step on #temp1.cokey = #last_step.cokey ORDER BY #temp1.areasymbol,  #temp1.musym 