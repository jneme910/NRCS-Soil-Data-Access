---Dominant Component
--KSat50_150
--Coarse50_150

--Starts by collecting all the map units
SELECT areasymbol, areaname, mapunit.mukey, musym, nationalmusym, muname, mukind
INTO #main
FROM legend
INNER JOIN mapunit on mapunit.lkey=legend.lkey 
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
(hrz.frag3to10_r + hrz.fraggt10_r) + 
	                        ((100 - (hrz.frag3to10_r + hrz.fraggt10_r)) - hrz.sieveno10_r + 
	                        (hrz.sieveno10_r * (hrz.sandtotal_r * 0.01)) * ((100 - (hrz.frag3to10_r + hrz.fraggt10_r)) * 0.01)) as totCoarse

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
WHEN hzdepb_r <= 150 THEN hzdepb_r  WHEN hzdepb_r > 150 and hzdept_r < 150 THEN 150 ELSE 50 END  <=100
ORDER BY 
muname, 
mukey,
comppct_r DESC, compname, cokey, hzdept_r ASC, hzdepb_r ASC, chkey





