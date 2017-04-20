---SOC
---Soil organic carbon stock estimate (SOC) in total soil profile (0 cm to the reported depth of the soil profile). The concentration of organic carbon present in the soil expressed in grams C per square meter for the total reported soil profile depth. NULL values are presented where data are incomplete or not available.

---Uses all components with horizon data.
---Does not calculate component SOC below the following component restrictions:
---Lithic bedrock, Paralithic bedrock, Densic bedrock, Fragipan, Duripan, Sulfuric
---
----soc =  ( (hzT * ( ( om / 1.724 ) * db3 )) / 100.0 ) * ((100.0 - fragvol) / 100.0) * ( compPct * 100 )

--  soc      = ( (H2 * ( ( L2 / 1.724 ) * J2 )) / 100.0 ) * ((100.0 - K2) / 100.0) * ( F2 * 100 )

---A			B		C		D				E			F			G			H			I 			J				K			L		M			N
---mukey	cokey		hzname	restrictiodepth	hzdept_r	comppct_r	hzdepb_r	thickness	texture		dbthirdbar_r	fragvol		om_r	chkey		SOC
---2809839	13906974	Ap		89				0			90			18			18			SIL			1.4				5			1.5		39904473	1874.651972
---2809839	13906974	Bt1		89				18			90			25			7			SICL		1.5				5			0.5	3	9904470		260.3683295
---2809839	13906974	2Bt2	89				25			90			48			23			C			1.4				11			0.25	39904471	374.0168213
---2809839	13906974	3Bt3	89				48			90			89			41			CNV-L		1.5				45			0.25	39904472	441.4515661
---																																						Sum	2950.488689		
																																						
---2809839	13906975	Ap		114				0			10			23			23			SIL			1.4				3			1.5		39904478	271.7575406
---2809839	13906975	BE		114				23			10			33			10			SIL			1.4				3			0.25	39904479	19.69257541
---2809839	13906975	2Bt2	114				58			10			89			31			C			1.4				11			0.25	39904475	56.01218097
---2809839	13906975	3Bt3	114				89			10			114			25			CNV-L		1.5				45			0.25	39904476	29.90864269
---																																						Sum 377.3709397											
---																																			SOC_0_999 Total 3327.859629



SELECT areASymbol, areaname, mapunit.mukey, mapunit.musym, nationalmusym, mapunit.muname, mukind, muacres
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
(SELECT TOP 1  reskind  FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND corestrictions.reskind IN ('Lithic bedrock','Duripan', 'Densic bedrock', 'Paralithic bedrock', 'Fragipan', 'Natric', 'Ortstein', 'Permafrost', 'Petrocalcic', 'Petrogypsic')
AND reskind IS NOT NULL ORDER BY resdept_r) AS TOPrestriction, c.cokey,

---begin selection of horizon properties
 hzname,
 hzdept_r,
 hzdepb_r,
 CASE WHEN (hzdepb_r-hzdept_r) IS NULL THEN 0 ELSE CAST((hzdepb_r-hzdept_r) AS INT) END AS thickness,  
--  thickness in inches
  om_r, dbthirdbar_r, 
  (SELECT CASE WHEN SUM (cf.fragvol_r) IS NULL THEN 0 ELSE CAST (SUM(cf.fragvol_r) AS INT) END FROM chfrags cf WHERE cf.chkey = ch.chkey) as fragvol,
brockdepmin,
  texture,
  ch.chkey
INTO #acpf
FROM legend  AS l
INNER JOIN mapunit AS mu ON mu.lkey = l.lkey 
AND l.areasymbol like 'WI025'
INNER JOIN muaggatt AS  mt on mu.mukey=mt.mukey
INNER JOIN component AS  c ON c.mukey = mu.mukey 
INNER JOIN chorizon AS ch ON ch.cokey = c.cokey and CASE WHEN hzdept_r IS NULL THEN 2 
WHEN om_r IS NULL THEN 2 
WHEN om_r = 0 THEN 2 
WHEN dbthirdbar_r IS NULL THEN 2
WHEN dbthirdbar_r = 0 THEN 2
ELSE 1 END = 1
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
SELECT
CASE  WHEN hzdepb_r <= 150 THEN hzdepb_r WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150 ELSE 0 END AS InRangeBot,
CASE  WHEN hzdept_r < 150 then hzdept_r ELSE 0 END AS InRangeTop, 

