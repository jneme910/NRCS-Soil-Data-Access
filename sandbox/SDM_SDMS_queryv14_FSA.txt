SELECT
laoverlap.areasymbol AS 'State_County_ID'
, legend.areasymbol AS 'Soil_Survey_Area_ID'
, laoverlap.areaname
, mapunit.mukey
, mapunit.musym
, mapunit.muname
, c.compname
, c.cokey
, (select TOP 1 case when laoverlap.areasymbol IN    ('AL001', 'AL003', 'AL005', 'AL007', 'AL009', 
'AL011', 'AL013', 'AL015', 'AL017', 'AL019', 'AL021', 'AL023', 'AL025', 'AL027', 'AL029', 'AL031', 
'AL035', 'AL037', 'AL039', 'AL041', 'AL043', 'AL045', 'AL047', 'AL051', 'AL053', 'AL055', 'AL057', 
'AL061', 'AL067', 'AL069', 'AL073', 'AL081', 'AL085', 'AL087', 'AL091', 'AL097', 'AL099', 'AL101', 
'AL105', 'AL109', 'AL111', 'AL113', 'AL115', 'AL117', 'AL119', 'AL121', 'AL123', 'AL125', 'AL127', 
'AL129', 'AL131', 'AL133', 'FL001', 'FL003', 'FL005', 'FL007', 'FL009', 'FL013', 'FL017', 'FL019', 
'FL023', 'FL027', 'FL029', 'FL031', 'FL033', 'FL035', 'FL037', 'FL039', 'FL041', 'FL043', 'FL045', 
'FL047', 'FL049', 'FL053', 'FL055', 'FL057', 'FL059', 'FL061', 'FL063', 'FL065', 'FL067', 'FL069', 
'FL073', 'FL075', 'FL077', 'FL079', 'FL081', 'FL083', 'FL089', 'FL091', 'FL093', 'FL095', 'FL097', 
'FL101', 'FL103', 'FL105', 'FL107', 'FL109', 'FL111', 'FL113', 'FL115', 'FL117', 'FL119', 'FL121', 
'FL123', 'FL125', 'FL127', 'FL129', 'FL131', 'FL133', 'GA001', 'GA003', 'GA005', 'GA007', 'GA009', 
'GA015', 'GA017', 'GA019', 'GA021', 'GA023', 'GA025', 'GA027', 'GA029', 'GA031', 'GA033', 'GA037', 
'GA039', 'GA043', 'GA045', 'GA049', 'GA051', 'GA053', 'GA055', 'GA061', 'GA065', 'GA067', 'GA069', 
'GA071', 'GA073', 'GA075', 'GA077', 'GA079', 'GA081', 'GA087', 'GA091', 'GA093', 'GA095', 'GA097', 
'GA099', 'GA101', 'GA103', 'GA107', 'GA109', 'GA113', 'GA115', 'GA121', 'GA125', 'GA127', 'GA131', 
'GA141', 'GA143', 'GA145', 'GA149', 'GA153', 'GA155', 'GA161', 'GA163', 'GA165', 'GA167', 'GA169', 
'GA173', 'GA175', 'GA177', 'GA179', 'GA181', 'GA183', 'GA185', 'GA189', 'GA191', 'GA193', 'GA197', 
'GA199', 'GA201', 'GA205', 'GA207', 'GA209', 'GA215', 'GA223', 'GA225', 'GA229', 'GA231', 'GA233', 
'GA235', 'GA237', 'GA239', 'GA243', 'GA245', 'GA249', 'GA251', 'GA253', 'GA259', 'GA261', 'GA263', 
'GA267', 'GA269', 'GA271', 'GA273', 'GA275', 'GA277', 'GA279', 'GA283', 'GA285', 'GA287', 'GA289', 
'GA293', 'GA299', 'GA301', 'GA303', 'GA305', 'GA307', 'GA309', 'GA315', 'GA319', 'GA321', 'LA001', 
'LA003', 'LA009', 'LA011', 'LA013', 'LA019', 'LA021', 'LA025', 'LA033', 'LA037', 'LA039', 'LA043', 
'LA049', 'LA053', 'LA059', 'LA063', 'LA069', 'LA079', 'LA085', 'LA091', 'LA103', 'LA105', 'LA115', 
'LA117', 'LA125', 'LA127', 'MS001', 'MS005', 'MS007', 'MS021', 'MS023', 'MS029', 'MS031', 'MS035', 
'MS037', 'MS039', 'MS041', 'MS045', 'MS047', 'MS049', 'MS059', 'MS061', 'MS063', 'MS065', 'MS067', 
'MS069', 'MS073', 'MS075', 'MS077', 'MS079', 'MS085', 'MS089', 'MS091', 'MS101', 'MS109', 'MS111', 
'MS113', 'MS121', 'MS123', 'MS127', 'MS129', 'MS131', 'MS147', 'MS153', 'MS157', 'NC007', 'NC013', 
'NC015', 'NC017', 'NC019', 'NC029', 'NC031', 'NC041', 'NC047', 'NC049', 'NC051', 'NC061', 'NC065', 
'NC073', 'NC079', 'NC083', 'NC085', 'NC091', 'NC093', 'NC101', 'NC103', 'NC105', 'NC107', 'NC117', 
'NC123', 'NC125', 'NC127', 'NC129', 'NC131', 'NC133', 'NC137', 'NC139', 'NC141', 'NC143', 'NC147', 
'NC153', 'NC155', 'NC163', 'NC165', 'NC187', 'NC191', 'NC195', 'SC003', 'SC005', 'SC009', 'SC011', 
'SC013', 'SC015', 'SC017', 'SC019', 'SC025', 'SC027', 'SC029', 'SC031', 'SC033', 'SC035', 'SC037', 
'SC041', 'SC043', 'SC047', 'SC049', 'SC051', 'SC053', 'SC055', 'SC057', 'SC061', 'SC063', 'SC065', 
'SC067', 'SC069', 'SC075', 'SC079', 'SC081', 'SC085', 'SC089', 'TX005', 'TX199', 'TX241', 'TX245', 
'TX291', 'TX347', 'TX351', 'TX361', 'TX373', 'TX403', 'TX405', 'TX419', 'TX455', 'TX457', 'VA025', 
'VA081', 'VA093', 'VA175', 'VA550', 'VA800')  then 'Y' else 'N' END  from laoverlap WHERE laoverlap.areatypename Like 'County or Parish' and legend.lkey=laoverlap.lkey GROUP BY laoverlap.areasymbol ORDER BY laoverlap.areasymbol desc ) as 
mu_lleaf
, (select TOP 1 cotreestomng.plantsym from cotreestomng where c.cokey=cotreestomng.cokey and cotreestomng.plantsym = 'PIPA2') AS llpine_cotreestomng 
, (select TOP 1 coeplants.plantsym from coeplants where c.cokey=coeplants.cokey and coeplants.plantsym = 'PIPA2') as llpine_coeplants 
, (select TOP 1 coforprod.plantsym from coforprod where c.cokey=coforprod.cokey and coforprod.plantsym = 'PIPA2') AS llpine_coforprod
, (SELECT CASE when min(soimoistdept_r) is null then '999' else cast(min(soimoistdept_r) as varchar) END
          from component left outer join comonth left outer join cosoilmoist
            on comonth.comonthkey = cosoilmoist.comonthkey
            on component.cokey = comonth.cokey
         where component.cokey = c.cokey and soimoiststat in ('Wet', 'Saturation')) as llp_wt
