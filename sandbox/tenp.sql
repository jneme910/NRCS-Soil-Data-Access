SELECT QUOTENAME (sacatalog.areasymbol, '"') AS AREASYMBOL, 
mapunit.mukey AS mukey, 
QUOTENAME (mapunit.musym, '"') AS MUSYM,
QUOTENAME (mapunit.muname, '"') AS MUNAME,
QUOTENAME (CONCAT(mapunit.mukey, ' - ', cokey), '"') AS MUCOMPKEY,
QUOTENAME (compname, '"') AS COMPNAME, 
QUOTENAME (comppct_r, '"') AS COMPPCT_R,
component.cokey,


(SELECT TOP 1 MIN (resdept_r) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE '%bedrock%' AND c.cokey=component.cokey  GROUP BY c.cokey) AS restrictiodepth,




(SELECT TOP 1 MIN (soimoistdept_r) FROM component AS c2 
INNER JOIN comonth ON c2.cokey=comonth.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey
AND c2.cokey=component.cokey AND soimoiststat = 'wet'  GROUP BY c2.cokey) AS MIN_YR_H20,

(SELECT TOP 1 MIN (soimoistdept_r) FROM component AS c2 
INNER JOIN comonth ON c2.cokey=comonth.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey
AND c2.cokey=component.cokey AND soimoiststat = 'wet'  AND month IN ('April', 'May', 'June') GROUP BY c2.cokey) AS MIN_APR2JUN_H20,
hydricrating,
drainagecl,
hydgrp
INTO #main
FROM sacatalog 
INNER JOIN legend  ON legend.areasymbol = sacatalog.areasymbol AND LEFT ((sacatalog.areasymbol),2) = 'WI'
INNER JOIN mapunit  ON mapunit.lkey = legend.lkey
INNER JOIN component ON component.mukey=mapunit.mukey AND majcompflag = 'Yes'



------------------ START OF HORIZON -----------------------
SELECT #main.mukey, 
#main.AREASYMBOL,
#main.MUSYM,
#main.MUNAME,
#main.MUCOMPKEY,
#main.MIN_YR_H20,
#main.MIN_APR2JUN_H20,
#main.COMPPCT_R,
#main.hydricrating,
#main.drainagecl,
#main.hydgrp,
c1.compname, c1.cokey, CASE WHEN (hzdepb_r-hzdept_r) IS NULL THEN 0 ELSE CAST((hzdepb_r-hzdept_r)  AS INT ) END AS thickness , 
ch.chkey, ch.hzdept_r, texture, hzdepb_r, hzname,awc_r , restrictiodepth
INTO #badgers
FROM #main
INNER JOIN component AS c1 ON c1.cokey = #main.cokey and c1.majcompflag = 'yes' 
LEFT OUTER JOIN chorizon AS ch ON ch.cokey = c1.cokey 
LEFT OUTER JOIN chtexturegrp AS cht ON ch.chkey=cht.chkey  WHERE cht.rvindicator = 'yes' AND  ch.hzdept_r IS NOT NULL  AND hzname NOT LIKE '%O%'
ORDER BY ch.hzdept_r 


----grab top depth for the mineral soil and will use it later to get mineral surface properties

SELECT #badgers.compname, #badgers.cokey, MIN(hzdept_r) AS min_t
INTO #hortopdepth
FROM #badgers
WHERE texture NOT LIKE '%PM%' and texture NOT LIKE '%DOM' and texture NOT LIKE '%MPT%' and texture NOT LIKE '%MUCK' and texture NOT LIKE '%PEAT%'
GROUP BY compname, cokey

---combine the mineral surface to grab surface mineral properties

Select #hortopdepth.cokey,
hzname,
 hzdept_r,
 hzdepb_r,
 thickness,
awc_r as awc_surf,
 chkey
INTO #badgers2
FROM #hortopdepth
LEFT OUTER JOIN #badgers on #hortopdepth.cokey=#badgers.cokey AND #hortopdepth.min_t = #badgers.hzdept_r
ORDER BY #hortopdepth.cokey, hzname



