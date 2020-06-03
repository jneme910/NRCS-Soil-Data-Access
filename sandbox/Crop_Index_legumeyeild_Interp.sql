SET STATISTICS IO ON 

USE sdmONLINE
go

DROP TABLE IF EXISTS #map;
DROP TABLE IF EXISTS #map2;
DROP TABLE IF EXISTS #map3;

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


CREATE TABLE #map
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250), 
	compname VARCHAR (250), 
	comppct_r INT,
	cokey INT, 
	WI_CCPI_rating REAL, 
	WI_CCPI_class VARCHAR(100), 
	NCCPI_rating REAL , 
	NCCPI_class VARCHAR(100),
	major_mu_pct_sum INT, 
	datestamp VARCHAR(32), 
	)


--Queries the map unit and legend
--Link Main
INSERT INTO #map (areaname, areasymbol, musym, mukey, muname, compname, comppct_r, cokey, WI_CCPI_rating, WI_CCPI_class, NCCPI_rating, NCCPI_class, major_mu_pct_sum,  datestamp )
 SELECT l.areaname, l.areasymbol, musym, mu.mukey, muname, compname, comppct_r, c.cokey, 
 ---(select TOP 1 cocropyld.nonirryield_r from cocropyld where c.cokey=cocropyld.cokey and cropname like 'Pasture') as PastureYLD,

--Commodity Crop Productivity Index (Corn) (WI)
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (WI)' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999 )as WI_CCPI_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (WI)'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as WI_CCPI_class,
 

--Catastrophic Event, Large Animal Mortality, Incinerate
 ISNULL((SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 3.0)' GROUP BY interphrc, interphr
 ORDER BY SUM (comppct_r) DESC), 9999) as NCCPI_rating,
 (SELECT TOP 1 interphrc
 FROM mapunit
 INNER JOIN component ON component.mukey=mapunit.mukey
 INNER JOIN cointerp ON component.cokey = cointerp.cokey AND mapunit.mukey = mu.mukey AND ruledepth = 0 AND mrulename LIKE 'NCCPI - National Commodity Crop Productivity Index (Ver 3.0)'
 GROUP BY interphrc, comppct_r ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as NCCPI_class,
 (SELECT SUM (CCO.comppct_r)
FROM mapunit AS MM2
INNER JOIN component AS CCO ON CCO.mukey = MM2.mukey AND mu.mukey = MM2.mukey AND majcompflag = 'Yes') AS  major_mu_pct_sum,
 CONCAT ([SC].[areasymbol] , ' ' , FORMAT ( [SC].[saverest], 'dd-MM-yy')) AS datestamp 


 FROM sacatalog SC 
 INNER JOIN legend  AS l ON l.areasymbol = SC.areasymbol
 INNER JOIN  mapunit AS mu ON mu.lkey = l.lkey AND  CASE WHEN @area_type = 2 THEN LEFT (l.areasymbol, 2) ELSE l.areasymbol END = @area
 INNER JOIN  component AS c ON c.mukey = mu.mukey AND majcompflag = 'yes'
 ORDER BY l.areasymbol, musym, muname, mu.mukey

--Commodity Crop Productivity Index (Corn) (WI)
--NCCPI - National Commodity Crop Productivity Index (Ver 3.0)

CREATE TABLE #map2
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250), 
	compname VARCHAR (250), 
	comppct_r INT,
	cokey INT, 
	major_mu_pct_sum INT, 
	adj_comp_pct REAL,

	WI_CCPI_rating REAL, 
	WI_CCPI_class VARCHAR(100), 
	NCCPI_rating REAL , 
	NCCPI_class VARCHAR(100),
	
	datestamp VARCHAR(32), 
	)


--Table 2
INSERT INTO #map2 (areaname, areasymbol, musym, mukey, muname, compname, comppct_r, cokey, major_mu_pct_sum, adj_comp_pct, WI_CCPI_rating, WI_CCPI_class, NCCPI_rating, NCCPI_class,   datestamp )

SELECT areaname, areasymbol, musym, mukey, muname, compname, comppct_r,  #map.cokey, major_mu_pct_sum,  ROUND ((1.0 * comppct_r / NULLIF(major_mu_pct_sum, 0)),2) AS adj_comp_pct, WI_CCPI_rating, WI_CCPI_class, NCCPI_rating, NCCPI_class, datestamp
FROM #map

CREATE TABLE #map3
   ( areaname VARCHAR (255), 
    areasymbol VARCHAR (20),
    musym VARCHAR (20), 
	mukey INT, 
	muname VARCHAR (250), 
	compname VARCHAR (250), 
	comppct_r INT,
	cokey INT, 
	major_mu_pct_sum INT, 
	adj_comp_pct REAL,

	WI_CCPI_rating REAL, 
	WI_CCPI_class VARCHAR(100), 
	NCCPI_rating REAL , 
	NCCPI_class VARCHAR(100),
	cropname VARCHAR(254),
	sum_crop REAL,
	datestamp VARCHAR(32), 
	)


--Table 3
INSERT INTO #map3 (areaname, areasymbol, musym, mukey, muname, compname, comppct_r, cokey, major_mu_pct_sum, adj_comp_pct, WI_CCPI_rating, WI_CCPI_class, NCCPI_rating, NCCPI_class, cropname, sum_crop, datestamp )
SELECT areaname, areasymbol, musym, mukey, muname, compname, comppct_r, #map2.cokey, major_mu_pct_sum, adj_comp_pct, WI_CCPI_rating, WI_CCPI_class, NCCPI_rating, NCCPI_class,    cropname ,  ROUND (SUM(nonirryield_r * adj_comp_pct) over(partition by mukey, #map2.cokey, cropname),2) sum_crop, datestamp
FROM #map2
LEFT OUTER JOIN cocropyld AS crop ON crop.cokey=#map2.cokey

 SELECT * FROM 
 (
 SELECT   areaname, areasymbol, musym, mukey, muname, WI_CCPI_rating, WI_CCPI_class, NCCPI_rating, NCCPI_class, cropname, sum_crop
 FROM #map3

 ) #r
 PIVOT (
 MIN (sum_crop)

   FOR cropname IN (
[Alfalfa hay],
[Bluegrass-white clover],
[Bromegrass hay],
[Bromegrass-alfalfa hay],
[Cool-season grasses],
[Grass hay],
[Grass-clover],
[Grass-legume hay],
[Grass-legume pasture],
[Improved permanent pasture],
[Kentucky bluegrass],
[Orchardgrass-alsike],
[Orchardgrass-red clover],
[Pasture],
[Reed canarygrass],
[Smooth bromegrass],
[Timothy-alsike],
[Timothy-red clover hay],
[Trefoil hay],
[Unimproved permanent pasture],
[Warm season grasses]
) 
) AS #crop_pivot_table;