, case when exists (select texture FROM component inner join chorizon on c.cokey=chorizon.cokey inner join chtexturegrp on chorizon.chkey=chtexturegrp.chkey WHERE texture IN ('COS', 'FS', 'VFS', 'LCOS', 'LS', 'LFS', 'LVFS', 'COSL', 'SL', 'FSL', 'VFSL') and hzdept_r <30) Then 'Y' ELSE 'N' END as llp_texture
, case when exists (select ph1to1h2o_r FROM component inner join chorizon on c.cokey=chorizon.cokey WHERE ph1to1h2o_r > 6 and hzdept_r <30) Then 'N' ELSE 'Y' END as llp_pH
, cast (case WHEN taxorder like 'Histosols' Then 1 
WHEN hydgrp like '%D'  Then 1 
WHEN hydgrp like 'C' And ((om_r * hzdepb_r/2.54) <= 10) And kwfact >= .28 Then 1 
WHEN hydgrp like 'C' And ((om_r * hzdepb_r/2.54) >= 10) Then 1 
WHEN hydgrp like 'B' And ((om_r * hzdepb_r/2.54) >= 35) And kwfact >= .40 Then 1 
WHEN hydgrp like 'B' And ((om_r * hzdepb_r/2.54) >= 45) And kwfact >= .20 Then 1 
WHEN hydgrp like 'A' and ((om_r * hzdepb_r/2.54) <= 30) Then 3 
WHEN hydgrp like 'B' and ((om_r * hzdepb_r/2.54) <= 9) and kwfact <= .48  Then 3 
WHEN hydgrp like 'B' And ((om_r * hzdepb_r/2.54) <= 15) And kwfact <= .26 Then 3 
WHEN hydgrp like 'A' And ((om_r * hzdepb_r/2.54) > 30)  Then 2 
WHEN hydgrp like 'B'  Then 2 
WHEN hydgrp like 'C' Then 2 ELSE 0 END as varchar) as mu_leach 
, c.wei AS mu_ifactor 
, case when ch.kffact is null then 0.02 else ch.kffact END AS mu_kfactor 
, case when legend.areasymbol IN ('ID607', 'ID610', 'OR021', 'OR049', 'OR055', 'OR625', 'OR667', 
'OR670','OR673', 'WA001', 'WA021', 'WA025', 'WA043', 'WA063', 'WA071', 'WA075', 'WA603', 'WA605',
'WA613', 'WA617', 'WA623', 'WA639', 'WA676', 'WA677') then 'Y' else 'N' END as palouse 
, c.tfact AS mu_tfactor 
, c.slope_r 
, c.slopelenusle_r 
, case when (map_l < 382 and wei > 55 and  claytotal_r < 21 and om_r < 3 and texcl not like '%sand' 
and left(legend.areasymbol,2) IN ('WA', 'OR', 'CA', 'ID')  ) then 'Y' else 'N' END as WESL 
, case when nirrcapscl is null then nirrcapcl else nirrcapcl + nirrcapscl end as nirrcapclass 
, 'SDM' as source 
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey=c.cokey and ruledepth = 0 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)') as NCCPI_Value_dcp 
INTO #step1 
FROM (mapunit INNER JOIN ((legend INNER JOIN laoverlap ON legend.lkey = laoverlap.lkey and 
laoverlap.areatypename ='County Or Parish' and LEFT(legend.areasymbol, 2) like 'GA') 
INNER JOIN muaoverlap ON laoverlap.lareaovkey = muaoverlap.lareaovkey) ON mapunit.mukey = 
muaoverlap.mukey)
INNER JOIN component c ON mapunit.mukey = c.mukey and c.cokey = (SELECT TOP 1 component.cokey FROM 
component WHERE component.mukey=mapunit.mukey ORDER BY component.comppct_r DESC) 
INNER JOIN chorizon ch ON c.cokey=ch.cokey and  hzdept_r = (select MIN(hzdept_r) FROM chorizon WHERE 
hzname != 'O%' and c.cokey = ch.cokey )
INNER JOIN chtexturegrp on ch.chkey=chtexturegrp.chkey and rvindicator = 'yes' 
INNER JOIN chtexture on chtexture.chtgkey=chtexturegrp.chtgkey
ORDER BY laoverlap.areasymbol, mapunit.musym, c.comppct_r DESC

