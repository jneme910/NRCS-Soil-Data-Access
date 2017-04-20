--The available water storage for the standard depth ranges is calculated using ALL
--components as long as they have horizon data and hzdept_r and hzdepb_r is not null and
--horizon thickness > 0. Weighting for component-to-mapunit uses comppct_r / 100. 

--COLUMN 0 to 150
--A			  B		C			D			E				F				G
-----------------------------------------------------------------------------------
--compname	mukey	AWS150_SUM	COMPPCT_R	SUM_COMP_PCT	D/E				F*C
--Brodale	2809844	9.19		3			100				0.03			0.2757
--Dorerton	2809844	14.1		3			100				0.03			0.423
--Rockbluff	2809844	8.07		3			100				0.03			0.2421
--Churchtown2809844	31.07		6			100				0.06			1.8642
--Elbaville	2809844	17.88		25			100				0.25			4.47
--Dorerton	2809844	14.36		60			100				0.6				8.616
--																		 SUM	15.9
-------------------------------------------------------------------------------------




SELECT areASymbol, areaname, mapunit.mukey, mapunit.musym, nationalmusym, mapunit.muname, mukind, muacres, aws0150wta
INTO #main
FROM legend
INNER JOIN mapunit on legend.lkey=mapunit.lkey 
INNER JOIN muaggatt AS mt1 on mapunit.mukey=mt1.mukey
AND legend.areasymbol = 'WI025'


SELECT
-- grab survey area data
LEFT((areasymbol), 2) AS state,
 l.areASymbol,
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
(SELECT TOP 1  reskind  FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND corestrictions.reskind IN ('bedrock, lithic', 'duripan', 'bedrock, densic', 'bedrock, paralithic', 'fragipan', 'natric', 'ortstein', 'permafrost', 'petrocalcic', 'petrogypsic')

AND reskind IS NOT NULL ORDER BY resdept_r) AS TOPrestriction, c.cokey,

---begin selection of horizon properties
 hzname,
 hzdept_r,
 hzdepb_r,
 CASE WHEN (hzdepb_r-hzdept_r) IS NULL THEN 0 ELSE CAST((hzdepb_r-hzdept_r) AS INT) END AS thickness,  
--  thickness in inches
  awc_r, 
  aws025wta,
  aws050wta,
  aws0100wta,
  aws0150wta,
  brockdepmin,
  texture,
  ch.chkey
INTO #acpf
FROM legend  AS l
INNER JOIN mapunit AS mu ON mu.lkey = l.lkey 
AND l.areasymbol like 'WI025'
INNER JOIN muaggatt mt on mu.mukey=mt.mukey
INNER JOIN component c ON c.mukey = mu.mukey 
INNER JOIN chorizon ch ON ch.cokey = c.cokey and CASE WHEN hzdept_r IS NULL THEN 2 
WHEN awc_r IS NULL THEN 2 
WHEN awc_r = 0 THEN 2 ELSE 1 END = 1
INNER JOIN chtexturegrp ct ON ch.chkey=ct.chkey and ct.rvindicator = 'yes'
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





---grab top depth for the mineral soil and will use it later to get mineral surface properties

SELECT compname, cokey, MIN(hzdept_r) AS min_t
INTO #hortopdepth
FROM #acpf
WHERE texture NOT LIKE '%PM%' and texture NOT LIKE '%DOM' and texture NOT LIKE '%MPT%' AND texture NOT LIKE '%MUCK' AND texture NOT LIKE '%PEAT%'
GROUP BY compname, cokey

---combine the mineral surface to grab surface mineral properties

SELECT #hortopdepth.cokey,
hzname,
hzdept_r,
hzdepb_r,
thickness,
texture AS texture_surf,
awc_r AS awc_surf,
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
CASE when awc_r IS NULL THEN 0 ELSE awc_r END AS awc_r,
chkey
INTO #acpfhzn
FROM #acpf


--- depth ranges for AWS ----
SELECT
CASE  WHEN hzdepb_r <= 150 THEN hzdepb_r WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150 ELSE 0 END AS InRangeBot,
CASE  WHEN hzdept_r < 150 then hzdept_r ELSE 0 END AS InRangeTop, 

