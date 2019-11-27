SELECT l.areaname, l.lkey, musym, muname, muacres, 
compname,  m.mukey/1 AS mukey, cokey/1 AS cokey, comppct_r
FROM legend AS l
INNER JOIN mapunit m ON m.lkey = l.lkey
AND m.mukey IN (753495	,
753496	,
753497	,
1591197	,
1591197	,
1591198	,
1591198	,
2629030	,
2629031	,
2629032	,
2629033	,
2629034	,
425320	,
425321	,
425319	,
425322	,
420984	,
420985	,
420986	,
435136	,
579853	,
579833	,
435144	,
435142	,
422307	,
422310	,
422311	,
422312	,
422313	,
422314	,
422308	,
422309	,
431382,
435142,
431383
)
INNER JOIN component  AS c ON c.mukey = m.mukey
AND majcompflag LIKE 'Yes'
ORDER BY areasymbol, musym,  mukey, comppct_r DESC, cokey