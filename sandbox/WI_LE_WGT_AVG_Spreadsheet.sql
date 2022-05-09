USE sdmOnline;

DROP TABLE IF EXISTS #NCCPI3;
DROP TABLE IF EXISTS #NCCPI;
DROP TABLE IF EXISTS #NCCPI6;
DROP TABLE IF EXISTS #NCCPI7

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET QUOTED_IDENTIFIER ON
SET STATISTICS IO ON
/*
~DeclareChar(@area,20)~
~DeclareInt(@area_type)~
*/
DECLARE @area VARCHAR(20);
DECLARE @area_type INT;

SELECT @area = 'WI'; --Enter State Abbreviation or Soil Survey Area i.e. WI or  WI025,  US 
SELECT @area_type = LEN(@area); --determines number of characters of area 2-State, 5- Soil Survey Area

SELECT farmlndcl
     , c.cokey
     , compname
     , CONCAT(mu.mukey, ' - ', cokey)                   AS mucompkey
     , mu.muname
     , LEFT((areasymbol), 2)                            AS state_sym
     , SUM(muacres) over (partition by l.lkey)          as SUM_ACRES
     , CAST((
                SELECT TOP 1
                    MIN(DISTINCT slope_l)
                FROM mapunit             AS m_sl
                    INNER JOIN component AS c_sl
                        ON m_sl.mukey = c_sl.mukey
                           AND majcompflag = 'yes'
                           AND m_sl.mukey = mu.mukey
                GROUP BY m_sl.mukey
            ) AS varchar) + '-' + CAST((
                                           SELECT TOP 1
                                               MAX(DISTINCT slope_h)
                                           FROM mapunit             AS m_sh
                                               INNER JOIN component AS c_sh
                                                   ON m_sh.mukey = c_sh.mukey
                                                      AND majcompflag = 'yes'
                                                      AND m_sh.mukey = mu.mukey
                                           GROUP BY m_sh.mukey
                                       ) AS varchar(3)) AS slope
     , l.lkey
     , CASE
           WHEN nirrcapscl IS NULL THEN
               nirrcapcl
           ELSE
               nirrcapcl + nirrcapscl
       END                                              AS LCC
     , mu.musym
     , mu.mukey
     , mu.muacres
     , comppct_r
     , LEFT((areasymbol), 2)                            AS state
     , l.areasymbol
     , l.areaname
     , (
           SELECT TOP 1
               MAX(DISTINCT interphr)
           FROM legend
               INNER JOIN mapunit
                   ON mapunit.lkey = legend.lkey
                      AND legend.lkey = l.lkey
               INNER JOIN component
                   ON component.mukey = mapunit.mukey
               INNER JOIN cointerp
                   ON component.cokey = cointerp.cokey
                      AND majcompflag = 'yes'
                      AND ruledepth = 1
                      AND mrulename = 'Commodity Crop Productivity Index (Corn) (WI)'
           GROUP BY legend.lkey
       )                                                AS MAX_AREA
     , (
           SELECT TOP 1
               MIN(DISTINCT interphr)
           FROM legend
               INNER JOIN mapunit
                   ON mapunit.lkey = legend.lkey
                      AND legend.lkey = l.lkey
               INNER JOIN component
                   ON component.mukey = mapunit.mukey
               INNER JOIN cointerp
                   ON component.cokey = cointerp.cokey
                      AND majcompflag = 'yes'
                      AND ruledepth = 1
                      AND mrulename = 'Commodity Crop Productivity Index (Corn) (WI)'
           GROUP BY legend.lkey
       )                                                as MIN_AREA
     , (
           SELECT MAX(interphr)
           FROM component
               INNER JOIN cointerp
                   ON component.cokey = cointerp.cokey
                      AND majcompflag = 'yes'
                      AND component.cokey = c.cokey
                      AND ruledepth = 1
                      AND mrulename = 'Commodity Crop Productivity Index (Corn) (WI)'
       )                                                as NCCPI_Corn_Value_dcp
     , SUM(comppct_r) OVER (PARTITION BY mu.mukey)      AS mu_pct_sum

INTO #NCCPI
FROM legend              AS l
    INNER JOIN mapunit   AS mu
        ON mu.lkey = l.lkey
           AND (CASE
                    WHEN @area_type = 2 THEN
                        LEFT(areasymbol, 2)
                    ELSE
                        areasymbol
                END = @area
               )
    INNER JOIN component AS c
        ON c.mukey = mu.mukey AND majcompflag = 'Yes'
/* AND c.cokey                   = (   SELECT TOP 1 c1.cokey
                                         FROM component AS c1
                                        INNER JOIN mapunit
                                           ON c.mukey     = mapunit.mukey
                                          AND c1.mukey    = mu.mukey
                                          and c1.compkind != 'miscellaneous area'
                                        ORDER BY c1.comppct_r DESC,
                                                 c1.cokey) --- GETS THE TOP DOM COMPONENT. */



