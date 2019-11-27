#PARAMETER areasym PROMPT "Enter Survey Area Symbol" CHAR.
#PARAMETER mukeys PROMPT "Or List of Mapunit Keys" MULTIPLE CHAR.
#PARAMETER includeminor PROMPT "Include minor soils?" BOOLEAN.
#PARAMETER useNationalMapunits PROMPT "Display national mapunit symbols?" BOOLEAN.

#

BASE TABLE comonth.
#Jason Nemecek
EXEC SQL SELECT areaname, 
musym, 
#soimoistdept_l/1 AS moisture_t, 
#soimoistdepb_l/1 AS moisture_b,
#month AS first_month,  
#month AS last_month,  
CASE WHEN comonth.month = 'January' THEN 'Jan'
WHEN comonth.month = 'February' THEN 'Feb'
WHEN comonth.month = 'March' THEN 'Mar'
WHEN comonth.month = 'April' THEN 'Apr'
WHEN comonth.month = 'May' THEN 'May'
WHEN comonth.month = 'June' THEN 'Jun'
WHEN comonth.month = 'July' THEN 'Juy'
WHEN comonth.month = 'August' THEN 'Aug'
WHEN comonth.month = 'September' THEN 'Sep'
WHEN comonth.month = 'October' THEN 'Oct'
WHEN comonth.month = 'November' THEN 'Nov'
WHEN comonth.month = 'December' THEN 'Dec' END AS first_month,

CASE WHEN comonth.month = 'January' THEN 'Jan'
WHEN comonth.month = 'February' THEN 'Feb'
WHEN comonth.month = 'March' THEN 'Mar'
WHEN comonth.month = 'April' THEN 'Apr'
WHEN comonth.month = 'May' THEN 'May'
WHEN comonth.month = 'June' THEN 'Jun'
WHEN comonth.month = 'July' THEN 'Jul'
WHEN comonth.month = 'August' THEN 'Aug'
WHEN comonth.month = 'September' THEN 'Sep'
WHEN comonth.month = 'October' THEN 'Oct'
WHEN comonth.month = 'November' THEN 'Nov'
WHEN comonth.month = 'December' THEN 'Dec' END AS last_month,
mapunit.mukey,
CAST ((mapunit.mukey/1) AS varchar (10)) AS soilwebmukey, 
CAST ((component.cokey/1) AS varchar (10)) AS soilwebcokey, 
muname, 
compname, 
localphase, 
component.cokey, 
component.cokey AS cokey_sub, 
flodfreqcl AS flodfreq, 
floddurcl AS floddurcl, 
comppct_r, 
hydgrp, 
comonth.month,
monthseq, 
pondfreqcl AS pondf, 
ponddurcl AS  ponddurcl, 
ponddep_l,
ponddep_h, 
runoff,
((CAST((SELECT MIN (soimoistdept_l) FROM comonth AS co1
INNER JOIN cosoilmoist AS cospt1 ON cospt1.comonthkey=co1.comonthkey AND co1.comonthkey=comonth.comonthkey AND soimoiststat="wet")AS VARCHAR (3)))  + '-' +
(CAST((SELECT MAX (soimoistdept_h) FROM comonth AS co2
INNER JOIN cosoilmoist AS cospt2 ON cospt2.comonthkey=co2.comonthkey AND co2.comonthkey=comonth.comonthkey AND soimoiststat="wet")AS VARCHAR (3))))  AS soimoistdept_l_h,

((CAST((SELECT MIN (CASE WHEN (soimoistdepb_l) >= 183 THEN 183 ELSE soimoistdepb_l END) FROM comonth AS co3
INNER JOIN cosoilmoist AS cospt3 ON cospt3.comonthkey=co3.comonthkey AND co3.comonthkey=comonth.comonthkey AND soimoiststat="wet")AS VARCHAR (3)))+ '-'+  
(CAST((SELECT MAX (CASE WHEN (soimoistdepb_h)>= 183 THEN 183 ELSE soimoistdepb_h END ) FROM comonth AS co4
INNER JOIN cosoilmoist AS cospt4 ON cospt4.comonthkey=co4.comonthkey AND co4.comonthkey=comonth.comonthkey AND soimoiststat="wet")AS VARCHAR (3))))   AS soimoistdepb_l_h,


CAST((SELECT MIN (soimoistdept_l) FROM comonth AS co9
INNER JOIN cosoilmoist AS cospt9 ON cospt9.comonthkey=co9.comonthkey AND co9.comonthkey=comonth.comonthkey AND soimoiststat="wet" AND soimoiststat IS NOT NULL) AS int)  AS min_soimoistdept_l,

