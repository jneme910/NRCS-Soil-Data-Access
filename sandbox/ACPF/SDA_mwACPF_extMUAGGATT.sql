SELECT  mu.mukey
     muagg.musym as MUsymbol,
     muagg.muname as MUname,
     muagg.wtdepaprjunmin as WTDepAprJun,
     muagg.flodfreqdcd as FloodFreq,
     CAST(muagg.pondfreqprs AS smallint) as PondFreq,
     muagg.drclassdcd as DrainCls,
     muagg.drclasswettest as DrainClsWet,
     muagg.hydgrpdcd as HydroGrp,
     CAST(muagg.hydclprs AS smallint) as Hydric,
	 nccpi2cs as NCCPIcs,
	 nccpi2sg as NCCPIsg,
	 rootznemc as RootZnDepth,
	 rootznaws as RootZnAWS,
	 droughty as Droughty,
	 pwsl1pomu as PotWetandSoil
	 
	 
	 , (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Corn and soybeans') as Nccpi_Corn_Soybeans_Class_dcp 
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Corn and soybeans') as Nccpi_Corn_Soybeans_Value_dcp 

, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Small grains') as Nccpi_SmallGrains_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Small grains') as Nccpi_SmallGrains_Value_dcp

FROM (legend INNER JOIN (mapunit INNER JOIN component ON mapunit.mukey = component.mukey AND majcompflag = 'yes') ON legend.lkey = mapunit.lkey AND LEFT (legend.areasymbol,2) = 'WI' 
INNER JOIN mu

--From Value1 Documentation

--nccpi2cs (Corn and Soybeans)	  
--National Commodity Crop Productivity Index for Corn and Soybeans (weighted average) for major earthy components. Values range from .01 (low productivity) to .99 (high productivity). Earthy components are those soil series or higher level taxa components that can support crop growth (Dobos et al., 2012). Major components are those soil components where the majorcompflag = 'Yes' (SSURGO component table). NULL values are presented where data are incomplete or not available.

--- nccpi2cs (Small Grain)
---National Commodity Crop Productivity Index for Small Grains (weighted average) for major earthy components. Values range from .01 (low productivity) to .99 (high productivity). Earthy components are those soil series or higher level taxa components that can support crop growth (Dobos et al., 2012). Major components are those soil components where the majorcompflag = 'Yes' (SSURGO component table). NULL values are presented where dataare incomplete or not available.

---rootznemc -Root Zone Available Water Storage (mm) ‐ earthy major components
---Root zone depth is the depth within the soil profile that commodity crop (cc) roots can effectively extract water and nutrients for growth. Root zone depth influences soil productivity significantly. Soil component horizon criteria for root‐limiting depth include: presence of hard bedrock, soft bedrock, a fragipan, a duripan, sulfuric material, a dense layer, a layer having a pH of less than 3.5, or a layer having an electrical conductivity of more than 12 within the component soil profile. If no root‐restricting zone is identified, a depth of 150 cm is used to approximate the root zone depth (Dobos et al., 2012). Root zone depth is computed for all map unit major earthy components (weighted average). Earthy components are those soil series or higher level taxa components that can support crop growth (Dobos et al., 2012). Major components are those soil components where the majorcompflag = 'Yes' (SSURGO component table). NULL values are presented where data are incomplete or not available.

---droughty -Droughty Soil Landscapes ‐ earthy major components
---Drought vulnerable soil landscapes comprise those map units that have available water storage within the root zone for commodity crops that is less than or equal to 6 inches (152 mm) expressed as "1" for a drought vulnerable soil landscape map unit or "0" for a nondroughty soil landscape map unit or NULL for miscellaneous areas (includes water bodies). It is computed as a weighted average for major earthy components. Earthy components are those soil series or higher level taxa components that can support crop growth (Dobos et al., 2012). Major components are those soil components where the majorcompflag = 'Yes' (SSURGO component table). NULL values are presented where data are incomplete or not available.

---pwsl1pomu  -Potential Wetland Soil Landscapes
---"Potential Wetland Soil Landscapes" (PWSL) is expressed as the percentage of the map unit that meets the PWSL criteria. The hydric rating (soil component variable “hydricrating”) is an indicator of wet soils. For version 1 (pwsl1), those soil components that meet the following criteria are tagged as PWSL and their comppct_r values are summed for each map unit. Soil components with hydricrating = 'YES' are considered PWSL. Soil components with hydricrating = “NO” are not PWSL. Soil components with hydricrating = 'UNRANKED' are tested using other attributes, and will be considered PWSL if any of the following conditions are met: drainagecl = 'Poorly drained' or 'Very poorly drained' or the localphase or the otherph data fields contain any of the phrases "drained" or "undrained" or "channeled" or "protected" or "ponded" or "flooded". If these criteria do not determine the PWSL for a component and hydricrating = 'UNRANKED', then the map unit will be classified as PWSL if the map unit name contains any of the phrases "drained" or "undrained" or "channeled" or "protected" or "ponded" or "flooded". For version 1 (pwsl1), waterbodies are identified as "999" when map unit names match a list of terms that identify water or intermittent water or map units have a sum of the comppct_r for "Water" that is 80% or greater. NULL values are presented where data are incomplete or not available.