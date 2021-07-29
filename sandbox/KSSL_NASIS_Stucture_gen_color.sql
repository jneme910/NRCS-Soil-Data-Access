	DROP TABLE IF EXISTS #temp_pedon;
	DROP TABLE IF EXISTS #structure;
DROP TABLE IF EXISTS #structure1;
DROP TABLE IF EXISTS #structure2;
DROP TABLE IF EXISTS #structure3;
DROP TABLE IF EXISTS #structure_single;
DROP TABLE IF EXISTS #structure_single2;


	SELECT 
	  l.[labsampnum]
      ,lpp.[result_source_key]
      ,lpp.[prep_code]
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
	  ,phiid
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
        ,[estimated_organic_carbon]
     ,CASE WHEN [estimated_organic_carbon] IS NOT NULL THEN LEFT (ROUND ([estimated_organic_carbon]* 1.724, 2),4)
       WHEN [estimated_organic_carbon] IS NULL AND [caco3_lt_2_mm] IS NOT NULL THEN LEFT (ROUND (([total_carbon_ncs]- ([caco3_lt_2_mm]*0.12))* 1.724, 2),4)
       WHEN [estimated_organic_carbon] IS NULL AND [caco3_lt_2_mm] IS NULL THEN LEFT (ROUND ([total_carbon_ncs]* 1.724,2),4) END AS [estimated_organic_matter]
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
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phc2.phiidref= phorizon.phiid AND colorhue  = ChoiceValue and DomainName = 'color_hue' and 
 colormoistst = 1 AND
dm.DomainID = dd.DomainID ORDER BY choicesequence DESC) AS varchar) AS dry_colorhue

,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phc2.phiidref= phorizon.phiid AND colorvalue  = ChoiceValue and DomainName = 'color_value' and 
 colormoistst = 1 AND
dm.DomainID = dd.DomainID order by colorpct desc) AS varchar) AS dry_colorvalue





,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phc2.phiidref= phorizon.phiid AND colorchroma  = ChoiceValue and DomainName = 'color_chroma' and 
 colormoistst = 1 AND
dm.DomainID = dd.DomainID order by colorpct desc) AS varchar) AS dry_colorchroma


,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phc2.phiidref= phorizon.phiid AND colorhue  = ChoiceValue and DomainName = 'color_hue' and 
 colormoistst = 2 AND
dm.DomainID = dd.DomainID order by colorpct desc) AS varchar) AS moist_colorhue
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phc2.phiidref= phorizon.phiid AND colorvalue  = ChoiceValue and DomainName = 'color_value' and 
 colormoistst = 2 AND
dm.DomainID = dd.DomainID order by colorpct desc) AS varchar) AS moist_colorvalue
,CAST ((select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phc2.phiidref= phorizon.phiid AND colorchroma  = ChoiceValue and DomainName = 'color_chroma' and 
 colormoistst = 2 AND
dm.DomainID = dd.DomainID order by colorpct desc) AS varchar) AS moist_colorchroma

