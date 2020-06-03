SELECT areasymbol, areaname, mapunit.mukey, muname, compname,  SUBSTRING(  (  SELECT  ( ', ' +  hydgrp)
FROM component AS co
WHERE  co.compname = s.compname
GROUP BY hydgrp
ORDER BY hydgrp
FOR XML PATH('') ), 3, 50) as  HSG, drainagecl
--INTO #temp_hsg
FROM (SELECT   compname, hydgrp
FROM legend 
       INNER JOIN mapunit ON mapunit.lkey=legend.lkey AND LEFT (areasymbol, 2) <> 'US'
              INNER JOIN component ON component.mukey=mapunit.mukey 
              AND compkind = 'Series' hydgrp = 'D' AND drainagecl ='Moderately well drained'
              AND majcompflag = 'Yes' GROUP BY compname, hydgrp ) AS s

             -- GROUP BY s.compname
       
    
