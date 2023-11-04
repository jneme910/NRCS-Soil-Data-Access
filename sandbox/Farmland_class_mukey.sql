SELECT mukey, LEFT (areasymbol,2) AS state_sym, CASE WHEN farmlndcl IS NULL  THEN 'Not rated'
        WHEN farmlndcl =  'All areas are prime farmland' THEN 'Prime'
        WHEN farmlndcl LIKE 'Prime farmland if%' THEN 'Prime if'
        WHEN farmlndcl =  'Farmland of statewide importance' THEN 'State'
        WHEN farmlndcl LIKE 'Farmland of statewide importance, if%' THEN 'State if'
        WHEN farmlndcl = 'Farmland of local importance' THEN 'Local'
        WHEN farmlndcl LIKE 'Farmland of local importance, if%' THEN 'Local if'
        WHEN farmlndcl = 'Farmland of unique importance' THEN 'Unique'
        ELSE 'Not Prime'
    END AS farmlndclass,
CASE WHEN farmlndcl IS NULL  THEN 0
        WHEN farmlndcl =  'All areas are prime farmland' THEN 1
        WHEN farmlndcl LIKE 'Prime farmland if%' THEN 2
        WHEN farmlndcl =  'Farmland of statewide importance' THEN 3
        WHEN farmlndcl LIKE 'Farmland of statewide importance, if%' THEN 4
        WHEN farmlndcl = 'Farmland of local importance' THEN 5
        WHEN farmlndcl LIKE 'Farmland of local importance, if%' THEN 6
        WHEN farmlndcl = 'Farmland of unique importance' THEN 7
        ELSE 8
    END AS farmlndclass_value
	

	FROM dbo.legend
	INNER JOIN mapunit ON mapunit.lkey = legend.lkey --AND LEFT (areasymbol,2) = 'WI' 
	--AND areasymbol <>'US'


		;