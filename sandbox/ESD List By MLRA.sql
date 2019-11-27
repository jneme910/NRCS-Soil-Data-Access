SELECT areasymbol AS MLRA_SYM, areaname AS MLRA_Name
FROM laoverlap
WHERE laoverlap.areatypename ='MLRA' 
GROUP BY areasymbol ,  areaname ORDER BY areasymbol ASC



SELECT lao.areasymbol AS MLRA, lao.areaname AS MLRA_Name, ecoclasstypename, ecoclassid, ecoclassname, ecoclassref 
FROM  legend 
INNER JOIN laoverlap AS lao ON legend.lkey = lao.lkey AND lao.areasymbol = '77B'
INNER JOIN muaoverlap AS mua ON mua.lareaovkey = lao.lareaovkey AND lao.areatypename='mlra' 
INNER JOIN mapunit AS mu ON mu.mukey = mua.mukey 
INNER JOIN component c ON c.mukey = mu.mukey AND compkind = 'series' 
INNER JOIN coecoclass on c.cokey = coecoclass.cokey and coecoclass.ecoclassref like 'Ecological Site Description Database'
GROUP BY lao.areasymbol , lao.areaname, ecoclasstypename, ecoclassid, ecoclassname, ecoclassref  ORDER BY lao.areasymbol ASC, ecoclassid

SELECT lao.areasymbol AS MLRA, lao.areaname AS MLRA_Name,  ecoclassid, ecoclassname, muname, mu.mukey, musym,  nationalmusym, legend.areasymbol, legend.areaname FROM  legend INNER JOIN laoverlap AS lao ON legend.lkey = lao.lkey AND lao.areasymbol = '77B' INNER JOIN muaoverlap AS mua ON mua.lareaovkey = lao.lareaovkey AND lao.areatypename='mlra' INNER JOIN mapunit AS mu ON mu.mukey = mua.mukey INNER JOIN component c ON c.mukey = mu.mukey AND compkind = 'series' INNER JOIN coecoclass on c.cokey = coecoclass.cokey and coecoclass.ecoclassref = 'Ecological Site Description Database' AND ecoclassid = 'R067BY015CO' GROUP BY lao.areasymbol , lao.areaname, ecoclassid, ecoclassname, muname, mu.mukey, musym,  nationalmusym, legend.areasymbol, legend.areaname  ORDER BY lao.areasymbol ASC, ecoclassid