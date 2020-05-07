SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #map;
DROP TABLE IF EXISTS #water2
DROP TABLE IF EXISTS #water3
DROP TABLE IF EXISTS #water4

--Define the area
DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;


-- Soil Data Access
--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 
-- End soil data access
SELECT @area= 'WI'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025

----------------------------------------------------------------------------------
SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area
----------------------------------------------------------------------------------

--Table
CREATE TABLE #map
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250), 
	datestamp VARCHAR(32), 
	major_mu_pct_sum SMALLINT)


--Queries the map unit and legend
INSERT INTO #map (areaname, areasymbol, musym, mapunit.mukey, muname, datestamp, major_mu_pct_sum)
SELECT legend.areaname, legend.areasymbol, musym, mapunit.mukey, muname, CONCAT ([SC].[areasymbol] , ' ' , FORMAT ( [SC].[saverest], 'dd-MM-yy')) AS datestamp, 
(SELECT SUM (CCO.comppct_r)
FROM mapunit AS MM2
INNER JOIN component AS CCO ON CCO.mukey = MM2.mukey AND mapunit.mukey = MM2.mukey AND majcompflag = 'Yes') AS  major_mu_pct_sum
FROM (legend 
INNER JOIN mapunit ON legend.lkey=mapunit.lkey 
AND  CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area
)  
INNER JOIN sacatalog SC ON legend.areasymbol = SC.areasymbol


--Table
CREATE TABLE #water2
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250),
	major_mu_pct_sum SMALLINT, 
	compname VARCHAR (255), 
	localphase VARCHAR (40), 
	cokey INT, 
	comppct_r SMALLINT,
	min_soimoistdept_l SMALLINT, min_soimoistdept_r SMALLINT,  max_soimoistdept_h SMALLINT,  min_soimoistdepb_l SMALLINT, max_soimoistdepb_l SMALLINT, max_soimoistdepb_h SMALLINT, wtbottom_l SMALLINT, wtbottom_l_moist SMALLINT, wtbottom_r_moist SMALLINT, max_soimoistdepb_r SMALLINT, adj_comp_pct REAL, 
	datestamp VARCHAR(32)
	)


