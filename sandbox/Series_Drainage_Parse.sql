
DROP TABLE IF EXISTS #ss
DROP TABLE IF EXISTS #ss4


CREATE TABLE #ss
    ( siid INT IDENTITY (1,1),
    series VARCHAR(240)--,
  CONSTRAINT pk_ss PRIMARY KEY CLUSTERED (siid)
	);


INSERT INTO #ss SELECT 'ABERNATHY' AS series;
INSERT INTO #ss SELECT 'ALOPARK' AS series;
INSERT INTO #ss SELECT 'AMIRET' AS series;
INSERT INTO #ss SELECT 'AREKOTA' AS series;
INSERT INTO #ss SELECT 'ATCHISON' AS series;
INSERT INTO #ss SELECT 'AVANS' AS series;
INSERT INTO #ss SELECT 'AZUVINA' AS series;
INSERT INTO #ss SELECT 'BAILEYVILLE' AS series;
INSERT INTO #ss SELECT 'BARNWELL' AS series;
INSERT INTO #ss SELECT 'BAYLOCK' AS series;
INSERT INTO #ss SELECT 'BAZOO' AS series;
INSERT INTO #ss SELECT 'BEARTOWN' AS series;
INSERT INTO #ss SELECT 'BEETREE' AS series;
INSERT INTO #ss SELECT 'BELVUE' AS series;
INSERT INTO #ss SELECT 'BIGSPRING' AS series;
INSERT INTO #ss SELECT 'BLOCHER' AS series;
INSERT INTO #ss SELECT 'BLOODSTONE' AS series;
INSERT INTO #ss SELECT 'BLUEGRASS' AS series;
INSERT INTO #ss SELECT 'BOADES' AS series;
INSERT INTO #ss SELECT 'BOTERO' AS series;
INSERT INTO #ss SELECT 'BRANCHVILLE' AS series;
INSERT INTO #ss SELECT 'BROADKILL' AS series;
INSERT INTO #ss SELECT 'BUCYRUS' AS series;
INSERT INTO #ss SELECT 'BUFFALO PARK' AS series;
INSERT INTO #ss SELECT 'BURGUNDY' AS series;
INSERT INTO #ss SELECT 'CALGRO' AS series;
INSERT INTO #ss SELECT 'CANTERBURY' AS series;
INSERT INTO #ss SELECT 'CARL' AS series;
INSERT INTO #ss SELECT 'CARLOTTA' AS series;
INSERT INTO #ss SELECT 'CARWAY' AS series;
INSERT INTO #ss SELECT 'CATESBY' AS series;
INSERT INTO #ss SELECT 'CENTRALPARK' AS series;
INSERT INTO #ss SELECT 'CHERAW' AS series;
INSERT INTO #ss SELECT 'CLIFFORD' AS series;
INSERT INTO #ss SELECT 'CLIFFTOP' AS series;
INSERT INTO #ss SELECT 'COMITE' AS series;
INSERT INTO #ss SELECT 'COWPEN' AS series;
INSERT INTO #ss SELECT 'CROSIADORE' AS series;
INSERT INTO #ss SELECT 'CURRY' AS series;
INSERT INTO #ss SELECT 'DECHAMPS' AS series;
INSERT INTO #ss SELECT 'DEGATER' AS series;
INSERT INTO #ss SELECT 'DELMEXICO' AS series;
INSERT INTO #ss SELECT 'DEROIN' AS series;
INSERT INTO #ss SELECT 'DODON' AS series;
INSERT INTO #ss SELECT 'ECLIPSE' AS series;
INSERT INTO #ss SELECT 'EDGERLY' AS series;
INSERT INTO #ss SELECT 'ELFKIN' AS series;
INSERT INTO #ss SELECT 'ELPALOALTO' AS series;
INSERT INTO #ss SELECT 'EUTRUDEPTS' AS series;
INSERT INTO #ss SELECT 'FERNANDER' AS series;
INSERT INTO #ss SELECT 'FINE' AS series;
INSERT INTO #ss SELECT 'FLASKAN' AS series;
INSERT INTO #ss SELECT 'FLYCATCHER' AS series;
INSERT INTO #ss SELECT 'FORESTVILLE' AS series;
INSERT INTO #ss SELECT 'FORTRESS' AS series;
INSERT INTO #ss SELECT 'FRIERSON' AS series;
INSERT INTO #ss SELECT 'FRUITDALE' AS series;
INSERT INTO #ss SELECT 'FUNMAR' AS series;
INSERT INTO #ss SELECT 'GARBERVILLE' AS series;
INSERT INTO #ss SELECT 'GELLATLY' AS series;
INSERT INTO #ss SELECT 'GILHULA' AS series;
INSERT INTO #ss SELECT 'GOODCREEK' AS series;
INSERT INTO #ss SELECT 'GREEN LEVEL' AS series;
INSERT INTO #ss SELECT 'GUMZ' AS series;
INSERT INTO #ss SELECT 'GYPLAYA' AS series;
INSERT INTO #ss SELECT 'HAHNSPEAK' AS series;
INSERT INTO #ss SELECT 'HAVERLON' AS series;
INSERT INTO #ss SELECT 'HAYDENFORK' AS series;
INSERT INTO #ss SELECT 'HEMLOCK' AS series;
INSERT INTO #ss SELECT 'HERMITAGE' AS series;
INSERT INTO #ss SELECT 'HICKORYKNOB' AS series;
INSERT INTO #ss SELECT 'ICEHOUSE' AS series;
INSERT INTO #ss SELECT 'KEATCHIE' AS series;
INSERT INTO #ss SELECT 'KENDUSKEAG' AS series;
INSERT INTO #ss SELECT 'KINDRED' AS series;
INSERT INTO #ss SELECT 'KINGSTOWNE' AS series;
INSERT INTO #ss SELECT 'LAHASH' AS series;
INSERT INTO #ss SELECT 'LANDISBURG' AS series;
INSERT INTO #ss SELECT 'LEMONVILLE' AS series;
INSERT INTO #ss SELECT 'LENNI' AS series;
INSERT INTO #ss SELECT 'LITHIC UDORTHENTS' AS series;
INSERT INTO #ss SELECT 'MACHO' AS series;
INSERT INTO #ss SELECT 'MANNIX' AS series;
INSERT INTO #ss SELECT 'MARGLENDALE' AS series;
INSERT INTO #ss SELECT 'MESIC NELLA' AS series;
INSERT INTO #ss SELECT 'MIDFIELD' AS series;
INSERT INTO #ss SELECT 'MILLSTREET' AS series;
INSERT INTO #ss SELECT 'MONTROSE' AS series;
INSERT INTO #ss SELECT 'MORENDA' AS series;
INSERT INTO #ss SELECT 'MT CARROLL' AS series;
INSERT INTO #ss SELECT 'MT VERNON' AS series;
INSERT INTO #ss SELECT 'NACOGDOCHESPRIOR' AS series;
INSERT INTO #ss SELECT 'NASSAWANGO' AS series;
INSERT INTO #ss SELECT 'OAK LEVEL' AS series;
INSERT INTO #ss SELECT 'OGBORN' AS series;
INSERT INTO #ss SELECT 'OLINVILLE' AS series;
INSERT INTO #ss SELECT 'ONEILL' AS series;
INSERT INTO #ss SELECT 'OPOLIS' AS series;
INSERT INTO #ss SELECT 'PANUMKEY' AS series;
INSERT INTO #ss SELECT 'PAPAKATING' AS series;
INSERT INTO #ss SELECT 'PAULINS KILL' AS series;
INSERT INTO #ss SELECT 'PEAKIN' AS series;
INSERT INTO #ss SELECT 'PENOBSCOT' AS series;
INSERT INTO #ss SELECT 'PHAROAH' AS series;
INSERT INTO #ss SELECT 'PICKEDOVER' AS series;
INSERT INTO #ss SELECT 'PIKECREEK' AS series;
INSERT INTO #ss SELECT 'PLEDGERLOW' AS series;
INSERT INTO #ss SELECT 'POLD' AS series;
INSERT INTO #ss SELECT 'PRAIRIEVIEW' AS series;
INSERT INTO #ss SELECT 'PUNKIN' AS series;
INSERT INTO #ss SELECT 'QUINDOCQUA' AS series;
INSERT INTO #ss SELECT 'RAINBEAR' AS series;
INSERT INTO #ss SELECT 'ROBBERSFIRE' AS series;
INSERT INTO #ss SELECT 'ROSEDALE' AS series;
INSERT INTO #ss SELECT 'ROSSVILLE' AS series;
INSERT INTO #ss SELECT 'SAMALA' AS series;
INSERT INTO #ss SELECT 'SANDY OVER' AS series;
INSERT INTO #ss SELECT 'SANDYSKELETAL' AS series;
INSERT INTO #ss SELECT 'SCHAFFER' AS series;
INSERT INTO #ss SELECT 'SEBASTICOOK' AS series;
INSERT INTO #ss SELECT 'SMITHAL' AS series;
INSERT INTO #ss SELECT 'SNDI' AS series;
INSERT INTO #ss SELECT 'ST PAUL' AS series;
INSERT INTO #ss SELECT 'STONEHOUSE' AS series;
INSERT INTO #ss SELECT 'SWAINSFLAT' AS series;
INSERT INTO #ss SELECT 'SWAINTON' AS series;
INSERT INTO #ss SELECT 'TOMLIN' AS series;
INSERT INTO #ss SELECT 'TORNERO' AS series;
INSERT INTO #ss SELECT 'TYPIC HAPLOHUMULTS' AS series;
INSERT INTO #ss SELECT 'UNIVERSITY' AS series;
INSERT INTO #ss SELECT 'USELESSBAY' AS series;
INSERT INTO #ss SELECT 'VICTORIALOW' AS series;
INSERT INTO #ss SELECT 'WAGONBED' AS series;
INSERT INTO #ss SELECT 'WASSOOKEAG' AS series;
INSERT INTO #ss SELECT 'WEDDEL' AS series;
INSERT INTO #ss SELECT 'WEST POINT' AS series;
INSERT INTO #ss SELECT 'WINDFETCH' AS series;
INSERT INTO #ss SELECT 'WOODMAN' AS series;
INSERT INTO #ss SELECT 'WOOLLY' AS series;
INSERT INTO #ss SELECT 'WRAYS' AS series;
INSERT INTO #ss SELECT 'YAPLE' AS series;
INSERT INTO #ss SELECT 'YOGOVUCI' AS series;



