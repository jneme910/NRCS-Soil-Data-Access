---SOC
---Soil organic carbon stock estimate (SOC) in total soil profile (0 cm to the reported depth of the soil profile). The concentration of organic carbon present in the soil expressed in grams C per square meter for the total reported soil profile depth. NULL values are presented where data are incomplete or not available.
---Uses all components with horizon data.
---Does not calculate component SOC below the following component restrictions:
---Lithic bedrock, Paralithic bedrock, Densic bedrock, Fragipan, Duripan, Sulfuric
---soc =  ( (hzT * ( ( om / 1.724 ) * db3 )) / 100.0 ) * ((100.0 - fragvol) / 100.0) 



SELECT areasymbol, areaname, mapunit.mukey, mapunit.mukey AS mulink, mapunit.musym, nationalmusym, mapunit.muname, mukind, muacres
INTO #main
FROM legend
INNER JOIN mapunit on legend.lkey=mapunit.lkey ---AND mapunit.mukey = 753534 --661781 --2809839 For Testing
INNER JOIN muaggatt AS mt1 on mapunit.mukey=mt1.mukey
--AND legend.areasymbol <> 'US' -- SSURGO
AND legend.areasymbol = 'US' -- STATSGO
--AND legend.areasymbol = 'WI025'


-------------------------------------------
SELECT
-- grab survey area data
LEFT((areasymbol), 2) AS state,
 l.areasymbol,
 l.areaname,
(SELECT SUM (DISTINCT comppct_r) FROM mapunit  AS mui3  INNER JOIN component AS cint3 ON cint3.mukey=mui3.mukey INNER JOIN chorizon AS chint3 ON chint3.cokey=cint3.cokey AND cint3.cokey = c.cokey GROUP BY chint3.cokey) AS sum_comp,
--grab map unit level information
 mu.mukey,
 mu.musym,
--grab component level information

 c.majcompflag,
 c.comppct_r,
 c.compname,
 compkind,
 localphase,
 slope_l,
 slope_r,
 slope_h,
(SELECT CAST(MIN(resdept_r) AS INTEGER) FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND reskind  IS NOT NULL) AS restrictiondepth,
(SELECT CASE WHEN MIN (resdept_r) IS NULL THEN 200 ELSE CAST (MIN (resdept_r) AS INT) END FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND reskind IS NOT NULL) AS restrictiodepth,
(SELECT TOP 1  reskind  FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND corestrictions.reskind IN ('Lithic bedrock','Duripan', 'Densic bedrock', 'Paralithic bedrock', 'Fragipan', 'Natric', 'Ortstein', 'Permafrost', 'Petrocalcic', 'Petrogypsic')
AND reskind IS NOT NULL ORDER BY resdept_r) AS TOPrestriction, c.cokey,

---begin selection of horizon properties
 hzname,
 hzdept_r,
 hzdepb_r,
 
hzdept_l,
 hzdepb_l,
  
  
hzdept_h,
 hzdepb_h,
 
 
 CASE WHEN (hzdepb_l-hzdept_l) IS NULL THEN 0 ELSE CAST((hzdepb_l-hzdept_l) AS INT) END AS thickness_l,  
  CASE WHEN (hzdepb_h-hzdept_h) IS NULL THEN 0 ELSE CAST((hzdepb_h-hzdept_h) AS INT) END AS thickness_h,  
CASE WHEN (hzdepb_r-hzdept_r) IS NULL THEN 0 ELSE CAST((hzdepb_r-hzdept_r) AS INT) END AS thickness,  

CASE WHEN texture LIKE '%PM%' AND (om_r) IS NULL THEN 35
WHEN texture LIKE '%MUCK%' AND (om_r) IS NULL THEN 35
WHEN texture LIKE '%PEAT%' AND (om_r) IS NULL THEN 35 ELSE om_r END AS om_r , 

CASE WHEN texture LIKE '%PM%' AND (om_l) IS NULL THEN 35
WHEN texture LIKE '%MUCK%' AND (om_l) IS NULL THEN 35
WHEN texture LIKE '%PEAT%' AND (om_l) IS NULL THEN 35 
WHEN (om_l) IS NULL THEN om_r
ELSE om_l END AS om_l , 

