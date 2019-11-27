--Soils with a WET soil moisture condition are: Histosols, soils with a saturated zone <= 30cm, or soils that are frequently or very frequently flooded for long or very long durations. 

--Soils with a WET-MESIC soil moisture condition do not meet the definition of WET
--AND are in the suborder of aquic and have an AWC to 100cm of >= 15.24cm OR have a saturated layer deeper than 30cm but not deeper
--than 91cm. Soils with a soil moisture condition of MESIC do not meet the definition of WET or WET-MESIC AND have an AWC to 100cm
-->= to 15.24 cm OR have a suborder of aquic and an AWC to 100cm < 15.24 cm OR have a saturated layer between 30cm and 91cm AND an
--AWC to 100cm < 15.24 cm. . 

--Soils with a DRY-MESIC soil moisture condition do not meet the criteria of WET, WET-MESIC or MESIC and have an AWC to 100cm between 7.62cm to 15.24 cm. 

--Soils with a DRY soil moisture condition do not meet the criteria of WET, WETMESIC ,MESIC or DRY-MESIC and have an AWC to 100cm less than 7.62cm.

--The available water storage for the standard depth ranges is calculated using ALL
--components as long as they have horizon data and hzdept_r and hzdepb_r is not null and
--horizon thickness > 0. Weighting for component-to-mapunit uses comppct_r / 100. 






SELECT areasymbol, areaname, mapunit.mukey, mapunit.musym, nationalmusym, mapunit.muname, mukind, muacres, compname, comppct_r, component.cokey, taxorder, taxsuborder
INTO #main
FROM legend
INNER JOIN mapunit on legend.lkey=mapunit.lkey 
INNER JOIN component ON component.mukey=mapunit.mukey
AND legend.areasymbol = 'WI025'
ORDER BY mapunit.muname ASC, mapunit.mukey,comppct_r DESC, compname


----Depth to Wetness, Flooding Frequency and Duration
SELECT muname, cwet.compname, #main.mukey, cwet.cokey, cwet.comppct_r,  (SELECT  TOP 1 (soimoistdept_r) 
FROM component AS cwet2
INNER JOIN comonth ON comonth.cokey=cwet2.cokey AND cwet2.cokey=cwet.cokey
INNER JOIN cosoilmoist on cosoilmoist.comonthkey=comonth.comonthkey AND soimoiststat = 'wet' ORDER BY soimoistdept_r ASC) AS MIN_Wet,
(SELECT top 1 flodfreqcl from comonth, MetadataDomainMaster dm, MetadataDomainDetail dd where comonth.cokey = cwet.cokey and flodfreqcl = ChoiceLabel and DomainName = 'flooding_frequency_class' and 
dm.DomainID = dd.DomainID order by choicesequence desc) as annflodfreq,
(SELECT top 1 floddurcl from comonth, MetadataDomainMaster dm, MetadataDomainDetail dd where comonth.cokey = cwet.cokey and floddurcl = ChoiceLabel and DomainName = 'flooding_duration_class' and 
dm.DomainID = dd.DomainID order by choicesequence desc) as annfloddur
INTO #wet
FROM #main
INNER JOIN component AS cwet ON cwet.mukey=#main.mukey
GROUP BY muname, #main.mukey, cwet.comppct_r, cwet.compname, cwet.cokey
ORDER BY muname, #main.mukey, cwet.comppct_r DESC, cwet.compname, cwet.cokey
--INNER JOIN comonth ON comonth.cokey=component.cokey
--INNER JOIN cosoilmoist on cosoilmoist.comonthkey=comonth.comonthkey AND soimoiststat = 'wet'



SELECT
-- grab survey area data
LEFT((areasymbol), 2) AS state,
mu.muname, 
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
(SELECT TOP 1  reskind  FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND corestrictions.reskind IN ('bedrock, lithic', 'duripan', 'bedrock, densic', 'bedrock, paralithic', 'fragipan', 'natric', 'ortstein', 'permafrost', 'petrocalcic', 'petrogypsic')

AND reskind IS NOT NULL ORDER BY resdept_r) AS toprestriction, c.cokey,

---begin selection of horizon properties
 hzname,
 hzdept_r,
 hzdepb_r,
 CASE WHEN (hzdepb_r-hzdept_r) IS NULL THEN 0 ELSE CAST((hzdepb_r-hzdept_r) AS INT) END AS thickness,  
