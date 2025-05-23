DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @mlra VARCHAR(20);

~DeclareChar(@area,20)~  -- Used for Soil Data Access
~DeclareINT(@area_type)~ 
~DeclareChar(@mlra,20)~  

SELECT @mlra= '112' -- Enter MLRA here


SELECT  
 ecoclassid, ecoclassname, s.compname, ecoclasstypename, ecoclassref, 

s.areasymbol AS ssa, muname, mukey, compname, cokey, comppct_r, (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + lao.areasymbol)
FROM mapunit AS m
INNER JOIN muaoverlap AS mua ON mua.mukey=m.mukey 
INNER JOIN laoverlap AS lao ON mua.lareaovkey = lao.lareaovkey AND lao.areatypename='mlra'   AND s.mukey=m.mukey
ORDER BY lao.areasymbol ASC 
FOR XML PATH('') ), 3, 1000) )as [mlra_sym], 
taxtempcl, taxmoistscl, taxtempregime

FROM (SELECT   ecoclassid, ecoclassname, legend.areasymbol, ecoclasstypename, ecoclassref, muname,musym,  mapunit.mukey, compname, c.cokey, comppct_r, taxtempcl, taxmoistscl, taxtempregime, lao.areasymbol AS mlra
FROM legend 
       INNER JOIN mapunit ON mapunit.lkey=legend.lkey  
	   INNER JOIN muaoverlap AS mua ON mua.mukey = mapunit.mukey
	   INNER JOIN laoverlap AS lao ON mua.lareaovkey = lao.lareaovkey AND lao.areatypename='mlra'  AND lao.areasymbol IN (@mlra)   
       INNER JOIN component AS c ON c.mukey=mapunit.mukey
			  AND majcompflag = 'Yes' 

INNER JOIN coecoclass on c.cokey = coecoclass.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database'
	 
			  ) AS s 

ORDER BY ecoclassid, ecoclassname, s.compname,  muname ASC, s.areasymbol ASC, mukey, comppct_r DESC, cokey