CASE WHEN texture LIKE '%PM%' AND (om_h) IS NULL THEN 35
WHEN texture LIKE '%MUCK%' AND (om_h) IS NULL THEN 35
WHEN texture LIKE '%PEAT%' AND (om_h) IS NULL THEN 35 
WHEN (om_h) IS NULL THEN om_h
ELSE om_h END AS om_h , 

--<30% OM – 0.25 g/cm3
--30 – 50 OM – 0.2 g/cm3
--50 – 75 OM – 0.15 g/cm3
-->75 OM – 0.1 g/cm3

CASE WHEN (texture LIKE '%PM%' AND (dbthirdbar_r) IS NULL AND (om_r) IS NULL) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_r) IS NULL AND (om_r) IS NULL) THEN 0.25
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_r) IS NULL AND (om_r) IS NULL) THEN 0.25 

WHEN (texture LIKE '%PM%' AND (dbthirdbar_r) IS NULL AND (om_r) <30) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_r) IS NULL AND ((om_r) BETWEEN 30 AND 50)) THEN 0.20
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_r) IS NULL AND ((om_r) BETWEEN 50 AND 75)) THEN 0.15 
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_r) IS NULL AND ((om_r) >= 75)) THEN 0.10

WHEN (texture LIKE '%PM%' AND (dbthirdbar_r) IS NULL ) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_r) IS NULL ) THEN 0.25
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_r) IS NULL ) THEN 0.25 

ELSE dbthirdbar_r END AS dbthirdbar_r, 

CASE WHEN texture LIKE '%PM%' AND (dbthirdbar_l) IS NULL AND (om_l) IS NULL THEN 0.25
WHEN texture LIKE '%MUCK%' AND (dbthirdbar_l) IS NULL AND (om_l) IS NULL THEN 0.25
WHEN texture LIKE '%PEAT%' AND (dbthirdbar_l) IS NULL AND (om_l) IS NULL THEN 0.25 

WHEN (texture LIKE '%PM%' AND (dbthirdbar_l) IS NULL AND (om_l) <30) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_l) IS NULL AND ((om_l) BETWEEN 30 AND 50)) THEN 0.20
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_l) IS NULL AND ((om_l) BETWEEN 50 AND 75)) THEN 0.15 
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_l) IS NULL AND ((om_l) >= 75)) THEN 0.10
WHEN (dbthirdbar_l) IS NULL THEN dbthirdbar_r

WHEN (texture LIKE '%PM%' AND (dbthirdbar_l) IS NULL ) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_l) IS NULL ) THEN 0.25
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_l) IS NULL ) THEN 0.25 

ELSE dbthirdbar_l END AS dbthirdbar_l, 

CASE WHEN texture LIKE '%PM%' AND (dbthirdbar_h) IS NULL AND (om_h) IS NULL THEN 0.25
WHEN texture LIKE '%MUCK%' AND (dbthirdbar_h) IS NULL AND (om_h) IS NULL THEN 0.25
WHEN texture LIKE '%PEAT%' AND (dbthirdbar_h) IS NULL AND (om_h) IS NULL THEN 0.25 
WHEN (texture LIKE '%PM%' AND (dbthirdbar_h) IS NULL AND (om_l) <30) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_h) IS NULL AND ((om_h) BETWEEN 30 AND 50)) THEN 0.20
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_h) IS NULL AND ((om_h) BETWEEN 50 AND 75)) THEN 0.15 
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_h) IS NULL AND ((om_h) >= 75)) THEN 0.10

WHEN (texture LIKE '%PM%' AND (dbthirdbar_h) IS NULL ) THEN 0.25
WHEN (texture LIKE '%MUCK%' AND (dbthirdbar_h) IS NULL ) THEN 0.25
WHEN (texture LIKE '%PEAT%' AND (dbthirdbar_h) IS NULL ) THEN 0.25 

