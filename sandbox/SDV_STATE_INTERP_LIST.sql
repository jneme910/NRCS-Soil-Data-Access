SELECT  
interpname, 
interptype

FROM SAINTERP
INNER JOIN SACATALOG ON SACATALOG.areasymbol= SAINTERP.areasymbol AND LEFT (SAINTERP.areasymbol, 2) = 'WI' GROUP BY interpname, interptype
