SELECT 
CAST (mapunit.mukey AS VARCHAR (30)) AS mukey,
CAST (component.cokey AS VARCHAR (30)) AS cokey,
CAST (chorizon.chkey AS VARCHAR (30))  AS chkey ,
component.comppct_r AS CompPct,
component.compname AS  CompName,
component.compkind AS  CompKind,
component.taxclname AS TaxCls,
CASE WHEN (chorizon.hzdepb_r-chorizon.hzdept_r) IS NULL THEN 0 ELSE CAST ((hzdepb_r-hzdept_r)  AS INT) END AS HrzThick,
CAST (chorizon.om_r AS DECIMAL (8,3)) AS OM,
CAST (chorizon.ksat_r AS DECIMAL (8,3)) AS  KSat,
CAST (chorizon.kffact AS DECIMAL (8,3)) AS kffact,
CAST (chorizon.kwfact AS DECIMAL (8,3)) AS kwfact,
CAST (chorizon.sandtotal_r AS DECIMAL (8,3)) AS totalSand ,		-- total sand, silt and clay fractions 
CAST (chorizon.silttotal_r AS DECIMAL (8,3)) AS totalSilt,
CAST (chorizon.claytotal_r AS DECIMAL (8,3)) AS totalClay,
CAST (chorizon.sandvf_r	AS DECIMAL (8,3)) AS VFSand,		        -- sand sub-fractions 
CAST (chorizon.dbthirdbar_r AS DECIMAL (8,3)) AS DBthirdbar	
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
WHERE chtexturegrp.texture Not In ('SPM','HPM', 'MPM') AND chtexturegrp.rvindicator='yes' AND component.cokey = chorizon.cokey ))AND ((chtexturegrp.rvindicator)='yes'))


