--
--If the RawRelationsParent temporary table already exists in the tempdb database, then run the DROP command to remove this temporary table from the tempdb database first (just these commands)
--Then after the DROP command, run the code below to create the table again (starting with "USE sdm;")
--
USE tempdb;
GO
drop table #RawRelationsParent; 
GO

USE sdm;
GO
--RawRelationsParent, not executed in the code, but you can run it if you want to see the output

select tl.TablePhysicalName as ltabphyname, tr.TablePhysicalName as rtabphyname, cl.ColumnPhysicalName as ltabcolphyname, cr.ColumnPhysicalName as rtabcolphyname 
INTO #RawRelationsParent 
from MetadataRelationshipDetail rd, MetadataTable tl, MetadataTable tr, MetadataTableColumn cl, MetadataTableColumn cr 
where tl.TableID = rd.LeftTableID and tr.TableID = rd.RightTableID and cl.TableID = rd.LeftTableID 
and cr.TableID = rd.RightTableID and cl.TableColumnSequence = rd.LeftTableColumnSequence and cr.TableColumnSequence = rd.RightTableColumnSequence;
GO 
SELECT * FROM #RawRelationsParent
WHERE ltabphyname='mapunit';
GO