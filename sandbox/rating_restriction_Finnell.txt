---Official Method #3 - adding Rating and restrictions to build a geospatial database link

---pulls all the major components and interp rating data for the query 
---begin SQL

SELECT areasymbol, musym, mapunit.mukey, muname, compname, comppct_r, majcompflag, cointerp.mrulename, cointerp.ruledepth, interphr, interphrc, rulename, component.cokey 
INTO #ratings 
FROM legend INNER JOIN mapunit ON legend.lkey = mapunit.lkey 
INNER JOIN component ON mapunit.mukey = component.mukey 
INNER JOIN cointerp ON component.cokey = cointerp.cokey 
WHERE legend.areasymbol like 'KS169' 
AND ruledepth = 0
AND majcompflag = 'Yes'
AND mrulename like 'DHS - Catastrophic Mortality, Large Animal Disposal, Trench' 
AND cointerp.seqnum = 0
ORDER by areasymbol, mukey, comppct_r desc, cokey, cointerp.mrulename, ruledepth, interphr desc, rulename

---pulls all the restriction data ruledepth 1 for each component

SELECT areasymbol, musym, mapunit.mukey, mapunit.muname, compname, comppct_r, majcompflag, cointerp.mrulename, cointerp.ruledepth, interphr, interphrc, rulename, component.cokey 
into #basement 
FROM legend INNER JOIN mapunit ON legend.lkey = mapunit.lkey 
INNER JOIN component ON mapunit.mukey = component.mukey 
INNER JOIN cointerp ON component.cokey = cointerp.cokey 
WHERE legend.areasymbol like 'KS169' 
AND interphr <> 0
AND cointerp.seqnum >0
AND mrulename like 'DHS - Catastrophic Mortality, Large Animal Disposal, Trench' 
ORDER by mapunit.mukey, comppct_r desc, cokey, cointerp.mrulename, ruledepth, interphr desc, rulename

--concatenates the restrictions into a descending order 

SELECT DISTINCT mukey, muname, cokey, compname, comppct_r, interphr, SUBSTRING(  (  SELECT ( '; ' + interphrc)
FROM #basement t2   
WHERE t1.cokey = t2.cokey
ORDER BY t1.cokey, t2.cokey
FOR XML PATH('') ), 3, 1000) as restrictions 
INTO #tempbase FROM #basement t1 
GROUP BY mukey, muname, comppct_r, cokey, compname, interphr, interphrc 
ORDER BY mukey, muname, comppct_r desc, cokey, compname, interphr desc

--  bring all data and join with restrictions

SELECT areasymbol, musym, r.mukey, r.muname, r.cokey, r.compname, r.comppct_r, majcompflag, mrulename, r.interphr, interphrc, restrictions 
INTO #final 
FROM #ratings r 
LEFT OUTER JOIN #tempbase t on r.cokey=t.cokey 
ORDER BY mukey, muname, comppct_r desc, cokey, compname

--Need to add a is null statement to bring in the Not Limited

SELECT DISTINCT areasymbol, musym, mukey, muname, cokey, compname, comppct_r, majcompflag, mrulename, Cast(CONVERT(DECIMAL(10,1),interphr) as nvarchar) AS Value2, interphrc , restrictions, interphrc +  ': ' + isnull(restrictions, '')  as interpclass
FROM #final 
ORDER BY mukey, muname, comppct_r desc, cokey, compname


DROP TABLE #basement
DROP TABLE #tempbase
DROP TABLE #ratings
DROP TABLE #final

--- end SQL