USE [SDWStaging]
GO

/****** Object:  StoredProcedure [dbo].[NasisToStaging_CheckFatalErrors]    Script Date: 10/17/2017 4:59:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[NasisToStaging_CheckFatalErrors]
       @distmdiid int
AS
BEGIN

DECLARE @ErrorList TABLE (ErrorMessage varchar(500))

--
--  Check for invalid area type: only Pangaea MLRA or Non-MLRA areas allowed
--

insert @ErrorList
select 'Data Error: Survey Area ''' + n_distlegendmd.areasymbol +
''' does not correspond to either a Pangaea Non-MLRA Soil Survey Area or a ' +
'Pangaea Country Soil Survey Area where the area symbol is ''US'', ' +
'and cannot be submitted to the warehouse.'
from n_distlegendmd with(nolock)
join n_legend with(nolock) on n_distlegendmd.liidref = n_legend.liid
join n_area with(nolock) on n_legend.areaiidref = n_area.areaiid
join n_areatype with(nolock) on n_area.areatypeiidref = n_areatype.areatypeiid
where n_distlegendmd.distmdiidref = @distmdiid
and 
(
		 (atdbiidref != 1) -- NSSC Pangaea
	or (n_areatype.areatypename not in ('Non-MLRA Soil Survey Area', 'Country')) 
	or (n_areatype.areatypename = 'Country' and n_distlegendmd.areasymbol != 'US')
)

--
--  Check for badly formed area symbols
--

insert @ErrorList
select 'Data Error: Area symbol ''' + areasymbol +
''' cannot be submitted to the warehouse because it contains characters ' +
'other than upper case letters or digits.'
from n_distlegendmd with(nolock)
where n_distlegendmd.distmdiidref = @distmdiid
and areasymbol like '%[^A-Z0-9]%'

--
--  Check for area symbols more than 7 characters long
--

insert @ErrorList
select 'Data Error: Area symbol ''' + areasymbol +
''' cannot be submitted to the warehouse because it has more than 7 characters.'
from n_distlegendmd with(nolock)
where n_distlegendmd.distmdiidref = @distmdiid
and len(areasymbol) > 7

--
--  Check for areas with name or acres missing
--

insert @ErrorList
select 'Data Error: Area symbol ''' + n_distlegendmd.areasymbol +
''' is missing an area name or acres and cannot be submitted to the warehouse.'
from n_distlegendmd with(nolock)
join n_legend with(nolock) on n_distlegendmd.liidref = n_legend.liid
join n_area with(nolock) on n_legend.areaiidref = n_area.areaiid
where n_distlegendmd.distmdiidref = @distmdiid
and (n_area.areaname is null or n_area.areaacres is null)

--
--  Check for missing state or county overlaps
--

-- First check just for the state overlap
insert @ErrorList
select 'Data Error: Legend for area ''' + areasymbol +
''' does not have a valid state entry in the Legend Area Overlap table.'
from n_distlegendmd with(nolock)
where n_distlegendmd.distmdiidref = @distmdiid
and not exists
(select * from n_laoverlap with(nolock)
 join n_area with(nolock) on n_area.areaiid = n_laoverlap.areaiidref
 join n_areatype with(nolock) on n_areatype.areatypeiid = n_area.areatypeiidref
 join contextsuffix with(nolock) on n_area.areasymbol = contextsuffix.contextsuffixcode
 where n_areatype.areatypename = 'State or Territory'
 and n_areatype.atdbiidref=1
 and n_distlegendmd.liidref = n_laoverlap.liidref)

    -- Make sure each valid state has counties
    insert @ErrorList
	select 'Data Error: Legend for area ''' + n_distlegendmd.areasymbol +
    ''' has no corresponding county for state ' + st_area.areasymbol +
    ' in the Legend Area Overlap table.'
    from n_distlegendmd with(nolock)
    join n_laoverlap with(nolock) on n_distlegendmd.liidref = n_laoverlap.liidref
    join n_area as st_area with(nolock) on st_area.areaiid = n_laoverlap.areaiidref
    join n_areatype with(nolock) on n_areatype.areatypeiid = st_area.areatypeiidref
    join contextsuffix with(nolock) on st_area.areasymbol = contextsuffix.contextsuffixcode
    where n_distlegendmd.distmdiidref = @distmdiid
     and n_distlegendmd.areasymbol != 'US'
     and n_areatype.atdbiidref=1
     and n_areatype.areatypename = 'State or Territory'
     and not exists
     (select * from n_laoverlap with(nolock)
      join n_area with(nolock) on n_area.areaiid = n_laoverlap.areaiidref
      join n_areatype with(nolock) on n_areatype.areatypeiid = n_area.areatypeiidref
      where n_distlegendmd.liidref = n_laoverlap.liidref
      and n_areatype.atdbiidref=1
      and n_areatype.areatypename = 'County or Parish'
      and substring(n_area.areasymbol, 1, 2) = st_area.areasymbol)

    -- Make sure each county has a valid state
    insert @ErrorList
    select 'Data Error: Legend for area ''' + n_distlegendmd.areasymbol +
    ''' has no corresponding state for county ' + co_area.areasymbol +
    ' in the Legend Area Overlap table.'
    from n_distlegendmd with(nolock)
    join n_laoverlap with(nolock) on n_distlegendmd.liidref = n_laoverlap.liidref
    join n_area as co_area with(nolock) on n_laoverlap.areaiidref = co_area.areaiid
    join n_areatype with(nolock) on co_area.areatypeiidref = n_areatype.areatypeiid
    where n_distlegendmd.distmdiidref = @distmdiid
    and n_distlegendmd.areasymbol != 'US'
    and n_areatype.atdbiidref = 1
    and n_areatype.areatypename = 'County or Parish'
    and not exists
    (select * from n_laoverlap with(nolock) 
     join n_area with(nolock) on n_laoverlap.areaiidref = n_area.areaiid
     join n_areatype with(nolock) on n_areatype.areatypeiid = n_area.areatypeiidref
     join contextsuffix with(nolock) on n_area.areasymbol = contextsuffix.contextsuffixcode
     where n_distlegendmd.liidref = n_laoverlap.liidref
     and n_areatype.atdbiidref=1
     and n_areatype.areatypename = 'State or Territory'
     and substring(co_area.areasymbol, 1, 2) = n_area.areasymbol)

--
--  Check for missing project scale
--

insert @ErrorList
select 'Data Error: Legend for area ''' + areasymbol +
''' does not have a project scale defined in the Legend table.'
from n_distlegendmd with(nolock)
join n_legend with(nolock) on n_distlegendmd.liidref = n_legend.liid
where n_distlegendmd.distmdiidref = @distmdiid
and projectscale is null

--
--  Check for duplicate mapunit symbols
--

insert @ErrorList
select 'Data Error: Mapunit symbol ' + musym + ' is used more than once in ' + 
areatypename collate Latin1_General_BIN + ': ' + 
areasymbol collate Latin1_General_BIN + ', Legend ID ' + 
cast(n_distlegendmd.liidref as varchar(20)) + '.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
where n_distlegendmd.distmdiidref = @distmdiid
group by musym, areatypename, areasymbol, n_distlegendmd.liidref
having count(musym) > 1

--
--  Check for duplicate data mapunits
--

declare @areatype varchar(60)
declare @areaname varchar(200)
declare @liid int
declare @dmuiid int
declare @musym varchar(6)
declare @musym_list varchar(200)

declare dmu_cursor cursor for
  select areatypename, areaname, n_distlegendmd.liidref, dmuiidref
  from n_distlegendmd with(nolock)
  join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
  where n_distlegendmd.distmdiidref = @distmdiid
  group by areatypename, areaname, n_distlegendmd.liidref, dmuiidref 
  having count(musym) > 1

open dmu_cursor
fetch next from dmu_cursor into @areatype, @areaname, @liid, @dmuiid
while @@fetch_status = 0
begin
	declare mu_cursor cursor for 
	  select musym
	  from n_distlegendmd with(nolock)
	  join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
	  where n_distlegendmd.distmdiidref = @distmdiid
	  and n_distmapunitmd.dmuiidref = @dmuiid
  
    set @musym_list = ''
    open mu_cursor
    fetch next from mu_cursor into @musym
    while @@fetch_status = 0
    begin
        set @musym_list = @musym_list + ' ' + @musym
        fetch next from mu_cursor into @musym
    end
    close mu_cursor
    deallocate mu_cursor
    insert @ErrorList
    select 'Data Error: Multiple mapunit symbols (' + @musym_list + ' ) are correlated to the same data mapunit in ' +
          @areatype + ': ' + @areaname + ', Legend ID ' + cast(@liid as varchar(20)) + '.'
end
close dmu_cursor
deallocate dmu_cursor

--
--  Check for missing mapunit names
--

insert @ErrorList
select 'Data Error: Mapunit symbol ' + musym collate SQL_Latin1_General_CP1_CI_AS + 
' in ' + areatypename + ': ' + areasymbol + ' has no mapunit name.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
where n_distlegendmd.distmdiidref = @distmdiid
and muname is null

--
--  Check for NOTCOM mapunit symbol not capitalized
--

insert @ErrorList
select 'Data Error: Mapunit symbol ' + musym  collate SQL_Latin1_General_CP1_CI_AS + 
' in ' + areatypename + ': '  + areasymbol + ' must be all upper case.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
where n_distlegendmd.distmdiidref = @distmdiid
and upper(musym) = 'NOTCOM'
and musym != 'NOTCOM'

--
--  Check for NOTCOM mapunit symbol not linked to the official NOTCOM mapunit
--

insert @ErrorList
select 'Data Error: Mapunit symbol NOTCOM in ' + areatypename + ': ' + areasymbol +
' is not linked to the official NOTCOM mapunit (nationalmusym = ''NOTCOM'')'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_mapunit on n_mapunit.muiid = n_distmapunitmd.muiidref
where n_distlegendmd.distmdiidref = @distmdiid
and musym = 'NOTCOM'
and nationalmusym != 'NOTCOM'

--
--  Check for the official NOTCOM mapunit linked to a mapunit symbol other than NOTCOM
--

insert @ErrorList
select 'Data Error: Mapunit symbol ' + musym Collate SQL_Latin1_General_CP1_CI_AS + 
' in ' + areatypename + ': ' + areasymbol +
' is linked to the official NOTCOM mapunit (nationalmusym = ''NOTCOM''). ' +
'Only a legend mapunit whose symbol is NOTCOM should be linked to the official NOTCOM mapunit.'	
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_mapunit with(nolock) on n_mapunit.muiid = n_distmapunitmd.muiidref
where n_distlegendmd.distmdiidref = @distmdiid
and musym != 'NOTCOM'
and nationalmusym = 'NOTCOM'	

--
--  Check for components without a name
--

insert @ErrorList
select 'Data Error: component has no name in ' + areatypename + ': ' + areasymbol + 
' Mapunit: ' + musym collate SQL_Latin1_General_CP1_CI_AS + ' (' + dbo.codevaltolbl(138,mustatus) +
', ID ' + CAST(muiidref AS varchar(14)) + '), Component ID ' + CAST(n_distcompmd.coiidref AS varchar(14)) + '.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_distcompmd with(nolock) on n_distmapunitmd.distmumdiid = n_distcompmd.distmumdiidref
join n_component with(nolock) on n_distcompmd.coiidref = n_component.coiid
where n_distlegendmd.distmdiidref = @distmdiid
and n_component.compname is null

--
--  Check for components with a null month
--

insert @ErrorList
select 'Data Error: Blank month in Component Month table. ' + areatypename + ': ' + areasymbol + 
' Mapunit: ' + musym collate SQL_Latin1_General_CP1_CI_AS + ' (' + dbo.codevaltolbl(138,mustatus) +
', ID ' + CAST(muiidref AS varchar(14)) + ') Component: ' + ISNULL(compname,'No Name') + '(ID ' + CAST(n_distcompmd.coiidref AS varchar(14)) + ').'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_distcompmd with(nolock) on n_distmapunitmd.distmumdiid = n_distcompmd.distmumdiidref
join n_comonth with(nolock) on n_distcompmd.coiidref = n_comonth.coiidref
where n_distlegendmd.distmdiidref = @distmdiid
and n_comonth.month is null;

--
--  Check for non-tech descriptions with null category
--

insert @ErrorList
select 'Data Error: Missing Category for nontechnical description in Mapunit Text table. ' +
areatypename + ': ' + areasymbol + ' Mapunit: ' + musym collate SQL_Latin1_General_CP1_CI_AS + 
' (' + dbo.codevaltolbl(138,mustatus) + ', ID ' + CAST(n_distmapunitmd.muiidref AS varchar(14)) + ').'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_mutext with(nolock) on n_distmapunitmd.muiidref = n_mutext.muiidref
where n_distlegendmd.distmdiidref = @distmdiid
and n_mutext.mapunittextkind = 1
and n_mutext.textcat is null
and exists (select * from n_disttextmd with(nolock)
            where n_disttextmd.distmdiidref = @distmdiid
            and n_disttextmd.textkindstring = 'Nontechnical description');

--
--  Check for missing component non-tech descriptions
--

insert @ErrorList
select 'Data Error: Missing Component Brief Soil Description. ' + areatypename + ': ' + areasymbol + 
' Mapunit: ' + musym collate SQL_Latin1_General_CP1_CI_AS + ' (ID ' + cast(muiidref as varchar(32)) +  
') Component: ' + ISNULL(compname,'No Name') + ' (ID ' + cast(n_distcompmd.coiidref as varchar(32)) + ').'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_distcompmd with(nolock) on n_distmapunitmd.distmumdiid = n_distcompmd.distmumdiidref
where n_distlegendmd.distmdiidref = @distmdiid
and not exists (select * from n_cotext with(nolock) 
                where n_cotext.coiidref = n_distcompmd.coiidref
                and n_cotext.comptextkind = 1)

--
--  Check for interps that don't meet SDV requirements:
--  Primary rule, ready for use, and having a valid suffix for
--  rules that are not in the Pangaea site.
--

insert @ErrorList
select 'Error: Selected interpretation ' + [rule].rulename + ' is not a primary rule.'
from n_distinterpmd with(nolock)
join [rule] with(nolock) on n_distinterpmd.ruleiidref = [rule].ruleiid
where n_distinterpmd.distmdiidref = @distmdiid
and [rule].primaryinterp != 1

insert @ErrorList
select 'Error: Selected interpretation ' + [rule].rulename + ' is not ready to use.'
from n_distinterpmd with(nolock)
join [rule] with(nolock) on n_distinterpmd.ruleiidref = [rule].ruleiid
where n_distinterpmd.distmdiidref = @distmdiid
and [rule].dataafuse != 1

insert @ErrorList
select 'Error: Selected interpretation ' + [rule].rulename + ' does not have a valid state or agency suffix.'
from n_distinterpmd with(nolock)
join [rule] with(nolock) on n_distinterpmd.ruleiidref = [rule].ruleiid
join nasissite with(nolock) on [rule].ruledbiidref = nasissite.nasissiteiid
where n_distinterpmd.distmdiidref = @distmdiid
and nasissitename != 'NSSC Pangaea' and nasissitename != 'NSSC Regional Interpretations'
and [dbo].[NasisToStaging_CheckRuleNameSuffix]([rule].rulename) = 0

--
--  Return list of error messages
--

select ErrorMessage from @ErrorList

END

GO


