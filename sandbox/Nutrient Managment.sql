SELECT mapunit.musym, cointerp.mrulename, cointerp.ruledepth, Max(cointerp.interplr) AS MaxOfinterplr, component.majcompflag, mapunit.mukey
INTO #Temp
FROM (mapunit INNER JOIN component ON mapunit.mukey = component.mukey) Inner JOIN cointerp ON component.cokey = cointerp.cokey
GROUP BY mapunit.musym, cointerp.mrulename, cointerp.ruledepth, component.majcompflag, mapunit.mukey
HAVING (((cointerp.mrulename)='AWM - 590 Main Rule - Months (WI)') AND ((cointerp.ruledepth)=0) AND ((component.majcompflag)='Yes'))

SELECT mapunit.musym, cointerp.mrulename, cointerp.ruledepth, Max(cointerp.interplr) AS MaxOfinterplr, component.majcompflag, cointerp.rulename, mapunit.mukey
INTO #TempPerm
FROM mapunit INNER JOIN (component INNER JOIN cointerp ON component.cokey=cointerp.cokey) ON mapunit.mukey=component.mukey
GROUP BY mapunit.musym, cointerp.mrulename, cointerp.ruledepth, component.majcompflag, cointerp.rulename, mapunit.mukey
HAVING (((cointerp.mrulename)='AWM - 590 Main Rule - Months (WI)') AND ((cointerp.ruledepth)=1) AND ((component.majcompflag)='Yes') AND ((cointerp.rulename)='WI-590 Permeable Soils Subrule'));

SELECT mapunit.musym, cointerp.mrulename, cointerp.ruledepth, Max(cointerp.interplr) AS MaxOfinterplr, component.majcompflag, cointerp.rulename, mapunit.mukey
INTO #TempRock
FROM mapunit INNER JOIN (component INNER JOIN cointerp ON component.cokey=cointerp.cokey) ON mapunit.mukey=component.mukey
GROUP BY mapunit.musym, cointerp.mrulename, cointerp.ruledepth, component.majcompflag, cointerp.rulename, mapunit.mukey
HAVING (((cointerp.mrulename)='AWM - 590 Main Rule - Months (WI)') AND ((cointerp.ruledepth)=1) AND ((component.majcompflag)='Yes') AND ((cointerp.rulename)='WI-590 Bedrock Subrule'));

SELECT mapunit.musym, cointerp.mrulename, cointerp.ruledepth, Max(cointerp.interplr) AS MaxOfinterplr, component.majcompflag, cointerp.rulename, mapunit.mukey
INTO #TempWater
FROM mapunit INNER JOIN (component INNER JOIN cointerp ON component.cokey = cointerp.cokey) ON mapunit.mukey = component.mukey
GROUP BY mapunit.musym, cointerp.mrulename, cointerp.ruledepth, component.majcompflag, cointerp.rulename, mapunit.mukey
HAVING (((cointerp.mrulename)='AWM - 590 Main Rule - Months (WI)') AND ((cointerp.ruledepth)=1) AND ((component.majcompflag)='Yes') AND ((cointerp.rulename)='WI-590 Apparent H20 - All Months'));

SELECT mapunit.musym, cointerp.mrulename, cointerp.ruledepth, component.majcompflag, mapunit.mukey, cointerp.interphrc
INTO #TempNotRated
FROM mapunit INNER JOIN (component INNER JOIN cointerp ON component.cokey = cointerp.cokey) ON mapunit.mukey = component.mukey
GROUP BY mapunit.musym, cointerp.mrulename, cointerp.ruledepth, component.majcompflag, mapunit.mukey, cointerp.interphrc
HAVING (((cointerp.mrulename)='AWM - 590 Main Rule - Months (WI)') AND ((cointerp.ruledepth)=0) AND ((component.majcompflag)='Yes') AND ((cointerp.interphrc)='Not Rated'));
S
ELECT #Temp.musym, #Temp.mukey,
CASE
WHEN #TempWater.MaxOfinterplr = 1
THEN 'w'
ELSE '' END AS W,
CASE
WHEN #TempRock.MaxOfinterplr = 1
THEN 'r'
ELSE ''
END AS R,
CASE
WHEN #TempPerm.MaxOfinterplr = 1
THEN 'p'
ELSE ''
END AS P,
CASE
WHEN #TempNotRated.interphrc = 'Not Rated'
THEN '+'
ELSE ''
END AS NotRated
INTO #TempLetter
FROM #Temp
LEFT JOIN #TempPerm ON #Temp.mukey = #TempPerm.mukey
LEFT JOIN #TempRock ON #Temp.mukey = #TempRock.mukey
LEFT JOIN #TempWater ON #Temp.mukey = #TempWater.mukey
LEFT JOIN #TempNotRated ON #Temp.mukey = #TempNotRated.mukey
ORDER by #Temp.musym
SELECT mapunit.musym AS Symbol, #TempLetter.W + #TempLetter.P + #TempLetter.r + #TempLetter.NotRated as Restriction, mapunit.muname as MapUnitName , mapunit.mukey
FROM legend
LEFT JOIN mapunit ON legend.lkey = mapunit.lkey
LEFT JOIN #TempLetter ON mapunit.mukey = #TempLetter.mukey
WHERE legend.areasymbol LIKE 'WI001'
ORDER BY legend.areasymbol, mapunit.museq