CAST ((SELECT MIN (soimoistdept_r) FROM comonth AS co13
INNER JOIN cosoilmoist AS cospt13 ON cospt13.comonthkey=co13.comonthkey AND co13.comonthkey=comonth.comonthkey AND soimoiststat="wet" AND soimoiststat IS NOT NULL)AS int)  AS min_soimoistdept_r,

(SELECT MAX (soimoistdept_h) FROM comonth AS co10
INNER JOIN cosoilmoist AS cospt10 ON cospt10.comonthkey=co10.comonthkey AND co10.comonthkey=comonth.comonthkey AND soimoiststat="wet" AND soimoiststat IS NOT NULL)  AS max_soimoistdept_h,

(SELECT MIN (CASE WHEN soimoistdepb_l >= 183 THEN 183 ELSE soimoistdepb_l END) FROM comonth AS co8
INNER JOIN cosoilmoist AS cospt8 ON cospt8.comonthkey=co8.comonthkey AND co8.comonthkey=comonth.comonthkey AND soimoiststat="wet" AND soimoiststat IS NOT NULL)  AS min_soimoistdepb_l,
(SELECT MAX (soimoistdepb_l) FROM comonth AS co8
INNER JOIN cosoilmoist AS cospt8 ON cospt8.comonthkey=co8.comonthkey AND co8.comonthkey=comonth.comonthkey AND soimoiststat="wet" AND soimoiststat IS NOT NULL)  AS max_soimoistdepb_l,


(SELECT MAX (CASE WHEN soimoistdepb_h >= 183 THEN 183 ELSE soimoistdepb_h END) FROM comonth AS co7
INNER JOIN cosoilmoist AS cospt7 ON cospt7.comonthkey=co7.comonthkey AND co7.comonthkey=comonth.comonthkey AND ISNULL (soimoiststat, "moist") ="wet")  AS max_soimoistdepb_h,


(SELECT MAX (CASE WHEN (soimoistdepb_l) IS NULL THEN soimoistdepb_r ELSE soimoistdepb_l END) FROM comonth AS co5
INNER JOIN cosoilmoist AS cospt5 ON cospt5.comonthkey=co5.comonthkey AND co5.comonthkey=comonth.comonthkey)  AS wtbottom_l,

(SELECT MAX (soimoistdepb_l) FROM comonth AS co11
INNER JOIN cosoilmoist AS cospt11 ON cospt11.comonthkey=co11.comonthkey AND co11.comonthkey=comonth.comonthkey  AND ISNULL (soimoiststat, "moist") !="wet")   AS wtbottom_l_moist,

---
CAST((SELECT CAST(MAX (CAST (soimoistdepb_r AS int))AS int)  FROM comonth AS co12
INNER JOIN cosoilmoist AS cospt12 ON cospt12.comonthkey=co12.comonthkey AND co12.comonthkey=comonth.comonthkey  AND ISNULL (soimoiststat, "moist") !="wet") AS int)  AS wtbottom_r_moist,

CAST ((SELECT CAST (MAX (CAST(soimoistdepb_r AS int)) AS int) FROM comonth AS co15
INNER JOIN cosoilmoist AS cospt15 ON cospt15.comonthkey=co15.comonthkey AND co15.comonthkey=comonth.comonthkey AND soimoiststat="wet" AND soimoiststat IS NOT NULL)AS int)  AS max_soimoistdepb_r
FROM legend
INNER JOIN mapunit ON mapunit.lkey= legend.lkey AND (areasymbol=areasym OR mapunit.mukey in (mukeys) )
INNER JOIN component ON component.mukey=mapunit.mukey AND  ( majcompflag = "Yes" OR 1 = includeminor )
LEFT OUTER JOIN  comonth ON comonth.cokey=component.cokey

;

SORT BY areaname, musym SYM, 
comppct_r DESC, compname, component.cokey, monthseq, comonth.month, soimoistdept_l_h,  soimoistdepb_l_h
AGGREGATE ROWS BY component.cokey, soimoistdept_l_h,  soimoistdepb_l_h
COLUMN first_month FIRST, last_month LAST, soimoistdept_l_h UNIQUE, soimoistdepb_l_h UNIQUE,wtbottom_l UNIQUE, wtbottom_r_moist MAX, 
max_soimoistdepb_r MAX,
min_soimoistdept_l MIN, 
max_soimoistdept_h MAX,
min_soimoistdepb_l MIN, 
max_soimoistdepb_h MAX. 


#EXEC SQL SELECT TOP 1 reskind
#FROM component
#INNER JOIN corestrictions on corestrictions.cokey=component.cokey AND component.cokey IN ($cokey_sub) AND reskind LIKE '%bedrock%';.

DEFINE reporttitle INITIAL SCRIPT(REPORT_TITLE).
DEFINE reporthdrtext IF NEW(areaname) THEN reporthdrtext ELSE NULL INITIAL SCRIPT(REPORT_HEADER).


