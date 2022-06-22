DROP TABLE IF EXISTS #comet_values_avg
DROP TABLE IF EXISTS #npad_agg_lite
DROP TABLE IF EXISTS #npad_comet_county_sum3


CREATE TABLE #comet_values_avg (
    cvaid INT IDENTITY(1, 1),
    practice_id INT,
    state_county_code INT,
    avg_co2_mean FLOAT,
    avg_n2o_mean FLOAT,
    avg_ch4_mean FLOAT,
    avg_soil_carbon_co2 FLOAT,
    avg_biomass_co2 FLOAT,
    avg_fossil_co2 FLOAT,
    avg_biomassburning_co2 FLOAT,
    avg_liming_co2 FLOAT,
    avg_drainedorganicsoils_co2 FLOAT,
    avg_direct_soil_n2o FLOAT,
    avg_indirect_soil_n2o FLOAT,
    avg_wetlandricecultivation_n2o FLOAT,
    avg_asbiomassburning_n2o FLOAT,
    avg_drainedorganicsoils_n2o FLOAT,
    avg_soil_ch4 FLOAT,
    avg_wetlandricecultivation_ch4 FLOAT,
    avg_biomassburning_ch4 FLOAT,
    avg_total_ghg_co2 FLOAT,
    avg_total_ghg_co2_min FLOAT,
    avg_total_ghg_co2_max FLOAT,
    CONSTRAINT pk_comet_values_avg_indx
        PRIMARY KEY CLUSTERED (cvaid))
go

INSERT INTO #comet_values_avg (
    practice_id ,
    state_county_code ,
    avg_co2_mean ,
    avg_n2o_mean ,
    avg_ch4_mean ,
    avg_soil_carbon_co2 ,
    avg_biomass_co2 ,
    avg_fossil_co2 ,
    avg_biomassburning_co2 ,
    avg_liming_co2 ,
    avg_drainedorganicsoils_co2 ,
    avg_direct_soil_n2o ,
    avg_indirect_soil_n2o ,
    avg_wetlandricecultivation_n2o ,
    avg_asbiomassburning_n2o ,
    avg_drainedorganicsoils_n2o ,
    avg_soil_ch4 ,
    avg_wetlandricecultivation_ch4 ,
    avg_biomassburning_ch4 ,
    avg_total_ghg_co2 ,
    avg_total_ghg_co2_min ,
    avg_total_ghg_co2_max )

SELECT DISTINCT [practice_id],
       [state_county_code],
       AVG(co2_mean) over (partition by state_county_code) as avg_co2_mean,
       AVG(n2o_mean) over (partition by state_county_code) as avg_n2o_mean,
       AVG(ch4_mean) over (partition by state_county_code) as avg_ch4_mean,
       AVG(soil_carbon_co2) over (partition by state_county_code) as avg_soil_carbon_co2,
       AVG(biomass_co2) over (partition by state_county_code) as avg_biomass_co2,
       AVG(fossil_co2) over (partition by state_county_code) as avg_fossil_co2,
       AVG(biomassburning_co2) over (partition by state_county_code) as avg_biomassburning_co2,
       AVG(liming_co2) over (partition by state_county_code) as avg_liming_co2,
       AVG(drainedorganicsoils_co2) over (partition by state_county_code) as avg_drainedorganicsoils_co2,
       AVG(direct_soil_n2o) over (partition by state_county_code) as avg_direct_soil_n2o,
       AVG(indirect_soil_n2o) over (partition by state_county_code) as avg_indirect_soil_n2o,
       AVG(wetlandricecultivation_n2o) over (partition by state_county_code) as avg_wetlandricecultivation_n2o,
       AVG(biomassburning_n2o) over (partition by state_county_code) AS  avg_asbiomassburning_n2o,
       AVG(drainedorganicsoils_n2o) over (partition by state_county_code) AS  avg_drainedorganicsoils_n2o,
       AVG(soil_ch4) over (partition by state_county_code) AS avg_soil_ch4,
       AVG(wetlandricecultivation_ch4) over (partition by state_county_code) AS avg_wetlandricecultivation_ch4,
       AVG(biomassburning_ch4) over (partition by state_county_code) AS avg_biomassburning_ch4,
       AVG(total_ghg_co2) over (partition by state_county_code) AS avg_total_ghg_co2,
       AVG(total_ghg_co2_min) over (partition by state_county_code) AS avg_total_ghg_co2_min,
       AVG(total_ghg_co2_max) over (partition by state_county_code) AS avg_total_ghg_co2_max
  FROM [COMET].[COMETFARM].[d_planner_implementations]