--Queries the map unit and legend
INSERT INTO #water2 (areaname, areasymbol, musym, mukey, muname,  major_mu_pct_sum, compname, localphase, cokey,comppct_r, 
min_soimoistdept_l , min_soimoistdept_r,max_soimoistdept_h,  min_soimoistdepb_l, max_soimoistdepb_l, max_soimoistdepb_h, wtbottom_l, wtbottom_l_moist, wtbottom_r_moist, max_soimoistdepb_r, 
adj_comp_pct,
datestamp)
SELECT DISTINCT 
areaname, areasymbol, musym, #map.mukey, muname,  major_mu_pct_sum, --Map Temp Table
c.compname, c.localphase, c.cokey, c.comppct_r, --Component Table
CAST((SELECT MIN (soimoistdept_l) FROM comonth AS co9
INNER JOIN cosoilmoist AS cospt9 ON cospt9.comonthkey=co9.comonthkey AND co9.comonthkey=co.comonthkey AND soimoiststat='wet' AND soimoiststat IS NOT NULL) AS int)  AS min_soimoistdept_l,
CAST ((SELECT MIN (soimoistdept_r) FROM comonth AS co13
INNER JOIN cosoilmoist AS cospt13 ON cospt13.comonthkey=co13.comonthkey AND co13.comonthkey=co.comonthkey AND soimoiststat='wet' AND soimoiststat IS NOT NULL)AS int)  AS min_soimoistdept_r,
(SELECT MAX (soimoistdept_h) FROM comonth AS co10
INNER JOIN cosoilmoist AS cospt10 ON cospt10.comonthkey=co10.comonthkey AND co10.comonthkey=co.comonthkey AND soimoiststat='wet' AND soimoiststat IS NOT NULL)  AS max_soimoistdept_h,
(SELECT MIN (CASE WHEN soimoistdepb_l >= 183 THEN 183 ELSE soimoistdepb_l END) FROM comonth AS co8
INNER JOIN cosoilmoist AS cospt8 ON cospt8.comonthkey=co8.comonthkey AND co8.comonthkey=co.comonthkey AND soimoiststat='wet' AND soimoiststat IS NOT NULL)  AS min_soimoistdepb_l,
(SELECT MAX (soimoistdepb_l) FROM comonth AS co8
INNER JOIN cosoilmoist AS cospt8 ON cospt8.comonthkey=co8.comonthkey AND co8.comonthkey=co.comonthkey AND soimoiststat='wet' AND soimoiststat IS NOT NULL)  AS max_soimoistdepb_l,
(SELECT MAX (CASE WHEN soimoistdepb_h >= 183 THEN 183 ELSE soimoistdepb_h END) FROM comonth AS co7
INNER JOIN cosoilmoist AS cospt7 ON cospt7.comonthkey=co7.comonthkey AND co7.comonthkey=co.comonthkey AND ISNULL (soimoiststat, 'moist') ='wet')  AS max_soimoistdepb_h,
(SELECT MAX (CASE WHEN (soimoistdepb_l) IS NULL THEN soimoistdepb_r ELSE soimoistdepb_l END) FROM comonth AS co5
INNER JOIN cosoilmoist AS cospt5 ON cospt5.comonthkey=co5.comonthkey AND co5.comonthkey=co.comonthkey)  AS wtbottom_l,
(SELECT MAX (soimoistdepb_l) FROM comonth AS co11
INNER JOIN cosoilmoist AS cospt11 ON cospt11.comonthkey=co11.comonthkey AND co11.comonthkey=co.comonthkey  AND ISNULL (soimoiststat, 'moist') !='wet')   AS wtbottom_l_moist,
CAST((SELECT CAST(MAX (CAST (soimoistdepb_r AS int))AS int)  FROM comonth AS co12
INNER JOIN cosoilmoist AS cospt12 ON cospt12.comonthkey=co12.comonthkey AND co12.comonthkey=co.comonthkey  AND ISNULL (soimoiststat, 'moist') !='wet') AS int)  AS wtbottom_r_moist,
CAST ((SELECT CAST (MAX (CAST(soimoistdepb_r AS int)) AS int) FROM comonth AS co15
INNER JOIN cosoilmoist AS cospt15 ON cospt15.comonthkey=co15.comonthkey AND co15.comonthkey=co.comonthkey AND soimoiststat='wet' AND soimoiststat IS NOT NULL)AS int)  AS max_soimoistdepb_r,
LEFT (ROUND ((1.0 * comppct_r / NULLIF(major_mu_pct_sum, 0)),2), 4) AS adj_comp_pct,
datestamp
FROM #map
INNER JOIN component AS c ON #map.mukey=c.mukey AND majcompflag = 'yes'
INNER JOIN comonth AS co ON co.cokey=c.cokey
GROUP BY areaname, areasymbol, musym, #map.mukey, muname,  major_mu_pct_sum, compname, localphase, c.cokey,comppct_r, co.comonthkey, datestamp


--Table
CREATE TABLE #water3
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250),
	major_mu_pct_sum SMALLINT, 
	compname VARCHAR (255), 
	localphase VARCHAR (40), 
	cokey INT, 
	comppct_r SMALLINT,
	min_soimoistdept_l SMALLINT, min_soimoistdept_r SMALLINT,  max_soimoistdept_h SMALLINT,  min_soimoistdepb_l SMALLINT, max_soimoistdepb_l SMALLINT, max_soimoistdepb_h SMALLINT, wtbottom_l SMALLINT, wtbottom_l_moist SMALLINT, wtbottom_r_moist SMALLINT, max_soimoistdepb_r SMALLINT, moisture_b2 REAL, adj_comp_pct REAL, 
	datestamp VARCHAR(32)
	)


--Queries the map unit and legend
INSERT INTO #water3 (areaname, areasymbol, musym, mukey, muname,  major_mu_pct_sum, compname, localphase, cokey,comppct_r, 
min_soimoistdept_l , min_soimoistdept_r,max_soimoistdept_h,  min_soimoistdepb_l, max_soimoistdepb_l, max_soimoistdepb_h, wtbottom_l, wtbottom_l_moist, wtbottom_r_moist, max_soimoistdepb_r,moisture_b2, adj_comp_pct, datestamp)

