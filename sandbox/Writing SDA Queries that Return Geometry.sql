select G.MupolygonWktWgs84 as geom, mapunit.mukey, muname
FROM mapunit
CROSS APPLY SDA_Get_MupolygonWktWgs84_from_Mukey(mapunit.mukey) as G
WHERE mukey IN (SELECT DISTINCT mukey FROM component WHERE compname like 'Antigo%' AND majcompflag = 'Yes')