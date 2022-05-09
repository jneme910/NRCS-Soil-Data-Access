USE [SDWStaging]
GO

/****** Object:  StoredProcedure [dbo].[NasisToStaging_CheckCompleteness]    Script Date: 10/17/2017 4:58:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[NasisToStaging_CheckCompleteness]
       @distmdiid int
AS
BEGIN

DECLARE @ErrorList TABLE (ErrorMessage varchar(500))

insert @ErrorList
select 'Error: Requested rule ID ' + CAST(n_distinterpmd.ruleiidref as varchar(10)) +
       ' does not exist in the NASIS database.'
from n_distinterpmd with(nolock)
where distmdiidref = @distmdiid
  and n_distinterpmd.ruleiidref not in (select ruleiid from [rule]);

insert @ErrorList
select 'Error: Requested legend ' + CAST(n_distlegendmd.liidref as varchar(10)) +
       ' was not copied to the staging database.'
from n_distlegendmd with(nolock)
where distmdiidref = @distmdiid
  and not exists (select * from legend with(nolock) where legend.lkey = n_distlegendmd.liidref
		and legend.areasymbolref = n_distlegendmd.areasymbol)

insert @ErrorList
select 'Error: Requested mapunit ' + CAST(n_distmapunitmd.muiidref as varchar(10)) +
       ' was not copied to the staging database.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
where distmdiidref = @distmdiid
  and not exists (select * from mapunit with(nolock) join lmapunit with(nolock) on lmapunit.muiidref = mapunit.muiid 
			join legend with(nolock) on legend.liid = lmapunit.liidref
			where mapunit.orignasisiid = n_distmapunitmd.muiidref
			  and mapunit.areasymbolref = n_distlegendmd.areasymbol
			  and legend.lkey = n_distlegendmd.liidref
			  and legend.areasymbolref = n_distlegendmd.areasymbol)

insert @ErrorList
select 'Error: Requested component ' + CAST(n_distcompmd.coiidref as varchar(10)) +
       ' was not copied to the staging database.'
from n_distlegendmd with(nolock)
join n_distmapunitmd with(nolock) on n_distlegendmd.distlegendmdiid = n_distmapunitmd.distlegendmdiidref
join n_distcompmd with(nolock) on n_distmapunitmd.distmumdiid = n_distcompmd.distmumdiidref
where distmdiidref = @distmdiid
  and not exists (select * from component with(nolock) join datamapunit with(nolock) on component.dmuiidref = datamapunit.dmuiid 
			where component.orignasisiid = n_distcompmd.coiidref
			  and datamapunit.orignasisiid = n_distmapunitmd.dmuiidref
			  and datamapunit.areasymbolref = n_distlegendmd.areasymbol)

insert @ErrorList
select distinct 'Error: No interpretations were generated for one or more components'
from n_distlegendmd with(nolock)
join datamapunit with(nolock) on datamapunit.areasymbolref = n_distlegendmd.areasymbol
join component with(nolock) on component.dmuiidref = datamapunit.dmuiid
join n_distinterpmd with(nolock) on n_distinterpmd.distmdiidref = n_distlegendmd.distmdiidref
where n_distlegendmd.distmdiidref = @distmdiid
  and not exists (select * from icomponent with(nolock) where icomponent.coiidref = component.coiid
      and icomponent.mruleiidref = n_distinterpmd.ruleiidref)

--
--  Return list of errors
--

select ErrorMessage from @ErrorList

END

GO


