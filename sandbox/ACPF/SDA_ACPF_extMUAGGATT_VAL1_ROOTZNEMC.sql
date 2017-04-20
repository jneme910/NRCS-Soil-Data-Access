-ROOTZNEMC
--Metadata:
--Root zone depth is the depth within the soil profile that commodity crop (cc) roots can effectively extract water and nutrients for growth. 
--Root zone depth influences soil productivity significantly. Soil component horizon criteria for root-limiting depth include: presence of 
--hard bedrock, soft bedrock, a fragipan, a duripan, sulfuric material, a dense layer, a layer having a pH of less than 3.5, or a layer having 
--an electrical conductivity of more than 16 within the component soil profile. If no root-restricting zone is identified, a depth of 150 cm 
--is used to approximate the root zone depth (Dobos et al., 2012). Root zone depth is computed for all map unit major earthy components 
--(weighted average). Earthy components are those soil series or higher level taxa components that can support crop growth (Dobos et al., 
--2012). Major components are those soil components where the majorcompflag = 'Yes' (SSURGO component table). NULL values are presented where 
--data are incomplete or not available.

--Python script notes for rootznemc:
--    # Look at soil horizon properties to adjust the root zone depth.
--    # This is in addition to the standard component restrictions
--    #
--    # Read the component restrictions into a dictionary, then read through the
--    # QueryTable_Hz table, calculating the final component rootzone depth
--    #
--	# Only major components are used.
--    # Components with COMPKIND = 'Miscellaneous area' or NULL are filtered out.
--    # Components with no horizon data are assigned a root zone depth of zero.
--    #
--   # Horizons with NULL hzdept_r or hzdepb_r are filtered out
--    # Horizons with hzdept_r => hzdepb_r are filtered out
--    # O horizons or organic horizons from the surface down to the first mineral horizon
--    # are filtered out.
--    #
--    # Horizon data below 150cm or select component restrictions are filtered out.
--	# Uses Lithic bedrock, Paralithic bedrock, Densic bedrock, Fragipan, Duripan, Sulfuric
--	# Other restrictions include pH < 3.5 and EC > 16
--	#
--	# A Dense layer calculation is also included as an additional component restriction. It
--	# looks at rv values for sandtotal, silttotal, claytotal and bulkdensity thirdbar
--	# a = dbthirdbar_r - ((( sand * 1.65 ) / 100.0 ) + (( silt * 1.30 ) / 100.0 ) + (( clay * 1.25 ) / 100.0))

--    # b = ( 0.002081 * sand ) + ( 0.003912 * silt ) + ( 0.0024351 * clay )

--    #  if a > b:
 --   #     This is a Dense horizon. Consider top depth to be a restriction for this component
