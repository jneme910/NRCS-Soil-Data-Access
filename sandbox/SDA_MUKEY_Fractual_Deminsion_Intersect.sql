  DROP TABLE IF EXISTS #temp2;
  
  select  mupolygonGeography.STLength()AS STLength,
       ( 2.0 * LOG(0.25 * mupolygonGeography.STLength()) ) / LOG(mupolygonGeography.STArea() ) AS fd,  LOG ( mupolygonGeography.STArea()) AS Log_polyarea,  mupolygonGeography.STArea() AS polyarea  
  --INTO #temp2
  from 
  (
  select GEOGRAPHY::STGeomFromWKB(
       (P.mupolygongeo.STUnion(mupolygongeo.STStartPoint()).STAsBinary()), 
       4326) as mupolygonGeography
  from mupolygon AS P 
  INNER JOIN mapunit AS M ON P.mukey = M.mukey 
  WHERE P.mukey IN (808535) 
  ) as subselect


 -- SELECT STLength, fd, Log_polyarea,polyarea 
 -- FROM #temp2
 -- ORDER BY fd DESC