SELECT areaname, areasymbol, musym, mukey, muname,  major_mu_pct_sum, compname, localphase, cokey,comppct_r, 
min_soimoistdept_l , min_soimoistdept_r,max_soimoistdept_h,  min_soimoistdepb_l, max_soimoistdepb_l, max_soimoistdepb_h, wtbottom_l, wtbottom_l_moist, wtbottom_r_moist, max_soimoistdepb_r,
CASE WHEN min_soimoistdepb_l IS NULL THEN  NULL
WHEN (min_soimoistdepb_l) = (max_soimoistdepb_h) THEN  LEFT (ROUND (min_soimoistdepb_l/30.48, 2) ,3)
WHEN (max_soimoistdepb_h) IS NULL AND  (min_soimoistdepb_l) IS NOT NULL  THEN LEFT (ROUND( min_soimoistdepb_l/30.48, 2),3) 
ELSE LEFT (ROUND(min_soimoistdepb_l/30.48, 2),3) END AS moisture_b2, adj_comp_pct, datestamp
FROM #water2

CREATE TABLE #water4
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250),
	major_mu_pct_sum SMALLINT, 
	compname VARCHAR (255), 
	localphase VARCHAR (40), 
	cokey INT, 
	comppct_r SMALLINT,
	min_soimoistdept_l SMALLINT, min_soimoistdept_r SMALLINT,  max_soimoistdept_h SMALLINT,  min_soimoistdepb_l SMALLINT, max_soimoistdepb_l SMALLINT, max_soimoistdepb_h SMALLINT, wtbottom_l SMALLINT, wtbottom_l_moist SMALLINT, wtbottom_r_moist SMALLINT, max_soimoistdepb_r SMALLINT, moisture_b2 REAL, adj_comp_pct REAL, perched_apparent VARCHAR (10),
	datestamp VARCHAR(32)
	)


--Queries the map unit and legend
INSERT INTO #water4 (areaname, areasymbol, musym, mukey, muname,  major_mu_pct_sum, compname, localphase, cokey,comppct_r, 
min_soimoistdept_l , min_soimoistdept_r,max_soimoistdept_h,  min_soimoistdepb_l, max_soimoistdepb_l, max_soimoistdepb_h, wtbottom_l, wtbottom_l_moist, wtbottom_r_moist, max_soimoistdepb_r,moisture_b2, adj_comp_pct, perched_apparent, datestamp)

SELECT areaname, areasymbol, musym, mukey, muname,  major_mu_pct_sum, compname, localphase, cokey,comppct_r, 
min_soimoistdept_l , min_soimoistdept_r,max_soimoistdept_h,  min_soimoistdepb_l, max_soimoistdepb_l, max_soimoistdepb_h, wtbottom_l, wtbottom_l_moist, wtbottom_r_moist, max_soimoistdepb_r,moisture_b2,
adj_comp_pct, 
CASE WHEN max_soimoistdepb_h IS NULL  THEN 'Not Rated' 
WHEN (moisture_b2)  IS NULL THEN 'Not Rated' 
WHEN moisture_b2 = 6 THEN 'Apparent' 
WHEN wtbottom_l = max_soimoistdepb_l THEN 'Apparent'  
WHEN wtbottom_r_moist >  max_soimoistdepb_r THEN 'Perched'  
WHEN wtbottom_l_moist >  max_soimoistdepb_l  THEN 'Perched' ELSE 'Perched' END AS perched_apparent,

datestamp
FROM #water3

SELECT DISTINCT  #map.areaname, #map.areasymbol, #map.musym, #map.mukey, #map.muname , (SELECT TOP 1 perched_apparent
FROM #water4 AS w 
WHERE w.mukey = #water4.mukey 
GROUP BY perched_apparent, adj_comp_pct ORDER BY SUM(CAST (adj_comp_pct AS real)) over(partition by perched_apparent) DESC) AS  dom_cond_pearched_apparent
FROM #map
LEFT OUTER JOIN #water4 ON #water4.mukey=#map.mukey 
GROUP BY #map.areaname , #map.areasymbol, #map.musym, #map.mukey, #water4.mukey , #map.muname , perched_apparent
ORDER BY #map.areasymbol ASC, #map.musym ASC, #map.mukey ASC, #map.muname ASC


DROP TABLE IF EXISTS #map;
DROP TABLE IF EXISTS #water2
DROP TABLE IF EXISTS #water3
DROP TABLE IF EXISTS #water4