CREATE INDEX comet_values_avg_2idx1c
ON #comet_values_avg (practice_id, state_county_code)


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
    avg_co2_mean_c REAL,
    avg_n2o_mean_c REAL,
    avg_ch4_mean_c REAL,
    avg_soil_carbon_co2_c REAL,
    avg_biomass_co2_c REAL,
    avg_fossil_co2_c REAL,
    avg_biomassburning_co2_c REAL,
    avg_liming_co2_c REAL,
    avg_drainedorganicsoils_co2_c REAL,
    avg_direct_soil_n2o_c REAL,
    avg_indirect_soil_n2o_c REAL,
    avg_wetlandricecultivation_n2o_c REAL,
    avg_asbiomassburning_n2o_c REAL,
    avg_drainedorganicsoils_n2o_c REAL,
    avg_soil_ch4_c REAL,
    avg_wetlandricecultivation_ch4_c REAL,
    avg_biomassburning_ch4_c REAL,
    avg_total_ghg_co2_c REAL,
    avg_total_ghg_co2_min_c REAL,
    avg_total_ghg_co2_max_c REAL,
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
                             avg_co2_mean_c,
                             avg_n2o_mean_c,
                             avg_ch4_mean_c,
                             avg_soil_carbon_co2_c,
                             avg_biomass_co2_c,
                             avg_fossil_co2_c,
                             avg_biomassburning_co2_c,
                             avg_liming_co2_c,
                             avg_drainedorganicsoils_co2_c,
                             avg_direct_soil_n2o_c,
                             avg_indirect_soil_n2o_c,
                             avg_wetlandricecultivation_n2o_c,
                             avg_asbiomassburning_n2o_c,
                             avg_drainedorganicsoils_n2o_c,
                             avg_soil_ch4_c,
                             avg_wetlandricecultivation_ch4_c,
                             avg_biomassburning_ch4_c,
                             avg_total_ghg_co2_c,
                             avg_total_ghg_co2_min_c,
                             avg_total_ghg_co2_max_c)
