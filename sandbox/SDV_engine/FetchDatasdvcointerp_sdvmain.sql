--
--If the sdvcointerp and sdvmain tables already exist in the tempdb database, then run these DROP commands to remove these temporary tables from the tempdb database first (just these commands)
--Then after the DROP commands, run the code below to create the tables again (starting with "USE sdm;")
--
USE tempdb;
GO
drop table #sdvmain; 
GO
drop table #sdvcointerp;
GO

use sdm;
GO
--This is executed

select legend.areasymbol, legend.areaname, sacatalog.saversion, sacatalog.saverest, mapunit.mukey, mapunit.musym, mapunit.nationalmusym, mapunit.muname, mapunit.museq, 
#sdvcointerp.interphr as attributevalue, #sdvcointerp.interphr as tiebreakvalue, null as primaryconstraint, null as secondaryconstraint, component.cokey as cokey, 
component.compname, component.comppct_r, #sdvcointerp.interphr into #sdvmain from sacatalog, legend, mapunit, component, #sdvcointerp 
where sacatalog.areasymbol=legend.areasymbol and mapunit.lkey=legend.lkey and component.mukey=mapunit.mukey and #sdvcointerp.cokey=component.cokey and mapunit.mukey in ('64274') 
and #sdvcointerp.mrulename = 'AWM - Manure and Food Processing Waste' and #sdvcointerp.ruledepth = 0 and component.comppct_r is not null and component.comppct_r > 0;
GO
SELECT * FROM #sdvmain;
GO