SELECT
 cokey
, case 
WHEN mu_lleaf like 'Y' and llpine_cotreestomng is null and llpine_coeplants is null and llpine_coforprod is null THEN 'N'
WHEN mu_lleaf like 'Y' and llpine_cotreestomng is null  and llpine_coeplants is null  and llpine_coforprod is null  and llp_wt < 30 and llp_texture like 'N' and llp_pH like 'N' THEN 'N'
WHEN mu_lleaf like 'Y' and llpine_cotreestomng is null  and llpine_coeplants is null  and llpine_coforprod is null  and llp_wt > 30 and llp_texture like 'N' and llp_pH like 'Y' THEN 'N'
WHEN mu_lleaf like 'Y' and llpine_cotreestomng is null  and llpine_coeplants is null and llpine_coforprod is null  and llp_wt > 30 and llp_texture like 'Y' and llp_pH like 'N' THEN 'N'
WHEN mu_lleaf like 'Y' and (llpine_cotreestomng is not null or llpine_coeplants is not null  or llpine_coforprod is not null) THEN 'Y'
WHEN mu_lleaf like 'Y' and llpine_cotreestomng is null and llpine_coeplants is null  and llpine_coforprod is null  and llp_wt > 30 and llp_texture like 'Y' and llp_pH like 'Y' THEN 'Y' ELSE 'N' END as llpine
, cast(case 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 0 and slope_r < 0.75) Then 100 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 0.75 and slope_r < 1.5) Then 200 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 1.5 and slope_r < 2.5) Then 300 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 2.5 and slope_r < 3.5) Then 200 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 3.5 and slope_r < 4.5) Then 180 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 4.5 and slope_r < 5.5) Then 160 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 5.5 and slope_r < 6.5) Then 150 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 6.5 and slope_r < 7.5) Then 140 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 7.5 and slope_r < 8.5) Then 130 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 8.5 and slope_r < 9.5) Then 125 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 9.5 and slope_r < 10.5) Then 120 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 10.5 and slope_r < 11.5) Then 110
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 11.5 and slope_r < 12.5) Then 100
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 12.5 and slope_r < 13.5) Then 90
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 13.5 and slope_r < 14.5) Then 80
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 14.5 and slope_r < 15.5) Then 70
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 15.5 and slope_r < 17.5) Then 60
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >=  17.5) Then 50 
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 0 and slope_r < 5.5) Then 350 
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 5.5 and slope_r < 10.5) Then 275
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 10.5 and slope_r < 15.5) Then 225
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 15.5 and slope_r < 20.5) Then 175
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 20.5 and slope_r < 25.5) Then 150
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 25.5 and slope_r < 35.5) Then 125
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 35.5)  Then 100 Else slopelenusle_r 
* 3.28  END as int) as rvslopelenusle 
, slope_r
INTO #step2 
FROM #step1

