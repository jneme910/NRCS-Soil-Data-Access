DROP TABLE IF EXISTS #comet_values_avg
DROP TABLE IF EXISTS #npad_agg_lite
DROP TABLE IF EXISTS #npad3

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED




CREATE TABLE #npad_agg_lite (
    n_id INT IDENTITY(1, 1),
    land_unit_id INT,
    practice_id INT,
    planned_system_id INT,
    practice_shape_id INT,
    scheduled_practice_id INT,
    prac_shape_calculated_acres REAL,
    creation_date VARCHAR(240),
    last_change_date VARCHAR(240),
    Tract_Number INT,
    Land_Unit_Number VARCHAR(40),
    Practice_Code VARCHAR(40),
    Calc_Practice_Code INT,
    Practice_Name VARCHAR(240),
    Practice_Units VARCHAR(10),
    Planned_Amount REAL,
    Planned_Date VARCHAR(240),
    Lifespan SMALLINT,
    Practice_Status VARCHAR(240),
    Applied_Amount REAL,
    Applied_Date DATETIME,
    Program_Code VARCHAR(240),
    Certified DATETIME,
    land_unit_state_county_code INT,
    state_county_code INT,
    state_code INT,
    county_code INT,
    state_abbr VARCHAR(10),
    county_name VARCHAR(240),
    county_display VARCHAR(240),
    independent_city_ind VARCHAR(240),
    state_name VARCHAR(240),
    county_sort_display VARCHAR(240),
    land_use_id INT,
    land_use_code VARCHAR(40),
    legacy_land_use_id INT,
    legacy_land_use_name VARCHAR(240),
    land_use_name VARCHAR(240),
    land_use_display VARCHAR(240),
    land_use_description VARCHAR(1000),
	pratice_acres REAL, 
	FY INT
  
    CONSTRAINT pk_npad_agg_indx3
        PRIMARY KEY CLUSTERED (n_id))
go

INSERT INTO #npad_agg_lite (land_unit_id,
                             practice_id,
                             planned_system_id,
                             practice_shape_id,
                             scheduled_practice_id,
                             prac_shape_calculated_acres,
                             creation_date,
                             last_change_date,
                             Tract_Number,
                             Land_Unit_Number,
                             Practice_Code,
                             Calc_Practice_Code,
                             Practice_Name,
                             Practice_Units,
                             Planned_Amount,
                             Planned_Date,
                             Lifespan,
                             Practice_Status,
                             Applied_Amount,
                             Applied_Date,
                             Program_Code,
                             Certified,
                             land_unit_state_county_code,
                             state_county_code,
                             state_code,
                             county_code,
                             state_abbr,
                             county_name,
                             county_display,
                             independent_city_ind,
                             state_name,
                             county_sort_display,
                             land_use_id,
                             land_use_code,
                             legacy_land_use_id,
                             legacy_land_use_name,
                             land_use_name,
                             land_use_display,
                             land_use_description,
							 pratice_acres,
							 FY
                          )