INTO #temp_pedon
FROM [sdmONLINE].[dbo].[lab_pedon] AS p
LEFT OUTER JOIN [sdmONLINE].[dbo].[lab_combine_nasis_ncss] AS cnn  ON p.pedon_key=cnn.pedon_key  
INNER JOIN [sdmONLINE].[dbo].[lab_layer] AS l ON l.pedon_key=p.pedon_key AND l.labsampnum /*IN ('10N03253',
'10N03254',
'10N03255',
'10N03256',
'10N05910',	 
'10N05911',	 
'10N05912',	 
'10N05913',	 
'10N05938',
'10N05938',
'10N05961',
'10N05962',
'10N05963',
'10N05964')
*/



 IN ('10N00245',
'10N00246',
'10N00247',
'10N00248',
'10N00249',
'10N00250',
'10N00251',
'10N00252',
'10N00253',
'10N00254',
'10N00255',
'10N00256',
'10N00257',
'10N00258',
'10N00259',
'10N00260',
'10N00261',
'10N00262',
'10N00263',
'10N00264',
'10N00265',
'10N00266',
'10N00267',
'10N00268',
'10N00269',
'10N00270',
'10N00271',
'10N00272',
'10N00273',
'10N00274',
'10N00275',
'10N00276',
'10N00277',
'10N00278',
'10N00279',
'10N00280',
'10N00281',
'10N00282',
'10N00283',
'10N00284',
'10N00285',
'10N00286',
'10N00287',
'10N00288',
'10N00289',
'10N00290',
'10N00291',
'10N00292',
'10N00293',
'10N00294',
'10N00295',
'10N00296',
'10N00297',
'10N00298',
'10N00299',
'10N00300',
'10N00301',
'10N00302',
'10N00303',
'10N00304',
'10N00305',
'10N00306',
'10N05845',
'10N05846',
'10N05847',
'10N05848',
'10N05849',
'10N05850',
'10N05851',
'10N05852',
'10N05853',
'10N05854',
'10N05855',
'10N05856',
'10N05857',
'10N05858',
'10N05859',
'10N05860',
'10N05861',
'10N05862',
'10N05863',
'10N05864',
'10N05865',
'10N05866',
'10N05867',
'10N05868',
'10N05869',
'10N05870',
'10N05871',
'10N05872',
'10N05873',
'10N05874',
'10N05875',
'10N05876',
'10N05877',
'10N05878',
'10N05879',
'10N05880',
'10N05881',
'10N05882',
'10N05883',
'10N05884',
'10N05885',
'10N05886',
'10N05887',
'10N05888',
'10N05889',
'10N05890',
'10N05891',
'10N05892',
'10N05893',
'10N05894',
'10N05895',
'10N05896',
'10N05897',
'10N05898',
'10N05899',
'10N05900',
'10N05901',
'10N05902',
'10N05903',
'10N05904',
'10N05905',
'10N05906',
'10N05907',
'10N05908',
'10N05909',
'10N05910',
'10N05911',
'10N05912',
'10N05913',
'10N05914',
'10N05915',
'10N05916',
'10N05917',
'10N05918',
'10N05919',
'10N05920',
'10N05921',
'10N05922',
'10N05923',
'10N05924',
'10N05925',
'10N05926',
'10N05927',
'10N05928',
'10N05929',
'10N05930',
'10N05931',
'10N05932',
'10N05933',
'10N05934',
'10N05935',
'10N05936',
'10N05937',
'10N05938',
'10N05939',
'10N05940',
'10N05957',
'10N05958',
'10N05959',
'10N05960',
'10N05961',
'10N05962',
'10N05963',
'10N05964',
'10N05965',
'10N05966',
'10N05967',
'10N05968',
'10N05969',
'10N05970',
'10N05971',
'10N05972',
'10N05973',
'10N05974',
'10N05975',
'10N05941',
'10N05942',
'10N05943',
'10N05944',
'10N05945',
'10N05946',
'10N05947',
'10N05948',
'10N05949',
'10N05950',
'10N05951',
'10N05952',
'10N05953',
'10N05954',
'10N05955',
'10N05956',
'10N03253',
'10N03254',
'10N03255',
'10N03256',
'10N03257',
'10N03258',
'10N03259',
'10N03260',
'10N03261',
'10N03262',
'10N03263',
'10N03264',
'10N03265',
'10N03266',
'10N03267',
'10N03268',
'10N03269',
'10N03270',
'10N03271',
'10N03272',
'10N03213',
'10N03214',
'10N03215',
'10N03216',
'10N03217',
'10N03218',
'10N03219',
'10N03220',
'10N03221',
'10N03222',
'10N03223',
'10N03224',
'10N03225',
'10N03226',
'10N03227',
'10N03228',
'10N03229',
'10N03230',
'10N03231',
'10N03232',
'10N03233',
'10N03234',
'10N03235',
'10N03236',
'10N03237',
'10N03238',
'10N03239',
'10N03240',
'10N03241',
'10N03242',
'10N03243',
'10N03244',
'10N03245',
'10N03246',
'10N03247',
'10N03248',
'10N03249',
'10N03250',
'10N03251',
'10N03252',
'11N00796',
'11N00797',
'11N00798',
'11N00799',
'11N00800',
'11N00801',
'11N00802',
'11N00803',
'11N00804',
'11N00805',
'11N00806',
'11N00807',
'11N00808',
'11N00809',
'11N00810',
'11N00811',
'11N00812',
'11N00813',
'11N00814',
'11N00815',
'11N00816',
'11N00817',
'11N00818',
'11N00819',
'11N00820',
'11N00821',
'11N00822',
'11N00823',
'11N00824',
'11N00825',
'11N00826',
'11N00827',
'11N00828',
'11N00829',
'11N00830',
'11N00831',
'11N00832',
'11N00833',
'11N00834',
'11N00835') 

INNER JOIN [sdmONLINE].[dbo].[lab_chemical_properties] AS lcp ON lcp.labsampnum=l.labsampnum 
INNER JOIN [sdmONLINE].[dbo].[lab_physical_properties] AS lpp  ON lpp.labsampnum=l.labsampnum 
INNER JOIN  [nasis].[dbo].[phsample] AS phs  ON  phs.labsampnum COLLATE SQL_Latin1_General_CP1_CI_AS = l.labsampnum COLLATE SQL_Latin1_General_CP1_CI_AS

