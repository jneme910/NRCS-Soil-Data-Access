SELECT mapunit.mukey, component.comppct_r, chorizon.hzdept_r, component.cokey, chorizon.chkey, component.majcompflag, chorizon.kffact
INTO #NoDuffK1
FROM (legend INNER JOIN (mapunit LEFT JOIN component ON mapunit.mukey = component.mukey) ON legend.lkey = mapunit.lkey) LEFT JOIN chorizon ON component.cokey = chorizon.cokey
WHERE (((chorizon.hzdept_r)=(SELECT Min(chorizon.hzdept_r) AS MinOfhzdept_r
FROM chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey
Where chtexturegrp.texture Not In ('SPM','HPM', 'MPM') AND chtexturegrp.rvindicator='Yes' AND component.cokey = chorizon.cokey )) AND ((legend.areasymbol) Like 'WI%') AND ((component.majcompflag)='Yes'))
ORDER BY legend.areasymbol, mapunit.musym, chorizon.hzdept_r


SELECT #NoDuffK1.mukey, Sum(#NoDuffK1.comppct_r) AS SumOfcomppct_r, #NoDuffK1.kffact
INTO #NoDuffK2
FROM #NoDuffK1
GROUP BY #NoDuffK1.mukey, #NoDuffK1.kffact


SELECT #NoDuffK2.mukey, Max(#NoDuffK2.SumOfcomppct_r) AS MaxOfSumOfcomppct_r
INTO #NoDuffK3
FROM #NoDuffK2
GROUP BY #NoDuffK2.mukey


SELECT #NoDuffK3.mukey, #NoDuffK2.kffact
INTO #NoDuffk
FROM #NoDuffK2 INNER JOIN #NoDuffK3 ON (#NoDuffK2.SumOfcomppct_r = #NoDuffK3.MaxOfSumOfcomppct_r) AND (#NoDuffK2.mukey = #NoDuffK3.mukey);
WITH #FirstofNoDuffk1 AS (Select mukey, kffact, rn = row_number() OVER (PARTITION BY mukey ORDER BY kffact desc) From #NoDuffk)


Select kffact as KffactDomCond, mukey
INTO #FirstofNoDuffk
From #FirstofNoDuffk1
Where rn=1

SELECT #NoDuffK1.mukey, MAX( #NoDuffK1.kffact) as KffactMostLmt
INTO #NoDuffMLK
FROM #NoDuffK1
GROUP BY #NoDuffK1.mukey

SELECT Min(component.tfact) AS MinTfact, component.mukey
INTO #Tfact
FROM legend
INNER JOIN mapunit ON legend.lkey = mapunit.lkey AND legend.areasymbol Like 'WI%'
INNER JOIN component ON mapunit.mukey = component.mukey AND component.majcompflag='yes'
GROUP BY component.mukey

SELECT component.mukey, Sum(component.comppct_r) AS SumOfcomppct_r, component.tfact
INTO #TfactDom1
FROM legend
INNER JOIN mapunit ON legend.lkey = mapunit.lkey AND legend.areasymbol Like 'WI%'
INNER JOIN component ON mapunit.mukey = component.mukey AND component.majcompflag='yes'
GROUP BY component.mukey, component.tfact

SELECT #TfactDom1.mukey, Max(#TfactDom1.SumOfcomppct_r) AS MaxOfSumOfcomppct_r
INTO #TfactDom2
FROM #TfactDom1
GROUP BY #TfactDom1.mukey

SELECT #TfactDom2.mukey, #TfactDom1.tfact
INTO #TfactDom
FROM #TfactDom1 INNER JOIN #TfactDom2 ON (#TfactDom1.SumOfcomppct_r = #TfactDom2.MaxOfSumOfcomppct_r) AND (#TfactDom1.mukey = #TfactDom2.mukey);
WITH #FirstofTfactDom1 AS (Select mukey, tfact, rn = row_number() OVER (PARTITION BY mukey ORDER BY tfact ASC) From #TfactDom)

Select Tfact as tfactDomCond, mukey
INTO #FirstofTfact
From #FirstofTfactDom1
Where rn=1

SELECT #Tfact.mukey, #FirstofTfact.tfactDomCond, #Tfact.MinTfact as TfactMostLmt, #FirstofNoDuffk.kffactDomCond, #NoDuffMLK.KffactMostLmt
FROM #Tfact
LEFT JOIN #FirstofNoDuffk ON #Tfact.mukey = #FirstofNoDuffk.mukey
LEFT JOIN #NoDuffMLK ON #Tfact.mukey = #NoDuffMLK.mukey
LEFT JOIN #FirstofTfact ON #Tfact.mukey = #FirstofTfact.mukey
-- No duff not working for beaverbay.