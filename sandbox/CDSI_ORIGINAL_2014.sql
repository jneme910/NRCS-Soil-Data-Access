SELECT areasymbol, areaname, mukey, musym, nationalmusym, muname, mukind, muacres
INTO #allmapunits
FROM legend
INNER JOIN mapunit on legend.lkey=mapunit.lkey and left(areasymbol,2) like 'VA'


SELECT
-- grab survey area data
LEFT((areasymbol), 2) as state
, l.areasymbol
, l.areaname
--take the worst case R and C factor for resource planning if multiples appear in a survey area
, (SELECT TOP 1 (CAST (laoverlap.areasymbol AS int)) FROM laoverlap WHERE laoverlap.areatypename Like 'Rainfall Factor Area%' and l.lkey=laoverlap.lkey GROUP BY laoverlap.areasymbol ORDER BY laoverlap.areasymbol desc) as Rfact
, (SELECT TOP 1 (CAST (laoverlap.areasymbol AS int)) FROM laoverlap WHERE laoverlap.areatypename Like 'Climate Factor Area%' and l.lkey=laoverlap.lkey GROUP BY laoverlap.areasymbol ORDER BY laoverlap.areasymbol desc) as Cfact

--grab map unit level information

, mu.mukey
, mu.musym
, farmlndcl

--grab component level information

, c.majcompflag
, c.comppct_r
, c.compname
, compkind
, (mu.muacres*c.comppct_r/100) AS compacres
, localphase
, slope_l
, slope_r
, slope_h
, CASE WHEN slopelenusle_r is not null Then (slopelenusle_r * 3.28)
      WHEN slope_r >= 0 And slope_r < 0.75 Then 100
      WHEN slope_r >= 0.75 And slope_r < 1.5 Then 200
      WHEN slope_r >= 1.5 And slope_r < 2.5 Then 300
      WHEN slope_r >= 2.5 And slope_r < 3.5 Then 200
      WHEN slope_r >= 3.5 And slope_r < 4.5 Then 180
      WHEN slope_r >= 4.5 And slope_r < 5.5 Then 160
      WHEN slope_r >= 5.5 And slope_r < 6.5 Then 150
      WHEN slope_r >= 6.5 And slope_r < 7.5 Then 140
      WHEN slope_r >= 7.5 And slope_r < 8.5 Then 130
      WHEN slope_r >= 8.5 And slope_r < 9.5 Then 125
      WHEN slope_r >= 9.5 And slope_r < 10.5 Then 120
      WHEN slope_r >= 10.5 And slope_r < 11.5 Then 110
      WHEN slope_r >= 11.5 And slope_r < 12.5 Then 100
      WHEN slope_r >= 12.5 And slope_r < 13.5 Then 90
      WHEN slope_r >= 13.5 And slope_r < 14.5 Then 80
      WHEN slope_r >= 14.5 And slope_r < 15.5 Then 70
      WHEN slope_r >= 15.5 And slope_r < 17.5 Then 60
      Else 50 END as slopelenusle_r
, (slopelenusle_r*3.28) AS slopelengthFT
, (SELECT CASE    
       WHEN slope_r <1 THEN 0.2223
       WHEN slope_r <2 THEN 0.2684
       WHEN slope_r <3 THEN 0.3348
       WHEN slope_r <4 THEN 0.4001
       WHEN slope_r <5 THEN 0.4465
       WHEN slope_r <6 THEN 0.4732
       WHEN slope_r <7 THEN 0.4869
       WHEN slope_r <8 THEN 0.4936
       WHEN slope_r <9 THEN 0.4969
       WHEN slope_r <10 THEN 0.4985
       ELSE 0.5
       END) AS mexp_h