LEFT OUTER JOIN (SELECT [area_code] AS country_code,[area_name] AS country_name, area_key FROM [sdmONLINE].[dbo].lab_area -- Country
) AS c ON cnn.[country_key]=c.area_key
LEFT OUTER JOIN (SELECT [area_code] AS state_code,[area_name] AS state_name, area_key FROM [sdmONLINE].[dbo].lab_area --State
) AS s ON cnn.[state_key]=s.area_key 
 
LEFT OUTER JOIN (SELECT [area_code] AS county_code,[area_name] AS county_name, area_key FROM [sdmONLINE].[dbo].lab_area --County
) AS ct ON cnn.[county_key]=ct.area_key
LEFT OUTER JOIN(SELECT [area_code] AS mlra_code,[area_name] AS mlra_name, area_key FROM [sdmONLINE].[dbo].lab_area --MLRA

) AS m ON cnn.[mlra_key]=m.area_key
LEFT OUTER JOIN (SELECT [area_code] AS ssa_code,[area_name] AS ssa_name, area_key FROM [sdmONLINE].[dbo].lab_area --SSA
) AS ss ON cnn.[ssa_key]=ss.area_key
 
INNER JOIN  [nasis].[dbo].phorizon ON phorizon.phiid=phs.phiidref




CREATE TABLE #structure
   (phiidref INT,
   phstructureiid INT, 
   d_struct_grade VARCHAR (50), 
   d_struct_size VARCHAR (50), 
   d_struct_type VARCHAR (50), 
   structid INT,  
   structpartsto INT,  
   next_structid INT,  
   before_structpartsto INT,
   agg_structure INT);
   
   
INSERT INTO #structure (phiidref, phstructureiid, d_struct_grade, d_struct_size, d_struct_type, structid,  structpartsto, next_structid, before_structpartsto, agg_structure)
SELECT  TOP 1000  [phiidref], phstructureiid,
(select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phstructure AS phs2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phs.phstructureiid= phs2.phstructureiid AND structgrade  = ChoiceValue and DomainName = 'structure_grade'  AND dm.DomainID = dd.DomainID ORDER BY phstructureiid )  AS d_struct_grade,
(select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phstructure AS phs2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phs.phstructureiid= phs2.phstructureiid AND structsize  = ChoiceValue and DomainName = 'structure_size'  AND dm.DomainID = dd.DomainID ORDER BY phstructureiid )  AS d_struct_size,
(select top 1  CAST ([ChoiceName] AS varchar ) from [nasis].[dbo].phstructure AS phs2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd where phs.phstructureiid= phs2.phstructureiid AND structtype = ChoiceValue and DomainName = 'structure_type'  AND dm.DomainID = dd.DomainID ORDER BY phstructureiid )  AS d_struct_type
  ,[structid]
  ,[structpartsto]
  , lead(structid) over (partition by phiidref order by phiidref ) as next_structid
  , lag([structpartsto]) over (partition by phiidref order by phiidref ) as before_structpartsto
,CASE WHEN lead(structid) over (partition by phiidref order by phiidref ) = [structpartsto] THEN [structpartsto]  ELSE [structid] END AS agg_structure
      

FROM [nasis].[dbo].phorizon  AS ph WITH (NOLOCK)
INNER JOIN [nasis].[dbo].phstructure AS phs WITH (NOLOCK) ON phs.phiidref=ph.phiid  AND CASE WHEN structgrade IS NULL AND structsize IS NULL AND structtype IS NULL THEN 1 ELSE 2 END = 2
INNER JOIN #temp_pedon ON phs.phiidref=#temp_pedon.phiid

ORDER BY phiidref, [structid] ASC, [structpartsto];


--Examples 
 --strong fine prismatic parts to moderate fine subangular blocky, and strong medium prismatic parts to moderate medium subangular blocky structure
 --weak medium angular blocky, and weak fine angular blocky, and weak medium subangular blocky, and weak fine subangular blocky structure; 
CREATE TABLE #structure1
   (phiidref INT,
	agg_structure INT,
	structure_desc_one  VARCHAR (254),
	row_num INT
	)
   
   
INSERT INTO #structure1 (phiidref, agg_structure,structure_desc_one ,row_num )
SELECT phiidref, -- phstructureiid, d_struct_grade, d_struct_size, d_struct_type, structid,  structpartsto, next_structid, before_structpartsto, 
agg_structure, 
(SELECT DISTINCT SUBSTRING(  (  SELECT ( CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN ' parts to' ELSE  ' parts to ' END  + CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN  d_struct_type  ELSE CONCAT (d_struct_grade, ' ',  d_struct_size, ' ' , d_struct_type ) END)  
FROM #structure AS s
WHERE s.phiidref=#structure.phiidref AND s.agg_structure=#structure.agg_structure  
ORDER BY structid ASC , phstructureiid ASC
FOR XML PATH('') ), 10, 1000) )as structure_desc_one, 
ROW_NUMBER() OVER(PARTITION BY phiidref ORDER BY structid ASC) AS row_num
FROM #structure;


