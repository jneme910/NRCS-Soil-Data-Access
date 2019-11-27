SELECT TOP 100 l.mlraoffice, LEFT((l.areasymbol), 2) as state, l.areasymbol, m.musym, m.muname, c.compname, hzdept_r, ROUND (sandtotal_r, 2) AS sandtotal_r, ROUND ((ISNULL (sandvc_r, 0) +ISNULL (sandco_r, 0) + ISNULL (sandmed_r, 0) + ISNULL (sandfine_r, 0) +ISNULL (sandvf_r, 0)) , 2) as CalcTotalSand, sandvc_r, sandco_r, sandmed_r, sandfine_r, sandvf_r, silttotal_r, claytotal_r, c.cokey, ch.chkey, 
ROUND ((sandtotal_r) ,2) as Sandtotalpop
INTO #SAND
FROM legend l 
    inner join mapunit m ON l.lkey = m.lkey
    inner join component c ON m.mukey = c.mukey
  inner join chorizon ch ON c.cokey = ch.cokey
AND l.areasymbol <> 'US' AND LEFT (l.areasymbol,2) = 'WI' AND majcompflag = 'yes' AND ROUND (sandtotal_r,2)  <> ROUND ((CASE WHEN sandvc_r IS NULL THEN 0 ELSE sandvc_r END) 

+ (CASE WHEN sandco_r IS NULL THEN 0 ELSE sandco_r END) 
+ (CASE WHEN sandmed_r IS NULL THEN 0 ELSE sandmed_r END) 
+  (CASE WHEN sandfine_r IS NULL THEN 0 ELSE sandfine_r END)
 + (CASE WHEN sandvf_r IS NULL THEN 0 ELSE sandvf_r END)
 

 , 2) AND c.cokey =16345983
ORDER by l.mlraoffice, l.areasymbol, m.musym, c.compname, ch.hzdept_r 

SELECT mlraoffice, state, areasymbol, musym, compname, cokey, chkey, hzdept_r, CalcTotalSand, Sandtotalpop
FROM #SAND
WHERE CalcTotalSand != Sandtotalpop
ORDER BY mlraoffice, state, areasymbol, musym, compname, cokey, chkey 
