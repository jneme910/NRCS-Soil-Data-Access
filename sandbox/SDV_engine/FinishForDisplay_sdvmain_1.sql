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
drop table #sdvmapunits;
GO
drop table #sdvcomponents;
GO
drop table #components;
GO

USE sdm;
GO
--This is executed by the program: method FetchData()

select i.cokey, mrulekey, mrulename, ruledepth, interphr, interphrc, seqnum 
into #sdvcointerp from mapunit m, component c, cointerp i with(nolock) 
where m.mukey = c.mukey and c.cokey = i.cokey and m.mukey in ('64274') and i.mrulename = 'AWM - Manure and Food Processing Waste';
GO
SELECT * FROM #sdvcointerp with(nolock);
GO

select legend.areasymbol, legend.areaname, sacatalog.saversion, sacatalog.saverest, mapunit.mukey, mapunit.musym, mapunit.nationalmusym, mapunit.muname, mapunit.museq, 
#sdvcointerp.interphr as attributevalue, #sdvcointerp.interphr as tiebreakvalue, null as primaryconstraint, null as secondaryconstraint, component.cokey as cokey, 
component.compname, component.comppct_r, #sdvcointerp.interphr into #sdvmain from sacatalog, legend, mapunit, component, #sdvcointerp with(nolock)  
where sacatalog.areasymbol=legend.areasymbol and mapunit.lkey=legend.lkey and component.mukey=mapunit.mukey and #sdvcointerp.cokey=component.cokey and mapunit.mukey in ('64274') 
and #sdvcointerp.mrulename = 'AWM - Manure and Food Processing Waste' and #sdvcointerp.ruledepth = 0 and component.comppct_r is not null and component.comppct_r > 0;
GO
SELECT * FROM #sdvmain with(nolock);
GO

--This is executed by the method ReduceMultiples()

SELECT * FROM #sdvmain with(nolock) 
WHERE tiebreakvalue is not null  
ORDER BY mukey, cokey, tiebreakvalue desc;
GO
SELECT * FROM #sdvmain with(nolock) 
WHERE mukey=64274 and cokey=17212105;
GO
SELECT * FROM #sdvmain with(nolock) 
WHERE mukey=64274 and cokey=17212106;
GO

SELECT * FROM #sdvmain with(nolock)
WHERE tiebreakvalue is null  
ORDER BY mukey, cokey;
GO

--This is executed by the method AggregateData()

--SELECT areasymbol, areaname, saversion, saverest, mukey, musym, nationalmusym, muname, museq, attributevalue, tiebreakvalue, primaryconstraint, secondaryconstraint, cokey, compname, comppct_r, interphr 
--FROM #sdvmain with(nolock);
--GO

SELECT * FROM #sdvmain with(nolock) 
WHERE mukey='64274';
GO

SELECT areasymbol, areaname, saversion, saverest, mukey, musym, nationalmusym, muname, museq, attributevalue, tiebreakvalue, primaryconstraint, secondaryconstraint, cokey, compname, comppct_r, interphr 
INTO #sdvcomponents
FROM #sdvmain with(nolock);
GO
SELECT * FROM #sdvcomponents with(nolock);
GO

--SELECT * FROM #sdvmain with(nolock) 
--WHERE cokey=17212106;
--GO

SELECT areasymbol, areaname, saversion, saverest, mukey, musym, nationalmusym, muname, museq, attributevalue, tiebreakvalue, primaryconstraint, secondaryconstraint, cokey, compname, comppct_r, interphr 
INTO #sdvmapunits
FROM #sdvmain with(nolock)
WHERE cokey=17212106;
GO
SELECT * FROM #sdvmapunits with(nolock);
GO

SELECT * FROM #sdvmain with(nolock) 
WHERE cokey is null and comppct_r is null;
GO

SELECT SUM(comppct_r) As SUMcomppct_r FROM #sdvcomponents with(nolock)
WHERE mukey='64274' and attributevalue is not null;
GO

-- This is for the FinishForDisplay() method

-- This is so we can see what fields and values are in the component table
--SELECT TOP 3* FROM component with(nolock);
--GO

--This will return a lot of records so you can cancel the query execution at any time (Go to the main menu up top and navigate to Query >> Cancel Executing Query):
--SELECT mapunit.mukey as mukey, component.cokey as cokey, component.compname, component.comppct_r, interphr, interphrc, component.localphase 
--FROM mapunit, component, cointerp with(nolock) 
--WHERE mapunit.mukey=component.mukey and component.cokey=cointerp.cokey;
--GO

--returns 868 rows
--SELECT mapunit.mukey as mukey, component.cokey as cokey, component.compname, component.comppct_r, interphr, interphrc, component.localphase 
--FROM mapunit, component, cointerp with(nolock) 
--WHERE mapunit.mukey=component.mukey and component.cokey=cointerp.cokey and mapunit.mukey in ('64274') and component.comppct_r is not null;
--GO

--returns 2 rows of data
select mapunit.mukey as mukey, component.cokey as cokey, component.compname, component.comppct_r, interphr, interphrc, component.localphase 
INTO #components 
from mapunit, component, cointerp 
where mapunit.mukey=component.mukey and component.cokey=cointerp.cokey and mapunit.mukey in ('64274') and component.comppct_r is not null 
and mrulename = 'AWM - Manure and Food Processing Waste' and ruledepth = 0 order by mapunit.mukey, component.comppct_r desc;
GO
SELECT * FROM #components;
GO

--returns the same 2 rows of data
SELECT * FROM #components
WHERE mukey='64274' and (interphrc is null or interphrc<> '0.335111111111111');
GO  

--this is just so we can create 0 rows of data (this is not in the code, this is for the Word document purposes, so ignore)
--SELECT * FROM #components
--WHERE mukey = '1234';
--GO

