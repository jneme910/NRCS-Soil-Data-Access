/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [phiidref]
      ,[seqnum]
      ,[colorpct]
    --  ,[colorhue]
	,  CAST ((SELECT TOP 1  CAST ([ChoiceName] AS VARCHAR ) FROM [nasis].[dbo].phcolor AS phc2, [nasis].[dbo].MetadataDomainMaster dm, [nasis].[dbo].MetadataDomainDetail dd WHERE  colorhue  = ChoiceValue AND DomainName = 'color_hue' AND 
 s.[phcoloriid]=phc2.[phcoloriid] AND
dm.DomainID = dd.DomainID ORDER BY choicesequence DESC) AS VARCHAR) AS colorhue
      ,[colorvalue]
      ,[colorchroma]
      ,[colorphysst]
      ,[colormoistst]
      ,[recwlupdated]
      ,[recuseriidref]
      ,[phcoloriid]
  FROM [nasis].[dbo].[phcolor] AS s --WHERE colorh