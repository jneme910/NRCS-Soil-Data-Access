SELECT areasymbol, musym, muname, mukey
INTO #kitchensink
FROM legend  AS lks
INNER JOIN  mapunit AS muks ON muks.lkey = lks.lkey AND lks.areasymbol ='WI081'  

SELECT mu1.mukey, cokey, comppct_r, 
SUM (comppct_r) over(partition by mu1.mukey ) AS SUM_COMP_PCT

 
INTO #comp_temp
FROM legend  AS l1
INNER JOIN  mapunit AS mu1 ON mu1.lkey = l1.lkey AND l1.areasymbol = 'WI081'  
INNER JOIN  component AS c1 ON c1.mukey = mu1.mukey AND majcompflag = 'Yes'


SELECT cokey, SUM_COMP_PCT, CASE WHEN comppct_r = SUM_COMP_PCT THEN 1 
ELSE CAST (CAST (comppct_r AS  decimal (5,2)) / CAST (SUM_COMP_PCT AS decimal (5,2)) AS decimal (5,2)) END AS WEIGHTED_COMP_PCT 
INTO #comp_temp3
FROM #comp_temp



SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, c.cokey AS COKEY, ch.chkey/1 AS CHKEY, compname, hzname, hzdept_r, hzdepb_r, CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END AS hzdept_r_ADJ, 
CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END AS hzdepb_r_ADJ,
CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END - CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END AS thickness,
comppct_r, 

SUM (CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END - CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END) over(partition by c.cokey) AS sum_thickness, 
om_r
INTO #main
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'WI081' 
INNER JOIN  component AS c ON c.mukey = mu.mukey  
INNER JOIN chorizon AS ch ON ch.cokey=c.cokey AND hzname NOT LIKE '%O%'AND hzname NOT LIKE '%r%'
AND hzdepb_r >8 AND hzdept_r <30
INNER JOIN chtexturegrp AS cht ON ch.chkey=cht.chkey  WHERE cht.rvindicator = 'yes' AND  ch.hzdept_r IS NOT NULL 
AND
texture NOT LIKE '%PM%' and texture NOT LIKE '%DOM' and texture NOT LIKE '%MPT%' and texture NOT LIKE '%MUCK' and texture NOT LIKE '%PEAT%' and texture NOT LIKE '%br%' and texture NOT LIKE '%wb%'

ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC, cokey,  hzdept_r, hzdepb_r



SELECT #main.areasymbol, #main.musym, #main.muname, #main.MUKEY, 
#main.COKEY, #main.CHKEY, #main.compname, hzname, hzdept_r, hzdepb_r, hzdept_r_ADJ, hzdepb_r_ADJ, thickness, sum_thickness, om_r, comppct_r, SUM_COMP_PCT, WEIGHTED_COMP_PCT ,

CAST(ROUND (SUM (CAST (CAST (thickness AS decimal (5,3))/ CAST (sum_thickness AS decimal (5,3)) AS decimal (5,3)) * CAST(om_r as decimal(5,3))) over(partition by #main.COKEY), 2)as decimal(5,2)) AS COMP_WEIGHTED_AVERAGE
--CAST(SUM (CAST (CAST (thickness AS decimal (5,3))/ CAST (sum_thickness AS decimal (5,3)) AS decimal (5,3))) over(partition by COKEY)as decimal(5,3)) AS test
INTO #comp_temp2
FROM #main
INNER JOIN #comp_temp3 ON #comp_temp3.cokey=#main.cokey
ORDER BY #main.areasymbol, #main.musym, #main.muname, #main.MUKEY, comppct_r DESC,  #main.COKEY,  hzdept_r, hzdepb_r

SELECT #comp_temp2.MUKEY,#comp_temp2.COKEY, WEIGHTED_COMP_PCT * COMP_WEIGHTED_AVERAGE AS COMP_WEIGHTED_AVERAGE1
INTO #last_step
FROM #comp_temp2 
GROUP BY  #comp_temp2.MUKEY,#comp_temp2.COKEY, WEIGHTED_COMP_PCT, COMP_WEIGHTED_AVERAGE

SELECT areasymbol, musym, muname, 
#kitchensink.mukey, #last_step.COKEY, 
CAST (SUM (COMP_WEIGHTED_AVERAGE1) over(partition by #kitchensink.mukey) as decimal(5,2))AS WEIGHTED_AVERAGE
INTO #last_step2
FROM #last_step
RIGHT OUTER JOIN #kitchensink ON #kitchensink.mukey=#last_step.mukey 
GROUP BY #kitchensink.areasymbol, #kitchensink.musym, #kitchensink.muname, #kitchensink.mukey, COMP_WEIGHTED_AVERAGE1, #last_step.COKEY
ORDER BY #kitchensink.areasymbol, #kitchensink.musym, #kitchensink.muname, #kitchensink.mukey


SELECT #last_step2.areasymbol, #last_step2.musym, #last_step2.muname, 
#last_step2.mukey, #last_step2.WEIGHTED_AVERAGE 

FROM #last_step2
LEFT OUTER JOIN #last_step ON #last_step.mukey=#last_step2.mukey 
GROUP BY #last_step2.areasymbol, #last_step2.musym, #last_step2.muname, #last_step2.mukey, #last_step2.WEIGHTED_AVERAGE
ORDER BY #last_step2.areasymbol, #last_step2.musym, #last_step2.muname, #last_step2.mukey, #last_step2.WEIGHTED_AVERAGE






