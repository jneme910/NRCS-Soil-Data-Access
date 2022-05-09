select
sdw.dbo.satabularver.areasymbol,
--(COUNT (sdw.dbo.mupolygon.mupolygonid) as 'SDW Polygon Count',
--MAX (spatialversion) as 'SDW Spatial Version',
(select COUNT (offline.mupolygonkey) FROM SDMOffline.dbo.mupolygon  as offline with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = offline.areasymbol) as 'SDMOffline Polygon Count',
(select COUNT (online.mupolygonkey) FROM SDMOnline.dbo.mupolygon as online with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = online.areasymbol) as 'SDMOnline Poplygon Count',
(select COUNT (snapshot.mupolygonkey) FROM SDM.dbo.mupolygon as snapshot with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = snapshot.areasymbol) as 'SDM Poplygon Count',

CASE WHEN (select COUNT (offline.mupolygonkey) FROM SDMOffline.dbo.mupolygon  as offline with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = offline.areasymbol) != 
                (select COUNT (online.mupolygonkey) FROM SDMOnline.dbo.mupolygon as online with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = online.areasymbol) OR
                (select COUNT (offline.mupolygonkey) FROM SDMOffline.dbo.mupolygon  as offline with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = offline.areasymbol) != 
                (select COUNT (snapshot.mupolygonkey) FROM SDM.dbo.mupolygon as snapshot with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = snapshot.areasymbol) OR
                 (select COUNT (snapshot.mupolygonkey) FROM SDM.dbo.mupolygon as snapshot with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = snapshot.areasymbol) !=
                 (select COUNT (online.mupolygonkey) FROM SDMOnline.dbo.mupolygon as online with (nolock) WHERE sdw.dbo.satabularver.areasymbol  = online.areasymbol)
                
                then 'Discrepency' ELSE '' END AS 'Comparision Results'

FROM sdw.dbo.satabularver WITH (NOLOCK)
--INNER JOIN (SELECT distinct areasymbol, MAX (tabularverest) AS topdate FROM sdw.dbo.satabularver GROUP by areasymbol)  topdates
--on topdates.areasymbol = sdw.dbo.mupolygon.areasymbol 
WHERE tabularverest > '11/01/2019'
GROUP BY sdw.dbo.satabularver.areasymbol
ORDER BY  sdw.dbo.satabularver.areasymbol
