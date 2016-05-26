SELECT
cast (mu.mukey as int) as mukey_num, mu.mukey, muag.drclassdcd, muag.drclasswettest, muag.brockdepmin, muag.wtdepannmin, muag.wtdepaprjunmin, muag.flodfreqdcd, muag.flodfreqmax, muag.pondfreqprs, muag.hydgrpdcd
INTO #muagTemp
FROM sacatalog sac
INNER JOIN legend l ON l.areasymbol = sac.areasymbol and l.areasymbol LIKE 'TN610'
INNER JOIN mapunit mu ON mu.lkey = l.lkey
INNER JOiN muaggatt muag on muag.mukey = mu.mukey
--Texture routine. This is incomplete as of now. Mapunits with 2 domcond are represented with two rows. The problem lies with T-sql having no FIRST function, need to look into Top.
--Fixed. 5/7/2010 Used row_number.

SELECT mapunit.mukey, Sum(component.comppct_r) AS SumOfcomppct_r, chorizon.hzdept_r, chtexturegrp.texture, chtexturegrp.rvindicator
INTO #TempTex1
FROM sacatalog sac
INNER JOIN legend l ON l.areasymbol = sac.areasymbol and l.areasymbol LIKE 'WI%'
INNER JOIN mapunit ON mapunit.lkey = l.lkey
INNER JOIN (component INNER JOIN (chorizon INNER JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey) ON component.cokey = chorizon.cokey) ON mapunit.mukey = component.mukey
GROUP BY mapunit.musym, mapunit.muname, mapunit.mukey, chorizon.hzdept_r, chtexturegrp.texture, chtexturegrp.rvindicator
HAVING (((chorizon.hzdept_r)=0) AND ((chtexturegrp.rvindicator)='yes'))

SELECT Max(#TempTex1.SumOfcomppct_r) AS MaxOfSumOfcomppct_r, #TempTex1.mukey
INTO #TempTex2
FROM #TempTex1 GROUP BY #TempTex1.mukey;

SELECT #TempTex1.texture, #TempTex1.mukey
INTO #TempTex3
FROM #TempTex1 INNER JOIN #TempTex2 ON (#TempTex1.mukey=#TempTex2.mukey) AND (#TempTex1.SumOfcomppct_r=#TempTex2.MaxOfSumOfcomppct_r);

SELECT mapunit.musym, #TempTex3.texture, mapunit.muname, mapunit.mukey
INTO #tex
FROM legend INNER JOIN (#TempTex3 RIGHT JOIN mapunit ON #TempTex3.mukey = mapunit.mukey) ON legend.lkey = mapunit.lkey
GROUP BY mapunit.musym, mapunit.muname, mapunit.mukey, legend.areasymbol, #TempTex3.texture
HAVING legend.areasymbol Like 'WI%';
WITH #Firstoftex1 AS (Select mukey, texture, rn = row_number() OVER (PARTITION BY mukey ORDER BY texture) From #tex)

Select texture, mukey
INTO #Firstoftex
From #Firstoftex1
Where rn=1
--Texture W\O Duff
--Forested Soils are often described with thin duff layers. In Wisconsin, approximately 570 major components are described with duff layers ranging from 2 to 10 cm. thick. Often, the duff layer is destroyed; therefore knowing the first mineral layer is beneficial. This field provides the texture of the first mineral layer below the duff layer.

SELECT mapunit.mukey, component.comppct_r, chorizon.hzdept_r, component.cokey, chorizon.chkey, chtexturegrp.texture, chtexturegrp.rvindicator, component.majcompflag
INTO #NoDuffTemp1
FROM (legend INNER JOIN (mapunit LEFT JOIN component ON mapunit.mukey = component.mukey) ON legend.lkey = mapunit.lkey) LEFT JOIN (chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey) ON component.cokey = chorizon.cokey
WHERE (((chorizon.hzdept_r)=(SELECT Min(chorizon.hzdept_r) AS MinOfhzdept_r
FROM chorizon LEFT JOIN chtexturegrp ON chorizon.chkey = chtexturegrp.chkey
Where chtexturegrp.texture Not In ('SPM','HPM', 'MPM') AND chtexturegrp.rvindicator='Yes' AND component.cokey = chorizon.cokey )) AND ((chtexturegrp.rvindicator)='Yes') AND ((legend.areasymbol) Like 'WI%') AND ((component.majcompflag)='Yes'))
ORDER BY legend.areasymbol, mapunit.musym, chorizon.hzdept_r

SELECT #NoDuffTemp1.mukey, Sum(#NoDuffTemp1.comppct_r) AS SumOfcomppct_r, #NoDuffTemp1.texture
INTO #NoDuffTemp2
FROM #NoDuffTemp1
GROUP BY #NoDuffTemp1.mukey, #NoDuffTemp1.texture

SELECT #NoDuffTemp2.mukey, Max(#NoDuffTemp2.SumOfcomppct_r) AS MaxOfSumOfcomppct_r
INTO #NoDuffTemp3
FROM #NoDuffTemp2
GROUP BY #NoDuffTemp2.mukey

SELECT #NoDuffTemp3.mukey, #NoDuffTemp2.texture
INTO #NoDufftex
FROM #NoDuffTemp2 INNER JOIN #NoDuffTemp3 ON (#NoDuffTemp2.SumOfcomppct_r = #NoDuffTemp3.MaxOfSumOfcomppct_r) AND (#NoDuffTemp2.mukey = #NoDuffTemp3.mukey);
WITH #FirstofNoDufftex1 AS (Select mukey, texture, rn = row_number() OVER (PARTITION BY mukey ORDER BY texture) From #NoDufftex)

Select texture, mukey
INTO #FirstofNoDufftex
From #FirstofNoDufftex1
Where rn=1

SELECT #muagTemp.*, #FirstofNoDufftex.texture as NoDuffSufTex, #Firstoftex.texture as SufTex
FROM #muagTemp
LEFT JOIN #FirstofNoDufftex ON #muagTemp.mukey = #FirstofNoDufftex.mukey
LEFT JOIN #Firstoftex ON #muagTemp.mukey = #Firstoftex.mukey