, case when nirrcapscl is null then nirrcapcl else nirrcapcl + nirrcapscl end as nirrcapclass
, case when irrcapscl is null then irrcapcl else irrcapcl + irrcapscl end as irrcapclass
, drainagecl
, runoff
, hydgrp
, hydgrpdcd
, hydricrating
, hydclprs
, (SELECT TOP 1 hydriccriterion FROM cohydriccriteria WHERE c.cokey = cohydriccriteria.cokey) as hydric_criteria
, corsteel
, corcon
, frostact
, tfact
, weg
, wei
, (SELECT TOP 1 coecoclass.ecoclassid FROM component LEFT OUTER JOIN coecoclass on component.cokey = coecoclass.cokey WHERE coecoclass.cokey = c.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database' order by ecoclassid) as ecositeID
, (SELECT TOP 1 coecoclass.ecoclassname FROM component LEFT OUTER JOIN coecoclass on component.cokey = coecoclass.cokey WHERE coecoclass.cokey = c.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database' order by ecoclassid) as ecositename
, constreeshrubgrp
, (SELECT TOP 1 coecoclass.ecoclassid FROM component INNER JOIN coecoclass on component.cokey = coecoclass.cokey and ecoclasstypename like 'Forage Suitability Groups' WHERE coecoclass.cokey = c.cokey ) as foragesuitgroupid
, (SELECT TOP 1 coecoclass.ecoclassname FROM component INNER JOIN coecoclass on component.cokey = coecoclass.cokey and ecoclasstypename like 'Forage Suitability Groups' WHERE coecoclass.cokey = c.cokey ) as foragesuitgroupname
, foragesuitgrpid
, rsprod_r
, taxclname
, taxorder
, taxsuborder
, taxgrtgroup
, taxsubgrp
, taxtempregime
, taxpartsize

--parent material and geomorphology information

, (SELECT TOP 1 copmgrp.pmgroupname FROM copmgrp WHERE c.cokey = copmgrp.cokey AND copmgrp.rvindicator='yes') as pm
, (SELECT TOP 1 cogeomordesc.geomfname FROM cogeomordesc WHERE c.cokey = cogeomordesc.cokey AND cogeomordesc.rvindicator='yes' and cogeomordesc.geomftname = 'Landform' ORDER BY geomfeatid)  as landform

--water table data for annual and for growing season

,(select CAST(min(soimoistdept_r/2.54) as integer) from component left outer join comonth left outer join cosoilmoist 
           on comonth.comonthkey = cosoilmoist.comonthkey
           on comonth.cokey = component.cokey
       where component.cokey = c.cokey
         and soimoiststat = 'Wet'
         and ((taxtempregime in ('Cryic', 'Pergelic') and comonth.month in ('July', 'August')) 
         or (taxtempregime in ('Frigid', 'Mesic', 'Isofrigid') and comonth.month in ('May', 'June',  'July', 'August', 'September')) 
         or (taxtempregime in ('Thermic', 'Hyperthermic') and comonth.month in ('April', 'May', 'June',  'July', 'August', 'September', 'October')) 
         or (taxtempregime in ('Isothermic', 'Isohyperthermic', 'Isomesic') 
         and comonth.month in ('March', 'April', 'May', 'June',  'July', 'August', 'September', 'October', 'November')))) as minGSwatertable_r

, (select CAST(max(soimoistdept_r/2.54) as int) 
         from component left outer join comonth left outer join cosoilmoist 
           on comonth.comonthkey = cosoilmoist.comonthkey
           on comonth.cokey = component.cokey
       where component.cokey = c.cokey
         and soimoiststat = 'Wet'
        and ((taxtempregime in ('Cryic', 'Pergelic') and comonth.month in ('July', 'August')) 
        or (taxtempregime in ('Frigid', 'Mesic', 'Isofrigid') and comonth.month in ('May', 'June',  'July', 'August', 'September')) 
        or (taxtempregime in ('Thermic', 'Hyperthermic') and comonth.month in ('April', 'May', 'June',  'July', 'August', 'September', 'October')) 
        or (taxtempregime in ('Isothermic', 'Isohyperthermic', 'Isomesic')  
        and comonth.month in ('March', 'April', 'May', 'June',  'July', 'August', 'September', 'October', 'November')))) as maxGSwatertable_r

, (select CAST(min(soimoistdept_r/2.54) as int) 
         from component left outer join comonth left outer join cosoilmoist 
           on comonth.comonthkey = cosoilmoist.comonthkey
           on comonth.cokey = component.cokey
       where component.cokey = c.cokey
         and soimoiststat = 'Wet') as minANwatertable_r

, (select CAST(max(soimoistdept_r/2.54) as int) 
         from component left outer join comonth left outer join cosoilmoist 
           on comonth.comonthkey = cosoilmoist.comonthkey
           on comonth.cokey = component.cokey
       where component.cokey = c.cokey
         and soimoiststat = 'Wet') as maxANwatertable_r


--the first annual flooding and ponding events populated in the month table sorted by worst case

,(select top 1 flodfreqcl from comonth, MetadataDomainMaster dm, MetadataDomainDetail dd where comonth.cokey = c.cokey and flodfreqcl = ChoiceLabel and DomainName = 'flooding_frequency_class' and 
dm.DomainID = dd.DomainID order by choicesequence desc) as annflodfreq
, (select top 1 floddurcl from comonth, MetadataDomainMaster dm, MetadataDomainDetail dd where comonth.cokey = c.cokey and floddurcl = ChoiceLabel and DomainName = 'flooding_duration_class' and 
dm.DomainID = dd.DomainID order by choicesequence desc) as annfloddur
,(select top 1 pondfreqcl from comonth, MetadataDomainMaster dm, MetadataDomainDetail dd where comonth.cokey = c.cokey and pondfreqcl = ChoiceLabel and DomainName = 'ponding_frequency_class' and 
dm.DomainID = dd.DomainID order by choicesequence desc) as annpondfreq
,(select top 1 ponddurcl from comonth, MetadataDomainMaster dm, MetadataDomainDetail dd where comonth.cokey = c.cokey and ponddurcl = ChoiceLabel and DomainName = 'ponding_duration_class' and 
dm.DomainID = dd.DomainID order by choicesequence desc) as annponddur

--grab the first restriction I still need to take the restriction_In query and 
---do the same for all those that put 500 or 0 in the result
--- need to set a default restriction depth - trying to make it ithe max hzdepb_r and got an error

,(SELECT cast(min(resdept_r) as integer) from component left outer join corestrictions on component.cokey = corestrictions.cokey where component.cokey = c.cokey and reskind is not null) as restrictiondepth

,(SELECT CASE when min(resdept_r) is null then 200 else cast(min(resdept_r) as int) END from component left outer join corestrictions on component.cokey = corestrictions.cokey where component.cokey = c.cokey and reskind is not null) as restrictiodepth

,(SELECT TOP 1  reskind  from component left outer join corestrictions on component.cokey = corestrictions.cokey where component.cokey = c.cokey and reskind is not null order by resdept_r) as TOPrestriction, c.cokey

--grab selected interpretations

, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)') as NCCPI_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)') as NCCPI_Value_dcp

, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Corn and soybeans') as Nccpi_Corn_Soybeans_Class_dcp 
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Corn and soybeans') as Nccpi_Corn_Soybeans_Value_dcp 

, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Small grains') as Nccpi_SmallGrains_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Small grains') as Nccpi_SmallGrains_Value_dcp

, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Cotton') as Nccpi_Cotton_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 1 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)' and interphrc like 'Cotton') as Nccpi_Cotton_Value_dcp  

, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'ENG - Shallow Excavations') as DShal_Excav_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'ENG - Shallow Excavations') as DShal_Excav_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'DHS - Catastrophic Mortality, Large Animal Disposal, Pit') as DHS_Pit_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'DHS - Catastrophic Mortality, Large Animal Disposal, Pit') as DHS_Pit_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'Ground Penetrating Radar Penetration') as GPR_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'Ground Penetrating Radar Penetration') as GPR_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'ENG - Septic Tank Absorption Fields') as Septic_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'ENG - Septic Tank Absorption Fields') as Septic_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'FOR - Potential Fire Damage Hazard') as Fire_Haz__Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'FOR - Potential Fire Damage Hazard') as Fire_Haz_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'WMS - Irrigation, Sprinkler (general)') as Sprinkler_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'WMS - Irrigation, Sprinkler (general)') as Sprinkler_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'DHS - Suitability for Clay Liner Material') as Liner_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'DHS - Suitability for Clay Liner Material') as Liner_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'FOR - Potential Erosion Hazard (Off-Road/Off-Trail)') as Off_Trail_Erosion_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'FOR - Potential Erosion Hazard (Off-Road/Off-Trail)') as Off_Trail_Erosion_Rating_dcp
, (SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'FOR - Potential Erosion Hazard (Road/Trail)') as Trail_Erosion_Class_dcp
, (SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey WHERE component.cokey = c.cokey AND ruledepth = 0 AND 
mrulename like 'FOR - Potential Erosion Hazard (Road/Trail)') as Trail_Erosion_Rating_dcp



---begin selection of horizon properties

, hzname
, hzdept_r
, hzdepb_r
, case when (hzdepb_r-hzdept_r) is null then 0 else cast((hzdepb_r-hzdept_r)  as int) END as thickness  
--  thickness in inches
, (select CASE when sum(cf.fragvol_r) is null then 0 else cast(sum(cf.fragvol_r) as INT) END FROM chfrags cf WHERE cf.chkey = ch.chkey) as fragvol
, texture
, (select top 1 unifiedcl from chorizon left outer join chunified on chorizon.chkey = chunified.chkey where chorizon.chkey = ch.chkey and chunified.rvindicator like 'yes') as unified
, (select top 1 aashtocl from chorizon left outer join chaashto on chorizon.chkey = chaashto.chkey where chorizon.chkey = ch.chkey and chaashto.rvindicator like 'yes') as aashto
, kffact
, kwfact
, sandtotal_r
, sandvc_r
, sandco_r
, sandmed_r
, sandfine_r
, sandvf_r
, silttotal_r
, claytotal_r
, pi_r
, ll_r
, om_r
, awc_r
, ksat_r
, dbthirdbar_r
, dbovendry_r
, lep_r
, wtenthbar_r
, wthirdbar_r
, wfifteenbar_r
, ph1to1h2o_r
, ph01mcacl2_r
, caco3_r
, cec7_r
, ecec_r
, ec_r
, sar_r
, gypsum_r
, aws025wta
, aws050wta
, aws0100wta
, aws0150wta
, brockdepmin
, wtdepannmin
, wtdepaprjunmin
, ch.chkey
INTO #cdsi
FROM legend l
--INNER JOIN mapunit mu ON mu.lkey = l.lkey 
INNER JOIN mapunit AS mu ON mu.lkey = l.lkey and LEFT(l.areasymbol, 2) like 'VA'
INNER JOIN muaggatt mt on mu.mukey=mt.mukey
INNER JOIN component c ON c.mukey = mu.mukey and majcompflag = 'yes' AND c.cokey = (SELECT TOP 1 c.cokey FROM component c WHERE c.mukey=mu.mukey and compkind not like 'miscellaneous area' ORDER BY c.comppct_r DESC )
INNER JOIN chorizon ch ON ch.cokey = c.cokey and hzdept_r is not null
INNER JOIN chtexturegrp ct ON ch.chkey=ct.chkey and ct.rvindicator = 'yes'
ORDER by l.areasymbol, mu.musym, hzdept_r 

---grab top depth for the mineral soil and will use it later to get mineral surface properties

