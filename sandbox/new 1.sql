FROM areatype
INNER JOIN area BY default 
INNER JOIN legend BY default AND legendsuituse = 'current wherever mapped' 
			AND area.areasymbol LIKE ? 'Soil Survey Area-Wildcard use percent' 
AND areatype.areatypename = 'Non-MLRA Soil Survey Area'

INNER JOIN lmapunit BY default
			AND mustatus IN ('approved', 'correlated')
INNER JOIN mapunit BY default
INNER JOIN correlation BY default
			AND repdmu = 1
INNER JOIN datamapunit BY default
INNER JOIN component by default
INNER JOIN chorizon By default AND desgnmaster != 'O'
INNER JOIN chunified BY default 
AND chunified.rvindicator = 1 
 AND unifiedcl = 'PT'