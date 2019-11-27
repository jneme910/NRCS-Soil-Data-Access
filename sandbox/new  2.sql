SELECT QUOTENAME (sacatalog.areasymbol, '"') AS AREASYMBOL, 
mapunit.mukey AS mukey, 
mapunit.musym AS MUSYM,
mapunit.muname AS MUNAME,
CASE WHEN (SELECT TOP 1  hydgrp FROM mapunit AS m_sl INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  AND majcompflag = 'yes' AND hydgrp = 'A' AND m_sl.mukey=mapunit.mukey GROUP BY m_sl.mukey, hydgrp) = 'A' THEN 'P' ELSE 'NR' END AS Hydro_Group_A_ANY_COMP,
CASE WHEN (SELECT TOP 1  MIN (resdept_r) 
FROM mapunit AS m_sl 
INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  
AND majcompflag = 'Yes' 
AND m_sl.mukey=mapunit.mukey  
 INNER JOIN corestrictions ON corestrictions.cokey=c_sl.cokey AND resdept_r <50 GROUP BY m_sl.mukey, resdept_r) IS NOT NULL THEN 'R' ELSE 'NR' END AS RV_BEDROCK_ANY_MAJ_COMP_LESS_THAN_50CM,
CASE WHEN (SELECT TOP 1  MIN (soimoistdept_r) 
FROM mapunit AS m_sl 
INNER JOIN component AS c_sl ON m_sl.mukey = c_sl.mukey  
AND majcompflag = 'yes'   AND m_sl.mukey=mapunit.mukey  
INNER JOIN comonth ON comonth.cokey=c_sl.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey AND soimoiststat = 'Wet' AND soimoistdept_r <30
GROUP BY m_sl.mukey, soimoistdept_r) IS NOT NULL THEN 'W' ELSE 'NR' END AS RV_WATER_LESS_12_ANY_MAJ_COMP