SELECT compname, cokey, MIN(hzdept_r) AS min_t
INTO #hortopdepth
FROM #cdsi
WHERE texture NOT LIKE '%PM%' and texture NOT LIKE '%DOM' and texture NOT LIKE '%MPT%' and texture NOT LIKE '%MUCK' and texture NOT LIKE '%PEAT%'
GROUP BY compname, cokey

---combine the mineral surface to grab surface mineral properties

Select #hortopdepth.cokey
, hzname
, hzdept_r
, hzdepb_r
, thickness
, fragvol as fragvol_surf
, texture as texture_surf
, unified  as unified_surf
, aashto as aashto_surf
, kffact as Kffact_surf
, kwfact as kwfact_surf
, sandtotal_r as sandtotal_surf
, sandvc_r as sandvc_surf
, sandco_r as sandco_surf
, sandmed_r as sandmed_surf
, sandfine_r as sandfine_surf
, sandvf_r as sandvf_surf
, silttotal_r as silttotal_surf
, claytotal_r as claytotal_surf
, pi_r as pi_surf
, ll_r as ll_surf
, om_r as om_surf
, awc_r as awc_surf
, ksat_r as ksat_surf
, dbthirdbar_r as dbthirdbar_surf
, dbovendry_r as dbovendry_surf
, lep_r as lep_surf
, wtenthbar_r as wtenthbar_surf
, wthirdbar_r as wthirdbar_surf
, wfifteenbar_r as wfifteenbar_surf
, ph1to1h2o_r as ph1to1h2o_surf
, ph01mcacl2_r as ph01mcacl2_surf
, caco3_r as caco3_surf
, cec7_r as cec7_surf
, ecec_r as ecec_surf
, ec_r as ec_surf
, sar_r as sar_surf
, gypsum_r as gypsum_surf
, chkey
INTO #cdsi2
FROM #hortopdepth
INNER JOIN #cdsi on #hortopdepth.cokey=#cdsi.cokey AND #hortopdepth.min_t = #cdsi.hzdept_r
ORDER BY #hortopdepth.cokey, hzname


---good to here, now to build master the quote HEL unquote query, found top mineral horizon and 
---grabbed the first horion data


SELECT ((0.065 + (0.0456 * slope_r) + (0.006541*Power(slope_r, 2)))*Power((slopelenusle_r / 22.1) , mexp_h)) AS LS_r, k.cokey, k.mukey
INTO #LS
FROM #cdsi k

SELECT LS_R, (LS_R * Rfact * Kwfact_surf)/tfact as EI, #LS.cokey, #LS.mukey
INTO #EIByComp
From #LS
INNER JOIN #cdsi ON #LS.cokey = #cdsi.cokey
INNER JOIN #cdsi2 on #LS.cokey = #cdsi2.cokey

Select Max(EI) as MostLimitingEI, m.mukey, m.muname, l.areasymbol, LS_R
INTO #EIFinal
From Legend l
inner join mapunit m on m.lkey = l.lkey
inner join #eibycomp ei on ei.mukey = m.mukey
Group by m.mukey, m.mukey, m.muname, l.areasymbol, LS_R

-- HEL data is finished, now time to gather the select max values from the profile ---
--the next step is to build weighted averages of the properties and to do 
---that I have to make null values zero sql

--horizon data

