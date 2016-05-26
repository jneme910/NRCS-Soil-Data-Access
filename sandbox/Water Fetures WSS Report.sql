#PARAMETER areasym PROMPT "Enter Survey Area Symbol" CHAR.
#PARAMETER mukeys PROMPT "Or List of Mapunit Keys" MULTIPLE CHAR.
#PARAMETER includeminor PROMPT "Include minor soils?" BOOLEAN.
#PARAMETER useNationalMapunits PROMPT "Display national mapunit symbols?" BOOLEAN.

BASE TABLE comonth.

EXEC SQL SELECT areaname, 
musym, 
mapunit.mukey, 
muname, 
compname, 
localphase, 
component.cokey, 
flodfreqcl AS flodf, 
floddurcl AS floddur, 
comppct_r, 
hydgrp, 
comonth.month, 
monthseq, 
pondfreqcl AS pondf, 
ponddurcl AS  ponddur, 
ponddep_l,
ponddep_h, 
runoff
FROM legend
INNER JOIN mapunit ON mapunit.lkey= legend.lkey AND (areasymbol=areasym OR mapunit.mukey in (mukeys) )
INNER JOIN component ON component.mukey=mapunit.mukey AND  ( majcompflag = "Yes" OR 1 = includeminor )
LEFT OUTER JOIN  comonth ON comonth.cokey=component.cokey
ORDER BY case when useNationalMapunits =0 then areaname else cast(mapunit.mukey as varchar(30)) end, 
comppct_r DESC, compname, 
    monthseq, component.cokey, comonth.month;.


EXEC SQL select soimoistdepb_l wtbottom_l, soimoistdepb_h wtbottom_h, soimoistdept_h wttop_h, soimoiststat moisture 
FROM comonth
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey;
AGGREGATE COLUMN wtbottom_l MAX, wtbottom_h MAX, wttop_h MAX.
	
EXEC SQL SELECT soimoistdept_l, soimoistdept_h, soimoistdepb_l, soimoistdepb_h, soimoiststat
FROM comonth
INNER JOIN cosoilmoist ON cosoilmoist.comonthkey=comonth.comonthkey;
SORT BY soimoistdept_l ASC
AGGREGATE COLUMN soimoistdept_l NONE, soimoistdept_h, soimoistdepb_l NONE, soimoistdepb_h NONE, soimoiststat NONE.

DEFINE reporttitle INITIAL SCRIPT(REPORT_TITLE).
DEFINE reporthdrtext IF NEW(areaname) THEN reporthdrtext ELSE NULL INITIAL SCRIPT(REPORT_HEADER).
DEFINE space INITIAL "".

# Toggle a style class between shade0 and shade1 by component
DEFINE toggle IF NEW (mapunit.mukey) THEN 0 ELSE IF NEW(component.cokey) THEN 1 - toggle ELSE toggle.
DEFINE shading IF toggle == 1 THEN "odd" ELSE "even".
#################################################################

# This is a workaround for a limitation in CVIR SQL translation.
# If the condition soimoiststat="wet" could be put in the join condition this would
# not be necessary. Putting it in the where clause would eliminate components
# that have no soil moisture, so we have to use
# a lookup to select the wet soil moisture states.
ASSIGN soimoistdept_l LOOKUP ("Wet", soimoiststat, soimoistdept_l).
ASSIGN soimoistdept_h LOOKUP ("Wet", soimoiststat, soimoistdept_h).
ASSIGN soimoistdepb_l LOOKUP ("Wet", soimoiststat, soimoistdepb_l).
ASSIGN soimoistdepb_h LOOKUP ("Wet", soimoiststat, soimoistdepb_h).
ASSIGN soimoiststat	LOOKUP ("Wet", soimoiststat, soimoiststat).
#################################################################

DEFINE soilnm SECASE(ISNULL(localphase) ? compname : compname||", "||localphase).
DEFINE areabreak IF useNationalMapunits THEN "Map Units" ELSE areaname.
DEFINE musym_label (IF useNationalMapunits THEN mapunit.mukey ELSE musym) || "--" || muname.
#DEFINE moisture_t ISNULL(soimoistdept_h) ? "---" : (soimoistdept_l == soimoistdept_h) ? SPRINTF("%3.1f", soimoistdept_l/30.48) : SPRINTF("%3.1f-%-3.1f", soimoistdept_l/30.48, soimoistdept_h/30.48).
DEFINE moisture_t	 IF ISNULL(soimoistdept_h) THEN "---" ELSE IF ((soimoistdept_l != 0) and (soimoistdept_l==soimoistdept_h)) THEN sprintf(">%3.1f", soimoistdept_l/30.48) ELSE IF ((soimoistdept_l == 0) and (soimoistdept_l == soimoistdept_h)) THEN "0.0" ELSE sprintf("%3.1f-%3.1f", soimoistdept_l/30.48, soimoistdept_h/30.48).

