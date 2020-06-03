DECLARE @area VARCHAR(20);
DECLARE @area_type INT ;
--~DeclareChar(@area,20)~  -- Used for Soil Data Access
--~DeclareINT(@area_type)~ 

SELECT @area= 'WI'; --Enter State Abbreviation or Soil Survey Area i.e. WI or WI025

------------------------------------------------------------------------------------
SELECT @area_type = LEN (@area); --determines number of characters of area 2-State, 5- Soil Survey Area


SELECT DISTINCT areasymbol, muname, mukey, compname, cokey, comppct_r, MIN(soimoistdept_r) over(partition by cokey) as min_soimoistdept_r
FROM (SELECT   areasymbol, muname, mapunit.mukey, compname, c.cokey, comppct_r, soimoistdept_r
FROM legend 
       INNER JOIN mapunit ON mapunit.lkey=legend.lkey AND  CASE WHEN @area_type = 2 THEN LEFT (areasymbol, 2) ELSE areasymbol END = @area  
	   
              INNER JOIN component AS c ON c.mukey=mapunit.mukey
			  AND majcompflag = 'Yes' 
			  INNER JOIN comonth ON c.cokey=comonth.cokey 
        INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey
			  ) AS s WHERE s.cokey IN 

			  (SELECT  c2.cokey FROM component AS c2 
INNER JOIN comonth ON c2.cokey=comonth.cokey 
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey
AND c2.cokey=s.cokey AND soimoiststat = 'wet'  GROUP BY c2.cokey) 



