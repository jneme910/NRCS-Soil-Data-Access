-- mwACPF_extMUAGGATT.sql
--
-- In support of the Agricultural Conservation Planning Framework (ACPF), extract
--  soils data from the NRCS MUAGGATT and Value1 tables. USE MWSoilsFY16

IF OBJECT_ID('dbo.mwACPF_MUAggTable') IS NOT NULL 
        DROP TABLE dbo.mwACPF_MUAggTable


SELECT mu.mukey
      ,muagg.musym as MUsymbol
      ,muagg.muname as MUname
      ,muagg.wtdepaprjunmin as WTDepAprJun
      ,muagg.flodfreqdcd as FloodFreq
      ,CAST(muagg.pondfreqprs AS smallint) as PondFreq
      ,muagg.drclassdcd as DrainCls
      ,muagg.drclasswettest as DrainClsWet
      ,muagg.hydgrpdcd as HydroGrp
      ,CAST(muagg.hydclprs AS smallint) as Hydric
	  ,val.nccpi2cs as NCCPIcs
	  ,val.nccpi2sg as NCCPIsg
	  ,val.rootznemc as RootZnDepth
	  ,val.rootznaws as RootZnAWS
	  ,val.droughty as Droughty
	  ,val.pwsl1pomu as PotWetandSoil
  INTO [MWSoilsFY16].[dbo].[mwACPF_MUAggTable]
  FROM [MWSoilsFY16].[dbo].[mw_MapUnitTable] mu left join USSoilsFY16.dbo.MUAGGATT muagg ON mu.mukey = muagg.mukey
       left join USSoilsFY16.dbo.VALU1 val ON val.mukey = mu.mukey
  ORDER BY mu.mukey
GO

ALTER TABLE mwACPF_MUAggTable ALTER COLUMN NCCPIcs Decimal(8,3) NULL
ALTER TABLE mwACPF_MUAggTable ALTER COLUMN NCCPIsg Decimal(8,3) NULL