DEFINE areabreak IF useNationalMapunits THEN "Map Units" ELSE areaname.
DEFINE musym_label (IF useNationalMapunits THEN mapunit.mukey ELSE musym) || "--" || muname.

DEFINE month2  IF first_month==last_month THEN  first_month ELSE first_month ||'-'|| last_month.



DEFINE moisture_t2	ISNULL(max_soimoistdept_h) ? "---" : (min_soimoistdept_l==max_soimoistdept_h)  ? sprintf("%3.1f", min_soimoistdept_l/30.48):  sprintf("%3.1f-%-3.1f", min_soimoistdept_l/30.48, max_soimoistdept_h/30.48).
DEFINE moisture_b2	IF ISNULL(min_soimoistdepb_l) THEN  "---" ELSE
					IF (min_soimoistdepb_l) == (max_soimoistdepb_h)  THEN  sprintf("%3.1f", min_soimoistdepb_l/30.48) ELSE
					IF ISNULL (max_soimoistdepb_h) AND NOT ISNULL (min_soimoistdepb_l) THEN sprintf("%3.1f", min_soimoistdepb_l/30.48) ELSE
					sprintf("%3.1f-%-3.1f", min_soimoistdepb_l/30.48, max_soimoistdepb_h/30.48).



DEFINE apparent		IF ISNULL(max_soimoistdepb_h) THEN "---" ELSE 
					IF ISNULL(moisture_b2) THEN "---" ELSE 
					IF moisture_b2 == 6.0 THEN "Apparent1" ELSE
					IF wtbottom_l  == max_soimoistdepb_l THEN "Apparent3"  ELSE
					IF wtbottom_r_moist >  max_soimoistdepb_r THEN "Perched1"  ELSE 
					IF wtbottom_l_moist >  max_soimoistdepb_l THEN "Perched2"   
					
					ELSE "Perched4".
###SAVE					
#DEFINE apparent		IF ISNULL(max_soimoistdepb_h) THEN "---" ELSE 
#					IF ISNULL(moisture_b2) THEN "---" ELSE 
#					IF moisture_b2 == '6.0' THEN "Apparent" ELSE
#					#IF wtbottom_r_moist >  min_soimoistdept_r THEN "Perched"  ELSE 
#					IF wtbottom_l_moist >  min_soimoistdept_l THEN "Perched"  ELSE 
#					IF wtbottom_l  == max_soimoistdepb_l THEN "Apparent" 
#					ELSE "Perched".					


DEFINE toggle        IF NEW (mapunit.mukey) THEN 0
                     ELSE IF NEW(component.cokey) THEN 1-toggle ELSE toggle.
DEFINE shading	IF toggle == 1 THEN "odd" ELSE "even". 


DEFINE soilnm		SECASE (ISNULL(localphase) ? compname : compname||", "||localphase).



DEFINE ponddep 		ISNULL(ponddep_l) ? "---" : sprintf("%3.1f-%-3.1f", ponddep_l/30.48, ponddep_h/30.48).

DEFINE pondfreq		ISNULL(pondf) ? " ---" : pondf.

TEMPLATE head1
    ELEMENT "tr"
        FIELD TAG "td" ATTRIB ("rowspan", "2"),
        FIELD TAG "td" ATTRIB ("rowspan", "2"),
        FIELD TAG "td" ATTRIB ("rowspan", "2"),
        FIELD TAG "td" ATTRIB ("rowspan", "2"),
        FIELD TAG "td" ATTRIB ("colspan", "3") ATTRIB ("class", "begindatagroup enddatagroup"),
        FIELD TAG "td" ATTRIB ("colspan", "3") ATTRIB ("class", "begindatagroup enddatagroup"),
        FIELD TAG "td" ATTRIB ("colspan", "2") ATTRIB ("class", "begindatagroup enddatagroup")
		,
			FIELD TAG "td" ATTRIB ("rowspan", "2") ,
				FIELD TAG "td" ATTRIB ("rowspan", "2") ,
					FIELD TAG "td" ATTRIB ("rowspan", "2") ,
						FIELD TAG "td" ATTRIB ("rowspan", "2") ,
	FIELD TAG "td" ATTRIB ("rowspan", "2") ,
        FIELD TAG "td" ATTRIB ("rowspan", "2")
		.

TEMPLATE head2
    ELEMENT "tr"
	FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
	FIELD TAG "td",
	FIELD TAG "td" ATTRIB("class", "enddatagroup"),

	FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
	FIELD TAG "td",
	FIELD TAG "td" ATTRIB("class", "enddatagroup"),

	FIELD TAG "td" ATTRIB("class", "begindatagroup"),
	FIELD TAG "td" ATTRIB("class", "enddatagroup").

