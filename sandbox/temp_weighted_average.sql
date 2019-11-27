SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, c.cokey AS COKEY, ch.chkey/1 AS CHKEY, compname, hzname, hzdept_r, hzdepb_r, CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END AS hzdept_r_ADJ, 
CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END AS hzdepb_r_ADJ,
CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END - CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END AS thickness,
comppct_r, SUM (comppct_r) over(partition by mu.mukey) AS SUM_COMP_PCT,
---(SELECT SUM (CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END - CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END) 
SUM (CASE WHEN hzdepb_r > 30  THEN 30 ELSE hzdepb_r END - CASE WHEN hzdept_r <8 THEN 8 ELSE hzdept_r END) over(partition by c.cokey) AS sum_thickness, 
om_r
INTO #main
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND l.areasymbol LIKE 'TN610' 
INNER JOIN  component AS c ON c.mukey = mu.mukey  
INNER JOIN chorizon AS ch ON ch.cokey=c.cokey AND hzname NOT LIKE '%O%'
AND hzdepb_r >8 AND hzdept_r <30
INNER JOIN chtexturegrp AS cht ON ch.chkey=cht.chkey  WHERE cht.rvindicator = 'yes' AND  ch.hzdept_r IS NOT NULL  AND hzname NOT LIKE '%O%'
ORDER BY areasymbol, musym, muname, mu.mukey, comppct_r DESC, cokey,  hzdept_r, hzdepb_r


SELECT areasymbol, musym, muname, MUKEY, COKEY, CHKEY, compname, hzname, hzdept_r, hzdepb_r, hzdept_r_ADJ, hzdepb_r_ADJ, thickness, sum_thickness, om_r, comppct_r, SUM_COMP_PCT,
CAST(SUM (CAST((thickness/sum_thickness)as decimal(5,3)) * CAST(om_r as decimal(5,3))) over(partition by COKEY)as decimal(5,3)) AS COMP_WEIGHTED_AVERAGE,
CAST(ROUND (SUM (CAST (CAST (thickness AS decimal (5,3))/ CAST (sum_thickness AS decimal (5,3)) AS decimal (5,3)) * CAST(om_r as decimal(5,3))) over(partition by COKEY), 2)as decimal(5,2)) AS test
--CAST(SUM (CAST (CAST (thickness AS decimal (5,3))/ CAST (sum_thickness AS decimal (5,3)) AS decimal (5,3))) over(partition by COKEY)as decimal(5,3)) AS test
FROM #main
ORDER BY areasymbol, musym, muname, MUKEY, comppct_r DESC,  COKEY,  hzdept_r, hzdepb_r