CASE  WHEN hzdepb_r <= 20  THEN hzdepb_r WHEN hzdepb_r > 20  and hzdept_r < 20 THEN 20  ELSE 0 END AS InRangeBot_0_20,
CASE  WHEN hzdept_r < 20 then hzdept_r ELSE 0 END AS InRangeTop_0_20, 


CASE  WHEN hzdepb_r <= 50  THEN hzdepb_r WHEN hzdepb_r > 50  and hzdept_r < 50 THEN 50  ELSE 20 END AS InRangeBot_20_50,
CASE  WHEN hzdept_r < 50 then hzdept_r ELSE 20 END AS InRangeTop_20_50, 

CASE  WHEN hzdepb_r <= 100  THEN hzdepb_r WHEN hzdepb_r > 100  and hzdept_r < 100 THEN 100  ELSE 50 END AS InRangeBot_50_100,
CASE  WHEN hzdept_r < 100 then hzdept_r ELSE 50 END AS InRangeTop_50_100, 
om_r, fragvol, dbthirdbar_r, cokey, mukey, 100.0 - fragvol AS frag_main
INTO #SOC
FROM #acpf
ORDER BY cokey

SELECT mukey, cokey, 
SUM((InRangeBot - InRangeTop)* ( ( om_r / 1.724 ) * dbthirdbar_r )) AS SOC150_Main,

SUM((InRangeBot_0_20 - InRangeTop_0_20)* ( ( om_r / 1.724 ) * dbthirdbar_r )) AS SOC_0_20_Main,

SUM((InRangeBot_20_50 - InRangeTop_20_50)* ( ( om_r / 1.724 ) * dbthirdbar_r )) AS SOC_20_50_Main,

SUM((InRangeBot_50_100 - InRangeTop_50_100)* ( ( om_r / 1.724 ) * dbthirdbar_r )) AS SOC_50_100_Main,



SUM((InRangeBot - InRangeTop)* om_r) AS SOC150,

SUM((InRangeBot_0_20 - InRangeTop_0_20)* om_r) AS SOC_0_20,

SUM((InRangeBot_20_50 - InRangeTop_20_50)* om_r) AS SOC_20_50,

SUM((InRangeBot_50_100 - InRangeTop_50_100)* om_r) AS SOC_50_100
INTO #SOC150
FROM #SOC 
GROUP BY  mukey, cokey

---return to weighted averages, using the thickness times the non-null horizon properties
SELECT mukey, cokey, chkey,
 thickness,
 restrictiodepth,
( (thickness * ( ( om_r / 1.724 ) * dbthirdbar_r )) / 100.0 ) * ((100.0 - fragvol) / 100.0)  AS soc, 
(om_r * thickness) as th_om_r
INTO #acpf3
FROM #acpfhzn 
ORDER BY mukey, cokey, chkey


---sum all horizon properties to gather the final product for the component

