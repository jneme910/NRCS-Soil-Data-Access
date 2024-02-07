SELECT mukey, muname
FROM mapunit
WHERE mukey IN (
SELECT * from SDA_Get_Mukey_from_intersection_with_WktWgs84('point(-121.77100 37.368402)'))