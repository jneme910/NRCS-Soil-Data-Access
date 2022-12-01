SELECT p.[pedlabsampnum], l.[labsampnum], cnn.[pedon_key], [estimated_organic_carbon], [hzn_desgn], [hzn_top], [hzn_bot], 
 CAST([aggregate_stability_05_2_mm] AS INT) AS aggregate_stability_05_2_mm, [aggregate_stability_05_2_metho]

  [pedoniid], [upedonid], CASE WHEN [corr_name] IS NULL THEN [samp_name] ELSE [corr_name] END AS soil_name, CASE WHEN [corr_class_type] IS NULL THEN [samp_class_type] ELSE [corr_class_type] END AS class_type, CASE WHEN [corr_classification_name] IS NULL THEN [samp_classification_name] ELSE [corr_classification_name] END AS [classification_name], 
 [siteiid], [usiteid], [site_obsdate], [latitude_decimal_degrees], [longitude_decimal_degrees], country_code, country_name, state_code, state_name, county_code, county_name, mlra_code, mlra_name, ssa_code, ssa_name, [pedobjupdate]
FROM [lab_pedon] AS p
     INNER JOIN [lab_combine_nasis_ncss] AS cnn ON p.pedon_key=cnn.pedon_key
     INNER JOIN [lab_layer] AS l ON l.pedon_key=p.pedon_key
     INNER JOIN [lab_chemical_properties] AS lcp ON lcp.labsampnum=l.labsampnum
     INNER JOIN [lab_physical_properties] AS lpp ON lpp.labsampnum=l.labsampnum AND [aggregate_stability_05_2_mm] IS NOT NULL
     INNER JOIN(SELECT [area_code] AS country_code, [area_name] AS country_name, area_key
                FROM lab_area 
     ) AS c ON cnn.[country_key]=c.area_key
     LEFT OUTER JOIN(SELECT [area_code] AS state_code, [area_name] AS state_name, area_key
                     FROM lab_area 
     ) AS s ON cnn.[state_key]=s.area_key
     LEFT OUTER JOIN(SELECT [area_code] AS county_code, [area_name] AS county_name, area_key
                     FROM lab_area 
     ) AS ct ON cnn.[county_key]=ct.area_key
     LEFT OUTER JOIN(SELECT [area_code] AS mlra_code, [area_name] AS mlra_name, area_key
                     FROM lab_area 
     ) AS m ON cnn.[mlra_key]=m.area_key
     LEFT OUTER JOIN(SELECT [area_code] AS ssa_code, [area_name] AS ssa_name, area_key
                     FROM lab_area
     ) AS ss ON cnn.[ssa_key]=ss.area_key
	 
	 ORDER BY p.[pedlabsampnum] ASC,l.[labsampnum] ASC, hzn_top, hzn_bot 
	 
