SELECT  DISTINCT compname, soimoistdept_r, soimoiststat, (SELECT DISTINCT LEAD(soimoistdept_r, 2,soimoistdept_r) OVER (PARTITION BY component.cokey ORDER BY (soimoistdept_r)) FROM component AS c1 WHERE c1.cokey=component.cokey) AS LAG_test, component.cokey
FROM sacatalog 
INNER JOIN legend  ON legend.areasymbol = sacatalog.areasymbol AND sacatalog.areasymbol = 'IL019'
---AND LEFT (sacatalog.areasymbol,2) = 'WI' -- SOIL SURVEYS 
INNER JOIN mapunit  ON mapunit.lkey = legend.lkey
INNER JOIN component ON component.mukey = mapunit.mukey  
AND majcompflag = 'Yes'   
AND mapunit.mukey=242966
INNER JOIN comonth ON comonth.cokey=component.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey 

--AND ((soimoiststat IN ('Dry', 'Moist') AND soimoistdept_r >=30))