SELECT plu.land_unit_id,
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
            WHEN Practice_Code LIKE '%327%' THEN 327
            WHEN Practice_Code LIKE '%328%' THEN 328
            WHEN Practice_Code LIKE '%329%' THEN 329
            WHEN Practice_Code LIKE '%332%' THEN 332
            WHEN Practice_Code LIKE '%340%' THEN 340
            WHEN Practice_Code LIKE '%342%' THEN 342
            WHEN Practice_Code LIKE '%345%' THEN 345
            WHEN Practice_Code LIKE '%372%' THEN 372
            WHEN Practice_Code LIKE '%379%' THEN 379
            WHEN Practice_Code LIKE '%380%' THEN 380
            WHEN Practice_Code LIKE '%381%' THEN 381
            WHEN Practice_Code LIKE '%386%' THEN 386
            WHEN Practice_Code LIKE '%390%' THEN 390
            WHEN Practice_Code LIKE '%391%' THEN 391
            WHEN Practice_Code LIKE '%393%' THEN 393
            WHEN Practice_Code LIKE '%412%' THEN 412
            WHEN Practice_Code LIKE '%422%' THEN 422
            WHEN Practice_Code LIKE '%453%' THEN 453
            WHEN Practice_Code LIKE '%484%' THEN 484
            WHEN Practice_Code LIKE '%512%' THEN 512
            WHEN Practice_Code LIKE '%528%' THEN 528
            WHEN Practice_Code LIKE '%543%' THEN 543
            WHEN Practice_Code LIKE '%544%' THEN 544
            WHEN Practice_Code LIKE '%550%' THEN 550
            WHEN Practice_Code LIKE '%555%' THEN 555
            WHEN Practice_Code LIKE '%585%' THEN 585
            WHEN Practice_Code LIKE '%590%' THEN 590
            WHEN Practice_Code LIKE '%601%' THEN 601
            WHEN Practice_Code LIKE '%602%' THEN 602
            WHEN Practice_Code LIKE '%603%' THEN 603
            WHEN Practice_Code LIKE '%612%' THEN 612
            WHEN Practice_Code LIKE '%650%' THEN 650 END AS [Calc_Practice_Code],
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
       avg_co2_mean * Applied_Amount  AS avg_co2_mean_c,
       avg_n2o_mean * Applied_Amount AS avg_n2o_mean_c,
       avg_ch4_mean * Applied_Amount AS avg_ch4_mean_c,
       avg_soil_carbon_co2 * Applied_Amount AS avg_soil_carbon_co2_c,
       avg_biomass_co2 * Applied_Amount AS avg_biomass_co2_c,
       avg_fossil_co2 * Applied_Amount AS avg_fossil_co2_c,
       avg_biomassburning_co2 * Applied_Amount AS avg_biomassburning_co2_c,
       avg_liming_co2 * Applied_Amount AS avg_liming_co2_c,
       avg_drainedorganicsoils_co2 * Applied_Amount AS avg_drainedorganicsoils_co2_c,
       avg_direct_soil_n2o * Applied_Amount AS avg_direct_soil_n2o_c,
       avg_indirect_soil_n2o * Applied_Amount AS avg_indirect_soil_n2o_c,
       avg_wetlandricecultivation_n2o * Applied_Amount AS avg_wetlandricecultivation_n2o_c,
       avg_asbiomassburning_n2o * Applied_Amount AS avg_asbiomassburning_n2o_c,
       avg_drainedorganicsoils_n2o * Applied_Amount AS avg_drainedorganicsoils_n2o_c,
       avg_soil_ch4 * Applied_Amount AS avg_soil_ch4_c,
       avg_wetlandricecultivation_ch4 * Applied_Amount AS avg_wetlandricecultivation_ch4_c,
       avg_biomassburning_ch4 * Applied_Amount AS avg_biomassburning_ch4_c,
       avg_total_ghg_co2 * Applied_Amount AS avg_total_ghg_co2_c,
       avg_total_ghg_co2_min * Applied_Amount AS avg_total_ghg_co2_min_c,
       avg_total_ghg_co2_max * Applied_Amount AS avg_total_ghg_co2_max_c
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
            ELSE 2 END           = 1 -- Stupid datetime is a mixed date type. 
 INNER JOIN [NPAD].[dbo].[land_unit] AS lu
    ON lu.[land_unit_id]         = plu.[land_unit_id] --AND lu.[land_unit_id] = 2625367 
 INNER JOIN [NPAD].[dbo].[d_state_county] AS sc
    ON sc.[state_county_code]    = lu.[land_unit_state_county_code]
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
		
            WHEN Practice_Code LIKE '%311%' THEN 1
            WHEN Practice_Code LIKE '%327%' THEN 1
            WHEN Practice_Code LIKE '%328%' THEN 1
            WHEN Practice_Code LIKE '%329%' THEN 1
            WHEN Practice_Code LIKE '%332%' THEN 1
            WHEN Practice_Code LIKE '%340%' THEN 1
            WHEN Practice_Code LIKE '%342%' THEN 1
            WHEN Practice_Code LIKE '%345%' THEN 1
            WHEN Practice_Code LIKE '%372%' THEN 1
            WHEN Practice_Code LIKE '%379%' THEN 1
            WHEN Practice_Code LIKE '%380%' THEN 1
            WHEN Practice_Code LIKE '%381%' THEN 1
            WHEN Practice_Code LIKE '%386%' THEN 1
            WHEN Practice_Code LIKE '%390%' THEN 1
            WHEN Practice_Code LIKE '%391%' THEN 1
            WHEN Practice_Code LIKE '%393%' THEN 1
            WHEN Practice_Code LIKE '%412%' THEN 1
            WHEN Practice_Code LIKE '%422%' THEN 1
            WHEN Practice_Code LIKE '%453%' THEN 1
            WHEN Practice_Code LIKE '%484%' THEN 1
            WHEN Practice_Code LIKE '%512%' THEN 1
            WHEN Practice_Code LIKE '%528%' THEN 1
            WHEN Practice_Code LIKE '%543%' THEN 1
            WHEN Practice_Code LIKE '%544%' THEN 1
            WHEN Practice_Code LIKE '%550%' THEN 1
            WHEN Practice_Code LIKE '%555%' THEN 1
            WHEN Practice_Code LIKE '%585%' THEN 1
            WHEN Practice_Code LIKE '%590%' THEN 1
            WHEN Practice_Code LIKE '%601%' THEN 1
            WHEN Practice_Code LIKE '%602%' THEN 1
            WHEN Practice_Code LIKE '%603%' THEN 1
            WHEN Practice_Code LIKE '%612%' THEN 1
            WHEN Practice_Code LIKE '%650%' THEN 1
            ELSE 2 END           = 1
 INNER JOIN [NPAD].[dbo].[land_unit_land_use] llu
    ON llu.[land_unit_id]        = lu.[land_unit_id] -- was outer join, might need to change to outer
 INNER JOIN [NPAD].[dbo].[d_land_use] AS luu
    ON luu.[land_use_id]         = llu.[land_use_id] -- was outer join, might need to change to outer
 INNER JOIN #comet_values_avg AS cv
    ON cv.practice_id            = ps.[practice_id]
   AND cv.state_county_code      = sc.[state_county_code]
  -- AND sc.[state_county_code]    = 29211