--    #  else:
--		#     This is NOT a Dense horizon
--------------------------------------------------------------------------------------------------------------------
---
---Gets the map unit information
---
SELECT sacatalog.areasymbol AS AREASYMBOL, 
mapunit.mukey AS mukey, 
mapunit.musym AS MUSYM,
mapunit.muname AS MUNAME
INTO #main
FROM sacatalog 
INNER JOIN legend  ON legend.areasymbol = sacatalog.areasymbol AND LEFT (sacatalog.areasymbol, 2) = 'WI'
--AND sacatalog.areasymbol = 'WI025'
INNER JOIN mapunit ON mapunit.lkey = legend.lkey --AND mapunit.mukey = 753459
--AND mukind = 'Complex'
ORDER BY sacatalog.areasymbol, mapunit.mukey, mapunit.muname  
---
--Gets the component information
---Min Top Restriction Depth
---Major Components Only
---Excludes Miscellaneous area or Where compkind is null
SELECT 
#main.AREASYMBOL, 
#main.mukey, 
#main.MUSYM,
#main.MUNAME,
CONCAT(#main.mukey, ' - ', cokey) AS MUCOMPKEY,
compname AS COMPNAME, 
comppct_r AS COMPPCT_R,
component.cokey,
compkind,
majcompflag, 
ISNULL((SELECT TOP 1 MIN (resdept_r) 
FROM component AS c
INNER JOIN corestrictions ON corestrictions.cokey=c.cokey AND reskind IN ('Densic bedrock', 'Lithic bedrock','Paralithic bedrock', 'Fragipan','Duripan','Sulfuric')
 AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_r), 150) AS RV_FIRST_RESTRICTION,
ISNULL((SELECT TOP 1 reskind
FROM component AS c
INNER JOIN corestrictions ON corestrictions.cokey=c.cokey AND reskind IN ('Densic bedrock', 'Lithic bedrock','Paralithic bedrock', 'Fragipan','Duripan','Sulfuric')

--Lithic bedrock, Paralithic bedrock, Densic bedrock, Fragipan, Duripan, Sulfuric
AND c.cokey=component.cokey  GROUP BY c.cokey, reskind, resdept_r, corestrictkey ORDER BY resdept_r, corestrictkey ), 'No Data') AS FIRST_RESTRICTION_KIND
INTO #co_main
FROM #main
INNER JOIN component ON component.mukey=#main.mukey AND majcompflag = 'yes'
AND CASE WHEN compkind = 'Miscellaneous area' THEN 2 
WHEN compkind IS NULL THEN 2 ELSE 1 END = 1 
ORDER BY #main.AREASYMBOL, 
#main.MUNAME, 
#main.mukey, 
comppct_r DESC, component.cokey

---
---Gets the horizon information
---
SELECT 
#co_main.AREASYMBOL, 
#co_main.mukey, 
#co_main.MUSYM,
#co_main.MUNAME,
#co_main.MUCOMPKEY,
#co_main.COMPNAME, 
#co_main.compkind,
#co_main.COMPPCT_R,
#co_main.majcompflag,
#co_main.cokey,
hzname, 
hzdept_r,
hzdepb_r,
chorizon.chkey,
ph1to1h2o_r AS pH,
ec_r AS ec, 
dbthirdbar_r - ((( sandtotal_r * 1.65 ) / 100.0 ) + (( silttotal_r * 1.30 ) / 100.0 ) + (( claytotal_r * 1.25 ) / 100.0)) AS a,
( 0.002081 * sandtotal_r ) + ( 0.003912 * silttotal_r ) + ( 0.0024351 * claytotal_r ) AS b,
CASE WHEN dbthirdbar_r - ((( sandtotal_r * 1.65 ) / 100.0 ) + (( silttotal_r * 1.30 ) / 100.0 ) + (( claytotal_r * 1.25 ) / 100.0))> ( 0.002081 * sandtotal_r ) + ( 0.003912 * silttotal_r ) + ( 0.0024351 * claytotal_r ) THEN hzdept_r ELSE 150 END AS  Dense_Restriction,
RV_FIRST_RESTRICTION,
FIRST_RESTRICTION_KIND,
CASE WHEN ph1to1h2o_r <3.5 THEN hzdept_r ELSE 150 END AS pH_Restriction,
CASE WHEN ec_r >=16 THEN hzdept_r ELSE 150 END AS ec_Restriction
INTO #Hor_main
FROM #co_main
INNER JOIN chorizon ON chorizon.cokey=#co_main.cokey AND hzname NOT LIKE '%O%'
ORDER BY #co_main.AREASYMBOL, 
#co_main.MUNAME, 
#co_main.mukey, 
#co_main.comppct_r DESC, #co_main.cokey, hzdept_r ASC,
hzdepb_r ASC, chorizon.chkey

---
---Merging the Min Restrictions together
---(pH_Restriction), (ec_Restriction), (Dense_Restriction), (RV_FIRST_RESTRICTION)
SELECT #Hor_main.cokey, 
#Hor_main.AREASYMBOL, 
#Hor_main.mukey, 
#Hor_main.MUSYM,
#Hor_main.MUNAME,
#Hor_main.MUCOMPKEY,
#Hor_main.COMPNAME, 
#Hor_main.compkind,
#Hor_main.COMPPCT_R,
#Hor_main.majcompflag,
#Hor_main.hzname, 
#Hor_main.hzdept_r,
#Hor_main.hzdepb_r,
#Hor_main.chkey,
#Hor_main.pH_Restriction,
#Hor_main.ec_Restriction,
#Hor_main.Dense_Restriction,
#Hor_main.RV_FIRST_RESTRICTION, MinValue
INTO #Hor_main2
FROM #Hor_main
CROSS APPLY (SELECT MIN(e) MinValue FROM (VALUES (pH_Restriction), (ec_Restriction), (Dense_Restriction), (RV_FIRST_RESTRICTION)) AS a(e)) A

---SELECTS THE MIN VALUE BY Component AND Map Unit
SELECT
--#Hor_main2.cokey, 
#Hor_main2.AREASYMBOL, 
#Hor_main2.mukey, 
#Hor_main2.MUNAME,
--#Hor_main2.COMPNAME, 
--#Hor_main2.compkind,
--#Hor_main2.COMPPCT_R,
--#Hor_main2.majcompflag,
--MIN(MinValue) over(partition by #Hor_main2.cokey) as Comp_RootZnDepth,
MIN(MinValue) over(partition by #Hor_main2.mukey) as MU_RootZnDepth
INTO #Hor_main3
FROM #Hor_main2
GROUP BY #Hor_main2.AREASYMBOL,#Hor_main2.mukey, #Hor_main2.MUNAME, 
--#Hor_main2.COMPNAME, #Hor_main2.compkind, #Hor_main2.cokey, #Hor_main2.COMPPCT_R,#Hor_main2.majcompflag,
 MinValue

---Time to come home. Go to your home data. Leave the nest
SELECT
 #main.AREASYMBOL, 
 #main.mukey, 
 #main.MUSYM,
 #main.MUNAME,
 #Hor_main3.MU_RootZnDepth AS RootZnDepth
 INTO #last_step
 FROM  #main
 LEFT OUTER JOIN #Hor_main3 ON #Hor_main3.mukey=#main.mukey
 GROUP BY  #main.AREASYMBOL, 
 #main.mukey, 
 #main.MUSYM,
 #main.MUNAME,
 #Hor_main3.MU_RootZnDepth 
 
--Extra Step  
SELECT 
---#last_step.AREASYMBOL, 
#last_step.mukey, 
---#last_step.MUSYM,
---#last_step.MUNAME,
#last_step.RootZnDepth 
FROM #last_step
 


