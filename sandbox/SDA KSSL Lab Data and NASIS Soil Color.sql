SELECT TOP 1000

 l,[labsampnum]
      ,lpp,[result_source_key]
      ,lpp,[prep_code]

	  ,cnn,[pedon_key]
      ,cnn,[site_key]
      ,p,[pedlabsampnum]
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
     ,CASE WHEN [estimated_organic_carbon] IS NOT NULL THEN LEFT (ROUND ([estimated_organic_carbon]* 1,724, 2),4)
       WHEN [estimated_organic_carbon] IS NULL AND [caco3_lt_2_mm] IS NOT NULL THEN LEFT (ROUND (([total_carbon_ncs]- ([caco3_lt_2_mm]*0,12))* 1,724, 2),4)
       WHEN [estimated_organic_carbon] IS NULL AND [caco3_lt_2_mm] IS NULL THEN LEFT (ROUND ([total_carbon_ncs]* 1,724,2),4) END AS [estimated_organic_matter]
, (SELECT TOP 1 [texture_lab]
FROM [sdmONLINE],[dbo],[lab_physical_properties] AS lpp2 WHERE lpp2,labsampnum=l,labsampnum AND [texture_lab] IS NOT NULL) AS [lab_texture]
        ,[organic_carbon_walkley_black]
      ,[oc_walkley_black_method]
 
      ,[caco3_lt_2_mm]
      ,[caco3_lt_2_mm_method]
      ,[corrected_gypsum_lt_2_mm]
       ,[caco3_lt_20_mm]
      ,[gypsum_lt_20_mm]
      ,[ca_to_mg_ratio]
--	  ,  dry_colorpct 
        
  --    , dry_colorhue
 ,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis],[dbo],phcolor AS phc2, [nasis],[dbo],MetadataDomainMaster dm, [nasis],[dbo],MetadataDomainDetail dd where phc2,phiidref= phorizon,phiid AND colorhue  = ChoiceValue and DomainName = 'color_hue' and 
 colormoistst = 1 AND
dm,DomainID = dd,DomainID order by colorpct desc) AS varchar) AS dry_colorhue
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis],[dbo],phcolor AS phc2, [nasis],[dbo],MetadataDomainMaster dm, [nasis],[dbo],MetadataDomainDetail dd where phc2,phiidref= phorizon,phiid AND colorhue  = ChoiceValue and DomainName = 'color_value' and 
 colormoistst = 1 AND
dm,DomainID = dd,DomainID order by colorpct desc) AS varchar) AS dry_colorvalue
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis],[dbo],phcolor AS phc2, [nasis],[dbo],MetadataDomainMaster dm, [nasis],[dbo],MetadataDomainDetail dd where phc2,phiidref= phorizon,phiid AND colorhue  = ChoiceValue and DomainName = 'color_chroma' and 
 colormoistst = 1 AND
dm,DomainID = dd,DomainID order by colorpct desc) AS varchar) AS dry_colorchroma

 ,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis],[dbo],phcolor AS phc2, [nasis],[dbo],MetadataDomainMaster dm, [nasis],[dbo],MetadataDomainDetail dd where phc2,phiidref= phorizon,phiid AND colorhue  = ChoiceValue and DomainName = 'color_hue' and 
 colormoistst = 2 AND
dm,DomainID = dd,DomainID order by colorpct desc) AS varchar) AS moist_colorhue
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis],[dbo],phcolor AS phc2, [nasis],[dbo],MetadataDomainMaster dm, [nasis],[dbo],MetadataDomainDetail dd where phc2,phiidref= phorizon,phiid AND colorhue  = ChoiceValue and DomainName = 'color_value' and 
 colormoistst = 2 AND
dm,DomainID = dd,DomainID order by colorpct desc) AS varchar) AS moist_colorvalue
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis],[dbo],phcolor AS phc2, [nasis],[dbo],MetadataDomainMaster dm, [nasis],[dbo],MetadataDomainDetail dd where phc2,phiidref= phorizon,phiid AND colorhue  = ChoiceValue and DomainName = 'color_chroma' and 
 colormoistst = 2 AND
