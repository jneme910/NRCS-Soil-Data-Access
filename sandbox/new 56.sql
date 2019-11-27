#PARAMETER areasym PROMPT "Enter Survey Area Symbol" CHAR.
#PARAMETER mukeys PROMPT "Or List of Mapunit Keys" MULTIPLE CHAR.
#PARAMETER includeminor PROMPT "Include minor soils?" BOOLEAN.
#PARAMETER useNationalMapunits PROMPT "Display national mapunit symbols?" BOOLEAN.

#
BASE TABLE  comonth.
#Jason Nemecek
EXEC SQL SELECT  comonth.comonthkey,
MAX(soimoistdept_r) AS soimoistdept_r1, 
MAX(soimoistdepb_r) AS soimoistdepb_r1


FROM legend
INNER JOIN mapunit ON mapunit.lkey= legend.lkey AND (areasymbol=areasym OR mapunit.mukey in (mukeys) )
INNER JOIN component ON component.mukey=mapunit.mukey AND  ( majcompflag = "Yes" OR 1 = includeminor )
INNER JOIN comonth ON comonth.cokey=component.cokey
INNER JOIN cosoilmoist  ON cosoilmoist.comonthkey=comonth .comonthkey 
GROUP BY comonth.comonthkey
ORDER BY comonth.comonthkey;. 

DEFINE water_Table_Kind	IF soimoistdept_r1 > soimoistdepb_r1 THEN "TRUE" ELSE "FALSE".

TEMPLATE table_body
    ELEMENT "tr"
        FIELD TAG "td" ATTRIB ("rowspan", "1"),
        FIELD TAG "td" ATTRIB ("rowspan", "1"),
        FIELD TAG "td" ATTRIB ("rowspan", "1").




 


SECTION WHEN AT START
    DATA
	ELEMENT OPEN "section".
    ELEMENT OPEN "table" ATTRIB ("orient", "land").
      ELEMENT "col" ATTRIB("width", ".2*").
      ELEMENT "col" ATTRIB("width", ".2*").
      ELEMENT "col" ATTRIB("width", ".2*").
	  
    ELEMENT OPEN "thead".
    USING table_body "soimoistdept_r", "soimoistdepb_r", "Water_Table_Kind".
    ELEMENT CLOSE "thead".
	ELEMENT OPEN "tbody".
END SECTION.


SECTION 

	DATA 
    USING table_body
soimoistdept_r1, soimoistdepb_r1, water_Table_Kind.

END SECTION.




SECTION WHEN AT END
    DATA
	ELEMENT CLOSE "tbody".
	ELEMENT CLOSE "table".
    ELEMENT CLOSE "section".
END SECTION.