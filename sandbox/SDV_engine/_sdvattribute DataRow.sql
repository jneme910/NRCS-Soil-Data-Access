USE sdmmgtONLINE;
--USE sdmmgt;
GO
SELECT * 
  FROM [sdmmgtONLINE].[dbo].[sdvattribute] with(nolock)
  --FROM [sdmmgt].[dbo].[sdvattribute] with(nolock)
  WHERE attributename = 'Manure and Food-Processing Waste';
GO
