-- mwACPF_extSoilProfile.sql
--
-- In support of the Agricultural Conservation Planning Framework (ACPF), extract
--  soils data from the NRCS SDM extraction.  In this case, extract data to
--  assist in identifying opportunities for re-saturated buffers and other riparian
--  conservation practices.  Of note, perform custom extraction of adhoc CHorizon
--  data to pre-defined depth ranges. Specifically, extract OM-r at 0-100cm and KSat
--  and a custom coarse soils value...also VALU1 table data at 0-20, 20-50, and 50-100cm depths.
--
-- Original coding: D. James USDA/ARS NLAE 09/2014
--  NB: Tip o' the Hat to code snippets from UC Davis Soil Resource Laboratory
--       see http://casoilresource.lawr.ucdavis.edu/drupal/
--
-- Note: 05/2015: For the MWDEP, 7 mapunits -- all single Fluvents with 1 component and comppct_r = 0 and
--       a number of other mapunits had the same problem. After much trouble I inserted
--       'HAVING sum(C.comppct_r) > 0'  into the subscript and it appears to have fixed it.
--
-- Note: 03/2016: Modified the table to exclude some VALU1 fields that moved to the MUAGG table.
--       Added three new fields specifically for resaturated buffers; OM, total Sand, and FragVol
--       These were extracted for a depth range of 75-125cm. FragVol comes from CHFRAGS and may
--       have more than one instance per horizon which required creation of a temporary table to hold
--       the mean chkey FragVol values. Could not figure out how to include in the nested queries.
--
-- Note: 07/2016: Modified to doe custom estractions for OM, KSat, and a coarse soils of our own design.


use MWSoilsFY16
DECLARE @c1 int;
DECLARE @f1 int;
DECLARE @c4 int;
DECLARE @f4 int;

SET @c1= 0;      -- ceiling 1: saturated buffer - OM
SET @f1= 100;    -- floor 1: saturated buffer - OM
SET @c4 = 50;    -- ceiling 4: saturated buffer - coarse & KSat
SET @f4 = 125;   -- floor 4: saturated buffer - coarse & KSat

IF OBJECT_ID('mwACPF_SoilProfilesTable') IS NOT NULL 
       DROP TABLE mwACPF_SoilProfilesTable

------------------ perform the main query
SELECT mu.mukey
      ,v1.aws0_20
      ,v1.aws20_50
      ,v1.aws50_100

      ,v1.soc0_20
      ,v1.soc20_50
      ,v1.soc50_100
      
	  ,OM0_100
      ,KSat50_150
	  ,Coarse50_150
	
INTO MWSoilsFY16.dbo.mwACPF_SoilProfilesTable
  
FROM MWSoilsFY16.dbo.mw_MapUnitTable mu 

  ----------------------------------------------------- Range OM 0-100
   LEFT JOIN   
      (
       SELECT C.mukey, 
              sum(C.comppct_r * co_wgtd_mean_om) / sum(C.comppct_r) AS OM0_100
         FROM
          (
        
             -- compute a horizon-thickness weighted mean to a set depth
             SELECT cokey, sum(HrzThick * om_r) / sum(HrzThick) AS co_wgtd_mean_om
                FROM 
                   (
                    SELECT cokey, hzdept_r, hzdepb_r, om_r, 
                    CASE
                       WHEN hzdept_r <= @c1 AND hzdepb_r <= @f1 THEN (hzdepb_r - @c1)  -- Hrz starts before, ends before selection
                       WHEN hzdept_r >= @c1 AND hzdepb_r <= @f1 THEN (hzdepb_r - hzdept_r)  -- Hrz starts after, ends before selection
                       WHEN hzdept_r >= @c1 AND hzdepb_r >= @f1 THEN (@f1 - hzdept_r)    -- Hrz starts after, ends after selection
                       WHEN hzdept_r <= @c1 AND hzdepb_r >= @f1 THEN (@f1 - @c1)    -- Hrz starts before, ends after selection
                    END as HrzThick
                    FROM USSoilsFY16.dbo.CHORIZON
                    WHERE ksat_r IS NOT NULL AND OM_r IS NOT NULL AND hzdepb_r > @c1 AND hzdept_r < @f1  -- Btm below Ceiling; Top above Floor
                    ) as hrzKsat
             GROUP BY cokey
          ) as coKsat
        JOIN USSoilsFY16.dbo.COMPONENT C ON coKsat.cokey = C.cokey
        GROUP BY C.mukey
        HAVING sum(C.comppct_r) > 0      
       ) AS mu_ksat1 
   ON mu.mukey = mu_ksat1.mukey

   
 
  ----------------------------------------------------- SatBuff 50-125
  ----------------------------------------------------- SatBuff mean OM, max KSat, max Coarse materials
  LEFT JOIN   
      (
       SELECT C.mukey 
              ,max(hz_max_KSat) AS KSat50_150
              ,max(hz_max_coarseSoils) AS Coarse50_150
         FROM
          (
        
             -- compute a horizon-thickness weighted mean to a set depth
             SELECT cokey, max(ksat_r) AS hz_max_KSat
                         , max(totCoarse) AS hz_max_coarseSoils
                FROM 
                   (
                    SELECT hrz.cokey, hrz.hzdept_r, hrz.hzdepb_r, hrz.ksat_r
					       ,(hrz.frag3to10_r + hrz.fraggt10_r) + 
	                        ((100 - (hrz.frag3to10_r + hrz.fraggt10_r)) - hrz.sieveno10_r + 
	                        (hrz.sieveno10_r * (hrz.sandtotal_r * 0.01)) * ((100 - (hrz.frag3to10_r + hrz.fraggt10_r)) * 0.01)) as totCoarse,
                    CASE
                       WHEN hzdept_r <= @c4 AND hzdepb_r <= @f4 THEN (hzdepb_r - @c4)  
                       WHEN hzdept_r >= @c4 AND hzdepb_r <= @f4 THEN (hzdepb_r - hzdept_r)  
                       WHEN hzdept_r >= @c4 AND hzdepb_r >= @f4 THEN (@f4 - hzdept_r)    
                       WHEN hzdept_r <= @c4 AND hzdepb_r >= @f4 THEN (@f4 - @c4)   
                    END as HrzThick
                    FROM USSoilsFY16.dbo.CHORIZON hrz 
                    WHERE ksat_r IS NOT NULL AND OM_r IS NOT NULL AND hzdepb_r > @c4 and hzdept_r < @f4 
                    ) as hrzSatBuff
             GROUP BY cokey
           ) as coSatBuff
        JOIN MWSoilsFY16.dbo.mw_DomComponents C ON coSatBuff.cokey = C.cokey
        GROUP BY C.mukey
        HAVING sum(C.comppct_r) > 0      
       ) AS mu_SatBuff 
   ON mu.mukey = mu_SatBuff.mukey

  
  ----------------------------------------------------- VALU1 table
   LEFT JOIN USSoilsFY16.dbo.valu1 v1 ON mu.mukey = v1.mukey
  ORDER BY mu.mukey
GO

ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN aws0_20 Decimal(12,3) NULL
ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN aws20_50 Decimal(12,3) NULL
ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN aws50_100 Decimal(12,3) NULL

ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN soc0_20 Decimal(12,3) NULL
ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN soc20_50 Decimal(12,3) NULL
ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN soc50_100 Decimal(12,3) NULL

ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN OM0_100 Decimal(8,3) NULL
ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN KSat50_150 Decimal(8,3) NULL
ALTER TABLE mwACPF_SoilProfilesTable ALTER COLUMN Coarse50_150 Decimal(8,3) NULL


GO