TEMPLATE units TAG "td"
    ELEMENT "tr" ATTRIB ("class", "units") 
	FIELD TAG "td", 
	FIELD TAG "td", FIELD TAG "td", FIELD TAG "td",
	FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
	FIELD TAG "td",
	FIELD TAG "td" ATTRIB("class", "enddatagroup"),
	FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
	FIELD TAG "td",
	FIELD TAG "td" ATTRIB("class", "enddatagroup"),
	FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
	FIELD TAG "td" ATTRIB("class", "enddatagroup")
	,
	FIELD TAG "td", 
	FIELD TAG "td", 
	FIELD TAG "td", 
	FIELD TAG "td", 
	FIELD TAG "td", 
	FIELD TAG "td", 
	FIELD TAG "td"
	.
 
TEMPLATE mapunit TAG "td"
    ELEMENT "tr"  
	FIELD TAG "td" ATTRIB ("role", "mu-name") ATTRIB ("colspan", "12") .

 
TEMPLATE component
    ELEMENT "tr" ATTRIB ("class", shading)
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "comp-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "hang-list"), 
	FIELD TAG "td" ATTRIB("class", "begindatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td"  VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" ATTRIB("class", "enddatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" ATTRIB("class", "begindatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" ATTRIB("class", "enddatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" ATTRIB("class", "begindatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" ATTRIB("class", "enddatagroup") VALUETAG "para" ATTRIB ("role", "class-name") 
	,
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
		FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
	FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name")
	.
 
HEADER INITIAL
    ELEMENT OPEN "section" ATTRIB ("label", "SoilReport").
   # ELEMENT "title" reporttitle.
   # IF reporthdrtext!="" ELEMENT "para" ATTRIB ("role", "headnote") reporthdrtext.
END HEADER.

SECTION area_lead WHEN FIRST OF areabreak
    DATA
    ELEMENT OPEN "table" ATTRIB ("orient", "land").
      ELEMENT "col" ATTRIB("width", "2*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
	  ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
	  ELEMENT "col" ATTRIB("width", "1*").
	  ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
	  ELEMENT "col" ATTRIB("width", "1*").
      ELEMENT "col" ATTRIB("width", "1*").
	  
    ELEMENT OPEN "thead".
    USING head1 "Map unit symbol and soil name", "Hydrologic group", "Surface runoff",
	"Month", "Water table",  "Ponding", "Flooding" 
	, 
"wtbottom_r_moist",
"max_soimoistdepb_r",
"wtbottom_l_moist",
"max_soimoistdepb_",
"wtbottom_l",
"max_soimoistdepb_l"
			.

    USING head2 "Upper limit", "Lower limit", "Kind", "Surface depth", "Duration", 
	"Frequency", "Duration", "Frequency".
    ELEMENT CLOSE "thead".

    ELEMENT OPEN "tbody".    
    USING units "", "", "", "", "Ft", "Ft","",
	"Ft", "", "", "", "" 
	#, "" ,""
	.
END SECTION.

SECTION mapunit WHEN FIRST OF mapunit.mukey
    DATA
	USING mapunit musym_label  VALUETAG 'a' ATTRIB ('style', 'color:green;font-style:italic;font-weight:bold;font-size:14'). #VALUETAG 'a' ATTRIB ('href', soilweb) ATTRIB ('target','_blank')ATTRIB ('style','width: 50px')
END SECTION.

SECTION 

	DATA 
    USING component 
    	    soilnm  SUPPRESS DUPLICATES BY component.cokey, #VALUETAG 'a' ATTRIB ('href', soilwebcomp) ATTRIB ('target','_blank')  ATTRIB ('style','width: 50px') 
	    	hydgrp  SUPPRESS DUPLICATES BY component.cokey,
            runoff  SUPPRESS DUPLICATES BY component.cokey,
	    	month2  , 
            moisture_t2    ALIGN CENTER,
            moisture_b2    ALIGN CENTER,
			apparent   ,	
		    ponddep   ALIGN CENTER,
			ponddurcl    ALIGN CENTER REPLACE NULL WITH " ---",
	 		pondfreq    ALIGN CENTER,
	 		floddurcl ALIGN CENTER REPLACE NULL WITH " ---",
			flodfreq   ALIGN CENTER 
	,
wtbottom_r_moist,
max_soimoistdepb_r,
wtbottom_l_moist,
max_soimoistdepb_l,
wtbottom_l,
max_soimoistdepb_l
.
END SECTION.



SECTION WHEN LAST OF areabreak
    DATA
	ELEMENT CLOSE "tbody".
	ELEMENT CLOSE "table".
END SECTION.

SECTION WHEN AT END
    DATA
    ELEMENT CLOSE "section".
END SECTION.