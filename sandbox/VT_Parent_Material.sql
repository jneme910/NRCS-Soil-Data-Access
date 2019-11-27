--start sql

DROP TABLE IF EXISTS #PM
DROP TABLE IF EXISTS #PM2
DROP TABLE IF EXISTS #PM3
DROP TABLE IF EXISTS #oneh
DROP TABLE IF EXISTS #twoh
DROP TABLE IF EXISTS #threeh
SELECT  
areasymbol, areaname, muname, 
musym, 
m.mukey, 
c.cokey, 
compname, 
comppct_r,
case when charindex(' ', pmgroupname, charindex(' ', pmgroupname) - 1) = 0 then pmgroupname else left(pmgroupname, charindex(' ', pmgroupname, charindex(' ', pmgroupname) - 1)) end AS pm,
 pmgroupname, 
 copmkey,
  pmorder, 
  pmmodifier, 
  pmgenmod, 
  pmkind, 
  pmorigin,
 (SELECT TOP 1 cogeomordesc.geomfname FROM cogeomordesc WHERE c.cokey = cogeomordesc.cokey AND cogeomordesc.rvindicator='yes' and cogeomordesc.geomftname = 'Landform') as landform,
 (SELECT TOP 1  resdept_r  from corestrictions WHERE c.cokey = corestrictions.cokey and reskind is not null) as restrictiondepth,
 (SELECT TOP 1 reskind from corestrictions WHERE c.cokey = corestrictions.cokey and reskind is not null) as restrictionkind,
 ROW_NUMBER() Over(Partition by m.mukey order by l.areasymbol, m.mukey, c.comppct_r DESC, pmorder) as RowNum 
INTO #PM
FROM legend l
inner join mapunit m on l.lkey=m.lkey and LEFT (l.areasymbol,2) = 'WI'
inner join component c on m.mukey=c.mukey AND c.cokey = (SELECT TOP 1 component.cokey FROM component WHERE component.mukey=m.mukey ORDER BY component.comppct_r DESC)
left outer join copmgrp on c.cokey = copmgrp.cokey AND copmgrp.rvindicator='yes'
left outer join copm on copmgrp.copmgrpkey=copm.copmgrpkey
order by areasymbol, musym, comppct_r desc, pmorder

SELECT areasymbol, muname,  musym, mukey, cokey, compname, comppct_r, pm, case when pmorigin is null then pmkind when pmkind is null then pmorigin else pmorigin +' '+pmkind end as parentmaterial
, pmgroupname, landform, restrictionkind, pmorder, pmmodifier, pmgenmod, pmkind, pmorigin, restrictiondepth, RowNum
INTO #PM2
FROM #PM
WHERE RowNum = (SELECT TOP 1 RowNum FROM #PM AS pl WHERE pl.mukey=#PM.mukey ORDER BY RowNum desc)
ORDER BY areasymbol, musym, pmorder desc;
--end sql

---with — recursive common table expression
Select compname, hzname, hzdept_r, hzdepb_r, texdesc,  mukey, #PM2.cokey, ch.chkey,
ROW_NUMBER() Over(Partition by #PM2.cokey order by hzdept_r ASC, hzdepb_r ASC) as HRRowNum 
 INTO #PM3
 From #PM2
INNER JOIN chorizon AS ch ON ch.cokey=#PM2.cokey AND CASE WHEN hzname LIKE '%C%' THEN 1 ELSE 2 END = 1
INNER JOIN chtexturegrp AS cht ON cht.chkey=ch.chkey AND rvindicator = 'Yes' 



Select hzname AS [1hzname] , hzdept_r AS [1hzdept_r], hzdepb_r AS [1hzdepb_r], texdesc AS [1texdesc],  mukey, #PM3.cokey, chkey AS[1chkey]
INTO #oneh
FROM #PM3 WHERE HRRowNum = 1

Select hzname AS [2hzname] , hzdept_r AS [2hzdept_r], hzdepb_r AS [2hzdepb_r], texdesc AS [2texdesc],  mukey, #PM3.cokey, chkey AS[2chkey]
INTO #twoh
FROM #PM3 WHERE HRRowNum = 2

Select hzname AS [3hzname] , hzdept_r AS [3hzdept_r], hzdepb_r AS [3hzdepb_r], texdesc AS [3texdesc],  mukey, #PM3.cokey, chkey AS[3chkey]
INTO #threeh
FROM #PM3 WHERE HRRowNum = 3


SELECT 
areasymbol,	
muname,	
musym,	
#PM2.mukey,	
#PM2.cokey,	
compname,	
comppct_r,
pm,	
parentmaterial,
pmgroupname,	
landform,	
restrictionkind,	
pmorder,	
pmmodifier,	
pmgenmod,
pmkind,	
pmorigin,	
restrictiondepth, 
[1hzname] , 
[1hzdept_r], 
[1hzdepb_r], 
[1texdesc], 
[1chkey],
[2hzname] , 
[2hzdept_r], 
[2hzdepb_r], 
[2texdesc] ,
[2chkey],
[3hzname] , 
[3hzdept_r], 
[3hzdepb_r], 
[3texdesc] ,
[3chkey]	
FROM #PM2
LEFT OUTER JOIN #oneh ON #oneh.mukey=#PM2.mukey
LEFT OUTER JOIN #twoh ON #twoh.mukey=#PM2.mukey
LEFT OUTER JOIN #threeh ON #threeh.mukey=#PM2.mukey; 

--INNER JOIN #PM2 ON #PM2.mukey=#PM3.mukey

DROP TABLE IF EXISTS #PM
DROP TABLE IF EXISTS #PM2
DROP TABLE IF EXISTS #PM3
DROP TABLE IF EXISTS #oneh
DROP TABLE IF EXISTS #twoh
DROP TABLE IF EXISTS #threeh