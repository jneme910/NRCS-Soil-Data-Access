SELECT DISTINCT
    l.[labsampnum]
  , cnn.[pedon_key]
  , cnn.[site_key]
  , p.[pedlabsampnum]
  , [pedoniid]
  , [upedonid]
  , CASE
        WHEN [corr_name] IS NULL THEN
            [samp_name]
        ELSE
            [corr_name]
    END                          AS soil_name
  , CASE
        WHEN [corr_class_type] IS NULL THEN
            [samp_class_type]
        ELSE
            [corr_class_type]
    END                          AS class_type
  , CASE
        WHEN [corr_classification_name] IS NULL THEN
            [samp_classification_name]
        ELSE
            [corr_classification_name]
    END                          AS [classification_name]
  , [siteiid]
  , [usiteid]
  , [site_obsdate]
  , [latitude_decimal_degrees]
  , [longitude_decimal_degrees]
  , country_code
  , country_name
  , state_code
  , state_name
  , county_code
  , county_name
  , mlra_code
  , mlra_name
  , ssa_code
  , ssa_name
  , [pedobjupdate]
  , [hzn_desgn]
  , [hzn_top]
  , [hzn_bot]
  , CASE
        WHEN [estimated_organic_carbon] IS NOT NULL THEN
            LEFT(ROUND([estimated_organic_carbon] * 1.724, 2), 4)
        WHEN [estimated_organic_carbon] IS NULL
             AND [caco3_lt_2_mm] IS NOT NULL THEN
            LEFT(ROUND(([total_carbon_ncs] - ([caco3_lt_2_mm] * 0.12)) * 1.724, 2), 4)
        WHEN [estimated_organic_carbon] IS NULL
             AND [caco3_lt_2_mm] IS NULL THEN
            LEFT(ROUND([total_carbon_ncs] * 1.724, 2), 4)
    END                          AS [estimated_organic_matter]
  , (
        SELECT TOP 1
            [texture_lab]
        FROM [lab_physical_properties] AS lpp
        WHERE lpp.labsampnum = l.labsampnum
              AND [texture_lab] IS NOT NULL
    )                            AS [lab_texture]
  , [cec_nh4_ph_7]
  , [cec_nh4_ph_7_method]
  , (
        SELECT TOP 1
            [Clay_Mineral_Interpretation]
        FROM [lab_xray_and_thermal] AS XRAY2
        WHERE xray.labsampnum = xray2.labsampnum
        ORDER BY CASE
                     WHEN [Clay_Mineral_Interpretation] IS NULL THEN
                         2
                     ELSE
                         1
                 END ASC
    )                            AS Clay_Mineral_Interpretation
  , cole_whole_soil
  , cole_whole_soil_method
  , atterberg_liquid_limit
  , atterberg_liquid_limit_method
  , atterberg_plasticity_index
  , plastic_limit                plastic_limit_method
FROM [lab_pedon]                           AS p
    INNER JOIN [lab_combine_nasis_ncss]    AS cnn
        ON p.pedon_key = cnn.pedon_key
           AND CASE
                   WHEN [corr_name] IS NULL THEN
                       [samp_name]
                   ELSE
                       [corr_name]
               END IN ( 'Blount', 'Pewamo', 'Glynwood', 'Morley', 'Hoytville', 'Nappanee' )
    INNER JOIN [lab_layer]                 AS l
        ON l.pedon_key = p.pedon_key
    INNER JOIN [lab_chemical_properties]   AS lcp
        ON lcp.labsampnum = l.labsampnum
    INNER JOIN [lab_physical_properties]   AS lpp
        ON lpp.labsampnum = l.labsampnum
    LEFT OUTER JOIN [lab_xray_and_thermal] AS xray
        ON xray.labsampnum = l.labsampnum
    INNER JOIN
    (
        SELECT [area_code] AS country_code
             , [area_name] AS country_name
             , area_key
        FROM lab_area -- Country
    )                                      AS c
        ON cnn.[country_key] = c.area_key
    LEFT OUTER JOIN
    (
        SELECT [area_code] AS state_code
             , [area_name] AS state_name
             , area_key
        FROM lab_area --State
    )                                      AS s
        ON cnn.[state_key] = s.area_key
    LEFT OUTER JOIN
    (
        SELECT [area_code] AS county_code
             , [area_name] AS county_name
             , area_key
        FROM lab_area --County
    )                                      AS ct
        ON cnn.[county_key] = ct.area_key
    LEFT OUTER JOIN
    (
        SELECT [area_code] AS mlra_code
             , [area_name] AS mlra_name
             , area_key
        FROM lab_area --MLRA
    )                                      AS m
        ON cnn.[mlra_key] = m.area_key
    LEFT OUTER JOIN
    (
        SELECT [area_code] AS ssa_code
             , [area_name] AS ssa_name
             , area_key
        FROM lab_area --SSA
    )                                      AS ss
        ON cnn.[ssa_key] = ss.area_key
ORDER BY CASE
             WHEN [corr_name] IS NULL THEN
                 [samp_name]
             ELSE
                 [corr_name]
         END ASC
       , l.[labsampnum] ASC
       , [hzn_top]