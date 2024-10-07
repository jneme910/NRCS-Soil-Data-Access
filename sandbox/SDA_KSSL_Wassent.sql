SELECT 
 
	l.[labsampnum]
      ,lce.[result_source_key]
 
 
         ,cnn.[pedon_key]
      ,cnn.[site_key]
      ,p.[pedlabsampnum]
      ,[project_key]
 
 
      ,[layer_field_label_1]
      ,[hzn_top]
      ,[hzn_bot]
      
      ,[hzn_desgn]
 
      ,[pedoniid]
      ,[upedonid]
  
      ,CASE WHEN [corr_name] IS NULL THEN [samp_name] ELSE [corr_name] END AS soil_name
      ,CASE WHEN [corr_class_type] IS NULL THEN [samp_class_type] ELSE [corr_class_type] END AS class_type
  
      ,CASE WHEN [corr_classification_name] IS NULL THEN [samp_classification_name] ELSE [corr_classification_name]  END AS [classification_name] 
 
      ,[siteiid]
      ,[usiteid]
      ,[site_obsdate]
      ,[latitude_decimal_degrees]
      ,[longitude_decimal_degrees]
      ,country_code
         ,country_name
       , state_code
       , state_name
         , county_code
       , county_name
       , mlra_code
       , mlra_name
       , ssa_code
       , ssa_name
        ,[note]
      ,[pedobjupdate]
 
      ,[total_carbon_ncs_method]
      ,[caco3_lt_2_mm]
      ,[caco3_lt_2_mm_method]
      ,[estimated_organic_carbon]
  , [bulk_density_3rd_bar_for_calc]
  ,[bulk_density_3rd_bar_source]
       ,[texture_lab]
      ,[particle_size_method]
      ,[clay_total]
      ,[silt_total]
      ,[sand_total]
      ,[clay_fine]
      ,[clay_caco3]
      ,[silt_fine]
      ,[silt_coarse]
      ,[sand_very_fine]
      ,[sand_fine]
      ,[sand_medium]
      ,[sand_coarse]
    ,[total_carbon_ncs]
      ,[total_carbon_ncs_method]
     ,[caco3_lt_2_mm]
      ,[caco3_lt_2_mm_method]
     ,[estimated_organic_carbon]

	,CASE WHEN estimated_organic_carbon IS NOT NULL THEN estimated_organic_carbon
	        WHEN estimated_organic_carbon IS NULL AND caco3_lt_2_mm IS NOT NULL THEN (total_carbon_ncs - (caco3_lt_2_mm * 0.12))
			WHEN estimated_organic_carbon IS NULL AND caco3_lt_2_mm IS NULL AND total_carbon_ncs IS NOT NULL THEN total_carbon_ncs
		    WHEN organic_carbon_walkley_black IS NOT NULL THEN 0.25 + organic_carbon_walkley_black  * 0.86
	   END AS Combined_Est_Org_Carbon   
	   
, (SELECT TOP 1 [texture_lab]
FROM [sdmONLINE].[dbo].[lab_physical_properties] AS lpp2 WHERE lpp2.labsampnum=l.labsampnum AND [texture_lab] IS NOT NULL) AS [lab_texture]
        ,[organic_carbon_walkley_black]
      ,[oc_walkley_black_method]
 
      ,[caco3_lt_2_mm]
      ,[caco3_lt_2_mm_method]
      ,[corrected_gypsum_lt_2_mm]
       ,[caco3_lt_20_mm]
      ,[gypsum_lt_20_mm]
      ,[ca_to_mg_ratio]
FROM [lab_combine_nasis_ncss] AS cnn
INNER JOIN [lab_pedon] AS p ON p.pedon_key=cnn.pedon_key AND CASE WHEN [corr_classification_name] LIKE '%wassent%' THEN 1 
WHEN  [samp_classification_name] LIKE '%wassent%' THEN 1 ELSE 2 END = 1
 
 
INNER JOIN [lab_layer] AS l ON l.pedon_key=p.pedon_key 
 
INNER JOIN [lab_chemical_properties] AS lcp ON lcp.labsampnum=l.labsampnum 
INNER JOIN [lab_physical_properties] AS lpp  ON lpp.labsampnum=l.labsampnum 
INNER JOIN [lab_calculations_including_estimates_and_default_values] AS lce ON lce.labsampnum=l.labsampnum 
INNER JOIN (SELECT [area_code] AS country_code,[area_name] AS country_name, area_key FROM lab_area -- Country
) AS c ON cnn.[country_key]=c.area_key
INNER JOIN  (SELECT [area_code] AS state_code,[area_name] AS state_name, area_key FROM lab_area --State
) AS s ON cnn.[state_key]=s.area_key 
 
INNER JOIN (SELECT [area_code] AS county_code,[area_name] AS county_name, area_key FROM lab_area --County
) AS ct ON cnn.[county_key]=ct.area_key
 
INNER JOIN (SELECT [area_code] AS mlra_code,[area_name] AS mlra_name, area_key FROM lab_area --MLRA
) AS m ON cnn.[mlra_key]=m.area_key
INNER JOIN (SELECT [area_code] AS ssa_code,[area_name] AS ssa_name, area_key FROM lab_area --SSA
) AS ss ON cnn.[ssa_key]=ss.area_key
