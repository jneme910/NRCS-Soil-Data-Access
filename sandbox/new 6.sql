SELECT l.areasymbol, tabularversion
FROM sacatalog sac
INNER JOIN legend l ON l.areasymbol = sac.areasymbol and l.areasymbol LIKE 'WI001'