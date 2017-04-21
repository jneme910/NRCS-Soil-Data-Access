---Gets the Dominant Component
--Gets Max Coarse50_150 by intersecting horizons the occur between 50 and 150 cm 


--Starts by collecting all the map units
SELECT areasymbol, areaname, mapunit.mukey, musym, nationalmusym, muname, mukind
INTO #main
FROM legend
INNER JOIN mapunit on mapunit.lkey=legend.lkey  --AND mapunit.mukey= 753505
AND legend.areasymbol = 'WI025'


---Gets only the dominant component 
SELECT 
#main.mukey,
muname, 
cokey,
compname,
comppct_r 
INTO #acpf  
FROM #main
INNER JOIN component ON component.mukey=#main.mukey
AND component.cokey = 
(SELECT TOP 1 c1.cokey FROM component AS c1 
INNER JOIN mapunit AS m ON c1.mukey=m.mukey AND c1.mukey=#main.mukey ORDER BY c1.comppct_r DESC, CASE WHEN LEFT (muname,2)= LEFT (compname,2) THEN 1 ELSE 2 END ASC, c1.cokey) 

--Gets only the horizons that intersect 50 AND 150 
SELECT #acpf.mukey,
muname, 
#acpf.cokey,
#acpf.compname,
#acpf.comppct_r, hzname, chkey, hzdept_r,  hzdepb_r, 

CASE WHEN frag3to10_r IS NULL THEN 0 
WHEN frag3to10_r = '' THEN 0 
ELSE frag3to10_r END AS frag3to10_r, 

CASE WHEN fraggt10_r IS NULL THEN 0 
WHEN fraggt10_r = '' THEN 0 
ELSE fraggt10_r END AS fraggt10_r, 

CASE WHEN sieveno10_r IS NULL THEN 0
WHEN sieveno10_r  = '' THEN 0 
 ELSE sieveno10_r END AS sieveno10_r, 
 
 
CASE WHEN sandtotal_r IS NULL THEN 0
WHEN sandtotal_r  = '' THEN 0 
 ELSE sandtotal_r END AS sandtotal_r, 				
							
CASE    WHEN hzdepb_r < 50 THEN 0
WHEN hzdept_r >150 THEN 0 
WHEN hzdepb_r >= 50 AND hzdept_r < 50 THEN 50 
WHEN hzdept_r < 50 THEN 0
		WHEN hzdept_r < 150 then hzdept_r ELSE 50 END AS InRangeTop_50_100 ,
		
	
CASE   WHEN hzdept_r > 150 THEN 0
WHEN hzdepb_r < 50 THEN 0
WHEN hzdepb_r <= 150 THEN hzdepb_r  WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150 ELSE 50 END AS InRangeBot_50_100
INTO #acpf2
FROM #acpf
INNER JOIN chorizon ON chorizon.cokey=#acpf.cokey 
AND CASE    WHEN hzdepb_r < 50 THEN 0
WHEN hzdept_r >150 THEN 0 
WHEN hzdepb_r >= 50 AND hzdept_r < 50 THEN 50 
WHEN hzdept_r < 50 THEN 0
		WHEN hzdept_r < 150 then hzdept_r ELSE 50 END  >= 50 AND 
		
CASE   WHEN hzdept_r > 150 THEN 0
WHEN hzdepb_r < 50 THEN 0
WHEN hzdepb_r <= 150 THEN hzdepb_r  WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150 ELSE 50 END  <=150
ORDER BY 
muname, 
mukey,
comppct_r DESC, compname, cokey, hzdept_r ASC, hzdepb_r ASC, chkey

--------------------------------------
SELECT mukey,
muname, 
cokey,
compname,
comppct_r, hzname, chkey, hzdept_r,  hzdepb_r,
CASE 
WHEN frag3to10_r IS NULL AND fraggt10_r IS NULL AND sandtotal_r  IS NULL THEN 0
WHEN frag3to10_r = 0  AND fraggt10_r = 0  AND sandtotal_r  = 0  THEN 0 ELSE 
ROUND((frag3to10_r + fraggt10_r) + 
	                        ((100 - (frag3to10_r + fraggt10_r)) - sieveno10_r + 
	                        (sieveno10_r * (sandtotal_r * 0.01)) * ((100 - (frag3to10_r + fraggt10_r)) * 0.01)),2) END  AS Initial_totCoarse	
INTO #acpf3							
FROM #acpf2  							
ORDER BY 
muname, 
mukey,
comppct_r DESC, compname, cokey, hzdept_r ASC, hzdepb_r ASC, chkey


------------------------------------------------
SELECT DISTINCT  muname, 
mukey, MAX(Initial_totCoarse) over(PARTITION BY compname) as Initial_totCoarse2
INTO #last_step
FROM #acpf3

SELECT DISTINCT  muname, 
mukey, ISNULL (Initial_totCoarse2, 0) AS totCoarse
INTO #last_step2
FROM #last_step

SELECT #main.mukey,
#main.muname, 
totCoarse
FROM #last_step2
RIGHT OUTER JOIN #main ON #main.mukey=#last_step2.mukey
ORDER BY #main.muname ASC, #main.mukey, totCoarse


	

							
							





