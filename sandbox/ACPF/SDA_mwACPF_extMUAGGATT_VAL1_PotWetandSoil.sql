 ---The report does not count for null component percents where the component was hydric. I was thinking of adding 3 percent 
 
 --pwsl1pomu  -Potential Wetland Soil Landscapes
---=====================================================================================
---PWSL1POMU
---Potential Wetland Soil Landscapes (PWSL) is expressed as the percentage of the map unit that meets the PWSL criteria. 
---The hydric rating (soil component variable “hydricrating”) is an indicator of wet soils. For version 1 (pwsl1), 
---those soil components that meet the following criteria are tagged as PWSL and their comppct_r values are summed for each map unit.
---# 1. Soil components with hydricrating = 'YES' are considered PWSL. 
---# 2. Soil components with hydricrating = “NO” are not PWSL. 
---# 3. Soil components with hydricrating = 'UNRANKED' are tested using other attributes, and will be considered PWSL if any of the following conditions are met: 
---	  A. drainagecl = 'Poorly drained' or 'Very poorly drained' 
---	  B. or the localphase or the otherph data fields contain any of the phrases "drained" or "undrained" or "channeled" or "protected" or "ponded" or "flooded". 

---	  If these criteria do not determine the PWSL for a component and hydricrating = 'UNRANKED', 
---	  then the map unit will be classified as PWSL if the map unit name contains any of the phrases "drained" or "undrained" or "channeled" or "protected" or "ponded" or "flooded". 
---	  For version 1 (pwsl1), waterbodies are identified as "999" when map unit names match a list of terms that identify water or intermittent water or map units have a sum of 
---	  the comppct_r for "Water" that is 80% or greater. NULL values are presented where data are incomplete or not available.

	  
---Script Notes for PWSL 

---if hydricrating = 'Yes', then use this component,

---else if:
---        # 1. compkind = 'Miscellaneous area' or is NULL and (
---        # 2. compname = 'Water' or
---        # 3. compname like '% water' or
---        # 4. compname like '% Ocean' or
---        # 5. compname like '% swamp'
---		   # 6. muname = 'Water'
		
---        For draincl look for ("Poorly drained", "Very poorly drained")
---        For localphase or otherphase look for ("drained", "undrained", "channeled", "protected", "ponded", "flooded")
		
---Hydric Soils Rating By mapunit
---This Hydric Soil Category rating indicates the components of map units that meet the criteria for hydric soils. Map units are composed of one or more major soil components or 
---soil types that generally make up 20 percent or more of the map unit and are listed in the map unit name, and they may also have one or more minor contrasting soil components 
---that generally make up less than 20 percent of the map unit. Each major and minor map unit component that meets the hydric criteria is rated hydric. 
---The map unit class ratings based on the hydric components present are: 
---1. Hydric, 
---2. Predominantly Hydric, 
---3. Partially Hydric, 
---4. Predominantly Nonhydric, Nonhydric.

 ---The report also shows the total representative percentage of each map unit that the hydric components comprise.