dm,DomainID = dd,DomainID order by colorpct desc) AS varchar) AS moist_colorchroma

  /*    , dry_colorvalue
      , dry_colorchroma
      , dry_colorphysst
      , dry_colormoistst
	  ,dry_phiidref
	  ,moist_colorpct 
      , moist_colorhue
      , moist_colorvalue
      , moist_colorchroma
      ,moist_colorphysst
      , moist_colormoistst

	  */
FROM [sdmONLINE],[dbo],[lab_combine_nasis_ncss] AS cnn
INNER JOIN [sdmONLINE],[dbo],[lab_pedon] AS p ON p,pedon_key=cnn,pedon_key --AND [upedonid] LIKE '%WI%'
INNER JOIN [sdmONLINE],[dbo],[lab_layer] AS l ON l,pedon_key=p,pedon_key 
INNER JOIN [sdmONLINE],[dbo],[lab_chemical_properties] AS lcp ON lcp,labsampnum=l,labsampnum 
INNER JOIN [sdmONLINE],[dbo],[lab_physical_properties] AS lpp  ON lpp,labsampnum=l,labsampnum 
INNER JOIN  [nasis],[dbo],[phsample] AS phs  ON  phs,labsampnum COLLATE SQL_Latin1_General_CP1_CI_AS = l,labsampnum COLLATE SQL_Latin1_General_CP1_CI_AS
INNER JOIN (SELECT [area_code] AS country_code,[area_name] AS country_name, area_key FROM [sdmONLINE],[dbo],lab_area -- Country
) AS c ON cnn,[country_key]=c,area_key
INNER JOIN  (SELECT [area_code] AS state_code,[area_name] AS state_name, area_key FROM [sdmONLINE],[dbo],lab_area --State
WHERE [area_code] = 'NE') AS s ON cnn,[state_key]=s,area_key 
 
INNER JOIN (SELECT [area_code] AS county_code,[area_name] AS county_name, area_key FROM [sdmONLINE],[dbo],lab_area --County
) AS ct ON cnn,[county_key]=ct,area_key
 
INNER JOIN (SELECT [area_code] AS mlra_code,[area_name] AS mlra_name, area_key FROM [sdmONLINE],[dbo],lab_area --MLRA
) AS m ON cnn,[mlra_key]=m,area_key
INNER JOIN (SELECT [area_code] AS ssa_code,[area_name] AS ssa_name, area_key FROM [sdmONLINE],[dbo],lab_area --SSA
) AS ss ON cnn,[ssa_key]=ss,area_key

INNER JOIN  [nasis],[dbo],phorizon ON phorizon,phiid=phs,phiidref 
/*LEFT OUTER JOIN (SELECT   [colorpct] AS dry_colorpct 
, [colorhue] AS moist_colorhue

      ,[colorvalue] AS dry_colorvalue
      ,[colorchroma] AS dry_colorchroma
      ,[colorphysst] AS dry_colorphysst
      ,[colormoistst] AS dry_colormoistst
	  ,phiidref AS dry_phiidref
FROM	[nasis],[dbo],phcolor WHERE [colormoistst]= 1) AS phcd ON phcd,dry_phiidref= phorizon,phiid

--LEFT OUTER JOIN (SELECT    [colorpct] AS moist_colorpct 
, [colorhue] AS moist_colorhue
      ,[colorvalue] AS moist_colorvalue
      ,[colorchroma] AS moist_colorchroma
      ,[colorphysst] AS moist_colorphysst
      ,[colormoistst] AS moist_colormoistst
	  ,phiidref AS moist_phiidref

	  
FROM	[nasis],[dbo],phcolor WHERE [colormoistst]= 2) AS phcm ON phcm,moist_phiidref= phorizon,phiid
*/
-- INNER JOIN [nasis],[dbo],[phorizon] ON 

-- ORDER BY l,[labsampnum] ASC,[hzn_top]ASC ,[hzn_bot]


