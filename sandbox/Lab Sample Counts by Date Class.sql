--Lab Sample Dates � Raw data

SELECT 
COUNT (DISTINCT p.pedon_key) AS total,
COUNT (DISTINCT[1960_key]) AS [1960_count] , -- 1960
COUNT (DISTINCT[1960_1990_key]) AS [1960_1990_count], --1960-1990
COUNT (DISTINCT[1990_2010_key]) AS [1990_2010_count], --1990-2010
COUNT (DISTINCT[2010_key]) AS [2010_count] --1990-2010
 
 FROM [combine_nasis_ncss] AS cnn --Start

LEFT OUTER JOIN (SELECT [pedon_key] AS [1960_key] , CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END AS [1960]  FROM [combine_nasis_ncss] --- Before 1960
 WHERE  CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END < 1960) AS c ON cnn.[pedon_key]=c.[1960_key]

LEFT OUTER JOIN (SELECT [pedon_key] AS [1960_1990_key] , CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END AS [1960_1990]  FROM [combine_nasis_ncss] --- 1960 Between and 1990
 WHERE  CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END BETWEEN 1960 AND 1990) AS d ON cnn.[pedon_key]=d.[1960_1990_key]

 LEFT OUTER JOIN (SELECT [pedon_key] AS [1990_2010_key] , CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END AS [1990_2010]  FROM [combine_nasis_ncss] --- 1990 Between and 2010
 WHERE  CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END BETWEEN 1990 AND 2010) AS e ON cnn.[pedon_key]=e.[1990_2010_key]

  LEFT OUTER JOIN (SELECT [pedon_key] AS [2010_key] , CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END AS [2010]  FROM [combine_nasis_ncss] --- 1990 Between and 2010
 WHERE  CASE WHEN site_obsdate IS NULL THEN DATEPART(YEAR,samp_classdate) ELSE DATEPART(YEAR, site_obsdate) END >= 2010) AS f ON cnn.[pedon_key]=f.[2010_key]

 INNER JOIN [pedon] AS p ON p.pedon_key=cnn.pedon_key 