SELECT TOP 10 plu.land_unit_id,
       ps.[practice_id],
       [planned_system_id],
       [practice_shape_id],
       ps.[scheduled_practice_id],
       --[alt_land_unit_id] pound out but don't delete
       ROUND([prac_shape_calculated_quan], 3) AS prac_shape_calculated_acres,
       ps.[creation_date] AS creation_date,
       ps.[last_change_date] AS last_change_date,
       ps.[Tract_Number],
       ps.[Land_Unit_Number],
       [Practice_Code],
       CASE
	    WHEN Practice_Code LIKE '%116%' THEN 116
   WHEN Practice_Code LIKE '%216' THEN 216	--Soil Testing
   WHEN Practice_Code LIKE '%327' THEN 327 --Conservation Cover
   WHEN Practice_Code LIKE '%328' THEN 328	--Conservation Crop Rotation
   WHEN Practice_Code LIKE '%329' THEN 329	--Residue and Tillage Management, No-Till
   WHEN Practice_Code LIKE '%334' THEN 334	--Controlled Traffic Farming
   WHEN Practice_Code LIKE '%340' THEN 340	--Cover Crop
   WHEN Practice_Code LIKE '%345' THEN 345	--Residue and Tillage Management, Reduced-Till
   WHEN Practice_Code LIKE '%484' THEN 484	--Mulching
   WHEN Practice_Code LIKE '%449' THEN 449	--Irrigation Water Management
   WHEN Practice_Code LIKE '%512' THEN 512	--Forage and Biomass Planting
   WHEN Practice_Code LIKE '%528' THEN 528	--Prescribed Grazing
   WHEN Practice_Code LIKE '%550' THEN 550	--Range Planting
   WHEN Practice_Code LIKE '%590' THEN 590	--Nutrient Management
   WHEN Practice_Code LIKE '%595' THEN 595	--Pest Management Conservation System
   WHEN Practice_Code LIKE '%610' THEN 610	--Salinity & Sodic Soil Management
   WHEN Practice_Code LIKE '%808' THEN 808	--Soil Carbon Amendment
   WHEN Practice_Code LIKE '%314' THEN 314	--Brush Management
   WHEN Practice_Code LIKE '%315' THEN 315	--Herbaceous Weed Treatment
   WHEN Practice_Code LIKE '%324' THEN 324	--Deep Tillage
   WHEN Practice_Code LIKE '%330' THEN 330	--Contour Farming
   WHEN Practice_Code LIKE '%333' THEN 333	--Amending Soil Properties with Gypsum Products
   WHEN Practice_Code LIKE '%338' THEN 338	--Prescribed Burning
   WHEN Practice_Code LIKE '%342' THEN 342	--Critical Area Planting
   WHEN Practice_Code LIKE '%382' THEN 382	--Fence
   WHEN Practice_Code LIKE '%394' THEN 394	--Firebreak
   WHEN Practice_Code LIKE '%516' THEN 516	--Pipeline
   WHEN Practice_Code LIKE '%548' THEN 548	--Grazing Land Mechanical Treatment
   WHEN Practice_Code LIKE '%561' THEN 561	--Heavy Use Area Protection
   WHEN Practice_Code LIKE '%574' THEN 574	--Spring Development
   WHEN Practice_Code LIKE '%575' THEN 575	--Animal Trails and Walkways
   WHEN Practice_Code LIKE '%580' THEN 590	--Streambank and Shoreline Protection
   WHEN Practice_Code LIKE '%614' THEN 614	--Watering Facility
   WHEN Practice_Code LIKE '%642' THEN 642	--Water Well
 END AS [Calc_Practice_Code],
       [Practice_Name],
       [Practice_Units],
       [Planned_Amount],
       [Planned_Date] AS Planned_Date,
       [Lifespan],
       [Practice_Status],
       [Applied_Amount],
       [Applied_Date] AS Applied_Date,
       [Program_Code],
       FORMAT(CAST([Certified] AS datetime), 'MMM dd yyyy') AS Certified, --'MMM dd yyyy')
       lu.[land_unit_state_county_code], --Land Unit
       sc.[state_county_code],
       sc.[state_code],
       sc.[county_code],
       sc.[state_abbr],
       sc.[county_name],
       sc.[county_display],
       sc.[independent_city_ind],
       sc.[state_name],
       sc.[county_sort_display],
       luu.[land_use_id],
       luu.[land_use_code],
       luu.[legacy_land_use_id],
       luu.[legacy_land_use_name],
       luu.[land_use_name],
       luu.[land_use_display],
       luu.[land_use_description],
       [Applied_Amount] AS pratice_acres,
	   CASE
            WHEN LEFT(Certified, 4) = 2020
             AND YEAR(CAST(certified AS datetime)) = 2020
             AND MONTH(CAST(certified AS datetime)) >= 10 THEN YEAR(CAST(certified AS datetime)) + 1
            WHEN LEFT(Certified, 4) = 2021
             AND YEAR(CAST(certified AS datetime)) = 2021
             AND MONTH(CAST(certified AS datetime)) < 10 THEN  YEAR(CAST(certified AS datetime))
      
			 
			 WHEN LEFT(Certified, 4) = 2019
             AND YEAR(CAST(certified AS datetime)) = 2019
             AND MONTH(CAST(certified AS datetime)) >= 10 THEN YEAR(CAST(certified AS datetime)) + 1
            WHEN LEFT(Certified, 4) = 2020
             AND YEAR(CAST(certified AS datetime)) = 2020
             AND MONTH(CAST(certified AS datetime)) < 10 THEN  YEAR(CAST(certified AS datetime))
         
			
			  WHEN LEFT(Certified, 4) = 2018
             AND YEAR(CAST(certified AS datetime)) = 2018
             AND MONTH(CAST(certified AS datetime)) >= 10 THEN YEAR(CAST(certified AS datetime)) + 1
            WHEN LEFT(Certified, 4) = 2019
             AND YEAR(CAST(certified AS datetime)) = 2019
             AND MONTH(CAST(certified AS datetime)) < 10 THEN  YEAR(CAST(certified AS datetime))
           
		   ELSE YEAR(CAST(certified AS datetime)) 
			END  AS FY  

  FROM [npadGeo].[dbo].[VW_PRACTICE_SHAPE_A_limitedAttributes] AS ps
 INNER JOIN [NPAD].[dbo].[practice_land_unit] AS plu
    ON plu.scheduled_practice_id = ps.scheduled_practice_id
   AND CASE
            WHEN LEFT(Certified, 4) = 2020
             AND YEAR(CAST(certified AS datetime)) = 2020
             AND MONTH(CAST(certified AS datetime)) >= 10 THEN 1
            WHEN LEFT(Certified, 4) = 2021
             AND YEAR(CAST(certified AS datetime)) = 2021
             AND MONTH(CAST(certified AS datetime)) < 10 THEN 1
            WHEN LEFT(Certified, 4) = 2019
             AND YEAR(CAST(certified AS datetime)) = 2019
             AND MONTH(CAST(certified AS datetime)) >= 10 THEN 1
            WHEN LEFT(Certified, 4) = 2020
             AND YEAR(CAST(certified AS datetime)) = 2020
             AND MONTH(CAST(certified AS datetime)) < 10 THEN 1
          WHEN LEFT(Certified, 4) = 2018
             AND YEAR(CAST(certified AS datetime)) = 2018
             AND MONTH(CAST(certified AS datetime)) >= 10 THEN 1
            WHEN LEFT(Certified, 4) = 2019
             AND YEAR(CAST(certified AS datetime)) = 2019
             AND MONTH(CAST(certified AS datetime)) < 10 THEN 1
            ELSE 2 END           = 1 -- Stupid datetime is a mixed date type. 
 INNER JOIN [NPAD].[dbo].[land_unit] AS lu
    ON lu.[land_unit_id]         = plu.[land_unit_id] --AND lu.[land_unit_id] = 2625367 
 INNER JOIN [NPAD].[dbo].[d_state_county] AS sc
    ON sc.[state_county_code]    = lu.[land_unit_state_county_code] AND  sc.[state_abbr]= 'CA'
   AND [Practice_Status]         = 'Applied'
   AND certified                 != 'Not Certified'
   --AND ISDATE(Planned_Date)      = 1
   AND CASE
   WHEN Practice_Code LIKE '%116%' THEN 1
   WHEN Practice_Code LIKE '%216' THEN 1	--Soil Testing
   WHEN Practice_Code LIKE '%327' THEN 1	--Conservation Cover
   WHEN Practice_Code LIKE '%328' THEN 1	--Conservation Crop Rotation
   WHEN Practice_Code LIKE '%329' THEN 1	--Residue and Tillage Management, No-Till
   WHEN Practice_Code LIKE '%334' THEN 1	--Controlled Traffic Farming
   WHEN Practice_Code LIKE '%340' THEN 1	--Cover Crop
   WHEN Practice_Code LIKE '%345' THEN 1	--Residue and Tillage Management, Reduced-Till
   WHEN Practice_Code LIKE '%484' THEN 1	--Mulching
   WHEN Practice_Code LIKE '%449' THEN 1	--Irrigation Water Management
   WHEN Practice_Code LIKE '%512' THEN 1	--Forage and Biomass Planting
   WHEN Practice_Code LIKE '%528' THEN 1	--Prescribed Grazing
   WHEN Practice_Code LIKE '%550' THEN 1	--Range Planting
   WHEN Practice_Code LIKE '%590' THEN 1	--Nutrient Management
   WHEN Practice_Code LIKE '%595' THEN 1	--Pest Management Conservation System
   WHEN Practice_Code LIKE '%610' THEN 1	--Salinity & Sodic Soil Management
   WHEN Practice_Code LIKE '%808' THEN 1	--Soil Carbon Amendment
   WHEN Practice_Code LIKE '%314' THEN 1	--Brush Management
   WHEN Practice_Code LIKE '%315' THEN 1	--Herbaceous Weed Treatment
   WHEN Practice_Code LIKE '%324' THEN 1	--Deep Tillage
   WHEN Practice_Code LIKE '%330' THEN 1	--Contour Farming
   WHEN Practice_Code LIKE '%333' THEN 1	--Amending Soil Properties with Gypsum Products
   WHEN Practice_Code LIKE '%338' THEN 1	--Prescribed Burning
   WHEN Practice_Code LIKE '%342' THEN 1	--Critical Area Planting
   WHEN Practice_Code LIKE '%382' THEN 1	--Fence
   WHEN Practice_Code LIKE '%394' THEN 1	--Firebreak
   WHEN Practice_Code LIKE '%516' THEN 1	--Pipeline
   WHEN Practice_Code LIKE '%548' THEN 1	--Grazing Land Mechanical Treatment
   WHEN Practice_Code LIKE '%561' THEN 1	--Heavy Use Area Protection
   WHEN Practice_Code LIKE '%574' THEN 1	--Spring Development
   WHEN Practice_Code LIKE '%575' THEN 1	--Animal Trails and Walkways
   WHEN Practice_Code LIKE '%580' THEN 1	--Streambank and Shoreline Protection
   WHEN Practice_Code LIKE '%614' THEN 1	--Watering Facility
   WHEN Practice_Code LIKE '%642' THEN 1	--Water Well

            ELSE 2 END           = 1
 INNER JOIN [NPAD].[dbo].[land_unit_land_use] llu
    ON llu.[land_unit_id]        = lu.[land_unit_id] -- was outer join, might need to change to outer
 INNER JOIN [NPAD].[dbo].[d_land_use] AS luu
    ON luu.[land_use_id]         = llu.[land_use_id] -- was outer join, might need to change to outer



