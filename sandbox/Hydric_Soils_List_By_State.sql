SELECT areasymbol, areaname, muname, mapunit.mukey/1 AS mukey , musym, compname, component.cokey/1 AS cokey, comppct_r, drainagecl AS drainage_class
FROM (legend INNER JOIN (mapunit INNER JOIN component ON mapunit.mukey = component.mukey AND majcompflag = 'yes') ON legend.lkey = mapunit.lkey 
AND LEFT(legend.areasymbol,2) LIKE 'MN')
