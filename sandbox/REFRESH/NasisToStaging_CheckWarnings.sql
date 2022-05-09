USE [SDWStaging]
GO

/****** Object:  StoredProcedure [dbo].[NasisToStaging_CheckWarnings]    Script Date: 10/17/2017 5:00:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[NasisToStaging_CheckWarnings]
       @distmdiid int
AS
BEGIN

DECLARE @WarningList TABLE (WarningMessage varchar(500))

--
--  Check for mapunits without a unique matching data mapunit (warning only)
--

insert @WarningList
select 'Warning: No data mapunit has been exported for ' + areatypename + ': ' + areasymbol + 
' Mapunit: ' + musym collate SQL_Latin1_General_CP1_CI_AS + ' (' + dbo.codevaltolbl(138,mustatus) +
', ID ' + CAST(muiidref AS varchar(14)) + '), because ' + norepdmureason + '.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref 
and n_distlegendmd.distmdiidref = @distmdiid
where n_distmapunitmd.dmuiidref is null

--
--  Check if export_certification_status is not certified (warning only)
--

insert @WarningList
select 'Warning: Legend for area ''' + n_distlegendmd.areasymbol +
''' has Export Certification Status missing or ''not certified''. It will be ' +
'recorded as ''fully certified'' in the data warehouse.'
from n_distlegendmd with(nolock)
where n_distlegendmd.distmdiidref = @distmdiid
and (exportcertstatus = 1 or exportcertstatus is null)

--
--  Check if export_certification_status is partially certified and
--   no description is provided (warning only)
--

insert @WarningList
select 'Warning: Legend for area ''' + n_distlegendmd.areasymbol +
''' has Export Certification Status as ''partly certified'' but Export Metadata has no explanation.'
from n_distlegendmd with(nolock)
where n_distlegendmd.distmdiidref = @distmdiid
and exportcertstatus = 2 and exportmetadata is null

--
--  Check for missing mapunit acres (warning only)
--

insert @WarningList
select 'Warning: Mapunit symbol ' + n_lmapunit.musym collate SQL_Latin1_General_CP1_CI_AS + ' in ' + 
n_areatype.areatypename + ': ' + n_area.areasymbol + ' has no mapunit acres.'
from n_distlegendmd with(nolock) join n_distmapunitmd with(nolock) on distlegendmdiid=distlegendmdiidref
 and n_distlegendmd.distmdiidref = @distmdiid
join n_lmapunit with(nolock) on n_distmapunitmd.muiidref = n_lmapunit.muiidref
 and n_distmapunitmd.liidref = n_lmapunit.liidref
join n_legend with(nolock) on n_lmapunit.liidref = n_legend.liid
join n_area with(nolock) on n_legend.areaiidref = n_area.areaiid
join n_areatype with(nolock) on n_area.areatypeiidref = n_areatype.areatypeiid
where n_lmapunit.muacres is null

--
--  Check if Component Nontechnical Descriptions have been exported
--

insert @WarningList
select 'Warning: Component Nontechnical Descriptions have not been selected for export.'
from n_distmd with(nolock) where n_distmd.distmdiid = @distmdiid
and not exists (select * from n_disttextmd with(nolock)
            where n_disttextmd.distmdiidref = @distmdiid
			and n_disttextmd.tablab = 'Component'
            and n_disttextmd.textkindstring = 'Nontechnical description');

--
--  Return list of warnings
--

select WarningMessage from @WarningList

END

GO


