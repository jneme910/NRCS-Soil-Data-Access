/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT
CONCAT ('["', upedonid,'",',lat, ',', long, '],') AS loc
      ,[Series]
      ,[User_pedon_ID]
      ,lab_webmap.[pedon_Key]
      ,[peiid]
      ,[Soil_Classification]

	 , REPLACE (CONCAT ('<a target=zz_blankzz href=zz' , [Primary_Lab_Report], 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 

, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	 [Taxonomy_Report]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 
, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	      [Supplementary_Lab_Report]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 
, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	      [Water_Retention_Report]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 
, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	      [Correlation_Report]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 
, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	      [pedon_Description_Report]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 
, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	      [Soil_Profile]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 
, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,	      [Soil_web]	, 'zz>Click Here</a>'), 'zz', '''') AS [Primary_Lab_Report] 

	   ,[lat]
      ,[long]



    FROM lab_webmap
  INNER JOIN lab_combine_nasis_ncss ON  lab_combine_nasis_ncss.pedon_key = lab_webmap.pedon_Key
  INNER JOIN lab_area ON lab_area.area_key=lab_combine_nasis_ncss.state_key --AND area_code = 'WI'
   INNER JOIN  (SELECT pedon_key FROM lab_layer
WHERE project_key IN (6357,
6374,
6375,
6376,
6395) ) AS s ON s.pedon_key = lab_combine_nasis_ncss.pedon_key