CASE  WHEN hzdepb_r <= 20  THEN hzdepb_r WHEN hzdepb_r > 20  and hzdept_r < 20 THEN 20  ELSE 0 END AS InRangeBot_0_20,
CASE  WHEN hzdept_r < 20 then hzdept_r ELSE 0 END AS InRangeTop_0_20, 


CASE  WHEN hzdepb_r <= 50  THEN hzdepb_r WHEN hzdepb_r > 50  and hzdept_r < 50 THEN 50  ELSE 20 END AS InRangeBot_20_50,
CASE  WHEN hzdept_r < 50 then hzdept_r ELSE 20 END AS InRangeTop_20_50, 

CASE  WHEN hzdepb_r <= 100  THEN hzdepb_r WHEN hzdepb_r > 100  and hzdept_r < 100 THEN 100  ELSE 50 END AS InRangeBot_50_100,
CASE  WHEN hzdept_r < 100 then hzdept_r ELSE 50 END AS InRangeTop_50_100, 
awc_r, cokey, mukey
INTO #aws
FROM #acpf
ORDER BY cokey

SELECT mukey, cokey, 
SUM((InRangeBot - InRangeTop)*awc_r) AS aws150,

SUM((InRangeBot_0_20 - InRangeTop_0_20)*awc_r) AS aws_0_20,

SUM((InRangeBot_20_50 - InRangeTop_20_50)*awc_r) AS aws_20_50,

SUM((InRangeBot_50_100 - InRangeTop_50_100)*awc_r) AS aws_50_100
INTO #aws150
FROM #aws 
GROUP BY  mukey, cokey

---return to weighted averages, using the thickness times the non-null horizon properties
SELECT mukey, cokey, chkey,
 thickness,
 restrictiodepth,
(awc_r*thickness) as th_awc_r
INTO #acpf3
FROM #acpfhzn 
ORDER BY mukey, cokey, chkey


---sum all horizon properties to gather the final product for the component

SELECT mukey, cokey, restrictiodepth,
CAST(sum(thickness) AS float(2)) AS sum_thickness,
CAST(sum(th_awc_r) AS float(2)) AS sum_awc_r
INTO #acpf4
FROM #acpf3
GROUP BY mukey, cokey, restrictiodepth 
ORDER BY mukey

---find the depth to use in the weighted average calculation 

SELECT mukey, cokey, CASE WHEN sum_thickness < restrictiodepth then sum_thickness  else restrictiodepth end AS restrictiondepth
INTO #depthtest
FROM #acpf4



---sql to create weighted average by dividing by the restriction depth found in the above query

SELECT #acpf4.mukey, #acpf4.cokey,
 sum_thickness,
 #depthtest.restrictiondepth,
