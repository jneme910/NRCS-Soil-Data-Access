DROP TABLE IF EXISTS #map;

SELECT  LEFT (areasymbol,2) AS state_sym, areaname, REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,'http://websoilsurvey.nrcs.usda.gov/app/WebSoilSurvey.aspx?aoissa=', areasymbol, 'zz>', areasymbol,'</a>'), 'zz', '''') AS areasymbol, muname,  musym, mu.mukey,
REPLACE (CONCAT ('<a target=zz_blankzz href=zz' ,'https://casoilresource.lawr.ucdavis.edu/soil_web/ssurgo.php?action=explain_mapunit&mukey=', mu.mukey, 'zz>Click Here</a>'), 'zz', '''') AS [Soil_Web],
CASE WHEN compkind = 'series' THEN REPLACE (CONCAT ('<a target=zzzzz_blankzzzzz href=zzzzz' ,'https://casoilresource.lawr.ucdavis.edu/see/#', compname, 'zzzzz>Click Here</a>'), 'zzzzz', '''') ELSE '' END AS [soil_series_extent],
CASE WHEN compkind = 'series' THEN REPLACE (CONCAT ('<a target=zzzzz_blankzzzzz href=zzzzz' ,'https://casoilresource.lawr.ucdavis.edu/sde/?series=', compname, 'zzzzz>Click Here</a>'), 'zzzzz', '''') ELSE '' END AS [soil_data_explorer],
compname, c.cokey,  comppct_r, majcompflag, hzdept_r, hzdepb_r,  sandtotal_r, silttotal_r, sandmed_r, 
LEFT (ROUND (CASE WHEN  silttotal_r = 0 THEN 0 WHEN claytotal_r = 0 THEN 0 ELSE [silttotal_r]/[claytotal_r] END,2),4) AS silt_clay_ratio,
LEFT (ROUND ([sandmed_r]/[sandtotal_r],2),4) AS med_sand_ratio, chkey

FROM legend  AS l
INNER JOIN mapunit AS mu ON mu.lkey=l.lkey AND LEFT(l.areasymbol,2)  <> 'US'
INNER JOIN  component AS c ON c.mukey = mu.mukey  AND majcompflag = 'Yes' 
INNER JOIN  chorizon AS ch ON c.cokey = ch.cokey AND ([sandtotal_r] BETWEEN 60 AND 65 AND [claytotal_r] IS NOT NULL AND [silttotal_r] IS NOT NULL AND [sandmed_r] IS NOT NULL--AND [sand_medium] >= 50
AND CASE WHEN  silttotal_r = 0 THEN 0 WHEN claytotal_r = 0 THEN 0 ELSE [silttotal_r]/[claytotal_r] END BETWEEN 0.75 AND 1 
AND LEFT (ROUND ([sandmed_r]/[sandtotal_r],2),4) >= .0
)
GROUP BY areaname, areasymbol, muname,  musym, mu.mukey, compname, c.cokey,  comppct_r, majcompflag, hzdept_r, hzdepb_r,  sandtotal_r, silttotal_r, sandmed_r, claytotal_r, chkey, compkind
ORDER BY areasymbol ASC,areaname,  muname, mu.mukey, comppct_r DESC, c.cokey, hzdept_r ASC, chkey


 --select GEOGRAPHY::STGeomFromWKB(
   --  (P.mupolygongeo.STUnion(mupolygongeo.STStartPoint()).STAsBinary()),
   --   4326)
 -- from mupolygon AS P
 -- INNER JOIN #map AS M ON P.mukey = M.mukey
  --WHERE P.mukey IN (1865918)