DEFINE moisture_b ISNULL(soimoistdepb_l) ? "---" : (soimoistdepb_l > 181) ? ">6.0" : SPRINTF("%3.1f-%-3.1f", soimoistdepb_l/30.48, soimoistdepb_h/30.48).





DEFINE ponddep ISNULL(ponddep_l) ? "---" : SPRINTF("%3.1f-%-3.1f", ponddep_l/30.48, ponddep_h/30.48).
#DEFINE ponddur		CODELABEL(ponddurcl).
#DEFINE pondf		CODELABEL(pondfreqcl).
DEFINE pondfreq		pondf == "None" ? "---" : pondf.
#DEFINE flodf		CODELABEL(flodfreqcl).
#DEFINE floddur		CODELABEL(floddurcl).
DEFINE allvar musym || compname || localphase || moisture_t || moisture_b || ponddep || ponddur || pondfreq || floddur || flodf.
DEFINE newdata NEW(allvar).
DEFINE counter IF newdata == 1 THEN 0 ELSE counter + 1.
DEFINE mnnum	IF comonth.month == "January" THEN "1"
				ELSE IF comonth.month == "February" THEN "2"
				ELSE IF comonth.month == "March" THEN "3"
				ELSE IF comonth.month == "April" THEN "4"
				ELSE IF comonth.month == "May" THEN "5"
				ELSE IF comonth.month == "June" THEN "6"
				ELSE IF comonth.month == "July" THEN "7"
				ELSE IF comonth.month == "August" THEN "8"
				ELSE IF comonth.month == "September" THEN "9"
				ELSE IF comonth.month == "October" THEN "10"
				ELSE IF comonth.month == "November" THEN "11"
				ELSE IF comonth.month == "December" THEN "12" ELSE ")".
DEFINE startmn IF newdata == 1 THEN mnnum ELSE startmn.
DEFINE endmn IF newdata == 1 THEN startmn ELSE startmn + counter.
DEFINE mnfirst startmn == "1" ? "Jan" : startmn == "2" ? "Feb" : startmn == "3" ? "Mar" : startmn == "4" ? "Apr" : startmn == "5" ? "May" : startmn == "6" ? "Jun" : startmn == "7" ? "Jul" : startmn == "8" ? "Aug" : startmn == "9" ? "Sep" : startmn == "10" ? "Oct" : startmn == "11" ? "Nov" : startmn == "12" ? "Dec" : "---".
DEFINE mnlast endmn == "1" ? "Jan" : endmn == "2" ? "Feb" : endmn == "3" ? "Mar" : endmn == "4" ? "Apr" : endmn == "5" ? "May" : endmn == "6" ? "Jun" : endmn == "7" ? "Jul" : endmn == "8" ? "Aug" : endmn == "9" ? "Sep" : endmn == "10" ? "Oct" : endmn == "11" ? "Nov" : endmn == "12" ? "Dec" : "---".
DEFINE mnrge startmn == endmn ? mnfirst : mnfirst || "-" || mnlast. 
DEFINE moisture_chk	ISNULL(wtbottom_h) ? 0 : 1.
DEFINE moisture_chk1 moisture_t == "---" ? 0 : 1.
DEFINE moisthigh moisture_chk1 == 1 ? "wet" : moisture_chk == 0 ? "---" : "wtbottom_h".			   
DEFINE wtbottom_high ISNULL(wtbottom_h) ? "---" : wtbottom_h > 181 ? "---" : sprintf(">%3.1f", wtbottom_h/30.48).
DEFINE moisthigh1 moisthigh == "wet" ? moisture_t : moisthigh == "wtbottom_h" ? wtbottom_high : mnrge == "Jan-Dec" ? "---" : "---".
DEFINE moisture_chk2 ISNULL(wtbottom_l) ? 0 : 1.
DEFINE moisture_chk3 moisture_b == "---" ? 0 : 1.
DEFINE moistlow	moisture_chk3 == 1 ? "wet" : moisture_chk2 == 0 ? "---" : "wtbottom_l".
DEFINE wtbottom_low	ISNULL(wtbottom_l) ? "---" : wtbottom_l > 181 ? "---" : sprintf(">%3.1f", wtbottom_l/30.48).
DEFINE moistlow1 moistlow == "wet" ? moisture_b : moistlow == "wtbottom_l" ?  wtbottom_low : mnrge == "Jan-Dec" ? "---" : "---".
DEFINE wtbottom1 ARRAYMAX(wtbottom_l).
DEFINE apparent	IF ISNULL(soimoistdepb_h) THEN "---" ELSE IF wtbottom1 == soimoistdepb_l THEN "apparent" ELSE "perched".
DEFINE cname (startmn == "1" OR ISNULL(startmn)) ? soilnm : "".
DEFINE hydro		startmn == "1" OR ISNULL(startmn) ? hydgrp : "".
DEFINE runt		startmn == "1" OR ISNULL(startmn) ? runoff : "".
DEFINE pondfreq1	not isnull(pondf)  ? pondf :  isnull(pondf) and mnrge == "Jan-Dec" ? "---" : "---".
DEFINE flodfreq1	not isnull(flodf) ? flodf :  isnull(flodf) and mnrge == "Jan-Dec" ? "None" : "---".

