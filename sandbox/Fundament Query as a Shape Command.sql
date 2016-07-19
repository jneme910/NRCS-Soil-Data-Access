SHAPE
{
--SQL query begins…
SELECT DISTINCT saversion, saverest,
l.areasymbol, l.areaname, l.lkey
FROM sacatalog sac
INNER JOIN legend l ON sac.areasymbol = l.areasymbol AND l.areasymbol = 'WI001'
INNER JOIN mapunit mu ON l.lkey = mu.lkey
WHERE mu.mukey IN
(422917,422918,422919, 422920)
--SQL query ends.
}
APPEND
(
(SHAPE
{
--SQL query begins…
SELECT lkey, musym, muname, museq, mukey
FROM mapunit mu
WHERE mu.mukey IN
(422917,422918,422919, 422920)
--SQL query ends.
}
APPEND
(
(SHAPE
{
--SQL query begins…
SELECT mu.mukey,
comppct_r, compname, localphase, slope_r, c.cokey
FROM mapunit mu
LEFT OUTER JOIN component c ON mu.mukey = c.mukey
WHERE mu.mukey IN
(422917,422918,422919, 422920)
}
APPEND
(
{
--SQL query begins…
SELECT c.cokey,
hzdept_r, hzdepb_r, ch.chkey
FROM mapunit mu
LEFT OUTER JOIN component c ON mu.mukey = c.mukey
LEFT OUTER JOIN chorizon ch ON c.cokey = ch.cokey
WHERE mu.mukey IN
(422917,422918,422919, 422920)
--SQL query ends.
}
AS chorizon RELATE cokey TO cokey)
)
AS component RELATE mukey TO mukey)
)
AS mapunit RELATE lkey TO lkey
)