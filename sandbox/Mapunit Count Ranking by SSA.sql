SELECT areasymbol, areaname, COUNT (mukey) AS map_unit_count 
INTO #temp_count
FROM legend
INNER JOIN mapunit ON mapunit.lkey=legend.lkey AND areasymbol LIKE 'WI%'
GROUP BY areasymbol, areaname


SELECT areasymbol, areaname,  map_unit_count ,  RANK () over(partition by 1  ORDER BY map_unit_count DESC) as ranking
FROM #temp_count
