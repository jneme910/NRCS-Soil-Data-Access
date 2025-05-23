/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *,
      CONCAT ('<li><b>', [ColumnPhysicalName], ': </b>') AS c1
	  , CONCAT ([ColumnDescription],'</li>' ) AS c2
   
  FROM [sdmONLINE].[dbo].[MetadataTableColumn]
  --WHERE [ColumnPhysicalName] IN  (' musym', 'areasymbol', 'muname', ' musym,', 'compname', 'cokey',  'comppct_r', 'hzname', 'hzdept_r', 'hzdepb_r',  'sandtotal_r', 'silttotal_r', 'sandmed_r', 'claytotal_r', 'chkey') 
 -- GROUP BY [ColumnPhysicalName], [ColumnDescription]
  ORDER BY [ColumnPhysicalName]