--Define the area
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @InRangeTop INT;
DECLARE @InRangeBot INT;
DECLARE @major INT;


-- Soil Data Access
/*
~DeclareChar(@area,20)~  -- Used for Soil Data Access
~DeclareINT(@area_type)~
~DeclareINT(@major)~
*/
-- End soil data access

SELECT @area= 'WI'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025
SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area
SELECT @major = 0; -- Enter 0 for major component, enter 1 for all components


SELECT 
 areasymbol, musym, muname, mu.mukey/1  AS mukey,
 (SELECT TOP 1 coecoclass.ecoclassname
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey       AND (CASE
                                            WHEN 1 = @major
                                                THEN 0
                                            WHEN majcompflag = 'Yes'
                                                THEN 0
                                            ELSE
                                                1
                                        END = 0
                                       )
INNER JOIN coecoclass on component.cokey = coecoclass.cokey  
AND mapunit.mukey = mu.mukey and ecoclasstypename like 'Forage Suitability Groups' 
GROUP BY coecoclass.ecoclassname, comppct_r ORDER BY SUM(comppct_r) over(partition by coecoclass.ecoclassname) DESC) as dom_cond_FSG_class,
(SELECT TOP 1 coecoclass.ecoclassid
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey      AND (CASE
                                            WHEN 1 = @major
                                                THEN 0
                                            WHEN majcompflag = 'Yes'
                                                THEN 0
                                            ELSE
                                                1
                                        END = 0
                                       )
INNER JOIN coecoclass on component.cokey = coecoclass.cokey 
AND mapunit.mukey = mu.mukey and ecoclasstypename like 'Forage Suitability Groups' 
GROUP BY ecoclassid, comppct_r ORDER BY SUM(comppct_r) over(partition by ecoclassid) DESC) as dom_cond_FSG_id,
 
 (SELECT TOP 1 coecoclass.ecoclassname
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey       AND (CASE
                                            WHEN 1 = @major
                                                THEN 0
                                            WHEN majcompflag = 'Yes'
                                                THEN 0
                                            ELSE
                                                1
                                        END = 0
                                       )
INNER JOIN coecoclass on component.cokey = coecoclass.cokey 
AND mapunit.mukey = mu.mukey and  coecoclass.ecoclassref like 'Ecological Site Description Database'
GROUP BY ecoclassname, comppct_r ORDER BY SUM(comppct_r) over(partition by ecoclassname) DESC) as dom_cond_ESD_class,
 (SELECT TOP 1 coecoclass.ecoclassid
FROM mapunit 
INNER JOIN component ON component.mukey=mapunit.mukey      AND (CASE
                                            WHEN 1 = @major
                                                THEN 0
                                            WHEN majcompflag = 'Yes'
                                                THEN 0
                                            ELSE
                                                1
                                        END = 0
                                       )
INNER JOIN coecoclass on component.cokey = coecoclass.cokey 
AND mapunit.mukey = mu.mukey and coecoclass.ecoclassref like 'Ecological Site Description Database'
GROUP BY ecoclassid, comppct_r ORDER BY SUM(comppct_r) over(partition by ecoclassid) DESC) as dom_cond_ESD_id


FROM legend  AS l
INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND CASE WHEN @area_type = 2 THEN LEFT (l.areasymbol, 2) ELSE l.areasymbol END = @area

ORDER BY areasymbol, musym, muname, mu.mukey