--  thickness in inches
  awc_r, 
  aws025wta,
  aws050wta,
  --aws0100wta,
  aws0100wta,
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

SELECT muname, compname, cokey, MIN(hzdept_r) AS min_t
INTO #hortopdepth
FROM #acpf
WHERE texture NOT LIKE '%PM%' and texture NOT LIKE '%DOM' and texture NOT LIKE '%MPT%' AND texture NOT LIKE '%MUCK' AND texture NOT LIKE '%PEAT%'
GROUP BY muname, compname, cokey

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
muname, 
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
CASE  WHEN hzdepb_r <= 100 THEN hzdepb_r WHEN hzdepb_r > 100 and hzdept_r < 100 THEN 100 ELSE 0 END AS InRangeBot,
CASE  WHEN hzdept_r < 100 then hzdept_r ELSE 0 END AS InRangeTop, 

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
SUM((InRangeBot - InRangeTop)*awc_r) AS aws100,

SUM((InRangeBot_0_20 - InRangeTop_0_20)*awc_r) AS aws_0_20,

SUM((InRangeBot_20_50 - InRangeTop_20_50)*awc_r) AS aws_20_50,

SUM((InRangeBot_50_100 - InRangeTop_50_100)*awc_r) AS aws_50_100
INTO #aws100
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
  #acpf.muname,
  majcompflag,
  comppct_r,
  #acpf.compname,
  compkind,
  localphase,
  slope_l,
  slope_r,
  slope_h,
  CAST(aws100 AS Decimal(5,1)) AS aws100_dcp,
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
LEFT OUTER JOIN #aws100 on #acpf.cokey = #aws100.cokey
LEFT OUTER JOIN #acpfwtavg on #acpf.cokey = #acpfwtavg.cokey
ORDER BY #acpf.state, #acpf.areasymbol, #acpf.areaname, #acpf.musym




SELECT #main.musym, #main.muname,  #main.compname, #main.comppct_r, MIN_Wet,  #alldata.aws100_dcp , #main.mukey,
CASE WHEN annflodfreq = 'Frequent' THEN 1
WHEN annflodfreq = 'Very frequent' THEN 1 ELSE 0 END AS ffreq,
CASE WHEN  annfloddur = 'Long (7 to 30 days)' THEN 1
WHEN annfloddur = 'Very long (more than 30 days)' THEN 1 ELSE 0 END AS fdur, taxorder, taxsuborder,
#main.cokey
INTO #laststep
FROM #main
LEFT OUTER JOIN #alldata ON #alldata.cokey=#main.cokey
INNER JOIN #wet ON #wet.cokey=#main.cokey 
ORDER BY #main.muname, #main.musym, #main.comppct_r DESC, #main.compname, #main.cokey

SELECT mukey, cokey, musym AS 'Mapunit Symbol', muname AS 'Mapunit Name',  compname AS 'Component Name', comppct_r AS 'Component Percent', MIN_Wet AS 'Depth to Wetness (cm)',  aws100_dcp AS 'Available Water Storage (100 cm)' , 
ffreq + fdur AS 'Flooding(frequency + duration)',
CASE WHEN taxorder = 'Histosols' AND MIN_Wet <= 30 THEN 'wet'
WHEN ffreq = 1 AND fdur = 1 THEN 'wet'
WHEN LEFT (taxsuborder,3) = 'Aqu' AND aws100_dcp  >= 15.24 THEN 'wet-mesic'
WHEN MIN_Wet BETWEEN 30 AND 91  AND aws100_dcp  >= 15.24  THEN 'wet-mesic'
WHEN aws100_dcp  >= 15.24 THEN 'mesic' 
WHEN LEFT (taxsuborder,3) = 'Aqu' AND aws100_dcp  < 15.24 THEN 'mesic'
WHEN MIN_Wet BETWEEN 30 AND 91  AND aws100_dcp  < 15.24  THEN 'mesic'
WHEN aws100_dcp BETWEEN 7.62 AND 15.24 THEN 'dry-mesic'
WHEN aws100_dcp  < 7.62 THEN  'dry' ELSE 'N/A'
END AS 'Soil Moisture Site Condition'
FROM #laststep
ORDER BY muname, musym, comppct_r DESC, compname, cokey