SELECT
#step2.cokey
, llpine
, case 
WHEN rvslopelenusle < 4.5 Then 1
WHEN rvslopelenusle >= 4.5 And rvslopelenusle < 7.5 Then 2 
WHEN rvslopelenusle >= 7.5 And rvslopelenusle < 10.5 Then 3 
WHEN rvslopelenusle >= 10.5 And rvslopelenusle < 13.5 Then 4 
WHEN rvslopelenusle >= 13.5 And rvslopelenusle < 20 Then 5 
WHEN rvslopelenusle >= 20 And rvslopelenusle < 37.5 Then 6 
WHEN rvslopelenusle >= 37.5 And rvslopelenusle < 62.5 Then 7 
WHEN rvslopelenusle >= 62.6 And rvslopelenusle < 87.5 Then 8 
WHEN rvslopelenusle >= 87.5 And rvslopelenusle < 125 Then 9 
WHEN rvslopelenusle >= 125 And rvslopelenusle < 175 Then 10 
WHEN rvslopelenusle >= 175 And rvslopelenusle < 225 Then 11 
WHEN rvslopelenusle >= 225 And rvslopelenusle < 275 Then 12 
WHEN rvslopelenusle >= 275 And rvslopelenusle < 350 Then 13 
WHEN rvslopelenusle >= 350 And rvslopelenusle < 500 Then 14 
WHEN rvslopelenusle >= 500 And rvslopelenusle < 700 Then 15 
WHEN rvslopelenusle >= 700 And rvslopelenusle < 900 Then 16 Else 17 END as columnx 
, case 
WHEN slope_r < 0.35 Then 1 
WHEN slope_r >= 45 And slope_r < 55 Then 18 
WHEN slope_r >= 35 And slope_r < 45 Then 17 
WHEN slope_r >= 27.5 And slope_r < 35 Then 16 
WHEN slope_r >= 22.5 And slope_r < 27.5 Then 15 
WHEN slope_r >= 18.0 And slope_r < 22.5 Then 14 
WHEN slope_r >= 15.0 And slope_r < 18 Then 13 
WHEN slope_r >= 13.0 And slope_r < 15 Then 12 
WHEN slope_r >= 11.0 And slope_r < 13 Then 11 
WHEN slope_r >= 9.0 And slope_r < 11 Then 10 
WHEN slope_r >= 7.0 And slope_r < 9 Then 9 
WHEN slope_r >= 5.5 And slope_r < 7 Then 8 
WHEN slope_r >= 4.5 And slope_r < 5.5 Then 7 
WHEN slope_r >= 3.5 And slope_r < 4.5 Then 6 
WHEN slope_r >= 2.5 And slope_r < 3.5 Then 5 
WHEN slope_r >= 1.5 And slope_r < 2.5 Then 4 
WHEN slope_r >= 0.75 And slope_r < 1.5 Then 3 
WHEN slope_r >= 0.35 And slope_r < 0.75 Then 2 Else 19 END as row 
INTO #step3 
FROM #step2


