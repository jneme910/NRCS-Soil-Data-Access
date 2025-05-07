SELECT   legend.areasymbol, muname , 
		legend.[areasymbol]
      ,[spatialversion]
      ,mapunit.[musym]
      ,mapunit.[nationalmusym]
      ,mapunit.[mukey]
      ,[muareaacres]
      ,[mupolygongeo].STAsText() soilgeom
--      ,[mupolygonproj]
      ,[mupolygonkey]
    
FROM legend 
INNER JOIN dbo.mapunit ON mapunit.lkey = legend.lkey
AND 
CASE WHEN  musym IN ('NOTCOM', 'NOTPUB') THEN 1
WHEN  UPPER (muname) LIKE '%DENIED%' THEN 1
WHEN UPPER (muname) LIKE '%ACCESS%' THEN 1
WHEN UPPER ( muname) LIKE '%NO SOILS DATA%' THEN 1
WHEN UPPER(muname) LIKE '%NOT SURVEY%'THEN 1
WHEN UPPER (muname) LIKE '%NO DATA%' THEN 1
WHEN UPPER (muname) LIKE '%UNMAPPED%'  THEN 1
WHEN UPPER (muname) LIKE '%NOT MAPPED%' THEN 1 
WHEN UPPER (muname) LIKE '%LIMIT%' THEN 1
WHEN UPPER (muname) LIKE '%MILITARY IMPACT%' THEN 1 ELSE 2 END = 1
INNER JOIN dbo.mupolygon ON mupolygon.mukey = mapunit.mukey