SELECT mukey, cokey, restrictiodepth,
CAST(sum(thickness) AS float(2)) AS sum_thickness,
CAST(sum(th_om_r) AS float(2)) AS sum_om_r, 
CAST(sum(soc) AS float(2)) AS sum_soc 

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
(sum_soc) AS profile_socstorage,
(sum_soc/#depthtest.restrictiondepth)  AS wtavg_soc_to_restrict,
(sum_om_r) AS profile_Waterstorage,
(sum_om_r/#depthtest.restrictiondepth)  AS wtavg_om_r_to_restrict
INTO #acpfwtavg 
FROM #acpf4 
INNER JOIN #depthtest on #acpf4.cokey=#depthtest.cokey
---WHERE sum_om_r != 0
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
  CAST(SOC150_Main AS Decimal(5,1)) AS SOC150_dcp_Main,
	CAST(SOC_0_20_Main AS Decimal(5,1)) AS SOC_0_20_dcp_Main,
		CAST(SOC_20_50_Main AS Decimal(5,1)) AS SOC_20_50_dcp_Main,
			CAST(SOC_50_100_Main AS Decimal(5,1)) AS SOC_50_100_dcp_Main,
	
	CAST(profile_socstorage AS Decimal(5,3)) AS SOC_profile_dcp_Main,
  CAST(wtavg_soc_to_restrict AS Decimal(5,1)) AS SOC_restrict_dcp_Main,
  
  
    CAST(SOC150 AS Decimal(5,1)) AS SOC150_dcp,
	CAST(SOC_0_20 AS Decimal(5,1)) AS SOC_0_20_dcp,
		CAST(SOC_20_50 AS Decimal(5,1)) AS SOC_20_50_dcp,
			CAST(SOC_50_100 AS Decimal(5,1)) AS SOC_50_100_dcp,
  CAST(profile_Waterstorage AS Decimal(5,1)) AS SOC_profile_dcp,
  CAST(wtavg_om_r_to_restrict AS Decimal(5,1)) AS SOC_restrict_dcp,
  
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
LEFT OUTER JOIN #SOC150 on #acpf.cokey = #SOC150.cokey
LEFT OUTER JOIN #acpfwtavg on #acpf.cokey = #acpfwtavg.cokey
ORDER BY #acpf.state, #acpf.areasymbol, #acpf.areaname, #acpf.musym

---Uses the above query and the query on line 89
SELECT  #alldata.mukey,  #alldata.cokey, #alldata.SOC150_dcp, WEIGHTED_COMP_PCT , 
CAST (CASE WHEN #alldata.SOC150_dcp IS NULL THEN 0 ELSE #alldata.SOC150_dcp END * CASE WHEN #alldata.SOC150_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS om_COMP_SUM,
CAST (CASE WHEN #alldata.SOC_0_20_dcp IS NULL THEN 0 ELSE #alldata.SOC_0_20_dcp END * CASE WHEN #alldata.SOC_0_20_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS om_COMP_SUM_0_20,
CAST (CASE WHEN #alldata.SOC_20_50_dcp IS NULL THEN 0 ELSE #alldata.SOC_20_50_dcp END * CASE WHEN #alldata.SOC_20_50_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS om_COMP_SUM_20_50,
CAST (CASE WHEN #alldata.SOC_50_100_dcp IS NULL THEN 0 ELSE #alldata.SOC_50_100_dcp END * CASE WHEN #alldata.SOC_50_100_dcp IS NULL THEN 0 ELSE WEIGHTED_COMP_PCT   END AS Decimal(5,2)) AS om_COMP_SUM_50_100

INTO #alldata2
FROM #alldata
INNER JOIN #muacpf3 ON #alldata.cokey=#muacpf3.cokey


SELECT #alldata2.mukey , CAST (SUM (om_COMP_SUM) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_om_WEIGHTED_AVG0_150,
CAST (SUM (om_COMP_SUM_0_20) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_om_WEIGHTED_AVG_0_20,
CAST (SUM (om_COMP_SUM_20_50) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_om_WEIGHTED_AVG_20_50,
CAST (SUM (om_COMP_SUM_50_100) over(partition by #alldata2.mukey )AS Decimal(5,2)) AS MU_om_WEIGHTED_AVG_50_100
INTO #alldata3
FROM #alldata2


SELECT state,
 #main.areasymbol,
 #main.areaname,
 #main.mukey,
 #main.musym,
 muname,
 nationalmusym,
 mukind,
MU_om_WEIGHTED_AVG0_150, 
SOC0150wta AS MuAGG_SOC0150wta,
MU_om_WEIGHTED_AVG_0_20 AS SOC0_20,
MU_om_WEIGHTED_AVG_20_50 AS SOC20_50,
MU_om_WEIGHTED_AVG_50_100 AS SOC50_100

FROM #main
LEFT OUTER JOIN #alldata on #main.mukey=#alldata.mukey
LEFT OUTER JOIN #alldata3 on #main.mukey=#alldata3.mukey
GROUP BY  state, #main.areasymbol,  #main.areaname, #main.mukey,   muname, #main.musym,  nationalmusym,  mukind, MU_om_WEIGHTED_AVG0_150, SOC0150wta, MU_om_WEIGHTED_AVG_0_20, MU_om_WEIGHTED_AVG_20_50, MU_om_WEIGHTED_AVG_50_100  ORDER BY areasymbol, musym