SELECT DISTINCT
CAST(ROUND ((1.0 * comppct_r / NULLIF(mu_pct_sum, 0)),2) AS DECIMAL(8,2)) AS adj_comp_pct
    , mukey                                          AS MKEY2
  , CASE
        WHEN muacres IS NULL THEN
            '0%'
        ELSE
            REPLACE(
                       (CAST(ROUND(
                                      (CAST(CAST(ISNULL(muacres, 0) / 1 AS decimal(10, 3))
                                            / CAST(SUM_ACRES / 1 AS decimal(10, 3)) AS decimal(10, 3))
                                      ) * 100
                                    , 2
                                  ) AS VARCHAR) + '%'
                       )
                     , '00%'
                     , '%'
                   )
    END                                            AS PCT_ACRES
  , MIN_AREA + ((MAX_AREA - MIN_AREA) / 20)        AS GROUP20 --BREAKING THE GROUPS INTO 20 CLASSES USING MIN A
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 2)  AS GROUP19
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 3)  AS GROUP18
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 4)  AS GROUP17
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 5)  AS GROUP16
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 6)  AS GROUP15
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 7)  AS GROUP14
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 8)  AS GROUP13
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 9)  AS GROUP12
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 10) AS GROUP11
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 11) AS GROUP10
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 12) AS GROUP09
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 13) AS GROUP08
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 14) AS GROUP07
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 15) AS GROUP06
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 16) AS GROUP05
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 17) AS GROUP04
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 18) AS GROUP03
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 19) AS GROUP02
  , MIN_AREA + (((MAX_AREA - MIN_AREA) / 20) * 20) AS GROUP01
  , #NCCPI.cokey

INTO #NCCPI3
FROM #NCCPI


SELECT DISTINCT 
    areasymbol           AS AREA_SYMBOL
  , state_sym            AS STATE_SYMBOL
  , areaname             AS AREA_NAME
  , mukey                AS MUKEY
  , mucompkey
  , muname               AS MAP_UNIT_NAME
  , compname
  , comppct_r            AS comp_pct
  , adj_comp_pct
  ,mu_pct_sum
  , musym                AS MUSYM
  , farmlndcl            AS FARM_CLASS
  , LCC
  , slope                AS SLOPE_RANGE
  , muacres              AS MAP_UNIT_ACRES
  , PCT_ACRES
  , SUM_ACRES
  , NCCPI_Corn_Value_dcp AS WICCPI_CROP_MAX
  , MIN_AREA             AS MIN_VALUE_LEGEND_CROP
  , MAX_AREA             AS MAX_VALUE_LEGEND_CROP
  , CASE --NORMALIZE FOR COUNTY
        WHEN [NCCPI_Corn_Value_dcp] <= [GROUP20] THEN
            0
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP20]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP19]
        ) THEN
            5
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP19]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP18]
        ) THEN
            10
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP18]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP17]
        ) THEN
            15
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP17]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP16]
        ) THEN
            20
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP16]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP15]
        ) THEN
            25
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP15]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP14]
        ) THEN
            30
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP14]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP13]
        ) THEN
            35
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP13]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP12]
        ) THEN
            40
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP12]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP11]
        ) THEN
            45
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP11]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP10]
        ) THEN
            50
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP10]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP09]
        ) THEN
            55
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP09]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP08]
        ) THEN
            60
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP08]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP07]
        ) THEN
            65
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP07]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP06]
        ) THEN
            70
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP06]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP05]
        ) THEN
            75
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP05]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP04]
        ) THEN
            80
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP04]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP03]
        ) THEN
            85
        WHEN
        (
            [NCCPI_Corn_Value_dcp] > [GROUP03]
            AND [NCCPI_Corn_Value_dcp] <= [GROUP02]
        ) THEN
            90
        WHEN [NCCPI_Corn_Value_dcp] >= [GROUP20] THEN
            100
        ELSE
            0
    END                  AS LE,
	#NCCPI3.cokey
INTO #NCCPI6

FROM #NCCPI3
    INNER JOIN #NCCPI
        ON #NCCPI.cokey = #NCCPI3.cokey


SELECT DISTINCT 
AREA_SYMBOL AS area_symbol,
MUKEY AS map_unit_key,
1 AS map_unit_sequence,
MAP_UNIT_NAME AS map_unit_name,
MUSYM AS musym,
FARM_CLASS AS farmclass,
MAP_UNIT_ACRES	 AS map_unit_acres,
adj_comp_pct ,
mu_pct_sum,
LCC	AS lcc, 
(adj_comp_pct * LE)  AS calc_wgt_avg,
LE,
cokey,
 (SELECT TOP 1 LCC	
 FROM #NCCPI6 AS n2
 WHERE n2.mukey=n1.mukey
 GROUP BY lcc, adj_comp_pct ORDER BY SUM(adj_comp_pct) over(partition by lcc) DESC) as domc_lcc
INTO #NCCPI7
FROM  #NCCPI6 AS n1
GROUP BY AREA_SYMBOL ,
MUKEY ,
MAP_UNIT_NAME ,
MUSYM ,
FARM_CLASS ,
MAP_UNIT_ACRES	, 
adj_comp_pct ,
mu_pct_sum,
LCC	,
adj_comp_pct ,
LE,
cokey


SELECT DISTINCT
area_symbol,
map_unit_key,
map_unit_sequence,
map_unit_name,
musym,
farmclass,
LEFT (domc_lcc, patindex('%[0-9]%',  domc_lcc)) AS lc,

CAST (ROUND (SUM (calc_wgt_avg) OVER (PARTITION BY  map_unit_key),0) AS INT) AS sum_le,
map_unit_acres

FROM  #NCCPI7


SET STATISTICS IO OFF