~DeclareGeometry(@aoi)~
SELECT @aoi = geometry::STPolyFromText('polygon(( -92.2487354592 40.4775958391,-92.2481449938 40.4733969736,-92.2465048119 40.4740202427,-92.2433228591 40.4740530463,-92.2465048119 40.47697257,-92.2487354592 40.4775958391))', 4326)

--   Extract all intersected polygons
~DeclareIdGeomTable(@intersectedPolygonGeometries)~
~GetClippedMapunits(@aoi,polygon,geo,@intersectedPolygonGeometries)~

--   Convert geometries to geographies so we can get areas
~DeclareIdGeogTable(@intersectedPolygonGeographies)~
~GetGeogFromGeomWgs84(@intersectedPolygonGeometries,@intersectedPolygonGeographies)~

--   Return the polygonal geometries
SELECT * FROM @intersectedPolygonGeographies
where geog.STGeometryType() = 'Polygon'