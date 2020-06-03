 DROP TABLE IF EXISTS #metric
 
 
 CREATE TABLE #metric (
 [id] INT,[query_id] INT ,[query_name] VARCHAR (50) ,[query_frequency] VARCHAR (10) ,[query_month] TINYINT ,[month_abrv] VARCHAR (10) ,month_name VARCHAR (20)  ,[query_year] INT ,[state] VARCHAR (20) ,[seqnum] INT ,[query_title] VARCHAR (20) ,[query_header] VARCHAR (300) ,[count] 	INT
   )

INSERT INTO  #metric ([id] ,[query_id] ,[query_name],[query_frequency] ,[query_month] ,[month_abrv]	,month_name ,[query_year],[state]  ,[seqnum] ,[query_title] ,[query_header] ,[count]
	  )



SELECT  [id]
      ,[query_id]
      ,[query_name]
      ,[query_frequency]
      ,[query_month]
	  ,CASE
          WHEN [query_month] = 1 THEN 'Jan'
          WHEN [query_month] = 2 THEN 'Feb'
          WHEN [query_month] = 3 THEN 'Mar'
          WHEN [query_month] = 4 THEN 'Apr'
          WHEN [query_month] = 5 THEN 'May'
          WHEN [query_month] = 6 THEN 'Jun'
          WHEN [query_month] = 7 THEN 'Jul'
          WHEN [query_month] = 8 THEN 'Aug'
          WHEN [query_month] = 9 THEN 'Sep'
          WHEN [query_month] = 10 THEN 'Oct'
          WHEN [query_month] = 11 THEN 'Nov'
          WHEN [query_month] = 12 THEN 'Dec'
          ELSE 'OTHER'
       END AS [month_abrv]
	   ,DATENAME (MONTH, DATEADD(MONTH, MONTH(query_month) - 1, '1900-01-01')) AS month_name
      ,[query_year]
      ,[state]
      ,[seqnum]
      ,[query_title]
      ,[query_header]
      ,[count] 
	  FROM wss_metric_query_results
where 
state = 'WI' AND query_name = 'wss_top100ratings' AND count >=700  AND query_month = 1
 
 ORDER BY query_name, query_frequency,  query_year, query_month, [state] 

  SELECT * FROM 
 (
 SELECT query_name, [query_header],  query_year,  [state], [count]
 FROM #metric
 WHERE query_name = 'wss_top100ratings'
 ) #r
 PIVOT (
 SUM (count) 
   FOR [query_header] IN (
--[AASHTO Group Classification (Surface)],
--[Agricultural Organic Soil Subsidence],
--[Available Water Capacity],
--[Available Water Supply, 0 to 25 cm],
--[Bulk Density, One-Third Bar],
--[Calcium Carbonate (CaCO3)],
--[Camp Areas],
--[Cation-Exchange Capacity (CEC-7)],
[Commodity Crop Productivity Index (Corn) (WI)],
--[Corrosion of Concrete],
--[Corrosion of Steel],
[Depth to Any Soil Restrictive Layer],
[Depth to Water Table],
[Drainage Class],
--[Dwellings With Basements],
--[Dwellings Without Basements],
--[Erosion Hazard (Off-Road, Off-Trail)],
[Farmland Classification],
[Flooding Frequency Class],
--[Gravel Source],
--[Harvest Equipment Operability],
[Hydric Rating by Map Unit],
[Hydrologic Soil Group],
[K Factor, Whole Soil],
--[Land Application of Municipal Sewage Sludge],
--[Lawns, Landscaping, and Golf Fairways],
--[Local Roads and Streets],
--[Manure and Food-Processing Waste],
--[Map Unit Name],
--[National Commodity Crop Productivity Index v2],
--[National Commodity Crop Productivity Index],
[Nonirrigated Capability Class],
--[Organic Matter Depletion],
[Organic Matter],
--[Parent Material Name],
--[Paths and Trails],
[Percent Clay],
[Percent Sand],
--[Percent Silt],
[pH (1 to 1 Water)],
--[Playgrounds],
--[Ponding Frequency Class],
--[Roadfill Source],
--[Sand Source],
--[Saturated Hydraulic Conductivity (Ksat)],
[Septic Tank Absorption Fields],
--[Shallow Excavations],
--[Small Commercial Buildings],
--[Soil Health - Organic Matter],
--[Soil Suitability - Karner Blue Butterfly (WI)],
[Soil Taxonomy Classification],
--[Surface Texture],
[T Factor]--,
--[Unified Soil Classification (Surface)],
--[Water Content, 15 Bar],
--[Water Content, One-Third Bar],
--[Yields of Non-Irrigated Crops (Component): Alfalfa hay (Tons)],
--[Yields of Non-Irrigated Crops (Component): Corn (Bu)]--,
--[Yields of Non-Irrigated Crops (Component): Soybeans (Bu)],
--[Yields of Non-Irrigated Crops (Map Unit): Alfalfa hay (Tons)],
--[Yields of Non-Irrigated Crops (Map Unit): Corn (Bu)],
--[Water Features]
) 
) AS #rest_pivot_table;