--start sql
SELECT areasymbol, musym, m.mukey, c.cokey, compname, comppct_r
, case when charindex(' ', pmgroupname, charindex(' ', pmgroupname) - 1) = 0
then pmgroupname else left(pmgroupname, charindex(' ', pmgroupname, charindex(' ', pmgroupname) - 1)) end AS pm
, pmgroupname, copmkey, pmorder, pmmodifier, pmgenmod, pmkind, pmorigin
, (SELECT TOP 1 cogeomordesc.geomfname FROM cogeomordesc WHERE c.cokey = cogeomordesc.cokey AND cogeomordesc.rvindicator='yes' and cogeomordesc.geomftname = 'Landform') as landform
, (SELECT TOP 1  resdept_r  from corestrictions WHERE c.cokey = corestrictions.cokey and reskind is not null) as restrictiondepth
, (SELECT TOP 1 reskind from corestrictions WHERE c.cokey = corestrictions.cokey and reskind is not null) as restrictionkind
, ROW_NUMBER() Over(Partition by m.mukey order by l.areasymbol, m.mukey, c.comppct_r DESC, pmorder) as RowNum 
INTO #PM_LAND 
FROM legend l
inner join mapunit m on l.lkey=m.lkey and l.areasymbol <> 'US'
inner join component c on m.mukey=c.mukey AND c.cokey = (SELECT TOP 1 component.cokey FROM component WHERE component.mukey=m.mukey ORDER BY component.comppct_r DESC)
left outer join copmgrp on c.cokey = copmgrp.cokey AND copmgrp.rvindicator='yes'
left outer join copm on copmgrp.copmgrpkey=copm.copmgrpkey
order by areasymbol, musym, comppct_r desc, pmorder

SELECT areasymbol, musym, mukey, cokey, compname, comppct_r, pm, case when pmorigin is null then pmkind when pmkind is null then pmorigin else pmorigin +' '+pmkind end as parentmaterial
, pmgroupname, landform, restrictionkind, pmorder, pmmodifier, pmgenmod, pmkind, pmorigin, restrictiondepth, RowNum
FROM #PM_LAND
WHERE RowNum = (SELECT TOP 1 RowNum FROM #PM_LAND pl WHERE pl.mukey=#PM_LAND.mukey ORDER BY RowNum desc)
ORDER BY areasymbol, musym, pmorder desc
--end sql