TEMPLATE head1
ELEMENT "tr"
FIELD TAG "td" ATTRIB ("rowspan", "2"),
FIELD TAG "td" ATTRIB ("rowspan", "2"),
FIELD TAG "td" ATTRIB ("rowspan", "2"),
FIELD TAG "td" ATTRIB ("rowspan", "2"),
FIELD TAG "td" ATTRIB ("colspan", "2") ATTRIB ("class", "begindatagroup enddatagroup"),
FIELD TAG "td" ATTRIB ("colspan", "3") ATTRIB ("class", "begindatagroup enddatagroup"),
FIELD TAG "td" ATTRIB ("colspan", "2") ATTRIB ("class", "begindatagroup enddatagroup").

TEMPLATE head2
ELEMENT "tr"
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup"),
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td",
FIELD TAG "td" ATTRIB("class", "enddatagroup"),
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup").

TEMPLATE units TAG "td"
ELEMENT "tr" ATTRIB ("class", "units") 
FIELD, FIELD, FIELD, FIELD,
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup"),
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td",
FIELD TAG "td" ATTRIB("class", "enddatagroup"),
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup").
 
TEMPLATE mapunit TAG "td"
ELEMENT "tr" ATTRIB ("class", "mapunit") 
FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "mu-name"), 
FIELD, FIELD, FIELD,
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup"),
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td",
FIELD TAG "td" ATTRIB("class", "enddatagroup"),
FIELD TAG "td" ATTRIB("class", "begindatagroup"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup").
 
TEMPLATE component
ELEMENT "tr" ATTRIB("class", shading)
FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "comp-name"), 
FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" ATTRIB("class", "begindatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" ATTRIB("class", "begindatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" ATTRIB("class", "begindatagroup") VALUETAG "para" ATTRIB ("role", "class-name"), 
FIELD TAG "td" ATTRIB("class", "enddatagroup") VALUETAG "para" ATTRIB ("role", "class-name").
 
HEADER INITIAL
ELEMENT OPEN "section" ATTRIB ("label", "SoilReport").
ELEMENT "title" reporttitle.
IF reporthdrtext != "" ELEMENT "para" ATTRIB ("role", "headnote") reporthdrtext.
END HEADER.

SECTION area_lead WHEN FIRST OF areabreak
DATA
ELEMENT OPEN "table" ATTRIB ("orient", "land").
IF useNationalMapunits == 0 ELEMENT "title" areaname.
IF useNationalMapunits != 0 INCLUDE "Subreport for area names" (areasym, mukeys).
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

ELEMENT OPEN "thead".
USING head1 "Map unit symbol and soil name", "Hydrologic group", "Surface runoff", "Month", "Water table", "Ponding", "Flooding".

USING head2 "Upper limit", "Lower limit", "Surface depth", "Duration", "Frequency", "Duration", "Frequency".
ELEMENT CLOSE "thead".

ELEMENT OPEN "tbody".    
USING units space, space, space, space, "Ft", "Ft", "Ft", space, space, space, space.
END SECTION.

SECTION mapunit WHEN FIRST OF mapunit.mukey
DATA
USING mapunit musym_label.
END SECTION.

SECTION WHEN LAST OF allvar KEEP WITH mapunit
DATA	
USING component cname, hydro REPLACE NULL WITH " ---", runt REPLACE NULL WITH " ---", mnrge, moisthigh1 ALIGN CENTER, moistlow1 ALIGN CENTER, ponddep ALIGN CENTER, ponddur ALIGN CENTER REPLACE NULL WITH " ---", pondfreq1 ALIGN CENTER REPLACE NULL WITH " ---", floddur ALIGN CENTER REPLACE NULL WITH " ---", flodfreq1 ALIGN CENTER REPLACE NULL WITH " ---".
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