--horizon data

SELECT
mukey, restrictiodepth, 
 cokey
, hzname
, hzdept_r
, hzdepb_r
, case when (hzdepb_r-hzdept_r) is null then 0 else cast((hzdepb_r-hzdept_r)  as int) END as thickness
, texture
, CASE when awc_r is null then 0 else awc_r end as awc_r
, chkey
INTO #badgershzn
FROM #badgers

--- depth ranges for AWS ----

Select 
CASE    WHEN hzdepb_r <= 150 THEN hzdepb_r
   WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150
   ELSE 0
   END AS InRangeBot,
CASE    WHEN hzdept_r < 150 then hzdept_r
   ELSE 0
   END as InRangeTop, awc_r, cokey, mukey
INTO #aws
FROM #badgers
order by cokey

select mukey, cokey, SUM((InRangeBot - InRangeTop)*awc_r) as AWS100
INTO #aws100
FROM #aws 
group by mukey, cokey

---return to weighted averages, using the thickness times the non-null horizon properties

SELECT mukey, cokey, chkey, thickness, (awc_r*thickness) as th_awc_r, restrictiodepth
INTO #badgers3
FROM #badgershzn 
ORDER BY mukey, cokey, chkey


---sum all horizon properties to gather the final product for the component

select mukey, cokey, restrictiodepth
, cast(sum(thickness) as float(2)) as sum_thickness
, cast(sum(th_awc_r) as float(2)) as sum_awc_r
INTO #badgers4
FROM #badgers3
GROUP BY mukey, cokey, restrictiodepth 
ORDER BY mukey

---find the depth to use in the weighted average calculation 

SELECT mukey, cokey, case when sum_thickness < restrictiodepth then sum_thickness  ELSE 200 end as restrictiondepth
INTO #depthtest
FROM #badgers4



---sql to create weighted average by dividing by the restriction depth found in the above query

select #badgers4.mukey, #badgers4.cokey, sum_thickness, (sum_awc_r) as profile_Waterstorage, (sum_awc_r/#depthtest.restrictiondepth) as wtavg_awc_r_to_restrict
INTO #badgerswtavg 
FROM #badgers4 
INNER JOIN #depthtest on #badgers4.cokey=#depthtest.cokey
ORDER by #badgers4.mukey, #badgers4.cokey

--time to put it all together using a lot of casts to change the data to reflect the way I want it to appear

SELECT #main.mukey, 
#main.AREASYMBOL,
#main.MUSYM,
#main.MUNAME,
#main.MUCOMPKEY,
#main.COMPNAME,
#main.COMPPCT_R,
#main.hydricrating,
#main.drainagecl,
#main.hydgrp,
#main.cokey,
#main.restrictiodepth,
CAST(AWS100 AS Decimal(5,1)) as AWS_0_150_dcp --,
--CAST(profile_Waterstorage AS Decimal(5,1)) as AWS_profile_dcp,
---CAST(wtavg_awc_r_to_restrict AS Decimal(5,1)) as AWS_restrict_dcp
FROM #main
---LEFT OUTER JOIN #badgers on #badgers.cokey = #main.cokey 
--LEFT OUTER JOIN #badgers2 on #badgers.cokey = #badgers2.cokey 
LEFT OUTER JOIN #aws100 on #main.cokey = #aws100.cokey
---WHERE (#badgers.cokey) IS NOT NULL  
GROUP BY 
#main.AREASYMBOL,
#main.MUSYM,
#main.MUNAME,
#main.MUCOMPKEY,
#main.mukey, 
#main.COMPNAME,
#main.COMPPCT_R,
#main.hydricrating,
#main.drainagecl,
#main.hydgrp,
#main.cokey,
#AWS100.AWS100,
#main.restrictiodepth

ORDER BY #main.areasymbol, #main.musym, #main.mukey, #main.COMPPCT_R, 
#main.cokey

