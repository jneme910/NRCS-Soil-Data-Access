SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #map;
DROP TABLE IF EXISTS #water
DROP TABLE IF EXISTS #water2
DROP TABLE IF EXISTS #comp
DROP TABLE IF EXISTS #horizon
DROP TABLE IF EXISTS #surface
DROP TABLE IF EXISTS #surface_tex
DROP TABLE IF EXISTS #surface_tex2
DROP TABLE IF EXISTS #surface_tex3
DROP TABLE IF EXISTS #surface_tex4
DROP TABLE IF EXISTS #surface_final
DROP TABLE IF EXISTS #fragment 
DROP TABLE IF EXISTS #fragment2
DROP TABLE IF EXISTS #diag
DROP TABLE IF EXISTS #d
DROP TABLE IF EXISTS #r
DROP TABLE IF EXISTS #rest_pivot_table
DROP TABLE IF EXISTS #rest
DROP TABLE IF EXISTS #frag_pivot_table
DROP TABLE IF EXISTS #frag
DROP TABLE IF EXISTS #surface_final2
DROP TABLE IF EXISTS #surface_final3
DROP TABLE IF EXISTS #spd
DROP TABLE IF EXISTS #acpf
DROP TABLE IF EXISTS #aws
DROP TABLE IF EXISTS #aws150
DROP TABLE IF EXISTS #bedrockcl2
DROP TABLE IF EXISTS #bedr
DROP TABLE IF EXISTS #rest2
DROP TABLE IF EXISTS #rest3

--Define the area
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @majcomp VARCHAR(20) ;

-- Soil Data Access
--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 
--~DeclareChar(@area,20)~
-- End soil data access
SELECT @area= 'WI'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025
SELECT @majcomp = 'yes'; -- Enter 'yes' for all components or 'no' for major components




------------------------------------------------------------------------------------
SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area
--creates the temp table for map unit and legend
CREATE TABLE #map
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250), 
	datestamp VARCHAR(32), 
	major_mu_pct_sum SMALLINT)


--Queries the map unit and legend
--Link Main
INSERT INTO #map (areaname, areasymbol, musym, mapunit.mukey, muname, datestamp, major_mu_pct_sum)
SELECT legend.areaname, legend.areasymbol, musym, mapunit.mukey, muname, CONCAT ([SC].[areasymbol] , ' ' , FORMAT ( [SC].[saverest], 'dd-MM-yy')) AS datestamp, 
(SELECT SUM (CCO.comppct_r)
FROM mapunit AS MM2
INNER JOIN component AS CCO ON CCO.mukey = MM2.mukey AND mapunit.mukey = MM2.mukey AND --majcompflag = 'yes'
(majcompflag NOT LIKE @majcomp or majcompflag = 'yes')
) AS  major_mu_pct_sum
FROM (legend 
INNER JOIN mapunit ON legend.lkey=mapunit.lkey 
--AND mukind = 'Consociation' 
--AND mapunit.mukey=1444409
--AND LEFT(legend.areasymbol,2) = @area
AND  CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area
)  --- State
--AND areasymbol = @area)  --- SSA
INNER JOIN sacatalog SC ON legend.areasymbol = SC.areasymbol





------------------------------------------------------------------------------------
---Queries the major components 
--- Link 
CREATE TABLE #comp ( mukey INT , compname VARCHAR (60), cokey INT, comppct_r  SMALLINT, landform VARCHAR (60), min_yr_water INT,  subgroup VARCHAR (10), greatgroup VARCHAR (10), wei VARCHAR (254), weg VARCHAR (254), h_spodic_flag SMALLINT,  h_lithic_flag  SMALLINT,h_parlithic_flag SMALLINT,h_densic_flag SMALLINT, h_duripan_flag SMALLINT,h_petrocalic_flag SMALLINT, h_petrogypsic_flag SMALLINT,h_petro_flag SMALLINT,h_salt_flag SMALLINT,
 slope_r REAL , hydgrp VARCHAR (254),
esd_id VARCHAR (30), esd_name VARCHAR (254), sum_fragcov_low REAL, sum_fragcov_rv REAL , sum_fragcov_high REAL, major_mu_pct_sum SMALLINT, adj_comp_pct REAL, restrictiodepth SMALLINT, compkind VARCHAR (254) )