WHEN (dbthirdbar_h) IS NULL THEN dbthirdbar_r
ELSE dbthirdbar_h END AS dbthirdbar_h, 


  (SELECT CASE WHEN SUM (cf.fragvol_r) IS NULL THEN 0 ELSE CAST (SUM(cf.fragvol_r) AS INT) END FROM chfrags cf WHERE cf.chkey = ch.chkey) as fragvol,
  
   (SELECT CASE WHEN SUM (cf.fragvol_l) IS NULL THEN 0 ELSE CAST (SUM(cf.fragvol_l) AS INT) END FROM chfrags cf WHERE cf.chkey = ch.chkey) as fragvol_l, 
   (SELECT CASE WHEN SUM (cf.fragvol_h) IS NULL THEN 0 ELSE CAST (SUM(cf.fragvol_h) AS INT) END FROM chfrags cf WHERE cf.chkey = ch.chkey) as fragvol_h,  
brockdepmin,
  texture,
  ch.chkey
INTO #acpf
FROM legend  AS l
INNER JOIN mapunit AS mu ON mu.lkey = l.lkey 
--AND l.areasymbol like 'WI025'
---AND mu.mukey =   753534 --661781 --2809839 For testing
--AND l.areasymbol <> 'US' -- SSURGO
AND l.areasymbol = 'US' -- STATSGO
INNER JOIN muaggatt AS  mt on mu.mukey=mt.mukey
INNER JOIN component AS  c ON c.mukey = mu.mukey 
LEFT OUTER JOIN  chorizon AS ch ON ch.cokey = c.cokey 
LEFT OUTER JOIN  chtexturegrp AS ct ON ch.chkey=ct.chkey and ct.rvindicator = 'yes'
and CASE WHEN hzdept_r IS NULL THEN 2 
WHEN texture LIKE '%PM%' AND om_r IS NULL THEN 1
WHEN texture LIKE '%MUCK%' AND om_r IS NULL THEN 1
WHEN texture LIKE '%PEAT%' AND om_r IS NULL THEN 1
WHEN texture LIKE '%PM%' AND dbthirdbar_r IS NULL THEN 1
WHEN texture LIKE '%MUCK%' AND dbthirdbar_r IS NULL THEN 1
WHEN texture LIKE '%PEAT%' AND dbthirdbar_r IS NULL THEN 1
--WHEN om_r IS NULL THEN 2 
WHEN om_r = 0 THEN 2 
--WHEN dbthirdbar_r IS NULL THEN 2
WHEN dbthirdbar_r = 0 THEN 2
ELSE 1 END = 1
ORDER by l.areasymbol, mu.musym, hzdept_r 



---Sums the Component Percent and eliminate duplicate values by cokey
SELECT mukey, cokey,  SUM (DISTINCT sum_comp) AS sum_comp2
INTO #muacpf
FROM #acpf AS acpf2
WHERE acpf2.cokey=cokey
GROUP BY mukey, cokey

