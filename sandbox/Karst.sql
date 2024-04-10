--Define the area
/* -- Used for SQL Server
DROP TABLE IF EXISTS #karst;
--DECLARE @area VARCHAR(20);
--DECLARE @area_type INT;
*/

~DeclareChar(@area,20)~  -- Used for Soil Data Access
~DeclareINT(@area_type)~ 


-- End soil data access
SELECT @area = 'SD607'; --Enter State Abbreviation or Soil Survey Area i.e. WI or  WI025,  US 

--determines number of characters of area 2-State, 5- Soil Survey Area
SELECT
    @area_type = LEN(@area); 

CREATE TABLE #karst
(
    areasymbol VARCHAR(20),
    mukey INT,
    musym VARCHAR(20),
    muname VARCHAR(250),
    cokey INT,
    compname VARCHAR(250),
    comppct_r INT,
    taxgrtgroup VARCHAR(250),
    pmgroupname VARCHAR(250),
    pmkind VARCHAR(250),
    pmorigin VARCHAR(250),
    pmorder VARCHAR(250),
    localphase VARCHAR(250),
)


--Queries the map unit and legend
--Link Main
INSERT INTO #karst
(
    areasymbol,
    mukey,
    musym,
    muname,
    cokey,
    compname,
    comppct_r,
    taxgrtgroup,
    pmgroupname,
    pmkind,
    pmorigin,
    pmorder,
    localphase
)
SELECT areasymbol,
       mapunit.mukey,
       mapunit.musym,
       mapunit.muname,
       component.cokey,
       compname,
       component.comppct_r,
       taxgrtgroup,
       (
           SELECT TOP 1
               pmgroupname
           FROM copmgrp AS co1
               INNER JOIN copm AS copm1
                   ON copm1.copmgrpkey = co1.copmgrpkey
                      AND rvindicator = 'Yes'
                      AND co1.cokey = component.cokey
           ORDER BY pmorder DESC
       ) AS pmgroupname,
       (
           SELECT TOP 1
               pmkind
           FROM copmgrp AS co2
               INNER JOIN copm AS copm2
                   ON copm2.copmgrpkey = co2.copmgrpkey
                      AND rvindicator = 'Yes'
                      AND co2.cokey = component.cokey
           ORDER BY pmorder DESC
       ) AS pmkind,
       (
           SELECT TOP 1
               pmorigin
           FROM copmgrp AS co3
               INNER JOIN copm AS copm3
                   ON copm3.copmgrpkey = co3.copmgrpkey
                      AND rvindicator = 'Yes'
                      AND co3.cokey = component.cokey
           ORDER BY pmorder DESC
       ) AS pmorigin,
       (
           SELECT TOP 1
               CASE
                   WHEN pmorder is null THEN
                       1
                   ELSE
                       pmorder
               END AS pmorder
           FROM copmgrp AS co3
               INNER JOIN copm AS copm3
                   ON copm3.copmgrpkey = co3.copmgrpkey
                      AND rvindicator = 'Yes'
                      AND co3.cokey = component.cokey
           ORDER BY pmorder DESC
       ) AS pmorder,
       localphase
FROM legend
    INNER JOIN mapunit
        on legend.lkey = mapunit.lkey --and areasymbol like 'SD607'
           AND (CASE
                    WHEN @area_type = 2 THEN
                        LEFT(areasymbol, 2)
                    ELSE
                        areasymbol
                END = @area
               )
    INNER JOIN component
        ON component.mukey = mapunit.mukey
           and majcompflag like 'Yes'
           and compkind IN ( 'series', 'taxadjunct', 'taxon above family', 'variant', 'family' )
ORDER BY areasymbol,
         mapunit.musym,
         comppct_r DESC




