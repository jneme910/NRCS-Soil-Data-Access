--DECLARE @cname VARCHAR(20);


/* Soil Series Extent by Component Name */

~DeclareChar(@cname,250)~  -- Used for Soil Data Access
SELECT @cname= 'Antigo'; -- Enter Series Name Here

SELECT @cname AS [Component Name];

SELECT areasymbol, areaname
FROM legend AS l
INNER JOIN  mapunit AS m ON l.lkey=m.lkey AND areasymbol <> 'US' -- Excludes Statsgo
INNER JOIN component AS c ON c.mukey=m.mukey AND compname = @cname
--AND majcompflag = 'Yes' 
--Remove double dash if just major components
GROUP BY areasymbol, areaname
ORDER BY  areasymbol ASC, areaname

