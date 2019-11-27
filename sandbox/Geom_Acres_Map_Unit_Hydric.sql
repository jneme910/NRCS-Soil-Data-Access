~DeclareGeometry(@aoi)~
SELECT 
 @aoi = geometry::STPolyFromText('polygon((
	-89.0700262286494 42.6083562860473,
			-89.0698426377674 42.6067698000198,
			-89.0682328840136 42.6041462670002,
			-89.0662190157062 42.6031633982762,
			-89.0636822729005 42.6022591642253,
			-89.0616781246165 42.6018038350401,
			-89.0601276887192 42.6016835897038,
			-89.0589401435416 42.601697906859,
			-89.058875877763 42.6020664744245,
			-89.0626599934687 42.6050453675497,
			-89.0633647145541 42.6075442924625,
			-89.0640092941339 42.6081518517664,
			-89.0660439774781 42.6083747992314,
			-89.0693478837049 42.6084488660588,
			-89.0700262286494 42.6083562860473))', 4326)-- 4326, is WGS84 geographic coordinates (epsg:4326) 
~DeclareIdGeomTable(@intersectedPolygonGeometries)~
~GetClippedMapunits(@aoi,polygon,geo,@intersectedPolygonGeometries)~
~DeclareIdGeogTable(@intersectedPolygonGeographies)~
~GetGeogFromGeomWgs84(@intersectedPolygonGeometries,@intersectedPolygonGeographies)~

-- get aggregated areas and associated mukey, musym, nationalmusym, areasymbol
SELECT 1 AS temp_id, id, SUM(geog.STArea()) AS area -- SQ Meters 
INTO #polyarea
FROM @intersectedPolygonGeographies
GROUP BY id;

-- Return the polygons with joined data. 
SELECT 
	mukey AS MUKEY, 
	area AS Area, 
	ROUND (area/4046.856,2) AS Acres, 
	musym AS [Map unit symbol], 
	nationalmusym AS National_symbol, 
	areasymbol AS [Area Symbol], areaname, 
	mlraoffice,
	areaacres, 
	projectscale, 
	mukey, 
	nationalmusym, 
	musym, 
	muname, 
	mukind,  
	muacres, 
	farmlndcl,
	pct_hydric, 
	pct_component, 
	n_component, 
	n_majcompflag, 
	l.lkey
FROM #polyarea AS p
INNER JOIN mapunit AS m ON p.id = m.mukey
INNER JOIN legend AS l ON l.lkey = m.lkey
 LEFT OUTER JOIN
  (
  SELECT co.mukey co_mukey, 
   SUM(comppct_r * CASE WHEN hydricrating = 'Yes' THEN 1 ELSE 0 END) pct_hydric,
   SUM(comppct_r) pct_component,
   COUNT(*) n_component,
   SUM(CASE WHEN majcompflag  = 'Yes' THEN 1 ELSE 0 END) n_majcompflag
  FROM component co
  GROUP BY co.mukey
  ) co ON co.co_mukey = m.mukey;
  


-- Return the aggregated area by mukey
SELECT  area, SUM (ALL ROUND (area/4046.856,2))  over(partition by temp_id)   AS [Total Acres]
FROM #polyarea



  