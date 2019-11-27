SELECT areasymbol, musym AS musymbol, muname, mukey
 INTO #main
 FROM legend  AS lks
 INNER JOIN  mapunit AS muks ON muks.lkey = lks.lkey AND lks.areasymbol ='WA661' AND muks.mukey = 74955
 
 
 SELECT mu1.mukey,  SUM (comppct_r) over(partition by mu1.mukey ) AS SUM_COMP_PCT, 
 c1.cokey,  c1.compname, c1.comppct_r, c1.majcompflag, c1.compkind, c1.localphase, c1.otherph, c1.taxorder, 
c1.taxsubgrp, c1.hydricrating, c1.drainagecl
 INTO #comp_level
 FROM legend  AS l1
 INNER JOIN  mapunit AS mu1 ON mu1.lkey = l1.lkey AND l1.areasymbol = 'WA661 'AND mu1.mukey = 74955
 INNER JOIN  component AS c1 ON c1.mukey = mu1.mukey AND majcompflag = 'Yes'


 SELECT 
 H.hzname, 
 H.desgnmaster, 
 H.chkey, 
 H.hzdept_r,
 H.hzdepb_r, 
 H.awc_r, 
 H.ksat_r, 
 H.sandtotal_r, 
 H.silttotal_r, 
 H.claytotal_r,
 H.sandfine_r AS vfsand,
 H.om_r,
 H.dbthirdbar_r, 
 H.ph1to1h2o_r,
 H.ec_r, 
 CHTG.texture,
SUBSTRING(  (  SELECT ( '-' + texcl)
FROM chtexturegrp AS CHTG2
INNER JOIN chtexture AS CT2 ON CHTG2.chtgkey = CT2.chtgkey
AND CHTG2.chtgkey = CHTG.chtgkey
ORDER BY CHTG.chtgkey, CHTG2.chtgkey
FOR XML PATH('') ), 2, 50) as textcls, 

SUBSTRING(  (  SELECT ( '-' + lieutex)
FROM chtexturegrp AS CHTG3
INNER JOIN chtexture AS CT3 ON CHTG3.chtgkey = CT3.chtgkey
AND CHTG3.chtgkey = CHTG.chtgkey
ORDER BY CHTG.chtgkey, CHTG3.chtgkey
FOR XML PATH('') ), 3, 50) as lieutex2, 

 (SELECT SUM(CF.fragvol_r) FROM chfrags AS CF WHERE H.chkey = CF.chkey GROUP BY CF.chkey) AS fragvol, 
 #comp_level.cokey,  #comp_level.compname, #comp_level.comppct_r, #comp_level.majcompflag, #comp_level.compkind, #comp_level.localphase, #comp_level.otherph, #comp_level.taxorder, 
#comp_level.taxsubgrp, #comp_level.hydricrating, #comp_level.drainagecl, #comp_level.mukey
 INTO #horizon_level
 FROM #comp_level
 INNER JOIN chorizon AS H ON #comp_level.cokey = H.cokey AND H.hzdept_r IS NOT NULL AND H.hzdepb_r IS NOT NULL
 INNER JOIN chtexturegrp AS  CHTG ON H.chkey = CHTG.chkey AND CHTG.rvindicator = 'Yes'
 INNER JOIN chtexture AS CT ON CHTG.chtgkey = CT.chtgkey
 
 
 SELECT 
 areasymbol, 
 musymbol, 
 muname, 
 #main.mukey,
 hzname, 
 desgnmaster, 
 chkey, 
 hzdept_r,
 hzdepb_r, 
 awc_r, 
 ksat_r, 
 sandtotal_r, 
 silttotal_r, 
 claytotal_r,
vfsand,
 om_r,
 dbthirdbar_r, 
 ph1to1h2o_r,
 ec_r, 
texture, 
textcls, 
lieutex2 AS lieutex, 
fragvol, 
cokey,  
compname, 
comppct_r, 
majcompflag, 
compkind, 
localphase, 
otherph, 
taxorder, 
taxsubgrp, 
hydricrating, 
drainagecl
 FROM #main
 LEFT OUTER JOIN #horizon_level ON #horizon_level.mukey=#main.mukey
 



 

SELECT M.mukey, M.musym AS musymbol, M.muname, C.cokey,  C.compname, C.comppct_r, C.majcompflag, C.compkind, C.localphase, C.otherph, C.taxorder, 
C.taxsubgrp, C.hydricrating, C.drainagecl, H.hzname, H.desgnmaster, H.chkey, H.hzdept_r, H.hzdepb_r, H.awc_r, H.ksat_r, H.sandtotal_r, 
H.silttotal_r, H.claytotal_r, H.sandfine_r AS vfsand, H.om_r, H.dbthirdbar_r, H.ph1to1h2o_r, H.ec_r, CHTG.texture, CT.texcl as textcls, 
CT.lieutex, (SELECT SUM(CF.fragvol_r) FROM chfrags CF WHERE H.chkey = CF.chkey GROUP BY CF.chkey) AS fragvol
            FROM mapunit M WITH (nolock)
            INNER JOIN legend L ON L.lkey = M.lkey AND L.areasymbol = 'WA661' AND M.mukey = 74955
            LEFT OUTER JOIN component C ON M.mukey = C.mukey AND C.comppct_r IS NOT NULL
            LEFT OUTER JOIN chorizon H ON C.cokey = H.cokey AND H.hzdept_r IS NOT NULL AND H.hzdepb_r IS NOT NULL
            LEFT OUTER JOIN chtexturegrp CHTG ON H.chkey = CHTG.chkey AND CHTG.rvindicator = 'Yes'
            LEFT OUTER JOIN chtexture CT ON CHTG.chtgkey = CT.chtgkey
            ORDER BY M.mukey, C.comppct_r DESC, C.cokey, H.hzdept_r ASC