SELECT
#step3.cokey
, llpine
, case 
WHEN row = 1 and columnx = 1 then 0.05 
WHEN row = 1 and columnx = 2 then 0.05 
WHEN row = 1 and columnx = 3 then 0.05 
WHEN row = 1 and columnx = 4 then 0.05 
WHEN row = 1 and columnx = 5 then 0.05 
WHEN row = 1 and columnx = 6 then 0.05 
WHEN row = 1 and columnx = 7 then 0.05 
WHEN row = 1 and columnx = 8 then 0.05 
WHEN row = 1 and columnx = 9 then 0.05 
WHEN row = 1 and columnx = 10 then 0.05 
WHEN row = 1 and columnx = 11 then 0.05 
WHEN row = 1 and columnx = 12 then 0.05 
WHEN row = 1 and columnx = 13 then 0.05 
WHEN row = 1 and columnx = 14 then 0.06 
WHEN row = 1 and columnx = 15 then 0.06 
WHEN row = 1 and columnx = 16 then 0.06 
WHEN row = 1 and columnx = 17 then 0.06 
WHEN row = 2 and columnx = 1 then 0.07 
WHEN row = 2 and columnx = 2 then 0.07 
WHEN row = 2 and columnx = 3 then 0.07 
WHEN row = 2 and columnx = 4 then 0.07 
WHEN row = 2 and columnx = 5 then 0.07 
WHEN row = 2 and columnx = 6 then 0.08 
WHEN row = 2 and columnx = 7 then 0.08 
WHEN row = 2 and columnx = 8 then 0.08 
WHEN row = 2 and columnx = 9 then 0.09 
WHEN row = 2 and columnx = 10 then 0.09 
WHEN row = 2 and columnx = 11 then 0.09 
WHEN row = 2 and columnx = 12 then 0.09 
WHEN row = 2 and columnx = 13 then 0.09 
WHEN row = 2 and columnx = 14 then 0.1 
WHEN row = 2 and columnx = 15 then 0.1 
WHEN row = 2 and columnx = 16 then 0.1 
WHEN row = 2 and columnx = 17 then 0.1 
WHEN row = 3 and columnx = 1 then 0.11 
WHEN row = 3 and columnx = 2 then 0.11 
WHEN row = 3 and columnx = 3 then 0.11 
WHEN row = 3 and columnx = 4 then 0.11 
WHEN row = 3 and columnx = 5 then 0.11 
WHEN row = 3 and columnx = 6 then 0.12 
WHEN row = 3 and columnx = 7 then 0.13 
WHEN row = 3 and columnx = 8 then 0.14 
WHEN row = 3 and columnx = 9 then 0.14 
WHEN row = 3 and columnx = 10 then 0.15 
WHEN row = 3 and columnx = 11 then 0.16 
WHEN row = 3 and columnx = 12 then 0.17 
WHEN row = 3 and columnx = 13 then 0.17 
WHEN row = 3 and columnx = 14 then 0.18 
WHEN row = 3 and columnx = 15 then 0.19 
WHEN row = 3 and columnx = 16 then 0.2 
WHEN row = 3 and columnx = 17 then 0.2 
WHEN row = 4 and columnx = 1 then 0.17 
WHEN row = 4 and columnx = 2 then 0.17 
WHEN row = 4 and columnx = 3 then 0.17 
WHEN row = 4 and columnx = 4 then 0.17 
WHEN row = 4 and columnx = 5 then 0.17 
WHEN row = 4 and columnx = 6 then 0.19 
WHEN row = 4 and columnx = 7 then 0.22 
WHEN row = 4 and columnx = 8 then 0.25 
WHEN row = 4 and columnx = 9 then 0.27 
WHEN row = 4 and columnx = 10 then 0.29 
WHEN row = 4 and columnx = 11 then 0.31 
WHEN row = 4 and columnx = 12 then 0.33 
WHEN row = 4 and columnx = 13 then 0.35 
WHEN row = 4 and columnx = 14 then 0.37 
WHEN row = 4 and columnx = 15 then 0.41 
WHEN row = 4 and columnx = 16 then 0.44 
WHEN row = 4 and columnx = 17 then 0.47 
WHEN row = 5 and columnx = 1 then 0.22 
WHEN row = 5 and columnx = 2 then 0.22 
WHEN row = 5 and columnx = 3 then 0.22 
WHEN row = 5 and columnx = 4 then 0.22 
WHEN row = 5 and columnx = 5 then 0.22 
WHEN row = 5 and columnx = 6 then 0.25 
WHEN row = 5 and columnx = 7 then 0.32 
WHEN row = 5 and columnx = 8 then 0.36 
WHEN row = 5 and columnx = 9 then 0.39 
WHEN row = 5 and columnx = 10 then 0.44 
WHEN row = 5 and columnx = 11 then 0.48 
WHEN row = 5 and columnx = 12 then 0.52 
WHEN row = 5 and columnx = 13 then 0.55 
WHEN row = 5 and columnx = 14 then 0.6 
WHEN row = 5 and columnx = 15 then 0.68 
WHEN row = 5 and columnx = 16 then 0.75 
WHEN row = 5 and columnx = 17 then 0.8 
WHEN row = 6 and columnx = 1 then 0.26 
WHEN row = 6 and columnx = 2 then 0.26 
WHEN row = 6 and columnx = 3 then 0.26 
WHEN row = 6 and columnx = 4 then 0.26 
WHEN row = 6 and columnx = 5 then 0.26 
WHEN row = 6 and columnx = 6 then 0.31 
WHEN row = 6 and columnx = 7 then 0.4 
WHEN row = 6 and columnx = 8 then 0.47 
WHEN row = 6 and columnx = 9 then 0.52 
WHEN row = 6 and columnx = 10 then 0.6 
WHEN row = 6 and columnx = 11 then 0.67 
WHEN row = 6 and columnx = 12 then 0.72 
WHEN row = 6 and columnx = 13 then 0.77 
WHEN row = 6 and columnx = 14 then 0.86 
WHEN row = 6 and columnx = 15 then 0.99 
WHEN row = 6 and columnx = 16 then 1.1 
WHEN row = 6 and columnx = 17 then 1.19 
WHEN row = 7 and columnx = 1 then 0.3 
WHEN row = 7 and columnx = 2 then 0.3 
WHEN row = 7 and columnx = 3 then 0.3 
WHEN row = 7 and columnx = 4 then 0.3 
WHEN row = 7 and columnx = 5 then 0.3 
WHEN row = 7 and columnx = 6 then 0.37 
WHEN row = 7 and columnx = 7 then 0.49 
WHEN row = 7 and columnx = 8 then 0.58 
WHEN row = 7 and columnx = 9 then 0.65 
WHEN row = 7 and columnx = 10 then 0.76 
WHEN row = 7 and columnx = 11 then 0.85 
WHEN row = 7 and columnx = 12 then 0.93 
WHEN row = 7 and columnx = 13 then 1.01 
WHEN row = 7 and columnx = 14 then 1.13 
WHEN row = 7 and columnx = 15 then 1.33 
WHEN row = 7 and columnx = 16 then 1.49 
WHEN row = 7 and columnx = 17 then 1.63 
WHEN row = 8 and columnx = 1 then 0.34 
WHEN row = 8 and columnx = 2 then 0.34 
WHEN row = 8 and columnx = 3 then 0.34 
WHEN row = 8 and columnx = 4 then 0.34 
WHEN row = 8 and columnx = 5 then 0.34 
WHEN row = 8 and columnx = 6 then 0.43 
WHEN row = 8 and columnx = 7 then 0.58 
WHEN row = 8 and columnx = 8 then 0.69 
WHEN row = 8 and columnx = 9 then 0.78 
WHEN row = 8 and columnx = 10 then 0.93 
WHEN row = 8 and columnx = 11 then 1.05 
WHEN row = 8 and columnx = 12 then 1.16 
WHEN row = 8 and columnx = 13 then 1.25 
WHEN row = 8 and columnx = 14 then 1.42 
WHEN row = 8 and columnx = 15 then 1.69 
WHEN row = 8 and columnx = 16 then 1.91 
WHEN row = 8 and columnx = 17 then 2.11 
WHEN row = 9 and columnx = 1 then 0.42 
WHEN row = 9 and columnx = 2 then 0.42 
WHEN row = 9 and columnx = 3 then 0.42 
WHEN row = 9 and columnx = 4 then 0.42 
WHEN row = 9 and columnx = 5 then 0.42 
WHEN row = 9 and columnx = 6 then 0.53 
WHEN row = 9 and columnx = 7 then 0.74 
WHEN row = 9 and columnx = 8 then 0.91 
WHEN row = 9 and columnx = 9 then 1.04 
WHEN row = 9 and columnx = 10 then 1.26 
WHEN row = 9 and columnx = 11 then 1.45 
WHEN row = 9 and columnx = 12 then 1.62 
WHEN row = 9 and columnx = 13 then 1.77 
WHEN row = 9 and columnx = 14 then 2.03 
WHEN row = 9 and columnx = 15 then 2.47 
WHEN row = 9 and columnx = 16 then 2.83 
WHEN row = 9 and columnx = 17 then 3.15 
WHEN row = 10 and columnx = 1 then 0.46 
WHEN row = 10 and columnx = 2 then 0.48 
WHEN row = 10 and columnx = 3 then 0.5 
WHEN row = 10 and columnx = 4 then 0.51 
WHEN row = 10 and columnx = 5 then 0.52 
WHEN row = 10 and columnx = 6 then 0.67 
WHEN row = 10 and columnx = 7 then 0.97 
WHEN row = 10 and columnx = 8 then 1.19 
WHEN row = 10 and columnx = 9 then 1.38 
WHEN row = 10 and columnx = 10 then 1.71 
WHEN row = 10 and columnx = 11 then 1.98 
WHEN row = 10 and columnx = 12 then 2.22 
WHEN row = 10 and columnx = 13 then 2.44 
WHEN row = 10 and columnx = 14 then 2.84 
WHEN row = 10 and columnx = 15 then 3.5 
WHEN row = 10 and columnx = 16 then 4.06 
WHEN row = 10 and columnx = 17 then 4.56 
WHEN row = 11 and columnx = 1 then 0.47 
WHEN row = 11 and columnx = 2 then 0.53 
WHEN row = 11 and columnx = 3 then 0.58 
WHEN row = 11 and columnx = 4 then 0.61 
WHEN row = 11 and columnx = 5 then 0.64 
WHEN row = 11 and columnx = 6 then 0.84 
WHEN row = 11 and columnx = 7 then 1.23 
WHEN row = 11 and columnx = 8 then 1.53 
WHEN row = 11 and columnx = 9 then 1.79 
WHEN row = 11 and columnx = 10 then 2.23 
WHEN row = 11 and columnx = 11 then 2.61 
WHEN row = 11 and columnx = 12 then 2.95 
WHEN row = 11 and columnx = 13 then 3.26 
WHEN row = 11 and columnx = 14 then 3.81 
WHEN row = 11 and columnx = 15 then 4.75 
WHEN row = 11 and columnx = 16 then 5.56 
WHEN row = 11 and columnx = 17 then 6.28 
WHEN row = 12 and columnx = 1 then 0.48 
WHEN row = 12 and columnx = 2 then 0.58 
WHEN row = 12 and columnx = 3 then 0.65 
WHEN row = 12 and columnx = 4 then 0.7 
WHEN row = 12 and columnx = 5 then 0.75 
WHEN row = 12 and columnx = 6 then 1 
WHEN row = 12 and columnx = 7 then 1.48 
WHEN row = 12 and columnx = 8 then 1.86 
WHEN row = 12 and columnx = 9 then 2.19 
WHEN row = 12 and columnx = 10 then 2.76 
WHEN row = 12 and columnx = 11 then 3.25 
WHEN row = 12 and columnx = 12 then 3.69 
WHEN row = 12 and columnx = 13 then 4.09 
WHEN row = 12 and columnx = 14 then 4.82 
WHEN row = 12 and columnx = 15 then 6.07 
WHEN row = 12 and columnx = 16 then 7.15 
WHEN row = 12 and columnx = 17 then 8.11 
WHEN row = 13 and columnx = 1 then 0.49 
WHEN row = 13 and columnx = 2 then 0.63 
WHEN row = 13 and columnx = 3 then 0.72 
WHEN row = 13 and columnx = 4 then 0.79 
WHEN row = 13 and columnx = 5 then 0.85 
WHEN row = 13 and columnx = 6 then 1.15 
WHEN row = 13 and columnx = 7 then 1.73 
WHEN row = 13 and columnx = 8 then 2.2 
WHEN row = 13 and columnx = 9 then 2.6 
WHEN row = 13 and columnx = 10 then 3.3 
WHEN row = 13 and columnx = 11 then 3.9 
WHEN row = 13 and columnx = 12 then 4.45 
WHEN row = 13 and columnx = 13 then 4.95 
WHEN row = 13 and columnx = 14 then 5.86 
WHEN row = 13 and columnx = 15 then 7.43 
WHEN row = 13 and columnx = 16 then 8.79 
WHEN row = 13 and columnx = 17 then 10.02 
WHEN row = 14 and columnx = 1 then 0.52 
WHEN row = 14 and columnx = 2 then 0.71 
WHEN row = 14 and columnx = 3 then 0.85 
WHEN row = 14 and columnx = 4 then 0.96 
WHEN row = 14 and columnx = 5 then 1.06 
WHEN row = 14 and columnx = 6 then 1.45 
WHEN row = 14 and columnx = 7 then 2.22 
WHEN row = 14 and columnx = 8 then 2.85 
WHEN row = 14 and columnx = 9 then 3.4 
WHEN row = 14 and columnx = 10 then 4.36 
WHEN row = 14 and columnx = 11 then 5.21 
WHEN row = 14 and columnx = 12 then 5.97 
WHEN row = 14 and columnx = 13 then 6.68 
WHEN row = 14 and columnx = 14 then 7.97 
WHEN row = 14 and columnx = 15 then 10.23 
WHEN row = 14 and columnx = 16 then 12.2 
WHEN row = 14 and columnx = 17 then 13.99 
WHEN row = 15 and columnx = 1 then 0.56 
WHEN row = 15 and columnx = 2 then 0.8 
WHEN row = 15 and columnx = 3 then 1 
WHEN row = 15 and columnx = 4 then 1.16 
WHEN row = 15 and columnx = 5 then 1.3 
WHEN row = 15 and columnx = 6 then 1.81 
WHEN row = 15 and columnx = 7 then 2.82 
WHEN row = 15 and columnx = 8 then 3.65 
WHEN row = 15 and columnx = 9 then 4.39 
WHEN row = 15 and columnx = 10 then 5.69 
WHEN row = 15 and columnx = 11 then 6.83 
WHEN row = 15 and columnx = 12 then 7.88 
WHEN row = 15 and columnx = 13 then 8.86 
WHEN row = 15 and columnx = 14 then 10.65 
WHEN row = 15 and columnx = 15 then 13.8 
WHEN row = 15 and columnx = 16 then 16.58 
WHEN row = 15 and columnx = 17 then 19.13 
WHEN row = 16 and columnx = 1 then 0.59 
WHEN row = 16 and columnx = 2 then 0.89 
WHEN row = 16 and columnx = 3 then 1.13 
WHEN row = 16 and columnx = 4 then 1.34 
WHEN row = 16 and columnx = 5 then 1.53 
WHEN row = 16 and columnx = 6 then 2.15 
WHEN row = 16 and columnx = 7 then 3.39 
WHEN row = 16 and columnx = 8 then 4.42 
WHEN row = 16 and columnx = 9 then 5.34 
WHEN row = 16 and columnx = 10 then 6.98 
WHEN row = 16 and columnx = 11 then 8.43 
WHEN row = 16 and columnx = 12 then 9.76 
WHEN row = 16 and columnx = 13 then 11.01 
WHEN row = 16 and columnx = 14 then 13.3 
WHEN row = 16 and columnx = 15 then 17.37 
WHEN row = 16 and columnx = 16 then 20.99 
WHEN row = 16 and columnx = 17 then 24.31 
WHEN row = 17 and columnx = 1 then 0.65 
WHEN row = 17 and columnx = 2 then 1.05 
WHEN row = 17 and columnx = 3 then 1.38 
WHEN row = 17 and columnx = 4 then 1.68 
WHEN row = 17 and columnx = 5 then 1.95 
WHEN row = 17 and columnx = 6 then 2.77 
WHEN row = 17 and columnx = 7 then 4.45 
WHEN row = 17 and columnx = 8 then 5.87 
WHEN row = 17 and columnx = 9 then 7.14 
WHEN row = 17 and columnx = 10 then 9.43 
WHEN row = 17 and columnx = 11 then 11.47 
WHEN row = 17 and columnx = 12 then 13.37 
WHEN row = 17 and columnx = 13 then 15.14 
WHEN row = 17 and columnx = 14 then 18.43 
WHEN row = 17 and columnx = 15 then 24.32 
WHEN row = 17 and columnx = 16 then 29.6 
WHEN row = 17 and columnx = 17 then 34.48 
WHEN row = 18 and columnx = 1 then 0.71 
WHEN row = 18 and columnx = 2 then 1.18 
WHEN row = 18 and columnx = 3 then 1.59 
WHEN row = 18 and columnx = 4 then 1.97 
WHEN row = 18 and columnx = 5 then 2.32 
WHEN row = 18 and columnx = 6 then 3.32 
WHEN row = 18 and columnx = 7 then 5.4 
WHEN row = 18 and columnx = 8 then 7.17 
WHEN row = 18 and columnx = 9 then 8.78 
WHEN row = 18 and columnx = 10 then 11.66 
WHEN row = 18 and columnx = 11 then 14.26 
WHEN row = 18 and columnx = 12 then 16.67 
WHEN row = 18 and columnx = 13 then 18.94 
WHEN row = 18 and columnx = 14 then 23.17 
WHEN row = 18 and columnx = 15 then 30.78 
WHEN row = 18 and columnx = 16 then 37.65 
WHEN row = 18 and columnx = 17 then 44.02 
WHEN row = 19 and columnx = 1 then 0.76 
WHEN row = 19 and columnx = 2 then 1.3 
WHEN row = 19 and columnx = 3 then 1.78 
WHEN row = 19 and columnx = 4 then 2.23 
WHEN row = 19 and columnx = 5 then 2.65 
WHEN row = 19 and columnx = 6 then 3.81 
WHEN row = 19 and columnx = 7 then 6.24 
WHEN row = 19 and columnx = 8 then 8.33 
WHEN row = 19 and columnx = 9 then 10.23 
WHEN row = 19 and columnx = 10 then 13.65 
WHEN row = 19 and columnx = 11 then 16.76 
WHEN row = 19 and columnx = 12 then 19.64 
WHEN row = 19 and columnx = 13 then 22.36 
WHEN row = 19 and columnx = 14 then 27.45 
WHEN row = 19 and columnx = 15 then 36.63 
WHEN row = 19 and columnx = 16 then 44.96 
WHEN row = 19 and columnx = 17 then 52.7 Else 53 END as mu_LS 
INTO #step4 
FROM #step3