---"Hydric" means that all major and minor components listed for a given map unit are rated as being hydric. 
---"Predominantly Hydric" means that all major components listed for a given map unit are rated as hydric, and at least one contrasting minor component is not rated hydric. 
---"Partially Hydric" means that at least one major component listed for a given map unit is rated as hydric, and at least one other major component is not rated hydric. 
---"Predominantly Nonhydric" means that no major component listed for a given map unit is rated as hydric, and at least one contrasting minor component is rated hydric. 
---"Nonhydric" means no major or minor components for the map unit are rated hydric. The assumption is that the map unit is nonhydric even if none of the components within the map unit have been rated.
 
 SELECT 
 areasymbol, 
 musym, 
 muname,
 mu.mukey/1  AS mukey,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu1
 INNER JOIN component ON component.mukey=mu1.mukey AND mu1.mukey = mu.mukey) AS comp_count,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu2 
 INNER JOIN component ON component.mukey=mu2.mukey AND mu2 .mukey = mu.mukey
 AND majcompflag = 'Yes') AS count_maj_comp,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu3
 INNER JOIN component ON component.mukey=mu3.mukey AND mu3.mukey = mu.mukey
 AND hydricrating = 'Yes' ) AS all_hydric,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu4
 INNER JOIN component ON component.mukey=mu4.mukey AND mu4.mukey = mu.mukey
 AND majcompflag = 'Yes' AND hydricrating = 'Yes') AS maj_hydric,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu5
 INNER JOIN component ON component.mukey=mu5.mukey AND mu5.mukey = mu.mukey
 AND majcompflag = 'Yes' AND hydricrating != 'Yes') AS maj_not_hydric,
  (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu6
 INNER JOIN component ON component.mukey=mu6.mukey AND mu6.mukey = mu.mukey
 AND majcompflag != 'Yes' AND hydricrating  = 'Yes' ) AS hydric_inclusions,
 (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu7
 INNER JOIN component ON component.mukey=mu7.mukey AND mu7.mukey = mu.mukey
 AND hydricrating  != 'Yes') AS all_not_hydric, 
  (SELECT TOP 1 COUNT_BIG(*)
 FROM mapunit AS mu8
 INNER JOIN component ON component.mukey=mu8.mukey AND mu8.mukey = mu.mukey
 AND hydricrating  IS NULL ) AS hydric_null ,
   (SELECT SUM (comppct_r)
 FROM mapunit AS mu9
 INNER JOIN component ON component.mukey=mu9.mukey AND mu9.mukey = mu.mukey
AND hydricrating  = 'Yes' ) AS MU_comppct_SUM
 
 INTO #main_query
 FROM legend  AS l
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey --AND mu.mukey IN ('168209') 
AND  l.areasymbol = 'WI025' ---LEFT(l.areasymbol,2) LIKE 'WI'
 
 ---Getting the component data and criteria together for the Component Percent. 
 SELECT  #main_query.areasymbol, #main_query.muname, #main_query.mukey, cokey, compname, hydricrating, localphase, drainagecl, 
 CASE 
 WHEN compkind = 'Miscellaneous area' AND compname = 'Water' 			THEN 999
 WHEN compkind = 'Miscellaneous area' AND compname LIKE '% water' 		THEN 999
 WHEN compkind = 'Miscellaneous area' AND compname LIKE  '% Ocean' 		THEN 999
 WHEN compkind = 'Miscellaneous area' AND compname LIKE '% swamp' 		THEN 999
 WHEN compkind = 'Miscellaneous area' AND muname = 'Water'			 	THEN 999 
 
 WHEN compkind IS NULL AND compname = 'Water' 			THEN 999
 WHEN compkind IS NULL  AND compname LIKE '% water' 	THEN 999
 WHEN compkind IS NULL  AND compname LIKE  '% Ocean' 	THEN 999
 WHEN compkind IS NULL  AND compname LIKE '% swamp' 	THEN 999
 WHEN compkind IS NULL  AND muname = 'Water' 			THEN 999  END AS Water999,
 
 CASE WHEN hydricrating = 'Yes' THEN comppct_r
 WHEN hydricrating = 'Unranked' AND localphase LIKE '%drained%' 	THEN comppct_r
 WHEN hydricrating = 'Unranked' AND localphase LIKE '%channeled%' 	THEN comppct_r
 WHEN hydricrating = 'Unranked' AND localphase LIKE '%protected%' 	THEN comppct_r
 WHEN hydricrating = 'Unranked' AND localphase LIKE '%ponded%' 		THEN comppct_r
 WHEN hydricrating = 'Unranked' AND localphase LIKE '%flooded%' 	THEN comppct_r	
 END AS hydric_sum
 INTO #mu_agg
 FROM #main_query
 INNER JOIN component ON component.mukey=#main_query.mukey
 
 SELECT  DISTINCT mukey, muname, areasymbol, 
CASE WHEN Water999 = 999 THEN MAX (999) over(PARTITION BY mukey)  ELSE SUM (hydric_sum) over(PARTITION BY mukey) END AS mu_hydric_sum
 INTO #mu_agg2
 FROM #mu_agg 

  SELECT  DISTINCT mukey, muname, areasymbol, 
mu_hydric_sum
 INTO #mu_agg3
 FROM #mu_agg2 WHERE mu_hydric_sum IS NOT NULL
 
 
SELECT  ---#main_query.areasymbol, 
---#main_query.musym, 
 ---#main_query.muname,
#main_query.mukey, #mu_agg3.mu_hydric_sum AS PotWetandSoil,
CASE WHEN comp_count = all_not_hydric + hydric_null THEN  'Nonhydric' 
WHEN comp_count = all_hydric  THEN 'Hydric' 
WHEN comp_count != all_hydric AND count_maj_comp = maj_hydric THEN 'Predominantly Hydric' 
WHEN hydric_inclusions >= 0.5 AND  maj_hydric < 0.5 THEN  'Predominantly Nonydric' 
WHEN maj_not_hydric >= 0.5  AND  maj_hydric >= 0.5 THEN 'Partially Hydric' ELSE 'Error' END AS hydric_rating
FROM #main_query
LEFT OUTER JOIN #mu_agg3 ON #mu_agg3.mukey=#main_query.mukey