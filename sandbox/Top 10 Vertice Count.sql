SELECT TOP 10  MAX (m.vertex_count) AS max_vertex_count, m.mukey 
FROM (SELECT  SUM(mupolygongeo.STNumPoints()) AS vertex_count, mukey 
FROM mupolygon  
INNER JOIN mapunit ON mapunit.mukey= mupolygon.mukey
INNER JOIN legend ON mapunit.lkey=legend.lkey AND areasymbol <> 'US'
GROUP BY mukey) AS m
GROUP BY m.vertex_count, m.mukey 
ORDER BY m.vertex_count, m.mukey