SELECT distinct
 LEFT(State_County_ID, 2) as st_alpha_fips_cd
, cast(case  
 WHEN LEFT(State_County_ID, 2) like 'AK' THEN 02
 WHEN LEFT(State_County_ID, 2) like 'AL' THEN 01
 WHEN LEFT(State_County_ID, 2) like 'AR' THEN 05
 WHEN LEFT(State_County_ID, 2) like 'AS' THEN 60
 WHEN LEFT(State_County_ID, 2) like 'AZ' THEN 04
 WHEN LEFT(State_County_ID, 2) like 'CA' THEN 06
 WHEN LEFT(State_County_ID, 2) like 'CO' THEN 08
 WHEN LEFT(State_County_ID, 2) like 'CT' THEN 09
 WHEN LEFT(State_County_ID, 2) like 'DC' THEN 11
 WHEN LEFT(State_County_ID, 2) like 'DE' THEN 10
 WHEN LEFT(State_County_ID, 2) like 'FL' THEN 12
 WHEN LEFT(State_County_ID, 2) like 'GA' THEN 13
 WHEN LEFT(State_County_ID, 2) like 'GU' THEN 66
 WHEN LEFT(State_County_ID, 2) like 'HI' THEN 15
 WHEN LEFT(State_County_ID, 2) like 'IA' THEN 19
 WHEN LEFT(State_County_ID, 2) like 'ID' THEN 16
 WHEN LEFT(State_County_ID, 2) like 'IL' THEN 17
 WHEN LEFT(State_County_ID, 2) like 'IN' THEN 18
 WHEN LEFT(State_County_ID, 2) like 'KS' THEN 20
 WHEN LEFT(State_County_ID, 2) like 'KY' THEN 21
 WHEN LEFT(State_County_ID, 2) like 'LA' THEN 22
 WHEN LEFT(State_County_ID, 2) like 'MA' THEN 25
 WHEN LEFT(State_County_ID, 2) like 'MD' THEN 24
 WHEN LEFT(State_County_ID, 2) like 'ME' THEN 23
 WHEN LEFT(State_County_ID, 2) like 'MI' THEN 26
 WHEN LEFT(State_County_ID, 2) like 'MN' THEN 27
 WHEN LEFT(State_County_ID, 2) like 'MO' THEN 29
 WHEN LEFT(State_County_ID, 2) like 'MS' THEN 28
 WHEN LEFT(State_County_ID, 2) like 'MT' THEN 30
 WHEN LEFT(State_County_ID, 2) like 'NC' THEN 37
 WHEN LEFT(State_County_ID, 2) like 'ND' THEN 38
 WHEN LEFT(State_County_ID, 2) like 'NE' THEN 31
 WHEN LEFT(State_County_ID, 2) like 'NH' THEN 33
 WHEN LEFT(State_County_ID, 2) like 'NJ' THEN 34
 WHEN LEFT(State_County_ID, 2) like 'NM' THEN 35
 WHEN LEFT(State_County_ID, 2) like 'NV' THEN 32
 WHEN LEFT(State_County_ID, 2) like 'NY' THEN 36
 WHEN LEFT(State_County_ID, 2) like 'OH' THEN 39
 WHEN LEFT(State_County_ID, 2) like 'OK' THEN 40
 WHEN LEFT(State_County_ID, 2) like 'OR' THEN 41
 WHEN LEFT(State_County_ID, 2) like 'PA' THEN 42
 WHEN LEFT(State_County_ID, 2) like 'PR' THEN 72
 WHEN LEFT(State_County_ID, 2) like 'RI' THEN 44
 WHEN LEFT(State_County_ID, 2) like 'SC' THEN 45
 WHEN LEFT(State_County_ID, 2) like 'SD' THEN 46
 WHEN LEFT(State_County_ID, 2) like 'TN' THEN 47
 WHEN LEFT(State_County_ID, 2) like 'TX' THEN 48
 WHEN LEFT(State_County_ID, 2) like 'UT' THEN 49
 WHEN LEFT(State_County_ID, 2) like 'VA' THEN 51
 WHEN LEFT(State_County_ID, 2) like 'VI' THEN 78
 WHEN LEFT(State_County_ID, 2) like 'VT' THEN 50
 WHEN LEFT(State_County_ID, 2) like 'WA' THEN 53
 WHEN LEFT(State_County_ID, 2) like 'WI' THEN 55
 WHEN LEFT(State_County_ID, 2) like 'WV' THEN 54
 WHEN LEFT(State_County_ID, 2) like 'WY' THEN 56 END as varchar)
 as st_fips_cd
, RIGHT(State_County_ID, 3) as cnty_fips_cd
, Soil_Survey_Area_ID as soil_srvy_ar_cd
, musym as soil_map_unit_cd
, mu_kfactor as wtr_erod_fctr
, mu_tfactor as soil_loss_tolr_fctr
, mu_ifactor as wind_erod_idx
, mu_LS as soil_slp_lgth_fctr
, llpine as long_leaf_suit_ind
, WESL as wesl_ind
, mu_leach as soil_lch_ind
, source
, cast(NCCPI_Value_dcp as decimal(3,2)) as NCCPI
, nirrcapclass
FROM #step4 
INNER JOIN #step1 on #step1.cokey=#step4.cokey
WHERE LEFT(nirrcapclass, 1) < 5
ORDER BY st_alpha_fips_cd, cnty_fips_cd, musym