--TRUNCATE TABLE #comp
INSERT INTO #comp (mukey, compname, cokey, comppct_r , landform, min_yr_water, subgroup, greatgroup, wei, weg, h_spodic_flag, h_lithic_flag ,h_parlithic_flag,h_densic_flag, h_duripan_flag,h_petrocalic_flag, h_petrogypsic_flag,h_petro_flag, h_salt_flag,  

slope_r, hydgrp, esd_id , esd_name, sum_fragcov_low, sum_fragcov_rv, sum_fragcov_high, major_mu_pct_sum, adj_comp_pct, restrictiodepth, compkind)
SELECT  map.mukey, compname, c.cokey, comppct_r ,
(SELECT TOP 1 cogeomordesc.geomfname FROM cogeomordesc WHERE c.cokey = cogeomordesc.cokey AND cogeomordesc.rvindicator='yes' and cogeomordesc.geomftname = 'Landform') as landform, 

(SELECT TOP 1 MIN (soimoistdept_r) FROM component AS c2 
INNER JOIN comonth ON c2.cokey=comonth.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey
AND c2.cokey=c.cokey AND soimoiststat = 'wet'  GROUP BY c2.cokey) AS min_yr_water,
CASE WHEN taxsubgrp LIKE '%natr%' THEN 'natr' WHEN taxsubgrp  LIKE '%gyps%' THEN 'gyps' ELSE 'NA' END AS subgroup, 

CASE WHEN taxgrtgroup LIKE '%verti%' THEN 'verti' 
WHEN taxgrtgroup  LIKE '%natr%' THEN 'natr' 
WHEN taxgrtgroup  LIKE '%calci%' THEN 'calci' 
WHEN taxgrtgroup  LIKE '%gyps%' THEN 'gyps' 
ELSE 'NA' END AS greatgroup, wei, weg,

