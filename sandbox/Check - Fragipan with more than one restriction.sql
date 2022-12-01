DROP TABLE IF EXISTS #tempfragipan

SELECT areasymbol, muname, c.compname, c.comppct_r,  c.cokey --, --c.reskind  ,c.resdept_r   ,c.resdepb_r
INTO #tempfragipan
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey AND areasymbol <> 'US'
INNER JOIN component AS c ON c.mukey=m.mukey AND c.cokey IN (SELECT dbo.component.cokey FROM component INNER JOIN dbo.corestrictions ON corestrictions.cokey = component.cokey AND c.cokey=component.cokey AND [reskind] = 'Fragipan')
INNER JOIN dbo.corestrictions AS cr ON cr.cokey = c.cokey
GROUP BY areasymbol, muname, c.compname, c.comppct_r,  c.cokey  HAVING COUNT (*) > 1

SELECT areasymbol, muname, f.compname, f.comppct_r,  f.cokey, cr1.reskind  ,cr1.resdept_r   ,cr1.resdepb_r
FROM #tempfragipan AS f
INNER JOIN dbo.corestrictions AS cr1 ON cr1.cokey = f.cokey ORDER BY areasymbol ASC, muname ASC, f.compname ASC, f.comppct_r ASC,  f.cokey ASC, cr1.resdept_r ASC