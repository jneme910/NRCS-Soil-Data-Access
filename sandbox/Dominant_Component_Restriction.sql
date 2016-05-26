SELECT QUOTENAME (sacatalog.areasymbol, '"') AS AREASYMBOL, 
mapunit.mukey AS mukey, 
QUOTENAME (mapunit.musym, '"') AS MUSYM,
QUOTENAME (mapunit.muname, '"') AS MUNAME,
QUOTENAME (CONCAT(mapunit.mukey, ' - ', cokey), '"') AS MUCOMPKEY,
QUOTENAME (compname, '"') AS COMPNAME, 
QUOTENAME (comppct_r, '"') AS COMPPCT_R,
component.cokey,


ISNULL((SELECT TOP 1 MIN (resdept_l) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE 'Paralithic bedrock' AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_l) , 9999)AS L_PARALITHIC,


ISNULL((SELECT TOP 1 MIN (resdept_l) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE 'Paralithic bedrock' AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_r) , 9999) AS RV_PARALITHIC,


ISNULL((SELECT TOP 1 MIN (resdept_h) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE 'Paralithic bedrock' AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_h), 9999) AS H_PARALITHIC,

ISNULL((SELECT TOP 1 MIN (resdept_l) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE 'Lithic bedrock' AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_l), 9999) AS L_LITHIC,

ISNULL((SELECT TOP 1 MIN (resdept_r) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE 'Lithic bedrock' AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_r), 9999)  AS RV_LITHIC,

ISNULL((SELECT TOP 1 MIN (resdept_h) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
and reskind LIKE 'Lithic bedrock' AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_h), 9999)  AS H_LITHIC,
--,

--(SELECT TOP 1 MIN (resdept_r) 
--FROM component AS c

--INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
-- AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_r) AS MIN_FIRST_RESTRICTION,

ISNULL((SELECT TOP 1 reskind
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
AND c.cokey=component.cokey  GROUP BY c.cokey, reskind, resdept_r, corestrictkey ORDER BY resdept_r, corestrictkey ), 'No Data') AS FIRST_RESTRICTION_KIND,

ISNULL((SELECT TOP 1 MIN (resdept_l) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
 AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_l), 9999) AS L_FIRST_RESTRICTION,

ISNULL((SELECT TOP 1 MIN (resdept_r) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
 AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_r), 9999) AS RV_FIRST_RESTRICTION,

ISNULL((SELECT TOP 1 MIN (resdept_h) 
FROM component AS c

INNER JOIN corestrictions ON corestrictions.cokey=c.cokey
AND c.cokey=component.cokey  GROUP BY c.cokey, resdept_h), 9999) AS H_FIRST_RESTRICTION

---INTO #main
FROM sacatalog 
INNER JOIN legend  ON legend.areasymbol = sacatalog.areasymbol AND LEFT (sacatalog.areasymbol, 2) = 'WI'
--AND LEFT ((sacatalog.areasymbol),2) = 'WI'
INNER JOIN mapunit  ON mapunit.lkey = legend.lkey
INNER JOIN component ON component.mukey=mapunit.mukey AND majcompflag = 'Yes'
AND component.cokey =
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit AS c ON c.mukey=c.mukey AND c1.mukey=mapunit.mukey ORDER BY c1.comppct_r DESC, c1.cokey) 