CREATE TABLE #structure_single
   (phiidref INT,
	ct_null_id INT,
	null_st_id INT
	)
INSERT INTO #structure_single (phiidref, ct_null_id, null_st_id )
SELECT DISTINCT phiidref, SUM (CASE WHEN structid IS NULL THEN 0  ELSE 1 END) over(partition by phiidref) as ct_null_id,
CASE WHEN (agg_structure)  IS NULL AND  (before_structpartsto)  IS NULL AND (structid)  IS NULL AND (structpartsto)  IS NULL AND (next_structid)  IS NULL  THEN 1 ELSE 2 END AS null_st_id
FROM #structure

--weak medium angular blocky, and weak fine angular blocky, and weak medium subangular blocky, and weak fine subangular blocky structure; 
-- Final query where there is no structure id for all of the phorizon

CREATE TABLE #structure_single2
   (phiidref INT,
	structure_desc_no_struct_id VARCHAR (254)
	)
INSERT INTO #structure_single2 (phiidref, structure_desc_no_struct_id  )
SELECT DISTINCT #structure_single.phiidref,
(SELECT DISTINCT SUBSTRING(  (  SELECT (CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN ', and '  ELSE  ', and ' END  + CASE WHEN d_struct_grade IS NULL AND d_struct_size IS NULL THEN  d_struct_type  ELSE CONCAT (d_struct_grade, ' ',  d_struct_size, ' ' , d_struct_type ) END)
FROM #structure AS s2
INNER JOIN #structure_single AS ss2 ON ss2.phiidref=s2.phiidref
AND  s2.phiidref=#structure_single.phiidref AND ct_null_id = 0 AND  null_st_id = 1
ORDER BY structid ASC , phstructureiid ASC
FOR XML PATH('') ), 6, 1000) )as structure_desc_no_struct_id
FROM #structure_single
INNER JOIN #structure  ON #structure_single.phiidref=#structure.phiidref 
INNER JOIN #structure1  ON #structure_single.phiidref=#structure1.phiidref 

CREATE TABLE #structure2
   (phiidref INT,
	agg_structure INT,
	structure_desc_one  VARCHAR (254)
	)
    
INSERT INTO #structure2 (phiidref, agg_structure, structure_desc_one )
SELECT DISTINCT phiidref,  
agg_structure,structure_desc_one --,row_num 
FROM #structure1 
GROUP BY phiidref, agg_structure, structure_desc_one

CREATE TABLE #structure3
   (phiidref INT,
	structure_desc  VARCHAR (254)
	)
INSERT INTO #structure3 (phiidref, structure_desc  )
SELECT DISTINCT phiidref,  (SELECT DISTINCT SUBSTRING(  (  SELECT ( ', and ' + structure_desc_one)
FROM #structure2 AS s2
WHERE s2.phiidref=#structure2.phiidref 
ORDER BY agg_structure ASC 
FOR XML PATH('') ), 6, 1000) )as structure_desc 
FROM #structure2 


SELECT DISTINCT 
labsampnum, result_source_key, prep_code, pedon_key, site_key, pedlabsampnum, project_key, layer_field_label_1, hzn_top, hzn_bot, hzn_desgn, pedoniid, upedonid, phiid, soil_name, class_type, classification_name, siteiid, usiteid, site_obsdate, latitude_decimal_degrees, longitude_decimal_degrees, country_code, country_name, state_code, state_name, county_code, county_name, mlra_code, mlra_name, ssa_code, ssa_name, note, pedobjupdate, texture_lab, particle_size_method, clay_total, silt_total, sand_total, clay_fine, clay_caco3, silt_fine, silt_coarse, sand_very_fine, sand_fine, sand_medium, sand_coarse, total_carbon_ncs, total_carbon_ncs_method, estimated_organic_carbon, estimated_organic_matter, lab_texture, organic_carbon_walkley_black, oc_walkley_black_method, caco3_lt_2_mm, caco3_lt_2_mm_method, corrected_gypsum_lt_2_mm, caco3_lt_20_mm, gypsum_lt_20_mm, ca_to_mg_ratio, dry_colorhue, dry_colorvalue, dry_colorchroma, moist_colorhue, moist_colorvalue, moist_colorchroma,


CASE WHEN structure_desc = '' THEN TRIM (structure_desc_no_struct_id) 
ELSE TRIM (structure_desc) END structure_desc_end
, #structure3.phiidref
FROM #structure3
INNER JOIN #temp_pedon ON  #structure3.phiidref=#temp_pedon.phiid
LEFT OUTER JOIN #structure_single2  ON #structure_single2.phiidref=#structure3.phiidref