CREATE INDEX npad_values_avg_idx1c3
ON #npad_agg_lite
(   land_unit_id, practice_id, scheduled_practice_id, state_county_code, state_code, county_code, certified)

/*
GO
CREATE SPATIAL INDEX [SI_practice_shape_geometry_indx]
    ON [#npad_agg_lite])
    USING GEOMETRY_GRID
    WITH  (
            BOUNDING_BOX = (XMAX = 180, XMIN = -180, YMAX = 90, YMIN = -90),
            GRIDS = (LEVEL_1 = MEDIUM, LEVEL_2 = MEDIUM, LEVEL_3 = MEDIUM, LEVEL_4 = MEDIUM)
          );
*/

CREATE TABLE #npad_comet_county_sum3
(comet_final_id INT IDENTITY(1, 1),
state_county_code INT, 
state_code INT, 
county_code INT , 
state_abbr VARCHAR (20), 
county_name VARCHAR (240), 
county_display  VARCHAR (240), 
state_name VARCHAR (240) , 
county_sort_display   VARCHAR (240), 
sum_acres_c FLOAT, 
sum_co2_mean_c FLOAT, 
sum_n2o_mean_c FLOAT, 
sum_ch4_mean_c FLOAT , 
sum_soil_carbon_co2_c FLOAT, 
sum_biomass_co2_c FLOAT , 
sum_fossil_co2_c FLOAT, 
sum_biomassburning_co2_c FLOAT, 
sum_liming_co2_c FLOAT, 
sum_drainedorganicsoils_co2_c FLOAT, 
sum_direct_soil_n2o_c FLOAT, 
sum_indirect_soil_n2o_c FLOAT, 
sum_wetlandricecultivation_n2o_c  FLOAT,  
sum_asbiomassburning_n2o_c  FLOAT, 
sum_drainedorganicsoils_n2o_c  FLOAT, 
sum_soil_ch4_c  FLOAT, 
sum_wetlandricecultivation_ch4_c FLOAT,  
sum_biomassburning_ch4_c  FLOAT, 
sum_total_ghg_co2_c  FLOAT,  
sum_total_ghg_co2_min_c  FLOAT,  
sum_total_ghg_co2_max_c FLOAT,
Practice_Code  VARCHAR (240),
Program_Code  VARCHAR (240)
   CONSTRAINT pk_comet_county_sum3_indx3
        PRIMARY KEY CLUSTERED (comet_final_id))
go

INSERT INTO #npad_comet_county_sum3
(
state_county_code ,
state_code,
county_code , 
state_abbr , 
county_name , 
county_display , 
state_name , 
county_sort_display , 
sum_acres_c, 
sum_co2_mean_c , 
sum_n2o_mean_c , 
sum_ch4_mean_c , 
sum_soil_carbon_co2_c , 
sum_biomass_co2_c , 
sum_fossil_co2_c , 
sum_biomassburning_co2_c , 
sum_liming_co2_c , 
sum_drainedorganicsoils_co2_c , 
sum_direct_soil_n2o_c , 
sum_indirect_soil_n2o_c , 
sum_wetlandricecultivation_n2o_c , 
sum_asbiomassburning_n2o_c , 
sum_drainedorganicsoils_n2o_c , 
sum_soil_ch4_c , 
sum_wetlandricecultivation_ch4_c , 
sum_biomassburning_ch4_c , 
sum_total_ghg_co2_c , 
sum_total_ghg_co2_min_c , 
sum_total_ghg_co2_max_c,
Practice_Code,
Program_Code
)

