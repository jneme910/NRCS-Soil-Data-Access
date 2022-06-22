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
--INTO #cr
FROM legend AS l
INNER JOIN mapunit AS mu ON mu.lkey=l.lkey AND LEFT (areasymbol, 2) =  'WI' ORDER BY areasymbol, mu.musym ASC

