DROP TABLE IF EXISTS #cr

--Soil Data Access
SELECT

LEFT((areasymbol), 2) as state
, l.areasymbol
, l.areaname
--take the worst case R and C factor for resource planning if multiples appear in a survey area
, (SELECT TOP 1 (CAST (laoverlap.areasymbol AS int)) FROM laoverlap WHERE laoverlap.areatypename Like 'Rainfall Factor Area%' and l.lkey=laoverlap.lkey GROUP BY laoverlap.areasymbol ORDER BY laoverlap.areasymbol desc) as Rfact
, (SELECT TOP 1 (CAST (laoverlap.areasymbol AS int)) FROM laoverlap WHERE laoverlap.areatypename Like 'Climate Factor Area%' and l.lkey=laoverlap.lkey GROUP BY laoverlap.areasymbol ORDER BY laoverlap.areasymbol desc) as Cfact


, mu.mukey
, mu.musym
, mu.nationalmusym
, mu.muname
, mukind
INTO #cr
FROM legend AS l
INNER JOIN mapunit AS mu ON mu.lkey=l.lkey AND LEFT (areasymbol, 2) <> 'US'

SELECT * , 
CASE WHEN Rfact IS NULL AND Cfact IS NULL THEN 1 ELSE 0 END AS both, 
CASE WHEN Rfact IS NULL THEN 1 ELSE 0 END AS Rfcount, 
CASE WHEN Cfact IS NULL THEN 1 ELSE 0 END AS Cfcount,
CASE WHEN Rfact IS NULL THEN 1 
WHEN Cfact IS NULL THEN 1 ELSE 0 END atleastone
FROM #cr WHERE CASE WHEN Rfact IS NULL THEN 1 
WHEN Cfact IS NULL THEN 1 ELSE 2 END = 1;