SELECT areasymbol,
       mukey,
       musym,
       muname,
       cokey,
       compname,
       comppct_r,
       taxgrtgroup,
       pmgroupname,
       pmkind,
       pmorigin,
       pmorder,
       localphase,
       CASE
           WHEN (
       (
           pmkind like 'residuum'
           and pmorigin like '%limestone%'
       )
                )
                and (taxgrtgroup like 'pale%')
                and (
                        (muname like '%karst%')
                        or (localphase like '%karst%')
                    ) then
               .4
           WHEN (
       (
           pmkind like 'residuum'
           and pmorigin like '%dolomite%'
       )
                )
                and (taxgrtgroup like 'pale%')
                and (
                        (muname like '%karst%')
                        or (localphase like '%karst%')
                    ) then
               .4
           WHEN (
                    pmkind like 'residuum'
                    and pmorigin like '%limestone%'
                )
                and (
                        (muname like '%karst%')
                        or (localphase like '%karst%')
                    ) then
               .8
           WHEN (
                    pmkind like 'residuum'
                    and pmorigin like '%dolomite%'
                )
                and (
                        (muname like '%karst%')
                        or (localphase like '%karst%')
                    ) then
               .8
           WHEN (
                    pmkind like 'residuum'
                    and pmorigin like '%limestone%'
                )
                and (taxgrtgroup like 'pale%') then
               .1
           WHEN (
                    pmkind like 'residuum'
                    and pmorigin like '%dolomite%'
                )
                and (taxgrtgroup like 'pale%') then
               .1
           WHEN
           (
               pmkind like 'residuum'
               and pmorigin like '%limestone%'
           ) then
               .5
           WHEN
           (
               pmkind like 'residuum'
               and pmorigin like '%dolomite%'
           ) then
               .5
           WHEN
           (
               pmkind like 'residuum'
               and pmorigin like '%marble%'
           ) then
               .5
           WHEN pmgroupname like '%residuum%limestone%' then
               0.5
           WHEN pmgroupname like '%till%limestone%' then
               0.5
           WHEN pmgroupname like '%colluvium%limestone%' then
               0.5
           WHEN pmgroupname like '%alluvium%limestone%' then
               0.5
           WHEN pmgroupname like '%residuum%dolomite%' then
               0.5
           WHEN pmgroupname like '%till%dolomite%' then
               0.5
           WHEN pmgroupname like '%colluvium%dolomite%' then
               0.5
           WHEN pmgroupname like '%alluvium%dolomite%' then
               0.5
           WHEN pmgroupname like '%residuum%marble%' then
               0.5
           WHEN pmgroupname like '%till%marble%' then
               0.5
           WHEN pmgroupname like '%colluvium%marble%' then
               0.5
           WHEN pmgroupname like '%alluvium%marble%' then
               0.5
           WHEN pmgroupname like '%loess%over%marble%' then
               0.5
           WHEN pmgroupname like '%loess%over%dolomite%' then
               0.5
           WHEN pmgroupname like '%loess%over%limestone%' then
               0.5
           WHEN
           (
               pmkind like '%till%'
               and pmorigin like '%limestone%'
           ) then
               .3
           WHEN
           (
               pmkind like '%till%'
               and pmorigin like '%dolomite%'
           ) then
               .3
           WHEN
           (
               pmkind like '%till%'
               and pmorigin like '%marble%'
           ) then
               .3
           WHEN
           (
               pmkind like '%colluvium%'
               and pmorigin like '%limestone%'
           ) then
               .3
           WHEN
           (
               pmkind like '%colluvium%'
               and pmorigin like '%dolomite%'
           ) then
               .3
           WHEN
           (
               pmkind like '%colluvium%'
               and pmorigin like '%marble%'
           ) then
               .3
           WHEN
           (
               pmkind like '%alluvium%'
               and pmorigin like '%limestone%'
           ) then
               .3
           WHEN
           (
               pmkind like '%alluvium%'
               and pmorigin like '%dolomite%'
           ) then
               .3
           WHEN
           (
               pmkind like '%alluvium%'
               and pmorigin like '%marble%'
           ) then
               .3
           WHEN (pmorigin like 'rock gypsum') THEN
               1
           WHEN (pmorigin like 'rock anhydrite') THEN
               1
           WHEN (pmorigin like 'rock halite') THEN
               1
           ELSE
               0
       END AS soluble
FROM #karst
