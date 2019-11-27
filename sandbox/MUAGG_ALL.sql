SELECT areasymbol, mu.musym, mu.muname, mu.mukey, hydgrpdcd
FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND  l.areasymbol LIKE 'WI025' 
INNER JOIN muaggatt ON muaggatt.mukey=mu.mukey