(sum_awc_r) AS profile_Waterstorage,
(sum_awc_r/#depthtest.restrictiondepth)  AS wtavg_awc_r_to_restrict
INTO #acpfwtavg 
FROM #acpf4 
INNER JOIN #depthtest on #acpf4.cokey=#depthtest.cokey
---WHERE sum_awc_r != 0
ORDER by #acpf4.mukey, #acpf4.cokey


--time to put it all together using a lot of CASTs to change the data to reflect the way I want it to appear

SELECT DISTINCT 
  #acpf.state,
  #acpf.areasymbol,
  #acpf.areaname,
  #acpf.musym,
  #acpf.mukey,
  #acpf.cokey,
  majcompflag,
  comppct_r,
  #acpf.compname,
  compkind,
  localphase,
  slope_l,
  slope_r,
  slope_h,
  CAST(aws150 AS Decimal(5,1)) AS aws150_dcp,
	CAST(aws_0_20 AS Decimal(5,1)) AS aws_0_20_dcp,
		CAST(aws_20_50 AS Decimal(5,1)) AS aws_20_50_dcp,
			CAST(aws_50_100 AS Decimal(5,1)) AS aws_50_100_dcp,
	
	
  CAST(profile_Waterstorage AS Decimal(5,1)) AS AWS_profile_dcp,
  CAST(wtavg_awc_r_to_restrict AS Decimal(5,1)) AS AWS_restrict_dcp,
  sum_thickness,
  CAST(#acpfwtavg.restrictiondepth/2.54 AS int)  restrictiondepth_IN,
  #acpfwtavg.restrictiondepth,
  TOPrestriction,
  #acpf2.chkey,
  #acpf2.hzname,
CAST(#acpf2.hzdept_r/2.54 AS int)  AS hzdept_r,
CAST(#acpf2.hzdepb_r/2.54 AS int) AS hzdeb_r
INTO #alldata
FROM #acpf2
INNER JOIN #acpf on #acpf.cokey = #acpf2.cokey 
LEFT OUTER JOIN #aws150 on #acpf.cokey = #aws150.cokey
LEFT OUTER JOIN #acpfwtavg on #acpf.cokey = #acpfwtavg.cokey
ORDER BY #acpf.state, #acpf.areasymbol, #acpf.areaname, #acpf.musym

---Uses the above query and the query on line 89
SELECT  #alldata.mukey,  #alldata.cokey, #alldata.aws150_dcp, WEIGHTED_COMP_PCT , 
CAST (CASE WHEN #alldata.aws150_dcp IS NULL THEN 0 ELSE #alldata.aws150_dcp END * CASE WHEN #alldata.aws150_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS AWC_COMP_SUM,
CAST (CASE WHEN #alldata.aws_0_20_dcp IS NULL THEN 0 ELSE #alldata.aws_0_20_dcp END * CASE WHEN #alldata.aws_0_20_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS AWC_COMP_SUM_0_20,
CAST (CASE WHEN #alldata.aws_20_50_dcp IS NULL THEN 0 ELSE #alldata.aws_20_50_dcp END * CASE WHEN #alldata.aws_20_50_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS AWC_COMP_SUM_20_50,
CAST (CASE WHEN #alldata.aws_50_100_dcp IS NULL THEN 0 ELSE #alldata.aws_50_100_dcp END * CASE WHEN #alldata.aws_50_100_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS AWC_COMP_SUM_50_100

INTO #alldata2
FROM #alldata
INNER JOIN #muacpf3 ON #alldata.cokey=#muacpf3.cokey


SELECT #alldata2.mukey , CAST (SUM (AWC_COMP_SUM) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_AWC_WEIGHTED_AVG0_150,
CAST (SUM (AWC_COMP_SUM_0_20) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_AWC_WEIGHTED_AVG_0_20,
CAST (SUM (AWC_COMP_SUM_20_50) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_AWC_WEIGHTED_AVG_20_50,
CAST (SUM (AWC_COMP_SUM_50_100) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_AWC_WEIGHTED_AVG_50_100
INTO #alldata3
FROM #alldata2


SELECT 
---state,
--- #main.areasymbol,
--- #main.areaname,
 #main.mukey,
--- #main.musym,
--- muname,
--- nationalmusym,
--- mukind,
---MU_AWC_WEIGHTED_AVG0_150, 
---aws0150wta AS MuAGG_aws0150wta,
MU_AWC_WEIGHTED_AVG_0_20 AS aws0_20,
MU_AWC_WEIGHTED_AVG_20_50 AS aws20_50,
MU_AWC_WEIGHTED_AVG_50_100 AS aws50_100

FROM #main
LEFT OUTER JOIN #alldata on #main.mukey=#alldata.mukey
LEFT OUTER JOIN #alldata3 on #main.mukey=#alldata3.mukey
GROUP BY  
---state, #main.areasymbol,  #main.areaname, 
#main.mukey,   
---muname, #main.musym,  nationalmusym,  mukind, MU_AWC_WEIGHTED_AVG0_150, aws0150wta, 
MU_AWC_WEIGHTED_AVG_0_20, MU_AWC_WEIGHTED_AVG_20_50, MU_AWC_WEIGHTED_AVG_50_100  
---ORDER BY areasymbol, musym

