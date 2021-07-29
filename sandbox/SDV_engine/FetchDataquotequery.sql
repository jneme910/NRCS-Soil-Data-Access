--
--If the sdvcointerp temporary table already exists in the tempdb database, then run the DROP command to remove this temporary table from the tempdb database first (just these commands)
--Then after the DROP command, run the code below to create the table again (starting with "USE sdm;")
--
USE tempdb;
GO
drop table #sdvcointerp; 
GO

use sdm;
GO
--This is executed

select i.cokey, mrulekey, mrulename, ruledepth, interphr, interphrc, seqnum 
into #sdvcointerp from mapunit m, component c, cointerp i 
where m.mukey = c.mukey and c.cokey = i.cokey and m.mukey in ('64274') and i.mrulename = 'AWM - Manure and Food Processing Waste';
GO
SELECT * FROM #sdvcointerp;
GO
