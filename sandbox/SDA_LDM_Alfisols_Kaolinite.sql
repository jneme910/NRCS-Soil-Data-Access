-- Insert Dynamic Pedon Lab Sample numbers


~DeclareINT(@upperdepth)~ 
~DeclareINT(@bottomdepth)~ 
~DeclareChar(@taxorder,100)~ 



--DECLARE @upperdepth INT;
--DECLARE @bottomdepth INT;
--DECLARE @taxorder VARCHAR(100);

SELECT @upperdepth = 0;
SELECT @bottomdepth = 150;
SELECT  @taxorder = 'Alfisols'


SELECT
    l.[labsampnum],
    [latitude_decimal_degrees],
    [longitude_decimal_degrees],
    cnn.[pedon_key],
    p.[pedlabsampnum],
    [hzn_top],
    [hzn_bot],
    [hzn_desgn],
    [pedoniid],
    [upedonid],
    CASE
        WHEN [corr_name] IS NULL
            THEN [samp_name]
        ELSE
            upper(substring([corr_name], 1, 1)) + lower(substring([corr_name], 2, 120))
    END                                                        AS soil_name,
    CASE
        WHEN [corr_class_type] IS NULL
            THEN [samp_class_type]
        ELSE
            [corr_class_type]
    END                                                        AS class_type,
    CASE
        WHEN [corr_classification_name] IS NULL
            THEN [samp_classification_name]
        ELSE
            [corr_classification_name]
    END                                                        AS [classification_name],
	[samp_taxminalogy],
	[corr_taxminalogy],
	[corr_taxminalogy],
    [usiteid],
    [site_obsdate],
    country_code,
    country_name,
    state_code,
    state_name,
    county_code,
    county_name,
    mlra_code,
    mlra_name,
    ssa_code,
    ssa_name,
    [pedobjupdate],
    CASE
        WHEN [estimated_organic_carbon] IS NOT NULL
            THEN estimated_organic_carbon
        WHEN
            (
                [estimated_organic_carbon] IS NOT NULL
                AND [caco3_lt_2_mm] IS NOT NULL
            )
            THEN ([total_carbon_ncs] - ([caco3_lt_2_mm] * 0.12))
        WHEN [estimated_organic_carbon] IS NULL
             AND [caco3_lt_2_mm] IS NULL
             AND [total_carbon_ncs] IS NOT NULL
            THEN [total_carbon_ncs]
        WHEN [organic_carbon_walkley_black] IS NOT NULL
            THEN 0.25 + [organic_carbon_walkley_black] * 0.86
    END                                                        AS [calc_estimated_organic_carbon],
    CASE
        WHEN [estimated_organic_carbon] IS NOT NULL
            THEN 'estimated_organic_carbon'
        WHEN [estimated_organic_carbon] IS NULL
             AND [caco3_lt_2_mm] IS NOT NULL
            THEN '([total_carbon_ncs]- ([caco3_lt_2_mm]*0.12))'
        WHEN [estimated_organic_carbon] IS NULL
             AND [caco3_lt_2_mm] IS NULL
             AND [total_carbon_ncs] IS NOT NULL
            THEN '[total_carbon_ncs]'
        WHEN [organic_carbon_walkley_black] IS NOT NULL
            THEN '0.25 +  [organic_carbon_walkley_black] * 0.86'
    END                                                        AS [calc_estimated_organic_carbon_field],
	  
   cec_nh4_ph_7,
    cec_nh4_ph_7_method,
    ecec_base_plus_aluminum,
    [texture_lab],
    lm.[analyzed_size_frac]                                    AS mineralogy_analyzed_size_frac,
    [Glass_Count_Method],
    [BG_Basic_Glass_Count],
    [DI_Diatoms_Glass_Count],
    [GA_Glass_Aggregates_Glass_Count],
    [GS_Glass_Glass_Count],
    [FG_Glass_Coated_Feldspar_Glass_Count],
    [GC_Glass_Coated_Grain_Glass_Count],
    [HG_Glass_Coated_Hornblende_Glass_Count],
    [OG_Glass_Coated_Opaques_Glass_Count],
    [QG_Glass_Coated_Quartz_Glass_Count],
    [GM_Glassy_Materials_Glass_Count],
    [OT_Other_Glass_Count],
    [PO_Plant_Opal_Glass_Count],
    [SS_Sponge_Spicule_Glass_Count],
    [AR_Weatherable_Aggregates_Glass_Count],
    [PA_Palagonite_Glass_Count],
    [PM_Pumice_Glass_Count],
    [Petro_Count_Method],
    [AC_Actinolite_Petro_Count],
    [FB_Albite_Petro_Count],
    [AM_Amphibole_Petro_Count],
    [AE_Anatase_Petro_Count],
    [AN_andalusite_Petro_Count],
    [FA_andesite_Petro_Count],
    [AY_Anhydrite_Petro_Count],
    [FN_Anorthite_Petro_Count],
    [FH_Anorthoclase_Petro_Count],
    [AH_Anthophyllite_Petro_Count],
    [AG_Antigorite_Petro_Count],
    [AP_Apatite_Petro_Count],
    [AO_Aragonite_Petro_Count],
    [AF_Arfvedsonite_Petro_Count],
    [AU_Augite_Petro_Count],
    [BA_Barite_Petro_Count],
    [BG_Basic_Glass_Petro_Count],
    [BY_Beryl_Petro_Count],
    [BT_Biotite_Petro_Count],
    [BC_Biotite_Chlorite_Petro_Count],
    [BE_Bohmite_Petro_Count],
    [BZ_Bronzite_Petro_Count],
    [BK_Brookite_Petro_Count],
    [BR_Brucite_Petro_Count],
    [CA_Calcite_Petro_Count],
    [CB_Carbonate_Aggregates_Petro_Count],
    [CT_Cassiterite_Petro_Count],
    [CD_Chert_Chalcedony_Jasper_Agate_Onyx_Petro_Count],
    [CL_Chlorite_Petro_Count],
    [CM_Chlorite_Mica_Petro_Count],
    [CY_Chrysotile_Petro_Count],
    [QC_Clay_Coated_Quartz_Petro_Count],
    [CH_Cliachite_Bauxite_Petro_Count],
    [CZ_Clinozoisite_Petro_Count],
    [CC_Coal_Petro_Count],
    [CO_Collophane_Petro_Count],
    [CN_Corundum_Petro_Count],
    [CR_Cristobalite_Petro_Count],
    [DI_Diatoms_Petro_Count],
    [DP_Diopside_Petro_Count],
    [DL_Dolomite_Petro_Count],
    [DU_Dumortierite_Petro_Count],
    [EN_Enstatite_Petro_Count],
    [EP_Epidote_Petro_Count],
    [FD_Feldspar_Petro_Count],
    [FZ_Feldspathoids_Petro_Count],
    [FM_Ferromagnesium_Petro_Count],
    [FU_Fluorite_Petro_Count],
    [FF_Foraminifera_Petro_Count],
    [GG_Galena_Petro_Count],
    [GN_Garnet_Petro_Count],
    [GI_Gibbsite_Petro_Count],
    [GA_Glass_Aggregates_Petro_Count],
    [FG_Glass_Coated_Feldspar_Petro_Count],
    [GC_Glass_Coated_Grain_Petro_Count],
    [HG_Glass_Coated_Hornblende_Petro_Count],
    [OG_Glass_Coated_Opaque_Petro_Count],
    [QG_Glass_Coated_Quartz_Petro_Count],
    [GS_Glass_Petro_Count],
    [GM_Glassy_Matrials_Petro_Count],
    [GL_Glauconite_Petro_Count],
    [GO_Glaucophane_Petro_Count],
    [GE_Goethite_Petro_Count],
    [GD_Gold_Petro_Count],
    [GY_Gypsum_Petro_Count],
    [KH_Halloysite_Petro_Count],
    [HE_Hematite_Petro_Count],
    [HN_Hornblende_Petro_Count],
    [HB_Hydrobiotite_Petro_Count],
    [ID_Iddingsite_Petro_Count],
    [QI_Iron_Oxide_Coated_Quartz_Petro_Count],
    [FE_Iron_Oxides_Geothite_Magnetite_Hematite_Li_Petro_Count],
    [JO_Jarosite_Petro_Count],
    [KK_Kaolinite_Petro_Count],
    [KY_Kyanite_Petro_Count],
    [FL_Labradorite_Petro_Count],
    [LA_Lamprobolite_Petro_Count],
    [LP_Lepidolite_Petro_Count],
    [LO_Lepidomelane_Petro_Count],
    [LU_Leucoxene_Petro_Count],
    [LM_Limonite_Petro_Count],
    [LT_Lithiophorite_Petro_Count],
    [ME_Magnesite_Petro_Count],
    [MG_Magnetite_Petro_Count],
    [MR_Marcasite_Petro_Count],
    [ML_Melilite_Petro_Count],
    [MI_Mica_Petro_Count],
    [FC_Microcline_Petro_Count],
    [MZ_Monazite_Petro_Count],
    [MT_Montmorillonite_Petro_Count],
    [MS_Muscovite_Petro_Coun],
    [NE_Nepheline_Petro_Count],
    [NX_Non_Crystalline_Petro_Count],
    [FO_Oligoclase_Petro_Count],
    [OV_Olivine_Petro_Count],
    [OP_Opaques_Petro_Count],
    [FR_Orthoclase_Petro_Count],
    [OR_Other_Resistant_Minerals_Petro_Count],
    [OW_Other_Weatherable_Minerals_Petro_Count],
    [OT_Other_Petro_Count],
    [PK_Perovskite_Petro_Count],
    [PL_Phlogophit_Petro_Count],
    [PD_Piemontite_Petro_Count],
    [FP_Plagioclase_Feldspar_Petro_Count],
    [PO_Plant_Opal_Petro_Count],
    [PJ_Plumbojarosite_Petro_Count],
    [PN_Pollen_Petro_Count],
    [FK_Potassium_Feldspar_Petro_Count],
    [PI_Pyrite_Petro_Count],
    [PU_Pyrolusite_Petro_Count],
    [PY_Pyrophyllite_Petro_Count],
    [PR_Pyroxene_Petro_Count],
    [QZ_Quartz_Petro_Count],
    [RA_Resistant_Aggregates_Petro_Count],
    [MD_Resistant_Mineraloids_Petro_Count],
    [RE_Resistant_Minerals_Petro_Count],
    [RO_Rhodochrosite_Petro_Count],
    [RB_Riebeckite_Blue_Amphibole_Petro_Count],
    [RU_Rutile_Petro_Count],
    [FS_Sanidine_Petro_Count],
    [SR_Sericite_Petro_Count],
    [SI_Siderite_Petro_Count],
    [SA_Siliceous_Aggregates_Petro_Count],
    [SL_Sillimanite_Petro_Count],
    [SG_Sphalerite_Petro_Count],
    [SP_Sphene_Petro_Count],
    [SN_Spinel_Petro_Count],
    [SS_Sponge_Spicule_Petro_Count],
    [SO_Staurolite_Petro_Count],
    [ST_Stilbite_Petro_Count],
    [SU_Sulfur_Petro_Count],
    [TA_Talc_Petro_Count],
    [TP_Topaz_Petro_Count],
    [TM_Tourmaline_Petro_Count],
    [TE_Tremolite_Petro_Count],
    [VR_Vermiculite_Petro_Count],
    [VC_Vermiculite_Chlorite_Petro_Count],
    [VH_Vermiculite_Hydrobiotite_Petro_Count],
    [VM_Vermiculite_Mica_Petro_Count],
    [VI_Vivianite_Petro_Count],
    [WV_Wavellite_Petro_Count],
    [AR_Weatherable_Aggregates_Petro_Count],
    [WE_Weatherable_Mineral_petro_Count],
    [ZE_Zeolite_Petro_Count],
    [ZR_Zircon_Petro_Count],
    [ZO_Zoisite_Petro_Count],
    [AI_Aegirine_Augite_Petro_Count],
    [AL_Allophane_Petro_Count],
    [CE_Cobaltite_Petro_Count],
    [HA_Halite_Petro_Count],
    [IL_Illite_Hydromuscovite_Petro_Count],
    [LC_Analcime_Petro_Count],
    [LE_Lepidocrocite_Petro_Count],
    [LI_Leucite_Petro_Count],
    [MC_Montmorillonite_Chlorite_Petro_Count],
    [MH_Maghemite_Petro_Count],
    [MM_Montmorillonite_Mica_Petro_Count],
    [MV_Montmorillonite_Vermiculite_Petro_Count],
    [PA_Palagonite_Petro_Count],
    [PG_Palygorskite_Petro_Count],
    [SC_Scapolite_Petro_Count],
    [SE_Sepiolite_Petro_Count],
    [SM_Smectite_Petro_Count],
    [TD_Tridymite_Petro_Count],
    [TH_thenardite_Petro_Count],
    [HY_Hypersthene_Petro_Count],
    [HS_Hydroxy_Interlayer_Smectite_Petro_Count],
    [HV_Hydroxy_Interlayer_Vermiculite_Petro_Count],
    [PM_Pumice_Petro_Count],
    [SZ_Serpentine_Petro_Count],
    [Total_Grains_Counted],
    [Resistant_Minerals_Total_Mineral_Soil],
    [Glass_Count_Mineral_Interpretation],
    lx.[analyzed_size_frac]                                    AS xray_analyzed_size_frac,
    [X_Ray_Method],
    [AM_Amphibole_X_Ray],
    [LC_Anacime_X_Ray],
    [AE_Anatase_X_Ray],
    [AG_Antigoite_X_Ray],
    [AO_Aragonite_X_Ray],
    [BT_Biotite_X_Ray],
    [BC_Biotite_Chlorite_X_Ray],
    [BR_Brucite_X_Ray],
    [CA_Calcite_X_Ray],
    [CL_Chlorite_X_Ray],
    [CM_Chlorite_Mica_X_Ray],
    [CR_Cristobalite_X_Ray],
    [DL_Dolomite_X_Ray],
    [EN_Enstatite_X_Ray],
    [FD_Feldspar_X_Ray],
    [GI_Gibbsite_X_Ray],
    [GL_Glauconite_X_Ray],
    [GE_Geothite_X_Ray],
    [GY_Gypsum_X_Ray],
    [KH_Halloysite_X_Ray],
    [HE_Hematite_X_Ray],
    [HN_Hornblende_X_Ray],
    [HB_Hydrobiotite_X_Ray],
    [IL_Illite_Hydromuscovite_X_Ray],
    [KK_Kaolinite_X_Ray],
    [FL_Labradorite_X_Ray],
    [LE_Lepidocrocite_X_Ray],
    [MH_Maghemite_X_Ray],
    [MG_Magnetite_X_Ray],
    [MI_Mica_X_Ray],
    [MT_Montmorillonite_X_Ray],
    [MC_Montmorillonite_Chlorite_X_Ray],
    [MM_Montmorillonite_Mica_X_Ray],
    [MV_Montmorillonite_Vermiculite_X_Ray],
    [MS_Muscovite_X_Ray],
    [NX_Non_Crystalline_X_Ray],
    [FO_Oligoclase_X_Ray],
    [FR_Orthoclase_X_Ray],
    [PG_Palygorskite_X_Ray],
    [PL_Phlogophite_X_Ray],
    [FP_Plagioclase_Feldspar_X_Ra],
    [FK_Potassium_Feldspar_X_Ray],
    [PY_Pyrophyllite_X_Ray],
    [QZ_Quartz_X_Ray],
    [RE_Resistant_Minerals_X_Ray],
    [SE_Sepiolite_X_Ray],
    [TA_Talc_X_Ray],
    [TH_thenardite_X_Ray],
    [TD_Tridymite_X_Ray],
    [VR_Vermiculite_X_Ray],
    [VC_Vermiculite_Chlorite_X_Ray],
    [VH_Vermiculite_Hydrobiotite_X_Ray],
    [VM_Vermiculite_Mica_X_Ray],
    [ZE_Zeolite_X_Ray],
    [HA_Halite_X_Ray],
    [HS_Hydroxy_Interlayered_Smectite_X_Ray],
    [HV_Hydroxy_Interlayered_Vermiculite_X_Ray],
    [FT_Fluorapatite_xray],
    [NU_Natrojarosite_X_Ray],
    [HA_PT_Paragonite_X_Ray],
    [NA_Natron_X_Ray],
    [JO_Jarosite_X_Ray],
    [SZ_Serpentine_X_Ray],
    [BE_Boehmite_X_Ray],
    [BD_Beidellite_X_Ray],
    [Clay_Mineral_Interpretation],
    [Coarse_Silt_Mineral_Interpretation],
    [Fine_Sand_Mineral_Interpretation],
    [Very_Fine_Sand_Mineral_Interpretation],
    [Differential_Scanning_Calorimeter_Method],
    [GI_Gibbsite_Differential_Scanning_Calorimetry],
    [KK_Kaolinite_Differential_Scanning_Calorimetry],
    [GE_Geothite_Differential_Scanning_Calorimetry],
    [GY_Gypsum_Differential_Scanning_Calorimetry],
    [AT_Alunite_Differential_Scanning_Calorimetry],
    [SM_Smectite_Differential_Scanning_Calorimetry],
    [KH_Halloysite_Differential_Scanning_Calorimetry],
    [QZ_Quartz_Differential_Scanning_Calorimetry],
    [VR_Vermiculite_Differential_Calorimetry],
    [thermal_Gravimetric_Method],
    [AG_Gypsum_thermal_Gravimetric_Analysis],
    [GI_Gibbsite_thermal_Gravimetric_Analysis],
    [GE_Kaolinite_Differential_thermal_Analysis],
    [KK_Kaolinite_thermal_Gravimetric_Analysis],
    [AG_Antigorite_thermal_Gravimetric_Analysis],
    [KH_Halloysite_thermal_Gravimetric_Analysis],
    [MT_Montmorillonite_thermal_Gravimetric_Analysis],
    [PG_Palygorskite_thermal_Gravimetric_Analysis],
    [CA_Calcite_thermal_Gravimetric_Analysis],
    [Differential_thermal_Analysis_Method],
    [GI_Gibbsite_Differential_thermal_Analysis],
    [KK_Kaolinite_Differential_thermal_Analysis],
    [GE_Geothite_Differential_thermal_Analysis],
    [KH_Halloysite_Differential_thermal_Analysi],
    [QZ_Quartz_Differential_thermal_Analysis]