(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
INNER JOIN chdesgnsuffix AS chs ON chs.chkey=ch2.chkey AND ch2.cokey=c.cokey AND desgnsuffix = 's' AND desgnsuffix IS NOT NULL) AS h_spodic_flag,
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND desgnmaster = 'R') AS h_lithic_flag ,
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%Cr%') AS h_parlithic_flag,
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%d%') AS h_densic_flag, 
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%qm%') AS h_duripan_flag, 
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%km%') AS h_petrocalic_flag, 
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%ym%') AS h_petrogypsic_flag,
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%m%') AS h_petro_flag, 
(SELECT TOP 1 MIN (hzdept_r)  FROM chorizon AS ch2 
WHERE ch2.cokey=c.cokey AND hzname LIKE'%z%') AS h_salt_flag, 
slope_r, hydgrp,
(SELECT TOP 1 ecoclassid
 FROM component AS ce1
 INNER JOIN coecoclass on ce1.cokey = coecoclass.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database' AND ce1.cokey=c.cokey) AS esd_id,
(SELECT TOP 1 ecoclassname
 FROM component AS ce1
 INNER JOIN coecoclass on ce1.cokey = coecoclass.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database' AND ce1.cokey=c.cokey) AS esd_name,
 (SELECT ROUND (SUM (sfragcov_l),2)
FROM component AS c2
INNER JOIN cosurffrags AS cosf ON cosf.cokey=c2.cokey AND c2.cokey=c.cokey GROUP BY c2.cokey)AS sum_fragcov_low,
 (SELECT ROUND (SUM (sfragcov_r),2)
FROM component AS c2
INNER JOIN cosurffrags AS cosf ON cosf.cokey=c2.cokey AND c2.cokey=c.cokey GROUP BY c2.cokey)AS sum_fragcov_rv,
(SELECT ROUND (SUM (sfragcov_h),2)
FROM component AS c2
INNER JOIN cosurffrags AS cosf ON cosf.cokey=c2.cokey AND c2.cokey=c.cokey GROUP BY c2.cokey)AS sum_fragcov_high,
major_mu_pct_sum, LEFT (ROUND ((1.0 * comppct_r / NULLIF(major_mu_pct_sum, 0)),2), 4) AS adj_comp_pct,
(SELECT CASE WHEN MIN (resdept_r) IS NULL THEN 200 ELSE CAST (MIN (resdept_r) AS INT) END FROM component LEFT OUTER JOIN corestrictions ON component.cokey = corestrictions.cokey WHERE component.cokey = c.cokey AND reskind IS NOT NULL) AS restrictiodepth, compkind

FROM #map AS map
INNER JOIN component AS c ON c.mukey=map.mukey AND  (majcompflag NOT LIKE @majcomp or majcompflag = 'yes') --majcompflag = 'yes'

;



 ---Restrictions
 --Link
  CREATE TABLE #rest ( cokey INT, compname  VARCHAR (60), [Densic bedrock] SMALLINT,[Lithic bedrock] SMALLINT,[Paralithic bedrock] SMALLINT,[Cemented horizon] SMALLINT,[Duripan] SMALLINT,[Fragipan] SMALLINT,[Manufactured layer] SMALLINT,[Petrocalcic] SMALLINT,[Petroferric] SMALLINT,[Petrogypsic] SMALLINT)
 INSERT INTO #rest  ( cokey, compname, [Densic bedrock],[Lithic bedrock],[Paralithic bedrock],[Cemented horizon],[Duripan],[Fragipan],[Manufactured layer],[Petrocalcic],[Petroferric],[Petrogypsic])
 SELECT * FROM 
 (
 SELECT  #comp.cokey,  compname,  resdept_r, reskind
 FROM #comp
 INNER JOIN corestrictions AS res ON res.cokey=#comp.cokey
 ) #r
 PIVOT (
 MIN (resdept_r) 
   FOR reskind IN (
[Densic bedrock],
[Lithic bedrock],
[Paralithic bedrock],
[Cemented horizon],
[Duripan],
[Fragipan],
[Manufactured layer],
[Petrocalcic],
[Petroferric],
[Petrogypsic]) 
) AS #rest_pivot_table;





---Min Soil Profile Depth (Finds min depth from all the fields
 CREATE TABLE #spd ( cokey INT, minsoil_profile_depth SMALLINT)
 INSERT INTO #spd (cokey, minsoil_profile_depth )
SELECT #comp.cokey,

  (
    SELECT MIN(min_depth)
    FROM (VALUES   (h_lithic_flag),
  (h_parlithic_flag),
  (h_duripan_flag),
 (h_petrocalic_flag),
  (h_petrogypsic_flag),
  (h_petro_flag),
  ([Densic bedrock]),
  ([Lithic bedrock]),
  ([Paralithic bedrock]),
  ([Cemented horizon]),
  ([Duripan]),
  ([Fragipan]),
  ([Manufactured layer]),
  ([Petrocalcic]),
  ([Petroferric]),
  ([Petrogypsic]) ) AS d (min_depth)
  ) AS minsoil_profile_depth
FROM
  #comp
  LEFT OUTER JOIN #rest ON #comp.cokey=#rest.cokey
;

 CREATE TABLE #bedr ( cokey INT, min_bedr_depth SMALLINT)
 INSERT INTO #bedr (cokey, min_bedr_depth )
SELECT #comp.cokey,

   (
    SELECT MIN(min_depth)
    FROM (VALUES   (h_lithic_flag),
  (h_parlithic_flag),

  ([Densic bedrock]),
  ([Lithic bedrock]),
  ([Paralithic bedrock]),

  ([Manufactured layer])
 ) AS d (min_depth)
  ) AS min_bedr_depth
FROM
  #comp
  LEFT OUTER JOIN #rest ON #comp.cokey=#rest.cokey
;

------------------------------------------------------------------------------------
CREATE TABLE #rest2 (muname  VARCHAR (250),row_num SMALLINT ,mukey INT , cokey INT , compkind  VARCHAR (30) , major_mu_pct_sum SMALLINT, adj_comp_pct REAL, all_restriction_class VARCHAR (50), bedrock_restriction_class VARCHAR (50)) 
INSERT INTO #rest2 (muname,row_num,mukey, cokey, compkind, major_mu_pct_sum, adj_comp_pct, all_restriction_class, bedrock_restriction_class) 
SELECT muname, ROW_NUMBER() OVER(PARTITION BY #map.mukey ORDER BY adj_comp_pct DESC, CASE WHEN LEFT (muname, 3) = LEFT (compname, 3) THEN 1 ELSE 2 END ASC,  #comp.cokey ) AS row_num,
#map.mukey, #comp.cokey, compkind, #map.major_mu_pct_sum, adj_comp_pct,
CASE WHEN  compkind = 'miscellaneous area' THEN 'not rated'
WHEN ISNULL (minsoil_profile_depth,200) < 25 THEN 'very shallow'
WHEN ISNULL (minsoil_profile_depth,200) BETWEEN 25 AND 50 THEN 'shallow'
WHEN ISNULL (minsoil_profile_depth,200) BETWEEN 50 AND 100 THEN 'moderately deep'
WHEN ISNULL (minsoil_profile_depth,200) BETWEEN 100 AND 150 THEN 'deep'
WHEN ISNULL (minsoil_profile_depth,200) >= 150 THEN 'very deep' END AS all_restriction_class,

CASE WHEN  compkind = 'miscellaneous area' THEN 'not rated'
WHEN ISNULL (min_bedr_depth,200) < 25 THEN 'very shallow'
WHEN ISNULL (min_bedr_depth,200) BETWEEN 25 AND 50 THEN 'shallow'
WHEN ISNULL (min_bedr_depth,200) BETWEEN 50 AND 100 THEN 'moderately deep'
WHEN ISNULL (min_bedr_depth,200) BETWEEN 100 AND 150 THEN 'deep'
WHEN ISNULL (min_bedr_depth,200) >= 150 THEN 'very deep' END AS bedrock_restriction_class
FROM #comp
LEFT OUTER JOIN #spd ON #spd.cokey=#comp.cokey
LEFT OUTER JOIN #bedr ON #bedr.cokey=#comp.cokey
INNER JOIN #map ON #map.mukey=#comp.mukey



CREATE TABLE #rest3 (mukey INT, muname VARCHAR (250),  dominant_condition_restriction VARCHAR (50), dominant_condition_bedrock VARCHAR (50)) 
INSERT INTO #rest3 (mukey, muname, dominant_condition_restriction, dominant_condition_bedrock) 
SELECT mukey, muname, 
(SELECT TOP 1 all_restriction_class
FROM #rest2 AS r 
WHERE r.mukey = #rest2.mukey 
GROUP BY all_restriction_class, adj_comp_pct ORDER BY SUM(adj_comp_pct) over(partition by all_restriction_class) DESC) AS  dominant_condition_restriction,
(SELECT TOP 1 bedrock_restriction_class
FROM #rest2 AS r 
WHERE r.mukey = #rest2.mukey 
GROUP BY bedrock_restriction_class, adj_comp_pct ORDER BY SUM(adj_comp_pct) over(partition by bedrock_restriction_class) DESC) AS  dominant_condition_bedrock

FROM  #rest2
WHERE row_num = 1


SELECT mukey, muname, dominant_condition_restriction, 
CASE 
WHEN dominant_condition_restriction = 'very shallow'  THEN 1
WHEN dominant_condition_restriction = 'shallow' THEN 2
WHEN dominant_condition_restriction = 'moderately deep'  THEN 3
WHEN dominant_condition_restriction = 'deep' THEN 4
WHEN dominant_condition_restriction = 'very deep' THEN 5
WHEN dominant_condition_restriction = 'not rated' THEN 9999 END AS rest_value,

dominant_condition_bedrock,
CASE 
WHEN dominant_condition_bedrock = 'very shallow'  THEN 1
WHEN dominant_condition_bedrock = 'shallow' THEN 2
WHEN dominant_condition_bedrock = 'moderately deep'  THEN 3
WHEN dominant_condition_bedrock = 'deep' THEN 4
WHEN dominant_condition_bedrock = 'very deep' THEN 5
WHEN dominant_condition_bedrock = 'not rated' THEN 9999 END AS rest_value
FROM #rest3
--WHERE dominant_condition_bedrock  != dominant_condition_restriction
DROP TABLE IF EXISTS #map;
DROP TABLE IF EXISTS #water
DROP TABLE IF EXISTS #water2
DROP TABLE IF EXISTS #comp
DROP TABLE IF EXISTS #horizon
DROP TABLE IF EXISTS #surface
DROP TABLE IF EXISTS #surface_tex
DROP TABLE IF EXISTS #surface_tex2
DROP TABLE IF EXISTS #surface_tex3
DROP TABLE IF EXISTS #surface_tex4
DROP TABLE IF EXISTS #surface_final
DROP TABLE IF EXISTS #fragment 
DROP TABLE IF EXISTS #fragment2
DROP TABLE IF EXISTS #diag
DROP TABLE IF EXISTS #d
DROP TABLE IF EXISTS #r
DROP TABLE IF EXISTS #rest_pivot_table
DROP TABLE IF EXISTS #rest
DROP TABLE IF EXISTS #frag_pivot_table
DROP TABLE IF EXISTS #frag
DROP TABLE IF EXISTS #surface_final2
DROP TABLE IF EXISTS #surface_final3
DROP TABLE IF EXISTS #spd
DROP TABLE IF EXISTS #acpf
DROP TABLE IF EXISTS #aws
DROP TABLE IF EXISTS #aws150