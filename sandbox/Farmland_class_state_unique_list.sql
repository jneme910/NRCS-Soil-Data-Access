DROP TABLE IF EXISTS #temp_fc

SELECT LEFT (areasymbol,2) AS state_sym, CASE WHEN farmlndcl IS NULL  THEN 'Not rated'
        WHEN farmlndcl =  'All areas are prime farmland' THEN 'Prime'
        WHEN farmlndcl LIKE 'Prime farmland if%' THEN 'Prime if'
        WHEN farmlndcl =  'Farmland of statewide importance' THEN 'State'
        WHEN farmlndcl LIKE 'Farmland of statewide importance, if%' THEN 'State if'
        WHEN farmlndcl = 'Farmland of local importance' THEN 'Local'
        WHEN farmlndcl LIKE 'Farmland of local importance, if%' THEN 'Local if'
        WHEN farmlndcl = 'Farmland of unique importance' THEN 'Unique'
        ELSE 'Not Prime'
    END AS farmlndclass,
		ROW_NUMBER() OVER(PARTITION BY LEFT (areasymbol,2) ORDER BY CASE WHEN farmlndcl IS NULL  THEN 'Not rated'
	        WHEN farmlndcl =  'All areas are prime farmland' THEN 'Prime'
	        WHEN farmlndcl LIKE 'Prime farmland if%' THEN 'Prime if'
	        WHEN farmlndcl =  'Farmland of statewide importance' THEN 'State'
	        WHEN farmlndcl LIKE 'Farmland of statewide importance, if%' THEN 'State if'
	        WHEN farmlndcl = 'Farmland of local importance' THEN 'Local'
	        WHEN farmlndcl LIKE 'Farmland of local importance, if%' THEN 'Local if'
	        WHEN farmlndcl = 'Farmland of unique importance' THEN 'Unique'
	        ELSE 'Not Prime'
	    END) AS row_num
INTO #temp_fc
	FROM dbo.legend
	INNER JOIN mapunit ON mapunit.lkey = legend.lkey --AND LEFT (areasymbol,2) = 'WI' 
	AND areasymbol <>'US'
	GROUP BY LEFT (areasymbol,2) ,CASE WHEN farmlndcl IS NULL  THEN 'Not rated'
	        WHEN farmlndcl =  'All areas are prime farmland' THEN 'Prime'
	        WHEN farmlndcl LIKE 'Prime farmland if%' THEN 'Prime if'
	        WHEN farmlndcl =  'Farmland of statewide importance' THEN 'State'
	        WHEN farmlndcl LIKE 'Farmland of statewide importance, if%' THEN 'State if'
	        WHEN farmlndcl = 'Farmland of local importance' THEN 'Local'
	        WHEN farmlndcl LIKE 'Farmland of local importance, if%' THEN 'Local if'
	        WHEN farmlndcl = 'Farmland of unique importance' THEN 'Unique'
	        ELSE 'Not Prime'
	    END
		ORDER BY LEFT (areasymbol,2) ASC ,CASE WHEN farmlndcl IS NULL  THEN 'Not rated'
	        WHEN farmlndcl =  'All areas are prime farmland' THEN 'Prime'
	        WHEN farmlndcl LIKE 'Prime farmland if%' THEN 'Prime if'
	        WHEN farmlndcl =  'Farmland of statewide importance' THEN 'State'
	        WHEN farmlndcl LIKE 'Farmland of statewide importance, if%' THEN 'State if'
	        WHEN farmlndcl = 'Farmland of local importance' THEN 'Local'
	        WHEN farmlndcl LIKE 'Farmland of local importance, if%' THEN 'Local if'
	        WHEN farmlndcl = 'Farmland of unique importance' THEN 'Unique'
	        ELSE 'Not Prime'
	    END ASC
		;


SELECT * ,MAX(row_num) over(partition by state_sym) as max_row_num
FROM #temp_fc