---Sums the component percent in a map unit
SELECT mukey, cokey, sum_comp2,  SUM (sum_comp2) over(partition by #muacpf.mukey ) AS sum_comp3 --, SUM (sum_comp2) AS sum_comp3
INTO #muacpf2
FROM #muacpf
GROUP BY mukey, cokey, sum_comp2

---Gets the Weighted component percent. Example from "Column F" up top 
SELECT mukey, cokey,  CASE WHEN sum_comp2 = sum_comp3 THEN 1 
ELSE CAST (CAST (sum_comp2 AS  decimal (5,2)) / CAST (sum_comp3 AS decimal (5,2)) AS decimal (5,2)) END AS WEIGHTED_COMP_PCT 
INTO #muacpf3
FROM #muacpf2





--grab top depth for the mineral soil and will use it later to get mineral surface properties
--Because of SOC this wasnt really needed. If any error add statement below back
SELECT compname, cokey, MIN(hzdept_r) AS min_t 
INTO #hortopdepth 
FROM #acpf 
---WHERE texture NOT LIKE '%PM%' and texture NOT LIKE '%DOM' and texture NOT LIKE '%MPT%' AND texture NOT LIKE '%MUCK' AND texture NOT LIKE '%PEAT%'
GROUP BY  cokey, compname


---combine the mineral surface to grab surface mineral properties
SELECT #hortopdepth.cokey,
hzname,
hzdept_r,
hzdepb_r,
thickness,
texture AS texture_surf,
om_r AS om_surf,
dbthirdbar_r AS db_surf, 
fragvol AS frag_surf, 
chkey
INTO #acpf2
FROM #hortopdepth
INNER JOIN #acpf on #hortopdepth.cokey=#acpf.cokey AND #hortopdepth.min_t = #acpf.hzdept_r
ORDER BY #hortopdepth.cokey, hzname




SELECT
mukey,
cokey,
hzname,
restrictiodepth, 
hzdept_r,
hzdepb_r,
CASE WHEN (hzdepb_r-hzdept_r) IS NULL THEN 0 ELSE CAST ((hzdepb_r-hzdept_r) AS INT) END AS thickness,
texture,
CASE WHEN dbthirdbar_r IS NULL THEN 0 ELSE dbthirdbar_r  END AS dbthirdbar_r, 
CASE WHEN fragvol IS NULL THEN 0 ELSE fragvol  END AS fragvol, 
CASE when om_r IS NULL THEN 0 ELSE om_r END AS om_r,
chkey
INTO #acpfhzn
FROM #acpf


--- depth ranges for SOC ----
SELECT hzname, chkey, comppct_r, hzdept_r, hzdepb_r, thickness,
CASE  WHEN hzdept_r < 150 then hzdept_r ELSE 0 END AS InRangeTop_0_150, 
CASE  WHEN hzdepb_r <= 150 THEN hzdepb_r WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150 ELSE 0 END AS InRangeBot_0_150,

CASE  WHEN hzdept_r < 5 then hzdept_r ELSE 0 END AS InRangeTop_0_5, 
CASE  WHEN hzdepb_r <= 5 THEN hzdepb_r WHEN hzdepb_r > 5 and hzdept_r < 5 THEN 5 ELSE 0 END AS InRangeBot_0_5,


CASE  WHEN hzdept_r < 30 then hzdept_r ELSE 0 END AS InRangeTop_0_30, 
CASE  WHEN hzdepb_r <= 30  THEN hzdepb_r WHEN hzdepb_r > 30  and hzdept_r < 30 THEN 30  ELSE 0 END AS InRangeBot_0_30,


CASE  WHEN hzdept_l < 30 then hzdept_l ELSE 0 END AS InRangeTop_0_30_l, 
CASE  WHEN hzdepb_h <= 30  THEN hzdepb_h WHEN hzdepb_h > 30  and hzdept_h < 30 THEN 30  ELSE 0 END AS InRangeBot_0_30_h,
---5 to 15 
CASE    WHEN hzdepb_r < 5 THEN 0
WHEN hzdept_r >15 THEN 0 
WHEN hzdepb_r >= 5 AND hzdept_r < 5 THEN 5 
WHEN hzdept_r < 5 THEN 0
		WHEN hzdept_r < 15 then hzdept_r ELSE 5 END AS InRangeTop_5_15 ,
		
	
CASE   WHEN hzdept_r > 15 THEN 0
WHEN hzdepb_r < 5 THEN 0
WHEN hzdepb_r <= 15 THEN hzdepb_r  WHEN hzdepb_r > 15 and hzdept_r < 15 THEN 15 ELSE 5 END AS InRangeBot_5_15,
---15 to 30
CASE    WHEN hzdepb_r < 15 THEN 0
WHEN hzdept_r >30 THEN 0 
WHEN hzdepb_r >= 15 AND hzdept_r < 15 THEN 15 
WHEN hzdept_r < 15 THEN 0
		WHEN hzdept_r < 30 then hzdept_r ELSE 15 END AS InRangeTop_15_30 ,
		
	
CASE   WHEN hzdept_r > 30 THEN 0
WHEN hzdepb_r < 15 THEN 0
WHEN hzdepb_r <= 30 THEN hzdepb_r  WHEN hzdepb_r > 30 and hzdept_r < 30 THEN 30 ELSE 15 END AS InRangeBot_15_30,

--30 to 60
CASE    WHEN hzdepb_r < 30 THEN 0
WHEN hzdept_r >60 THEN 0 
WHEN hzdepb_r >= 30 AND hzdept_r < 30 THEN 30 
WHEN hzdept_r < 30 THEN 0
		WHEN hzdept_r < 60 then hzdept_r ELSE 30 END AS InRangeTop_30_60 ,
		
	
CASE   WHEN hzdept_r > 60 THEN 0
WHEN hzdepb_r < 30 THEN 0
WHEN hzdepb_r <= 60 THEN hzdepb_r  WHEN hzdepb_r > 60 and hzdept_r < 60 THEN 60 ELSE 30 END AS InRangeBot_30_60,

---60 to 100
CASE    WHEN hzdepb_r < 60 THEN 0
WHEN hzdept_r >100 THEN 0 
WHEN hzdepb_r >= 60 AND hzdept_r < 60 THEN 60 
WHEN hzdept_r < 60 THEN 0
		WHEN hzdept_r < 100 then hzdept_r ELSE 60 END AS InRangeTop_60_100 ,
		
	
CASE   WHEN hzdept_r > 100 THEN 0
WHEN hzdepb_r < 60 THEN 0
WHEN hzdepb_r <= 100 THEN hzdepb_r  WHEN hzdepb_r > 100 and hzdept_r < 100 THEN 100 ELSE 60 END AS InRangeBot_60_100,

--100 to 200
CASE    WHEN hzdepb_r < 100 THEN 0
WHEN hzdept_r >200 THEN 0 
WHEN hzdepb_r >= 100 AND hzdept_r < 100 THEN 100 
WHEN hzdept_r < 100 THEN 0
		WHEN hzdept_r < 200 then hzdept_r ELSE 100 END AS InRangeTop_100_200 ,
		
	
CASE   WHEN hzdept_r > 200 THEN 0
WHEN hzdepb_r < 100 THEN 0
WHEN hzdepb_r <= 200 THEN hzdepb_r  WHEN hzdepb_r > 200 and hzdept_r < 200 THEN 200 ELSE 100 END AS InRangeBot_100_200,
CASE    WHEN hzdepb_r < 20 THEN 0
WHEN hzdept_r >50 THEN 0 
WHEN hzdepb_r >= 20 AND hzdept_r < 20 THEN 20 
WHEN hzdept_r < 20 THEN 0
		WHEN hzdept_r < 50 then hzdept_r ELSE 20 END AS InRangeTop_20_50 ,
		
	
CASE   WHEN hzdept_r > 50 THEN 0
WHEN hzdepb_r < 20 THEN 0
WHEN hzdepb_r <= 50 THEN hzdepb_r  WHEN hzdepb_r > 50 and hzdept_r < 50 THEN 50 ELSE 20 END AS InRangeBot_20_50,



CASE    WHEN hzdepb_r < 50 THEN 0
WHEN hzdept_r >100 THEN 0 
WHEN hzdepb_r >= 50 AND hzdept_r < 50 THEN 50 
WHEN hzdept_r < 50 THEN 0
		WHEN hzdept_r < 100 then hzdept_r ELSE 50 END AS InRangeTop_50_100 ,
		
	
CASE   WHEN hzdept_r > 100 THEN 0
WHEN hzdepb_r < 50 THEN 0
WHEN hzdepb_r <= 100 THEN hzdepb_r  WHEN hzdepb_r > 100 and hzdept_r < 100 THEN 100 ELSE 50 END AS InRangeBot_50_100,
--CASE    WHEN hzdept_r < 50 THEN 50
--		WHEN hzdept_r < 100 then hzdept_r ELSE 50 END AS InRangeTop_50_100,
		
--CASE    WHEN hzdepb_r < 50 THEN 50
--WHEN hzdepb_r <= 100 THEN hzdepb_r  WHEN hzdepb_r > 100 and hzdept_r < 100 THEN 100 ELSE 50 END AS InRangeBot_50_100,

om_r,om_l, om_h, fragvol,  fragvol_l, fragvol_h, dbthirdbar_r, dbthirdbar_l, dbthirdbar_h, cokey, mukey, 100.0 - fragvol AS frag_main, 
100.0 - fragvol_l AS frag_main_l,
100.0 - fragvol_h AS frag_main_h
INTO #SOC
FROM #acpf
ORDER BY cokey, hzdept_r ASC, hzdepb_r ASC, chkey


SELECT mukey, cokey, hzname, chkey, comppct_r, hzdept_r, hzdepb_r, thickness,
InRangeTop_0_150, 
InRangeBot_0_150, 
 
InRangeTop_0_30, 
InRangeBot_0_30, 
InRangeTop_0_30_l, 
InRangeBot_0_30_h, 

InRangeTop_20_50, 
InRangeBot_20_50, 

InRangeTop_50_100 ,
InRangeBot_50_100,
(( ((InRangeBot_0_150 - InRangeTop_0_150) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_0_150,

(( ((InRangeBot_0_30 - InRangeTop_0_30) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_0_30,

(( ((InRangeBot_0_30_h - InRangeTop_0_30_l) * ( ( om_l / 1.724 ) * dbthirdbar_l )) / 100.0 ) * ((100.0 - fragvol_l) / 100.0))  AS HZ_SOC_0_30_l,
(( ((InRangeBot_0_30_h - InRangeTop_0_30_l) * ( ( om_h / 1.724 ) * dbthirdbar_h )) / 100.0 ) * ((100.0 - fragvol_h) / 100.0))  AS HZ_SOC_0_30_h,
---Removed * ( comppct_r * 100 ) 
((((InRangeBot_20_50 - InRangeTop_20_50) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_20_50,
---Removed * ( comppct_r * 100 ) 
((((InRangeBot_50_100 - InRangeTop_50_100) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_50_100,

(( ((InRangeBot_0_5 - InRangeTop_0_5) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_0_5,


(( ((InRangeBot_5_15 - InRangeTop_5_15) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_5_15,

(( ((InRangeBot_15_30 - InRangeTop_15_30) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_15_30,

(( ((InRangeBot_30_60 - InRangeTop_30_60) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_30_60,


(( ((InRangeBot_60_100 - InRangeTop_60_100) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_60_100,

(( ((InRangeBot_100_200 - InRangeTop_100_200) * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0))  AS HZ_SOC_100_200
---Removed * ( comppct_r * 100 ) 
INTO #SOC2
FROM #SOC
ORDER BY  mukey ,cokey, comppct_r DESC, hzdept_r ASC, hzdepb_r ASC, chkey

---Aggregates and sum it by component. 
SELECT DISTINCT cokey, mukey,  
ROUND (SUM (HZ_SOC_0_150) over(PARTITION BY cokey) ,4) AS CO_SOC_0_150, 
ROUND (SUM (HZ_SOC_0_30) over(PARTITION BY cokey) ,4) AS CO_SOC_0_30, 
ROUND (SUM (HZ_SOC_0_30_l) over(PARTITION BY cokey) ,4) AS CO_SOC_0_30_l, 
ROUND (SUM (HZ_SOC_0_30_h) over(PARTITION BY cokey) ,4) AS CO_SOC_0_30_h, 
ROUND (SUM (HZ_SOC_20_50) over(PARTITION BY cokey),4) AS CO_SOC_20_50, 
ROUND (SUM (HZ_SOC_50_100) over(PARTITION BY cokey),4)  AS CO_SOC_50_100,
ROUND (SUM (HZ_SOC_0_5) over(PARTITION BY cokey),4) AS CO_SOC_0_5, 
ROUND (SUM (HZ_SOC_5_15) over(PARTITION BY cokey),4) AS CO_SOC_5_15, 
ROUND (SUM (HZ_SOC_15_30) over(PARTITION BY cokey),4) AS CO_SOC_15_30, 
ROUND (SUM (HZ_SOC_30_60) over(PARTITION BY cokey),4) AS CO_SOC_30_60, 
ROUND (SUM (HZ_SOC_60_100) over(PARTITION BY cokey),4) AS CO_SOC_60_100, 
ROUND (SUM (HZ_SOC_100_200) over(PARTITION BY cokey),4) AS CO_SOC_100_200 
INTO #SOC3
FROM #SOC2

SELECT DISTINCT #SOC3.cokey, #SOC3.mukey,  WEIGHTED_COMP_PCT, 
CO_SOC_0_30, CO_SOC_0_30 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_0_30,
CO_SOC_0_30_l, CO_SOC_0_30_l * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_0_30_l,
CO_SOC_0_30_h, CO_SOC_0_30_h * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_0_30_h,

CO_SOC_20_50, CO_SOC_20_50 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_20_50,
CO_SOC_50_100, CO_SOC_50_100 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_50_100,
CO_SOC_0_150, CO_SOC_0_150 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_0_150,
CO_SOC_0_5, CO_SOC_0_5 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_0_5,
CO_SOC_5_15, CO_SOC_5_15 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_5_15,
CO_SOC_15_30, CO_SOC_15_30 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_15_30,
CO_SOC_30_60, CO_SOC_30_60 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_30_60,
CO_SOC_60_100, CO_SOC_60_100 * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_60_100,
CO_SOC_100_200 , CO_SOC_100_200  * WEIGHTED_COMP_PCT AS WEIGHTED_CO_SOC_100_200
INTO #SOC4
FROM #SOC3
INNER JOIN #muacpf3 ON #muacpf3.cokey=#SOC3.cokey

--Unit Conversion *100
SELECT DISTINCT #main.mukey, ROUND (SUM (WEIGHTED_CO_SOC_0_30) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_0_30 , 

ROUND (SUM (WEIGHTED_CO_SOC_0_30_l) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_0_30_l , 
ROUND (SUM (WEIGHTED_CO_SOC_0_30_h) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_0_30_h , 

ROUND (SUM (WEIGHTED_CO_SOC_20_50) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_20_50 , 
ROUND (SUM (WEIGHTED_CO_SOC_50_100) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_50_100,

ROUND (SUM (WEIGHTED_CO_SOC_0_150) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_0_150,
ROUND (SUM (WEIGHTED_CO_SOC_0_5) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_0_5 , 

ROUND (SUM (WEIGHTED_CO_SOC_5_15) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_5_15 , 

ROUND (SUM (WEIGHTED_CO_SOC_15_30) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_15_30 , 

ROUND (SUM (WEIGHTED_CO_SOC_30_60) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_30_60 , 

ROUND (SUM (WEIGHTED_CO_SOC_60_100) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_60_100 , 

ROUND (SUM (WEIGHTED_CO_SOC_100_200) over(PARTITION BY #SOC4.mukey) ,4) *100  AS SOCSTOCK_100_200
INTO #SOC5
FROM #SOC4
RIGHT OUTER JOIN #main ON #main.mukey=#SOC4.mukey

SELECT DISTINCT
mukey,
CASE WHEN SOCSTOCK_0_30_l = 0 THEN SOCSTOCK_0_30  
WHEN SOCSTOCK_0_30_l IS NULL AND SOCSTOCK_0_30 IS NOT NULL THEN SOCSTOCK_0_30 
WHEN SOCSTOCK_0_30_l> SOCSTOCK_0_30 THEN SOCSTOCK_0_30
ELSE SOCSTOCK_0_30_l END AS SOCSTOCK_0_30_low,
SOCSTOCK_0_30 ,
CASE WHEN SOCSTOCK_0_30_h = 0 THEN SOCSTOCK_0_30 
WHEN SOCSTOCK_0_30_h IS NULL AND SOCSTOCK_0_30 IS NOT NULL THEN SOCSTOCK_0_30 
WHEN SOCSTOCK_0_30_h < SOCSTOCK_0_30  THEN SOCSTOCK_0_30 
ELSE SOCSTOCK_0_30_h END AS SOCSTOCK_0_30_high,
SOCSTOCK_20_50,
SOCSTOCK_50_100,
SOCSTOCK_0_5,
SOCSTOCK_0_150,
SOCSTOCK_5_15 , 
SOCSTOCK_15_30 ,
SOCSTOCK_30_60 ,
SOCSTOCK_60_100 , 
SOCSTOCK_100_200
FROM #SOC5