SELECT DISTINCT [state_county_code],
       [state_code] ,
	   [county_code],
       [state_abbr],
       [county_name],
       [county_display],
       [state_name],
       [county_sort_display],
	   SUM(Applied_Amount) over (partition by state_county_code, Program_Code, Practice_Code) as sum_acres_c, 
       SUM(avg_co2_mean_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_co2_mean_c,
       SUM(avg_n2o_mean_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_n2o_mean_c,
       SUM(avg_ch4_mean_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_ch4_mean_c,
       SUM(avg_soil_carbon_co2_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_soil_carbon_co2_c,
       SUM(avg_biomass_co2_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_biomass_co2_c,
       SUM(avg_fossil_co2_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_fossil_co2_c,
       SUM(avg_biomassburning_co2_c) over (partition by state_county_code, Program_Code, Practice_Code) as sum_biomassburning_co2_c,
       SUM(avg_liming_co2_c) over (partition by state_county_code,Program_Code, Practice_Code) as sum_liming_co2_c,
       SUM(avg_drainedorganicsoils_co2_c) over (partition by state_county_code,Program_Code, Practice_Code) as sum_drainedorganicsoils_co2_c,
       SUM(avg_direct_soil_n2o_c) over (partition by state_county_code,Program_Code, Practice_Code) AS sum_direct_soil_n2o_c,
       SUM(avg_indirect_soil_n2o_c) over (partition by state_county_code, Program_Code, Practice_Code) AS sum_indirect_soil_n2o_c,
       SUM(avg_wetlandricecultivation_n2o_c) over (partition by state_county_code, Program_Code, Practice_Code) AS  sum_wetlandricecultivation_n2o_c,
       SUM(avg_asbiomassburning_n2o_c) over (partition by state_county_code, Program_Code, Practice_Code) AS sum_asbiomassburning_n2o_c,
       SUM(avg_drainedorganicsoils_n2o_c) over (partition by state_county_code, Program_Code, Practice_Code) AS  sum_drainedorganicsoils_n2o_c,
       SUM(avg_soil_ch4_c) over (partition by state_county_code, Program_Code, Practice_Code) AS sum_soil_ch4_c,
       SUM(avg_wetlandricecultivation_ch4_c) over (partition by state_county_code, Program_Code, Practice_Code) AS  sum_wetlandricecultivation_ch4_c,
       SUM(avg_biomassburning_ch4_c) over (partition by state_county_code, Program_Code, Practice_Code) AS sum_biomassburning_ch4_c,
       SUM(avg_total_ghg_co2_c) over (partition by state_county_code, Program_Code, Practice_Code) sum_total_ghg_co2_c,
       SUM(avg_total_ghg_co2_min_c) over (partition by state_county_code, Program_Code, Practice_Code) sum_total_ghg_co2_min_c,
       SUM(avg_total_ghg_co2_max_c) over (partition by state_county_code, Program_Code, Practice_Code) sum_total_ghg_co2_max_c,
	   Practice_Code,
	   Program_Code
  FROM #npad_agg_lite

  CREATE INDEX comet_county_sum3_idx1c2
ON #npad_comet_county_sum3
(  state_county_code, state_code, county_code)

SELECT 
Program_Code, 
Practice_Code,
state_county_code , 
county_code , 
state_abbr , 
county_name , 
county_display , 
state_name , 
county_sort_display , 
sum_acres_c, 
sum_co2_mean_c , 
sum_n2o_mean_c , 
sum_ch4_mean_c , 
sum_soil_carbon_co2_c , 
sum_biomass_co2_c , 
sum_fossil_co2_c , 
sum_biomassburning_co2_c , 
sum_liming_co2_c , 
sum_drainedorganicsoils_co2_c , 
sum_direct_soil_n2o_c , 
sum_indirect_soil_n2o_c , 
sum_wetlandricecultivation_n2o_c , 
sum_asbiomassburning_n2o_c , 
sum_drainedorganicsoils_n2o_c , 
sum_soil_ch4_c , 
sum_wetlandricecultivation_ch4_c , 
sum_biomassburning_ch4_c , 
sum_total_ghg_co2_c , 
sum_total_ghg_co2_min_c , 
sum_total_ghg_co2_max_c
FROM #npad_comet_county_sum3
ORDER BY state_county_code  ASC
