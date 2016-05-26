FROM (lmapunit INNER JOIN (mapunit LEFT JOIN correlation ON mapunit.muiid = correlation.muiidref WHERE repdmu=1) ON lmapunit.muiidref = mapunit.muiid) 


FROM  (area_type
(INNER JOIN  area ON area_type.areatypeiid=area.areatypeiidref 
						AND areatypename = 'Non-MLRA Soil Survey Area'
INNER JOIN  legend ON legend.areaiidref=area.areaiid 
						AND legendsuituse = 'current wherever mapped' 

 AND area.areasymbol IN LIKE (?) 'Soil Survey Area-Wildcard use percent' 





INNER JOIN  lmapunit ON lmapunit.liidref=legend.liid AND mustatus IN ('approved', 'correlated') 
INNER JOIN  mapunit ON mapunit.muiid=lmapunit.muiidref 
INNER JOIN  correlation ON correlation.muiidref=mapunit.muiid AND repdmu= 1) lmapunit.muiidref = mapunit.muiid)
INNER JOIN  datamapunit ON datamapunit.dmuiid=correlation.dmuiidref 
INNER JOIN  component ON component.dmuiidref=datamapunit.dmuiid

FROM (lmapunit
INNER JOIN (mapunit LEFT JOIN correlation 
ON mapunit.muiid = correlation.muiidref=mapunit.muiid) 
ON lmapunit.muiidref = mapunit.muiid)

FROM (lmapunit
INNER JOIN (mapunit LEFT JOIN correlation 
ON mapunit.muiid = correlation.muiidref) 
ON lmapunit.muiidref = mapunit.muiid)

LEFT JOIN (chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey) ON component.cokey = chorizon.cokey
WHERE (((chorizon.hzdept_r)=(SELECT Min(chorizon.hzdept_r) AS MinOfhzdept_r
FROM chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey
Where chtexturegrp.texture Not In ('SPM','HPM', 'MPM') AND chtexturegrp.rvindicator='Yes' AND component.cokey = chorizon.cokey ))