--SELECT * FROM #ss ORDER BY series ASC;

CREATE TABLE #ss4
    ( 
	compname VARCHAR (240),
	drainagecl VARCHAR (240)
	);

----Gets the dominant Component (If more thean 1 component with the same name the script will sum up the component name
----Gets the Drainage Class
---TRUNCATE TABLE #ss4
INSERT INTO #ss4

SELECT 
CASE WHEN compname LIKE '%variant%' THEN UPPER (REPLACE (compname, 'variant', ''))
	 WHEN compname LIKE '%family%' THEN UPPER (REPLACE (compname, 'family', ''))
	 WHEN compname LIKE '%taxadjunct%' THEN UPPER (REPLACE (compname, 'taxadjunct', '')) ELSE UPPER (REPLACE (compname, '''', ' ')) END AS compname, drainagecl
 

FROM legend 
INNER JOIN mapunit  ON legend.lkey=mapunit.lkey AND  (legend.areasymbol) <> 'US' 
INNER JOIN component ON mapunit.mukey=component.mukey --AND majcompflag = 'yes'
;
--AND component.cokey = 
--(SELECT TOP 1 c1.cokey FROM component AS c1 
--INNER JOIN mapunit AS c ON c1.mukey=c.mukey AND c.mukey=mapunit.mukey ORDER BY 
--SUM(c1.comppct_r) over(partition by compname) DESC , CASE WHEN LEFT (muname,2)= LEFT (compname,2) THEN 1 ELSE 2 END ASC, c1.cokey)) 
--ORDER BY compname ASC



--SUBSTRING(  (  SELECT ( ', ' + drainagecl)
--FROM component AS  c2   
--WHERE component.cokey=c2.cokey
--ORDER BY component.cokey, c2.cokey
--FOR XML PATH('') ), 3, 1000) as drainagecl_list


SELECT DISTINCT series, compname, SUBSTRING(  (  SELECT DISTINCT ( ', ' + drainagecl)
FROM component AS  c2   
WHERE #ss4.compname=c2.compname
--ORDER BY #ss4.cokey, c2.cokey
FOR XML PATH('') ), 3, 1000) as drainagecl_list

FROM #ss 
LEFT OUTER JOIN #ss4 ON #ss4.compname=#ss.series GROUP BY series, compname ORDER BY series ASC;