/*
	   ,[Soil_Classification]
      ,[Primary_Lab_Report]
      ,[Taxonomy_Report]
      ,[Supplementary_Lab_Report]
      ,[Water_Retention_Report]
      ,[Correlation_Report]
      ,[pedon_Description_Report]
      ,[Soil_Profile]
      ,[Soil_web]

	  */


FROM
    [lab_pedon]                                                   AS p
    INNER JOIN
        [lab_combine_nasis_ncss]                                  AS cnn
            ON p.pedon_key = cnn.pedon_key
               AND CASE
                       WHEN samp_taxorder = @taxorder
                           THEN 1
                       WHEN cnn.corr_taxorder = @taxorder
                           THEN 1
                       WHEN cnn.SSL_taxorder = @taxorder
                           THEN 1
                       ELSE
                           2
                   END = 1
               AND CASE
                       WHEN [latitude_decimal_degrees] IS NULL
                           THEN 2
                       WHEN [longitude_decimal_degrees] IS NULL
                           THEN 2
                       ELSE
                           1
                   END = 1
    INNER JOIN
        [lab_layer]                                               AS l
            ON l.pedon_key = p.pedon_key
               AND ([hzn_top] != @upperdepth)
               AND l.hzn_desgn LIKE '%B%'
    INNER JOIN
        [lab_chemical_properties]                                 AS lcp
            ON lcp.labsampnum = l.labsampnum
    LEFT OUTER JOIN
        [lab_physical_properties]                                 AS lpp
            ON lpp.labsampnum = l.labsampnum
    INNER JOIN
        lab_xray_and_thermal                                      AS lx
            ON lx.labsampnum = l.labsampnum
    INNER JOIN
        lab_mineralogy_glass_count                                AS lm
            ON lm.labsampnum = l.labsampnum
               AND CASE
                       WHEN KK_Kaolinite_Petro_Count IS NOT NULL
                           THEN 1
                       WHEN KK_Kaolinite_X_Ray IS NOT NULL
                           THEN 1
                       ELSE
                           2
                   END = 1
    LEFT OUTER JOIN
        [lab_calculations_including_estimates_and_default_values] AS lce
            ON lce.labsampnum = l.labsampnum
    LEFT OUTER JOIN
        (
            SELECT
                [area_code] AS country_code,
                [area_name] AS country_name,
                area_key
            FROM
                lab_area
        )                                                         AS c
            ON cnn.[country_key] = c.area_key -- Country
    LEFT OUTER JOIN
        (
            SELECT
                [area_code] AS state_code,
                [area_name] AS state_name,
                area_key
            FROM
                lab_area
        )                                                         AS s
            ON cnn.[state_key] = s.area_key --State
    LEFT OUTER JOIN
        (
            SELECT
                [area_code] AS county_code,
                [area_name] AS county_name,
                area_key
            FROM
                lab_area
        )                                                         AS ct
            ON cnn.[county_key] = ct.area_key --County
    LEFT OUTER JOIN
        (
            SELECT
                [area_code] AS mlra_code,
                [area_name] AS mlra_name,
                area_key
            FROM
                lab_area
        )                                                         AS m
            ON cnn.[mlra_key] = m.area_key --MLRA
    LEFT OUTER JOIN
        (
            SELECT
                [area_code] AS ssa_code,
                [area_name] AS ssa_name,
                area_key
            FROM
                lab_area
        )                                                         AS ss
            ON cnn.[ssa_key] = ss.area_key --SSA
    INNER JOIN
        [lab_webmap]
            ON lab_webmap.pedon_Key = p.pedon_key


