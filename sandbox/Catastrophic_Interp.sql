
--Define the area
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
DECLARE @domc INT ;

-- Soil Data Access
--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 
--~DeclareINT(@area_type)~ 
-- End soil data access
SELECT @area= 'WI'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025


SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area

 SELECT TOP 10 areasymbol, musym, muname, mu.mukey/1  AS MUKEY, 
--DHS - Catastrophic Event, Large Animal Mortality, Burial
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Event, Large Animal Mortality, Burial' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999 )as ce_lam_b_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Event, Large Animal Mortality, Burial'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as ce_lam_b_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Catastrophic Event, Large Animal Mortality, Burial' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) )as ce_lam_b_reason,

--Catastrophic Event, Large Animal Mortality, Incinerate
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Event, Large Animal Mortality, Incinerate' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as ce_lam_i_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Event, Large Animal Mortality, Incinerate'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as ce_lam_i_class,
 
 (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Catastrophic Event, Large Animal Mortality, Incinerate' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS ce_lam_i_reason,

 --DHS - Catastrophic Mortality, Large Animal Disposal, Pit
 ISNULL ((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Mortality, Large Animal Disposal, Pit' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as ce_lad_p_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Mortality, Large Animal Disposal, Pit'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as ce_lad_p_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Catastrophic Mortality, Large Animal Disposal, Pit' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS ce_lad_p_reason, 

 --DHS - Catastrophic Mortality, Large Animal Disposal, Trench
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Mortality, Large Animal Disposal, Trench' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as ce_lad_t_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Catastrophic Mortality, Large Animal Disposal, Trench'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as ce_lad_t_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Catastrophic Mortality, Large Animal Disposal, Trench' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS ce_lad_t_reason, 

 --DHS - Site for Composting Facility - Subsurface
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Site for Composting Facility - Subsurface' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as scfss_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Site for Composting Facility - Subsurface'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as scfss_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Site for Composting Facility - Subsurface' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS scfss_reason ,

 --DHS - Site for Composting Facility - Surface
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Site for Composting Facility - Surface' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as scfs_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Site for Composting Facility - Surface'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as scfs_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Site for Composting Facility - Surface' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS scfs_reason, 


 --DHS - Suitability for Clay Liner Material
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Suitability for Clay Liner Material' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC),9999) as sclm_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Suitability for Clay Liner Material'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as sclm_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Suitability for Clay Liner Material' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS sclm_reason, 


 --DHS - Suitability for Composting Medium and Final Cover
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Suitability for Composting Medium and Final Cover' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC) , 9999) as scmfc_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'DHS - Suitability for Composting Medium and Final Cover'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as scmfc_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'DHS - Suitability for Composting Medium and Final Cover' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS scmfc_reason, 


 --MIL - Trafficability Veh. Type 7 50-passes wet season (DOD)	
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'MIL - Trafficability Veh. Type 7 50-passes wet season (DOD)' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as mt7ws_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'MIL - Trafficability Veh. Type 7 50-passes wet season (DOD)'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as mt7ws_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'MIL - Trafficability Veh. Type 7 50-passes wet season (DOD)' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS mt7ws_reason, 

 --MIL - Trafficability Veh. Type 7 dry season (DOD)
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'MIL - Trafficability Veh. Type 7 dry season (DOD)' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as mt7ds_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'MIL - Trafficability Veh. Type 7 dry season (DOD)'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as mt7ds_class,
 
  (SELECT DISTINCT SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM mapunit
INNER JOIN component ON component.mukey=mapunit.mukey AND compkind != 'miscellaneous area' AND component.cokey=c.cokey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey 

AND ruledepth != 0 AND interphrc NOT LIKE 'Not%' AND mrulename LIKE 'MIL - Trafficability Veh. Type 7 dry season (DOD)' GROUP BY interphrc, interphr
ORDER BY interphr DESC, interphrc
FOR XML PATH('') ), 3, 1000) ) AS mt7ds_reason


 FROM legend  AS l
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND  CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area
 INNER JOIN  component AS c ON c.mukey = mu.mukey AND c.cokey =
 (SELECT TOP 1 c1.cokey FROM component AS c1
 INNER JOIN mapunit ON c.mukey=mapunit.mukey AND c1.mukey=mu.mukey ORDER BY c1.comppct_r DESC, c1.cokey)
 ORDER BY areasymbol, musym, muname, mu.mukey

--DHS - Catastrophic Event, Large Animal Mortality, Burial
--DHS - Catastrophic Event, Large Animal Mortality, Incinerate
--DHS - Catastrophic Mortality, Large Animal Disposal, Pit
--DHS - Catastrophic Mortality, Large Animal Disposal, Trench
--DHS - Site for Composting Facility - Subsurface
--DHS - Site for Composting Facility - Surface
--DHS - Suitability for Clay Liner Material
--DHS - Suitability for Composting Medium and Final Cover

--MIL - Trafficability Veh. Type 7 50-passes wet season (DOD)	
--MIL - Trafficability Veh. Type 7 dry season (DOD)
