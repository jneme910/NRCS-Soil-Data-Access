SELECT 
mapunit.mukey, 
component.cokey,
component.comppct_r,

chtexturegrp.texture as Texture,
(SELECT TOP 1 chtexture.texcl FROM chtexturegrp AS cht INNER JOIN  chtexture ON cht.chtgkey=chtexture.chtgkey AND cht.rvindicator='yes' AND cht.chtgkey=chtexturegrp.chtgkey)  as TextCls,
(SELECT TOP 1 cop1.pmgroupname 
FROM component   AS c3 
INNER JOIN copmgrp AS cop1 ON cop1.cokey=c3.cokey AND component.cokey=c3.cokey AND cop1.rvindicator ='Yes') as ParMatGrp ,
(SELECT TOP 1  copm1.pmkind  FROM component AS c2 	  INNER JOIN copmgrp AS cop2 ON cop2.cokey=c2.cokey  INNER JOIN copm AS copm1 ON copm1.copmgrpkey=cop2.copmgrpkey AND component.cokey=c2.cokey AND cop2.rvindicator ='Yes' ORDER BY pmorder ASC, copm1.copmgrpkey ASC) as ParMatKind
FROM sacatalog 
INNER JOIN legend ON legend.areasymbol = sacatalog.areasymbol AND LEFT (sacatalog.areasymbol,2) = 'WI' 
INNER JOIN mapunit ON mapunit.lkey = legend.lkey 
INNER JOIN component ON component.mukey=mapunit.mukey AND majcompflag = 'yes' 
AND component.cokey = 
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit AS c ON c1.mukey=c.mukey AND c.mukey=mapunit.mukey ORDER BY c1.comppct_r DESC,CASE WHEN LEFT (muname,2)= LEFT (compname,2) THEN 1 ELSE 2 END ASC, c1.cokey) 
LEFT JOIN (chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey) ON component.cokey = chorizon.cokey 
AND (((chorizon.hzdept_r)=(SELECT Min(chorizon.hzdept_r) AS MIN_hor_depth_r
FROM chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey 
WHERE chtexturegrp.texture Not In ('SPM','HPM', 'MPM') AND chtexturegrp.rvindicator='Yes' AND component.cokey = chorizon.cokey ))AND ((chtexturegrp.rvindicator)='yes'))