SELECT
mukey
, cokey
, hzname
--, case when restrictiodepth = 0 then 10 else restrictiodepth END as 
, restrictiodepth 
, hzdept_r
, hzdepb_r
, case when (hzdepb_r-hzdept_r) is null then 0 else cast((hzdepb_r-hzdept_r)  as int) END as thickness
, (select CASE when sum(fragvol) is null then 0 else cast(sum(fragvol) as varchar) END FROM #cdsi)  as fragvol
, texture
, unified  
, kffact
, kwfact
, CASE when sandtotal_r is null then 0 else sandtotal_r end as sandtotal_r
, CASE when sandvc_r is null then 0 else sandvc_r end as sandvc_r
, CASE when sandco_r is null then 0 else sandco_r end as sandco_r
, CASE when sandmed_r is null then 0 else sandmed_r end as sandmed_r
, CASE when sandfine_r is null then 0 else sandfine_r end as sandfine_r
, CASE when sandvf_r is null then 0 else sandvf_r end as sandvf_r
, CASE when silttotal_r is null then 0 else silttotal_r end as silttotal_r
, CASE when claytotal_r is null then 0 else claytotal_r end as claytotal_r
, CASE when pi_r is null then 0 else pi_r end as pi_r
, CASE when ll_r is null then 0 else ll_r end as ll_r
, CASE when om_r is null then 0 else om_r end as om_r
, CASE when awc_r is null then 0 else awc_r end as awc_r
, CASE when ksat_r is null then 0 else ksat_r end as ksat_r
, CASE when dbthirdbar_r is null then 0 else dbthirdbar_r end as dbthirdbar_r
, CASE when dbovendry_r is null then 0 else dbovendry_r end as dbovendry_r
, CASE when lep_r is null then 0 else lep_r end as lep_r
, CASE when wtenthbar_r is null then 0 else wtenthbar_r end as wtenthbar_r
, CASE when wthirdbar_r is null then 0 else wthirdbar_r end as wthirdbar_r
, CASE when wfifteenbar_r is null then 0 else wfifteenbar_r end as wfifteenbar_r
, CASE when ph1to1h2o_r is null then 0 else ph1to1h2o_r end as ph1to1h2o_r
, CASE when ph01mcacl2_r is null then 0 else ph01mcacl2_r end as ph01mcacl2_r
, CASE when caco3_r is null then 0 else caco3_r end as caco3_r
, CASE when cec7_r is null then 0 else cec7_r end as cec7_r
, CASE when ecec_r is null then 0 else ecec_r end as ecec_r
, CASE when ec_r is null then 0 else ec_r end as ec_r
, CASE when sar_r is null then 0 else sar_r end as sar_r
, CASE when gypsum_r is null then 0 else gypsum_r end as gypsum_r
, chkey
INTO #cdsihzn
FROM #cdsi

--- depth ranges for AWS ----

Select 
CASE    WHEN hzdepb_r <= 100 THEN hzdepb_r
   WHEN hzdepb_r > 100 and hzdept_r < 100 THEN 100
   ELSE 0
   END AS InRangeBot,
CASE    WHEN hzdept_r < 100 then hzdept_r
   ELSE 0
   END as InRangeTop, awc_r, cokey, mukey
INTO #aws
FROM #cdsi
order by cokey

select mukey, cokey, SUM((InRangeBot - InRangeTop)*awc_r) as AWS100
INTO #aws100
FROM #aws 
group by mukey, cokey

---return to weighted averages, using the thickness times the non-null horizon properties

SELECT mukey, cokey, chkey
, thickness
, restrictiodepth
, ( fragvol*thickness) as th_fragvol
, (sandtotal_r*thickness) as th_sand_r
, (sandvc_r*thickness) as th_vcos_r
, (sandco_r*thickness) as th_cos_r
, (sandmed_r*thickness) as th_meds_r
, (sandfine_r*thickness) as th_fines_r
, (sandvf_r*thickness) as th_vfines_r
, (silttotal_r*thickness) as th_silt_r
, (claytotal_r*thickness) as th_clay_r
, (om_r*thickness) as th_om_r
, (awc_r*thickness) as th_awc_r
, (ksat_r*thickness) as th_ksat_r
, (dbthirdbar_r*thickness) as th_dbthirdbar_r
, (dbovendry_r*thickness) as th_dbovendry_r
, (lep_r*thickness) as th_lep_r
, (pi_r*thickness) as th_pi_r
, (ll_r*thickness) as th_ll_r
, (wtenthbar_r*thickness) as th_wtenthbar_r
, (wthirdbar_r*thickness) as th_wthirdbar_r
, (wfifteenbar_r*thickness) as th_wfifteenbar_r
, (ph1to1h2o_r*thickness) as th_ph1to1h2o_r
, (ph01mcacl2_r*thickness) as th_ph01mcacl2_r
, (caco3_r*thickness) as th_caco3_r
, (cec7_r*thickness) as th_cec7_r
, (ecec_r*thickness) as th_ecec_r
, (ec_r*thickness) as th_ec_r
, (sar_r*thickness) as th_sar_r 
, (gypsum_r*thickness) as th_gypsum_r
INTO #cdsi3
FROM #cdsihzn 
ORDER BY mukey, cokey, chkey


---sum all horizon properties to gather the final product for the component

select mukey, cokey, restrictiodepth
, cast(sum(thickness) as float(2)) as sum_thickness
, cast(sum(th_fragvol) as float(2)) as sum_fragvol_r
, cast(sum(th_sand_r) as float(2)) as sum_sand_r
, cast(sum(th_vcos_r) as float(2)) as sum_vcos_r
, cast(sum(th_cos_r) as float(2)) as sum_cos_r
, cast(sum(th_meds_r) as float(2)) as sum_meds_r
, cast(sum(th_fines_r) as float(2)) as sum_fines_r
, cast(sum(th_vfines_r) as float(2)) as sum_vfines_r
, cast(sum(th_silt_r) as float(2)) as sum_silt_r
, cast(sum(th_clay_r) as float(2)) as sum_clay_r
, cast(sum(th_om_r) as float(2)) as sum_om_r
, cast(sum(th_awc_r) as float(2)) as sum_awc_r
, cast(sum(th_ksat_r) as float(2)) as sum_ksat_r
, cast(sum(th_dbthirdbar_r) as float(2)) as sum_dbthirdbar_r
, cast(sum(th_dbovendry_r) as float(2)) as sum_dbovendry_r
, cast(sum(th_lep_r) as float(2)) as sum_lep_r
, cast(sum(th_pi_r) as float(2)) as sum_pi_r
, cast(sum(th_ll_r) as float(2)) as sum_ll_r
, cast(sum(th_wtenthbar_r) as float(2)) as sum_wtenthbar_r
, cast(sum(th_wthirdbar_r) as float(2)) as sum_wthirdbar_r
, cast(sum(th_wfifteenbar_r) as float(2)) as sum_wfifteenbar_r
, cast(sum(th_ph1to1h2o_r) as float(2)) as sum_ph1to1h2o_r
, cast(sum(th_ph01mcacl2_r) as float(2)) as sum_ph01mcacl2_r
, cast(sum(th_caco3_r) as float(2)) as sum_caco3_r
, cast(sum(th_cec7_r) as float(2)) as sum_cec7_r
, cast(sum(th_ecec_r) as float(2)) as sum_ecec_r
, cast(sum(th_ec_r) as float(2)) as sum_ec_r
, cast(sum(th_sar_r) as float(2)) as sum_sar_r
, cast(sum(th_gypsum_r) as float(2)) as sum_gypsum_r
INTO #cdsi4
FROM #cdsi3
GROUP BY mukey, cokey, restrictiodepth 
ORDER BY mukey

---find the depth to use in the weighted average calculation 

SELECT mukey, cokey, case when sum_thickness < restrictiodepth then sum_thickness  else restrictiodepth end as restrictiondepth
INTO #depthtest
FROM #cdsi4



---sql to create weighted average by dividing by the restriction depth found in the above query

select #cdsi4.mukey, #cdsi4.cokey
, sum_thickness
---, restrictiodepth
, #depthtest.restrictiondepth
, (sum_fragvol_r/#depthtest.restrictiondepth) as wtavg_fragvol_r
, (sum_sand_r/#depthtest.restrictiondepth) as wtavg_sand_r
, (sum_vcos_r/#depthtest.restrictiondepth) as wtavg_vcos_r
, (sum_cos_r/#depthtest.restrictiondepth) as wtavg_cos_r
, (sum_meds_r/#depthtest.restrictiondepth) as wtavg_meds_r
, (sum_fines_r/#depthtest.restrictiondepth) as wtavg_fines_r
, (sum_vfines_r/#depthtest.restrictiondepth) as wtavg_vfines_r
, (sum_silt_r/#depthtest.restrictiondepth) as wtavg_silt_r
, (sum_clay_r/#depthtest.restrictiondepth) as wtavg_clay_r
, (sum_om_r/#depthtest.restrictiondepth) as wtavg_om_r
, (sum_awc_r) as profile_Waterstorage
, (sum_awc_r/#depthtest.restrictiondepth) as wtavg_awc_r_to_restrict
, (sum_ksat_r/#depthtest.restrictiondepth) as wtavg_ksat_r
, (sum_dbthirdbar_r/#depthtest.restrictiondepth) as wtavg_dbthirdbar_r
, (sum_dbovendry_r/#depthtest.restrictiondepth) as wtavg_dbovendry_r
, (sum_lep_r/#depthtest.restrictiondepth) as wtavg_lep_r
, (sum_pi_r/#depthtest.restrictiondepth) as wtavg_pi_r
, (sum_ll_r/#depthtest.restrictiondepth) as wtavg_ll_r
, (sum_wtenthbar_r/#depthtest.restrictiondepth) as wtavg_wtenthbar_r
, (sum_wthirdbar_r/#depthtest.restrictiondepth) as wtavg_wthirdbar_r
, (sum_wfifteenbar_r/#depthtest.restrictiondepth) as wtavg_wfifteenbar_r
, (sum_ph1to1h2o_r/#depthtest.restrictiondepth) as wtavg_phH2O_r
, (sum_ph01mcacl2_r/#depthtest.restrictiondepth) as wtavg_phCACL_r
, (sum_caco3_r/#depthtest.restrictiondepth) as wtavg_caco3_r
, (sum_cec7_r/#depthtest.restrictiondepth) as wtavg_cec7_r
, (sum_ecec_r/#depthtest.restrictiondepth) as wtavg_ecec_r
, (sum_ec_r/#depthtest.restrictiondepth) as wtavg_ec_r
, (sum_sar_r/#depthtest.restrictiondepth) as wtavg_sar_r
, (sum_gypsum_r/#depthtest.restrictiondepth) as wtavg_gypsum_r 

INTO #CDSIwtavg 
FROM #cdsi4 
INNER JOIN #depthtest on #cdsi4.cokey=#depthtest.cokey
ORDER by #cdsi4.mukey, #cdsi4.cokey

--time to put it all together using a lot of casts to change the data to reflect the way I want it to appear

Select DISTINCT 
  #cdsi.state
, #cdsi.areasymbol
, #cdsi.areaname
, #cdsi.Rfact
, #cdsi.Cfact
, #cdsi.mukey
, #cdsi.musym
, #cdsi.cokey
, majcompflag
, comppct_r
, #cdsi.compname
, compkind
, compacres
, localphase
, slope_l
, slope_r
, slope_h
, farmlndcl
, nirrcapclass
, irrcapclass
, CAST(MostLimitingEI as Decimal(6,1)) as ErodibilityIndex
, CAST((((Cfact*wei)/tfact)/100) as Decimal(5, 1)) as WindErodIndex
, NCCPI_Class_dcp
, CAST(NCCPI_Value_dcp as Decimal(4,2)) as NCCPI_Value_dcp
, Nccpi_Corn_Soybeans_Class_dcp 
, CAST(Nccpi_Corn_Soybeans_Value_dcp as Decimal(4,2)) as Nccpi_Corn_Soybeans_Value_dcp
, Nccpi_SmallGrains_Class_dcp
, cast(Nccpi_SmallGrains_Value_dcp as Decimal(4,2)) as Nccpi_SmallGrains_Value_dcp
, Nccpi_Cotton_Class_dcp
, CAST (Nccpi_Cotton_Value_dcp as Decimal(4,2)) as Nccpi_Cotton_Value_dcp
, DShal_Excav_Class_dcp
, cast(DShal_Excav_Rating_dcp as Decimal(3,1)) as DShal_Excav_Rating_dcp
, DHS_Pit_Class_dcp
, cast(DHS_Pit_Rating_dcp as Decimal(3,1)) as DHS_Pit_Rating_dcp
, GPR_Class_dcp
, cast(GPR_Rating_dcp as Decimal(3,1)) as GPR_Rating_dcp
, Septic_Class_dcp
, cast(Septic_Rating_dcp as Decimal(3,1)) as Septic_Rating_dcp
, Fire_Haz__Class_dcp
, cast(Fire_Haz_Rating_dcp as Decimal(3,1)) as Fire_Haz_Rating_dcp
, Liner_Class_dcp
, cast(Liner_Rating_dcp as Decimal(3,1)) as Liner_Rating_dcp
, Sprinkler_Class_dcp
, cast(Sprinkler_Rating_dcp as Decimal(3,1)) as Sprinkler_Rating_dcp
, Trail_Erosion_Class_dcp
, cast(Trail_Erosion_Rating_dcp as Decimal(3,1)) as Trail_Erosion_Rating_dcp
, Off_Trail_Erosion_Class_dcp
, cast(Off_Trail_Erosion_Rating_dcp as Decimal(3,1)) as Off_Trail_Erosion_Rating_dcp
, corsteel
, corcon
, drainagecl
, runoff
, hydgrp
, hydgrpdcd
, CAST(AWS100 AS Decimal(5,1)) as AWS100_dcp
, CAST(profile_Waterstorage AS Decimal(5,1)) as AWS_profile_dcp
, CAST(wtavg_awc_r_to_restrict AS Decimal(5,1)) as AWS_restrict_dcp
, hydricrating
, hydric_criteria
, hydclprs
, ecositeID
, ecositename
, rsprod_r
, constreeshrubgrp
, foragesuitgrpid
, foragesuitgroupid
, foragesuitgroupname
, taxclname
, taxorder
, taxsuborder
, taxgrtgroup
, taxsubgrp
, taxtempregime
, taxpartsize
, pm
, landform
, sum_thickness
, cast(#CDSIwtavg.restrictiondepth/2.54 as int) restrictiondepth_IN
, #CDSIwtavg.restrictiondepth
, TOPrestriction
, maxANwatertable_r
, minANwatertable_r
, maxGSwatertable_r
, minGSwatertable_r
, annflodfreq
, annfloddur
, annpondfreq
, annponddur
, frostact
, #cdsi2.chkey
, #cdsi2.hzname
, cast(#cdsi2.hzdept_r/2.54 as int) as hzdept_r
, cast(#cdsi2.hzdepb_r/2.54 as int) as hzdeb_r
, texture_surf
, unified_surf
, kffact_surf
, kwfact_surf
, tfact
, fragvol_surf
, CAST(sandtotal_surf AS INT) as sandtotal_surf
, CAST(wtavg_sand_r AS INT) as sand_wtavg_r  
, CAST(silttotal_surf  AS INT) as silttotal_surf
, CAST(wtavg_silt_r AS INT) as silt_wtavg_r 
, CAST(claytotal_surf  AS INT) as claytotal_surf
, CAST(wtavg_clay_r AS INT) as clay_wtavg_r 
, CAST(wtavg_lep_r AS INT) as lep_wtavg_r 
, om_surf
, CAST(wtavg_om_r as Decimal(5,1)) as om_wtavg_r
, CAST(ksat_surf * 0.1417 as Decimal(7,2)) as ksat_surf_in_hr
, CAST(wtavg_ksat_r * 0.1417 as Decimal(7,2)) as ksat_wtavg_r_in_hr
, ph1to1h2o_surf 
, CAST(wtavg_phH2O_r as decimal(7,1)) as pH_wtavg_r 
, caco3_surf 
, CAST(wtavg_caco3_r as decimal(7,1)) as caco3_wtavg_r
, cec7_surf
, CAST(wtavg_cec7_r as decimal(5,1)) as cec7_wtavg_r 
, ec_surf 
, CAST(wtavg_ec_r as decimal(5,1)) as ec_wtavg_r 
, sar_surf 
, CAST(wtavg_sar_r as decimal(5,1)) as sar_wtavg_r 
, gypsum_surf
, CAST(wtavg_gypsum_r as decimal(5,1)) as gypsum_wtavg_r
INTO #alldata
FROM #cdsi2
INNER JOIN #cdsi on #cdsi.cokey = #cdsi2.cokey 
LEFT OUTER JOIN #EIFinal on #cdsi.mukey = #EIFinal.mukey
LEFT OUTER JOIN #aws100 on #cdsi.cokey = #aws100.cokey
LEFT OUTER JOIN #CDSIwtavg on #cdsi.cokey = #CDSIwtavg.cokey
ORDER BY #cdsi.state, #cdsi.areasymbol, #cdsi.areaname, #cdsi.musym


SELECT   state
, #allmapunits.areasymbol
, #allmapunits.areaname
, Rfact
, Cfact
, #allmapunits.mukey
, #allmapunits.musym
, muname
, nationalmusym
, mukind
, muacres
, cokey
, majcompflag
, comppct_r
, compname
, compkind
, compacres
, localphase
, slope_l
, slope_r
, slope_h
, farmlndcl
, nirrcapclass
, irrcapclass
, ErodibilityIndex
, case when ErodibilityIndex <9 then 'Low_less_than_9' when ErodibilityIndex >8 and ErodibilityIndex <20 Then 'Medium_low_grt_8_less_than_20' else 'High_grt_than_20' end as ErodibilityClass
, WindErodIndex
, NCCPI_Class_dcp
, NCCPI_Value_dcp
, case when Nccpi_Corn_Soybeans_Value_dcp < 0.3 then 'Low_C_S_Suitability' 
       WHEN Nccpi_Corn_Soybeans_Value_dcp > 0.1 AND Nccpi_Corn_Soybeans_Value_dcp < 0.5 then 'Moderately_Low_C_S_Suitability'
       WHEN Nccpi_Corn_Soybeans_Value_dcp > 0.4 AND Nccpi_Corn_Soybeans_Value_dcp < 0.9 then 'Moderate_C_S_Suitability'
       else 'High_C_S_Suitability' end as Nccpi_Corn_Soybeans_Class_dcp
, Nccpi_Corn_Soybeans_Value_dcp 
, case when Nccpi_SmallGrains_Value_dcp < 0.3 then 'Low_SmallGrains_Suitability' 
       WHEN Nccpi_SmallGrains_Value_dcp > 0.1 AND Nccpi_SmallGrains_Value_dcp < 0.5 then 'Moderately_Low_SmallGrains_Suitability'
       WHEN Nccpi_SmallGrains_Value_dcp > 0.4 AND Nccpi_SmallGrains_Value_dcp  < 0.9 then 'Moderate_SmallGrains_Suitability'
       else  'High_C_S_Suitability' end as Nccpi_SmallGrains_Class_dcp
, Nccpi_SmallGrains_Value_dcp
, case when Nccpi_Cotton_Value_dcp < 0.3 then 'Low_Cotton_Suitability' 
       WHEN Nccpi_Cotton_Value_dcp > 0.1 AND Nccpi_Cotton_Value_dcp < 0.5 then 'Moderately_Low_Cotton_Suitability'
       WHEN Nccpi_Cotton_Value_dcp > 0.4 AND Nccpi_Cotton_Value_dcp  < 0.9 then 'Moderate_Cotton_Suitability'
       else  'High_C_S_Suitability' end as Nccpi_Cotton_Class_dcp
, Nccpi_Cotton_Value_dcp
, DShal_Excav_Class_dcp
, DShal_Excav_Rating_dcp
, DHS_Pit_Class_dcp
, DHS_Pit_Rating_dcp
, GPR_Class_dcp
, GPR_Rating_dcp
, Septic_Class_dcp
, Septic_Rating_dcp
, Fire_Haz__Class_dcp
, Fire_Haz_Rating_dcp
, Liner_Class_dcp
, Liner_Rating_dcp
, Sprinkler_Class_dcp
, Sprinkler_Rating_dcp
, Trail_Erosion_Class_dcp
, Trail_Erosion_Rating_dcp
, Off_Trail_Erosion_Class_dcp
, oFF_Trail_Erosion_Rating_dcp
, corsteel
, corcon
, drainagecl
, runoff
, hydgrp
, hydgrpdcd
, AWS100_dcp
, AWS_profile_dcp
, AWS_restrict_dcp
, hydricrating
, hydric_criteria
, hydclprs
, ecositeID
, ecositename
, rsprod_r
, constreeshrubgrp
, foragesuitgrpid
, foragesuitgroupid
, foragesuitgroupname
, taxclname
, taxorder
, taxsuborder
, taxgrtgroup
, taxsubgrp
, taxtempregime
, taxpartsize
, pm
, landform
, sum_thickness
, restrictiondepth
, restrictiondepth_IN
, TOPrestriction
, maxANwatertable_r
, minANwatertable_r
, maxGSwatertable_r
, minGSwatertable_r
, annflodfreq
, annfloddur
, annpondfreq
, annponddur
, frostact
, chkey
, hzname
, hzdept_r
, hzdeb_r
, texture_surf
, unified_surf
, kffact_surf
, kwfact_surf
, tfact
, fragvol_surf
, sandtotal_surf
, sand_wtavg_r  
, silttotal_surf
, silt_wtavg_r 
, claytotal_surf
, clay_wtavg_r 
, lep_wtavg_r 
, om_surf
, om_wtavg_r
, ksat_surf_in_hr
, ksat_wtavg_r_in_hr
, ph1to1h2o_surf 
, pH_wtavg_r 
, caco3_surf 
, caco3_wtavg_r
, cec7_surf
, cec7_wtavg_r 
, ec_surf 
, ec_wtavg_r 
, sar_surf 
, sar_wtavg_r 
, gypsum_surf
, gypsum_wtavg_r 
FROM #allmapunits
LEFT OUTER JOIN #alldata on #allmapunits.mukey=#alldata.mukey
ORDER BY areasymbol, musym