CREATE INDEX npad_values_avg_idx1c3
ON #npad_agg_lite
(   land_unit_id, practice_id, scheduled_practice_id, state_county_code, state_code, county_code, certified)


GO



CREATE TABLE #npad3
(comet_final_id INT IDENTITY(1, 1),
state_county_code INT, 
state_code INT, 
county_code INT , 
state_abbr VARCHAR (20), 
county_name VARCHAR (240), 
county_display  VARCHAR (240), 
state_name VARCHAR (240) , 
county_sort_display   VARCHAR (240), 
FY INT, 
sum_acres FLOAT, 
Practice_Code  VARCHAR (240),
   CONSTRAINT pk_comet_county_sum3_indx3
        PRIMARY KEY CLUSTERED (comet_final_id))
go

INSERT INTO #npad3
(
state_county_code ,
state_code,
county_code , 
state_abbr , 
county_name , 
county_display , 
state_name , 
county_sort_display , 
FY,
sum_acres, 
Practice_Code
)

SELECT DISTINCT [state_county_code],
       [state_code] ,
	   [county_code],
       [state_abbr],
       [county_name],
       [county_display],
       [state_name],
       [county_sort_display],
	   [FY],
	   SUM(Applied_Amount) over (partition by state_county_code, FY,  Practice_Code) as sum_acres, 
  	   Practice_Code
	  FROM #npad_agg_lite


  
             SELECT
                *
            FROM
                (
                    SELECT
					   [state_county_code],
					   [state_code] ,
					   [county_code],
					   [state_abbr],
					   [county_name],
					   [county_display],
					   [state_name],
					   [county_sort_display],
					   [FY]
                    FROM   #npad3
                ) #d
            PIVOT
                (
                    MIN(sum_acres)
                    FOR Practice_Code IN ([116]	,
						[216]	,
						[327]	,
						[328]	,
						[329]	,
						[334]	,
						[340]	,
						[345]	,
						[484]	,
						[449]	,
						[512]	,
						[528]	,
						[550]	,
						[590]	,
						[595]	,
						[610]	,
						[808]	,
						[314]	,
						[315]	,
						[324]	,
						[330]	,
						[333]	,
						[338]	,
						[342]	,
						[382]	,
						[394]	,
						[516]	,
						[548]	,
						[561]	,
						[574]	,
						[575]	,
						[580]	,
						[614]	,
					[642]	

                                    )
                ) AS #practice_pivot_table;
 
 
 -- CREATE INDEX comet_county_sum3_idx1c2
--ON #npad_comet_county_sum3
--(  state_county_code, state_code, county_code)

*/



