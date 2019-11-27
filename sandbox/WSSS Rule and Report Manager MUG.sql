PARAMETER areasym PROMPT "Enter Survey Area Symbol" CHAR.
PARAMETER mukeys PROMPT "Or List of Mapunit Keys" MULTIPLE CHAR.
PARAMETER useNationalMapunits PROMPT "Display national mapunit symbols?" BOOLEAN.


BASE TABLE component.

EXEC SQL SELECT TOP 10
areasymbol, 
areaname, 
hydgrp, mapunit.mukey AS mukey,
mapunit.mukey AS mukey_main, 
hydricrating
musym, 
muname, 
nationalmusym, 
compname, 
farmlndcl,
compkind, 
comppct_l, 
comppct_h, 
comppct_r, 
cokey AS cokey_main, cokey, 
localphase,
slope_l, 
slope_h,
runoff, 
aspectrep, 
aspectccwise,
aspectcwise, 
drainagecl,
nirrcapcl, 
nirrcapscl,
nirrcapunit, 
irrcapcl, 
irrcapscl, 
irrcapunit, 

majcompflag, 
taxclname, 
taxtempcl, 
taxtempregime, 
MIN(elev_l) over(partition by mapunit.mukey) AS elevl,
MIN(elev_h) over(partition by mapunit.mukey) AS elevh,

MIN(map_l) over(partition by mapunit.mukey) AS mapl,
MIN(map_h) over(partition by mapunit.mukey) AS maph,

MIN(airtempa_l) over(partition by mapunit.mukey) AS airtempal,
MIN(airtempa_h) over(partition by mapunit.mukey) AS airtempah,

MIN(ffd_l) over(partition by mapunit.mukey) AS ffdl,
MIN(ffd_h) over(partition by mapunit.mukey) AS ffdh
    FROM legend
	INNER JOIN mapunit ON mapunit.lkey=legend.lkey
	INNER JOIN component ON component.mukey=mapunit.mukey
    AND ( areasymbol=areasym OR mapunit.mukey in (mukeys) )
    ORDER BY  CASE WHEN useNationalMapunits =0 THEN areaname ELSE nationalmusym END, 
    CASE WHEN majcompflag IS NULL THEN 'No' ELSE majcompflag END DESC, comppct_r DESC, component.cokey;
    AGGREGATE ROWS BY areaname, mukey, cokey.


# HORIZON DATA
EXEC SQL SELECT hzname, hzdept_r, hzdepb_r, chkey, ph1to1h2o_r, ec_r, ec_h,
sar_r, sar_h, awc_l, awc_r, awc_h
FROM component
INNER JOIN chorizon ON chorizon.cokey=component.cokey AND component.cokey IN ($cokey_main);
SORT BY hzdept_r, chkey
AGGREGATE COLUMN chkey NONE, hzname NONE, hzdept_r NONE,hzdepb_r NONE, ph1to1h2o_r NONE, ec_h NONE, sar_h NONE,
awc_l NONE, awc_r NONE, awc_h NONE.

# HORIZON TEXTURE DATA
EXEC SQL SELECT texture AS hztexture, hzdept_r AS depthhzdeptr, chtexturegrp.chkey AS texchiid
FROM component 
INNER JOIN chorizon ON chorizon.cokey=component.cokey AND component.cokey IN ($cokey_main)
INNER JOIN chtexturegrp ON chtexturegrp.chkey=chorizon.chkey AND chtexturegrp.rvindicator='Yes';
SORT BY depthhzdeptr, texchiid
AGGREGATE COLUMN hztexture NONE.


# TAX MOISTURE CLASS
EXEC SQL SELECT taxmoistcl, taxmoistscl
FROM component
INNER JOIN cotaxmoistcl ON cotaxmoistcl.cokey=component.cokey AND component.cokey IN ($cokey_main);.

#MAJOR COMPONENTS
EXEC SQL
SELECT mucmaj.compname, mucmaj.comppct_r, localphase phase2, mucmaj.compkind
FROM  mapunit
INNER JOIN component AS mucmaj ON  mucmaj.mukey=mapunit.mukey
AND mucmaj.majcompflag = 'Yes';
SORT BY mucmaj.comppct_r DESC, mucmaj.compname 
AGGREGATE COLUMN mucmaj.compname NONE, mucmaj.comppct_r NONE.

# SUM COMP PERCENT FOR MINOR COMPONENTS 
EXEC SQL
SELECT mucmin.comppct_r
FROM  mapunit
INNER JOIN component AS  mucmin ON mucmin.mukey
AND mapunit.mukey IN ($mukey_main) AND mucmin.majcompflag !=  'Yes';
AGGREGATE COLUMN mucmin.comppct_r SUM.

#INTERP RATING FOR HYDRIC RATING MAJORS  
#FIRST VALUE, MIGHT NEED TO SEE ABOUT MAKING A LIST
EXEC SQL SELECT TOP 1 hydricrating
FROM component
INNER JOIN cohydcrit ON cohydcrit.cokey=component.cokey AND cokey IN ($cokey_main) AND majcompflag = 'Yes';.    

#INTERP RATING FOR HYDRIC RATING MINOR
#FIRST VALUE, MIGHT NEED TO SEE ABOUT MAKING A LIST
EXEC SQL select hydricrating hydricratmin
FROM component
LEFT OUTER JOIN cohydcrit BY default AND coiid IN ($coiid) AND majcompflag = 0;
#AND dmuiidref IN ($dmuref);.
AGGREGATE COLUMN hydricratmin FIRST. 

#Get component horizon color and properties notes
EXEC SQL Select component.seqnum cseqnum, chorizon.seqnum chseqnum, textentry hor_col 			
FROM component
LEFT OUTER JOIN chorizon BY default
LEFT OUTER JOIN chorizon_text BY default
WHERE chorizontextkind = "miscellaneous notes"
AND textcat = "horizon note"
AND textsubcat = "color"
AND dmuiidref IN ($dmuref);
sort by cseqnum, chseqnum, hor_col 
aggregate column chseqnum none, hor_col none.

EXEC SQL Select component.seqnum cseqnumber, chorizon.seqnum chseqnumber, textentry hor_prop 			
FROM component
LEFT OUTER JOIN chorizon BY default
LEFT OUTER JOIN chorizon_text BY default
AND chorizontextkind = "miscellaneous notes"
AND  textcat = "horizon note"
AND textsubcat = "properties"
AND dmuiidref IN ($dmuref);
sort by cseqnumber, chseqnumber, hor_prop
aggregate column chseqnumber none, hor_prop none.
    
# get the MLRA symbol(s) and areaname(s) for each mapunit
EXEC SQL SELECT DISTINCT CAST (CAST (areasymbol AS varchar) + '-' + CAST (areaname AS varchar (250)) AS varchar (250)) AS mlra
FROM mapunit
INNER JOIN muaoverlap ON muaoverlap.mukey=mapunit.mukey AND  mapunit.mukey IN (mukey_main)
INNER JOIN laoverlap ON laoverlap.lareaovkey=muaoverlap.lareaovkey AND laoverlap.areatypename = "MLRA";
AGGREGATE COLUMN mlra LIST '; '.


EXEC SQL select component.seqnum compseq, comppct_r cpct, compname cmpnme, localphase lphase
FROM datamapunit 
INNER JOIN component BY default
AND   dmuiidref IN ($dmuiid)
and majcompflag = 1;
     SORT by cpct DESC
     aggregate column compseq NONE, cpct NONE, cmpnme NONE, lphase NONE.

EXEC SQL select comppct_r cpct_min
FROM datamapunit 
INNER JOIN component BY default
AND     dmuiidref IN ($dmuiid)
#    and comppct_r < cutoff;.
     and (majcompflag IS NULL or majcompflag = 0);
aggregate column cpct_min none.
  
#get geomorphic text note for component
EXEC SQL select textentry cgeo_not
FROM component 
INNER JOIN component_text BY default
and comptextkind="miscellaneous notes"
and textcat="geomorphic"
and textsubcat="adjective"
AND dmuiidref IN ($dmuiid);.

#get parent material text note for component
EXEC SQL select textentry AS pm_note 
FROM  component 
INNER JOIN component_text by default
and comptextkind="miscellaneous notes"
and textcat="parent material"
and textsubcat="adjective"
AND dmuiidref IN ($dmuiid);.

# get ecositeid and ecositetype
EXEC SQL select ecologicalsite.ecological_site_type ecotyp, ecositeid, ecositenm 
FROM component
#LEFT OUTER JOIN coecosite BY default AND coiid IN ($coiid) AND majcompflag = 1
LEFT OUTER JOIN coecosite ON coecosite.coiidref=component.coiid AND coiid IN ($coiid) AND majcompflag = 1
INNER JOIN REAL ecologicalsite BY default AND coiid IN ($coiid) AND majcompflag = 1
WHERE dmuiidref IN ($dmuiid);
AGGREGATE COLUMN ecositeid FIRST, ecositenm FIRST. 
    
# added to get the miscellaneous notes for typical vegetation notes for each component
EXEC SQL select textentry typ_veg 
FROM  component
INNER JOIN  component_text BY default
AND comptextkind = "miscellaneous notes"
AND  textcat = "typical vegetation"
AND dmuiidref IN ($dmuiid);.

# added to get the typical vegetation from the component existing plants table
EXEC SQL 
SELECT lplantname existplant, coeplants.seqnum, forestunprod, rangeprod
FROM component
INNER JOIN coeplants ON coeplants.coiidref=component.coiid AND coiid IN ($coiid) AND majcompflag = 1
INNER JOIN REAL localplant BY default;

SORT BY rangeprod DESC, forestunprod DESC, coeplants.seqnum, existplant
AGGREGATE COLUMN existplant LIST.

# extract landscape at the mapunit level for setting section

EXEC SQL SELECT geomfnamep AS geonm_ls, geomfmod AS geomod_ls, geomftname AS geotnm_ls
FROM component
INNER JOIN cogeomordesc BY default AND coiid IN ($coiid)
INNER JOIN REAL geomorfeat  BY default
INNER JOIN REAL geomorfeattype  BY default
AND	geomorfeattype.geomftname = "Landscape" ;
AGGREGATE COLUMN geotnm_ls NONE, geonm_ls NONE,  geomod_ls NONE.
  
EXEC SQL select reskind, resdept_r, resdept_l, resdept_h
FROM component
INNER JOIN corestrictions BY default AND coiid IN ($coiid) AND majcompflag = 1
AND  reskind in ("fragipan", "duripan", "petrocalcic", "ortstein", "petrogypsic", "cemented horizon",
"densic material", "placic", "bedrock, lithic", "bedrock, paralithic", "bedrock, densic", "petroferric") AND dmuiidref IN ($dmuiid);
SORT BY resdept_r, resdept_l
AGGREGATE COLUMN reskind none, resdept_r none, resdept_l none, resdept_h none.

EXEC SQL select copmgrpiid, pmgroupname, copmgrp.seqnum
FROM component
INNER JOIN copmgrp BY default 
 AND coiid IN ($coiid);
# AND majcompflag = 1
    SORT BY copmgrp.seqnum.

EXEC SQL select coforprod.lplantiidref foresttree 
FROM component
INNER JOIN coforprod BY default
AND dmuiidref IN ($dmuiid);
 AGGREGATE COLUMN foresttree FIRST.

EXEC SQL
SELECT soimoiststat
FROM component
INNER JOIN comonth BY default
INNER JOIN cosoilmoist BY default
AND  soimoiststat = "wet" AND coiid IN ($coiid);
AGGREGATE COLUMN soimoiststat UNIQUE.


EXEC SQL
SELECT flodfreqcl, pondfreqcl
FROM component
INNER JOIN  comonth  on comonth.coiidref=component.coiid AND coiid IN ($coiid);
AGGREGATE COLUMN flodfreqcl MAX, pondfreqcl MAX.
 
EXEC SQL SELECT textentry comprp_note 
FROM component
INNER JOIN cotext BY default AND  text_category="profile" AND dmuiidref IN ($dmuiid); .

EXEC SQL select textentry comp_note
FROM component
INNER JOIN cotext BY default AND dmuiidref IN ($dmuiid)
AND text_category="component"; .
    
EXEC SQL select textentry def_note 
FROM component
INNER JOIN cotext BY default
 AND dmuiidref IN ($dmuiid) AND text_category="definition"; .

# added to get surface features
EXEC SQL select textentry surfeat
 from component
INNER JOIN cotext BY default
AND dmuiidref IN ($dmuiid)
AND comptextkind = "miscellaneous notes"
AND  textcat = "surface feature";.

##Surface rock fragments
#EXEC SQL select sfragcov_l, sfragcov_h, sfragcov_r, sfragsize_l, sfragsize_h, 
#    sfragsize_r, sfragshp, sfraground 
#FROM component
#INNER JOIN cosurffrags by default and cosurffrags.coiidref=component.coiid;
##INNER JOIN cosurffrags BY default AND dmuiidref IN ($dmuiid);
#AGGREGATE COLUMN sfragcov_l FIRST, sfragcov_h FIRST, sfragcov_r FIRST, sfragsize_r FIRST, 
#sfragsize_l FIRST, sfragsize_h FIRST, sfragshp FIRST, sfraground FIRST.

#added to get altered hydrology text note
EXEC SQL select textentry alter_hyd
FROM component
INNER JOIN cotext BY default
AND dmuiidref IN ($dmuiid)
AND comptextkind = "miscellaneous notes"
AND  textcat = "hydrology"
AND  textsubcat = "altered";.
#
DEFINE tempclass    ISNULL (taxtempcl) ? "Not specified" :    LOCASE(CODELABEL(taxtempcl)).						
DEFINE tempregime   ISNULL (taxtempregime) ? "Not specified" : LOCASE(CODELABEL(taxtempregime)).
DEFINE moistclass   ISNULL(taxmoistcl) ? "Not specified" :   LOCASE(CODELABEL(taxmoistcl)).
DEFINE moistsubclass   ISNULL(taxmoistscl) ? "Not specified" :   SECASE(CODELABEL(taxmoistscl)).
ASSIGN taxclname    ISNULL(taxclname) ? "Not specified" :   taxclname.
#
DEFINE dmulocation         ISNULL (location) ? "None specified" : location.

#
DEFINE dgeonote		   ISNULL(dgeo_note) ? "None specified" : SECASE(dgeo_note).

# define MLRA as array delimited by a comma

DEFINE mlra_symbols      ISNULL(mlra) ? "Not specified" : ARRAYCAT(mlra, ", ").
#DEFINE mlranames         ISNULL(areaname) ? "NO OVERLAP" : ARRAYCAT(areaname, ", ").
DEFINE mlras	         ISNULL (mlra_symbols) ? "Not specified" :(mlra_symbols).

# Compute cumulative percentage from component percentages by mapunit.

DEFINE compsoi	IF ISNULL(localphase) THEN compname ||" soils" 
		ELSE compname ||", "||LOCASE(localphase)||" soils".
DEFINE compsoi2 IF compkind == 3 THEN compname ELSE compsoi.
DEFINE compsoi3 IF compkind == 3 THEN "Description of "|| compname ELSE "Description of "|| compsoi.

DEFINE first_comp	NEW(dmuiid).
DEFINE cum_pct		first_comp ? 0 : cum_pct.
#DEFINE major		ISNULL(compname) ? -1 :
#			comppct_r >= cutoff ? 1 : 0.
# Defines major component based on major component flag
#DEFINE major        majcompflag == 1 ? 1 : 0.

# need this var to check when last of minor
#DEFINE notminor		comppct_r >= cutoff.
#DEFINE minor		majcompflag == 0 ? 0 : 1.

ASSIGN cum_pct		cum_pct + comppct_r.

DEFINE comp_case        ISNULL(lphase) ? NMCASE(cmpnme) : 
                        NMCASE(cmpnme) || " " || lphase.

DEFINE composition      sprintf ("%s and similar soils: %.f percent", comp_case, cpct).
DEFINE compsoipct	    SPRINTF("%0.f percent", comppct_r).
DEFINE addminor         ARRAYSUM(cpct_min).
DEFINE mincomp          sprintf ("%.f percent", addminor).

# NPS major and minor components composiiton statements
DEFINE compname2   IF ISNULL(phase2) THEN mucmaj.compname 
		ELSE mucmaj.compname ||", "||LOCASE(phase2).
DEFINE mucsim	compname2 || " and similar soils: " ||
		SPRINTF("%0.f", mucmaj.comppct_r) || " percent".
ASSIGN mucsim	IF mucmaj.compkind == 3 THEN mucmaj.compname ||": "||SPRINTF("%0.f", mucmaj.comppct_r) || " percent" ELSE mucsim.

DEFINE mucminor	SPRINTF("Dissimilar minor components: %0.f percent", 
		mucmin.comppct_r).


# Convert elevation and precipitation from metric, and format as ranges.

DEFINE ell              ISNULL(elevl) ? "0" :elevl*3.2808.
DEFINE ellrnd           ell - MOD(ell, 5).

DEFINE elh              ISNULL(elevh) ? "0" :elevh*3.2808.
DEFINE elhrnd           elh - MOD(elh, 5).
			
DEFINE elev      	ISNULL(elevl) ? "---" : (ell < 50) ? sprintf("%.1f to %.f feet ", ell, elh) : sprintf("%.f to %.f feet ", ellrnd, elhrnd).

DEFINE elevation        ISNULL(elevl) ? "---" : (ell < 50) ? "(" || sprintf ("%.1f to %.1f meters", elevl, elevh)||
                        ")" : "(" || sprintf ("%.f to %.f meters", elevl, elevh) || ")".
DEFINE precipit		ISNULL(mapl) ? "---" :
         		sprintf ("%.f to %.f inches", mapl/25.4, maph/25.4).
DEFINE precip		ISNULL(mapl) ? "---" :
         		precipit || " (" || sprintf ("%.f to %.f millimeters", mapl, maph) || ")".

DEFINE maatemp          ISNULL(maatl) ? "---" :
                        sprintf ("%.f to %.f degrees F",  
                        maatl*1.8+32, maath*1.8+32). 
DEFINE maat             ISNULL(maatl) ? "---" : maatemp || " (" ||
                        sprintf ("%.f to %.f degrees C",  
                        maatl, maath) || ")". 

DEFINE frost		ISNULL(ffdl) ? "---" :
			sprintf ("%.f to %.f days",ffdl,ffdh).
			
DEFINE prime            ISNULL(farmlndcl) ? "not rated" : CODELABEL(farmlndcl).
			
# Create headings for mapunit and component descriptions.
# added localphase to component name on output

DEFINE name		sprintf("%s--%s", musym, muname).
DEFINE compnm_case	ISNULL(localphase) ? NMCASE(compname) :
                        NMCASE(compname) || ", " || LOCASE(localphase).
#DEFINE composition      sprintf ("**%s - %.f percent", compnm_case, comppct_r).
DEFINE comp_heading	(majcompflag == 1) ? "Soil Description" :
			(majcompflag == 0) ? "Minor components listed as estimated percent of mapunit:" :
			"Component data missing".
DEFINE comp_pct		ISNULL(comppct_l) ? ISNULL(comppct_r) ? "---" :
			sprintf ("%.f percent", comppct_r) :
			sprintf ("%.f to %.f percent", comppct_l, comppct_h).
DEFINE misc_land	compkind == 3.


DEFINE compnm	misc_land ? NMCASE(compname) :
			sprintf ("%s and similar soils", compnm_case).

#DEFINE majorcomp	NMCASE(compname).

#Add minorcomp from Oklahoma MUG
DEFINE minorcomp	sprintf ("%s: %s", compnm, comp_pct).
#DEFINE minorlocat	sprintf ("%s: %s", compnm, comp_pct).

## ASPECT

DEFINE aspect_r	IF aspectrep <= 23 THEN "north"
		ELSE IF aspectrep <= 68 THEN "northeast"
		ELSE IF aspectrep <= 113 THEN "east"
		ELSE IF aspectrep <= 158 THEN "southeast"
		ELSE IF aspectrep <= 203 THEN "south"
		ELSE IF aspectrep <= 248 THEN "southwest"
		ELSE IF aspectrep <= 293 THEN "west"
		ELSE IF aspectrep <= 338 THEN "northwest"
		ELSE IF NOT ISNULL (aspectrep) THEN "north"
		ELSE "Not specified".
ASSIGN aspect_r	SECASE(aspect_r).

DEFINE aspect_ccw IF aspectccwise <= 23 THEN "north"
		ELSE IF aspectccwise <= 68 THEN "northeast"
		ELSE IF aspectccwise <= 113 THEN "east"
		ELSE IF aspectccwise <= 158 THEN "southeast"
		ELSE IF aspectccwise <= 203 THEN "south"
		ELSE IF aspectccwise <= 248 THEN "southwest"
		ELSE IF aspectccwise <= 293 THEN "west"
		ELSE IF aspectccwise <= 338 THEN "northwest"
		ELSE IF NOT ISNULL (aspectccwise) THEN "north"
		ELSE "Not specified".
		
DEFINE aspect_cw IF aspectcwise <= 23 THEN "north"
		ELSE IF aspectcwise <= 68 THEN "northeast"
		ELSE IF aspectcwise <= 113 THEN "east"
		ELSE IF aspectcwise <= 158 THEN "southeast"
		ELSE IF aspectcwise <= 203 THEN "south"
		ELSE IF aspectcwise <= 248 THEN "southwest"
		ELSE IF aspectcwise <= 293 THEN "west"
		ELSE IF aspectcwise <= 338 THEN "northwest"
		ELSE IF NOT ISNULL (aspectcwise) THEN "north"
		ELSE "Not specified".
		
DEFINE aspect_range	IF aspect_ccw MATCHES aspect_cw THEN "All aspects" ELSE
			SECASE(aspect_ccw)||" to "||aspect_cw||" (clockwise)".	
		


DEFINE slope		ISNULL(slope_l) ? "---" :
			sprintf ("%.f to %.f percent",
			slope_l, slope_h).
DEFINE slp	SPRINTF("%0.f to %0.f percent", slope_l, slope_h).			
# define surface features
DEFINE surf_feat       ISNULL (surfeat) ? "None specified" : SECASE(surfeat).

#Surface rock fragments from region 4
EXEC SQL select sfragcov_l, sfragcov_h, sfragcov_r, sfragsize_l, sfragsize_h, 
    sfragsize_r, sfragshp, sfraground 
    from component, cosurffrags
    where join component to cosurffrags;
    AGGREGATE COLUMN sfragcov_l none, sfragcov_h none, sfragcov_r none, sfragsize_r none, 
    sfragsize_l none, sfragsize_h none, sfragshp none, sfraground none.
    
#Revised to round low percents to "less than 1" instead of zero 
DEFINE coverpct         ISNULL(sfragcov_r) ? "" :
			sfragcov_r <1 and sfragcov_r > 0 ? "Less than 1 percent " :
			sprintf ("About %.f percent ", sfragcov_r).    
DEFINE shape            ISNULL(sfragshp) ? "" : CODELABEL(sfragshp).
DEFINE roundness        ISNULL(sfraground) ? "" : CODELABEL(sfraground).
DEFINE fragtype         ISNULL(sfragcov_r) ? "" :
                        shape=="Flat" and (sfragsize_l>=2 
                        and sfragsize_h<=150) ? "channers" :
                        shape=="Flat" and (sfragsize_l>=150
                        and sfragsize_h<=380) ? "flagstones" :
                        shape=="Flat" and (sfragsize_l>=380
                        and sfragsize_h<=600) ? "stones" :
                        shape=="Flat" and sfragsize_l>=600 ? "boulders" :
                        shape=="Nonflat" and (sfragsize_l>=2
                        and sfragsize_h<=5) ? "fine gravel" :
                        shape=="Nonflat" and (sfragsize_l>=5
                        and sfragsize_h<=20) ? "medium gravel" :
                        shape=="Nonflat" and (sfragsize_l>=20
                        and sfragsize_h<=75) ? "coarse gravel" :
                        shape=="Nonflat" and (sfragsize_l>=75
                        and sfragsize_h<=250) ? "cobbles" :
                        shape=="Nonflat" and (sfragsize_l>=250
                        and sfragsize_h<=600) ? "stones" :
                        shape=="Nonflat" and (sfragsize_l>=600) ? "boulders" :
                        shape=="Nonflat" and (sfragsize_l==2
                        and sfragsize_h==75) ? "gravel" :
                        shape=="Nonflat" and (sfragsize_l >= 2 
                        and sfragsize_h <= 20) ? "fine and medium gravel" :
                        shape=="Nonflat" and (sfragsize_l >= 5 
                        and sfragsize_h <= 75) ? "medium and coarse gravel" :
	                "(shape or size unspecified)".
ASSIGN fragtype         roundness=="" ? fragtype :
                        fragtype=="fine gravel" ? ("fine " || roundness || " gravel") :
                        fragtype=="medium gravel" ? ("medium " || roundness || " gravel") :
                        fragtype=="coarse gravel" ? ("coarse " || roundness || " gravel") :
                        roundness || " " || fragtype.
DEFINE fragments        ISNULL(coverpct) ? fragtype : 
                        coverpct || fragtype.
DEFINE frag_ls          ARRAYCAT(fragments, ", ").
DEFINE frag_list        SECASE (frag_ls).
DEFINE surface_frags    frag_list=="" ? "Unspecified" : frag_list.

# get runoff classs
DEFINE runoff_class     ISNULL(runoff) ? "---" : SECASE(CODENAME(runoff)).
 
# Decode drainage.
DEFINE drainage		ISNULL(drainagecl) ? "---" : CODELABEL(drainagecl).

# Construct full landform phrase from feature names and exists-on relationships etc...
EXEC SQL SELECT geomfnamep AS geonm_lf, geomfmod AS geomod_lf, geomftname AS geotnm_lf, 
geomfeatid, existsonfeat, cogeomordesc.seqnum AS geoseqnum_lf
FROM component
INNER JOIN cogeomordesc BY default AND coiid IN ($coiid)
INNER JOIN REAL geomorfeat BY default 
INNER JOIN REAL geomorfeattype BY default 
AND (geomorfeattype.geomftname = "Landform" OR
geomorfeattype.geomftname = "Microfeature");
SORT BY geoseqnum_lf
AGGREGATE COLUMN geotnm_lf NONE, geonm_lf NONE,  geomod_lf NONE, geomfeatid NONE, existsonfeat NONE, geoseqnum_lf NONE.  

DEFINE geoname		ISNULL (geomod_lf) ? geonm_lf : geomod_lf|| " " || geonm_lf.
DEFINE landfrm		ALL ISNULL(geonm_lf) ? "" :
			GEOMORDESC(geoname, geomfeatid, existsonfeat).
DEFINE landform		ARRAYCAT(landfrm,", ").
DEFINE landform2	SECASE(landform).

#Selects position on landform from Component Two Dimensional  Surface Morphometery.

#Selects position on landform from Component Two Dimensional Surface Morphometery.
EXEC SQL select hillslopeprof, cogeomdiid, cosurfmorphhpp.seqnum
FROM component
INNER JOIN  cogeomordesc BY default AND coiid IN ($coiid)
INNER JOIN  cosurfmorphhpp BY default
INNER JOIN REAL geomorfeat ON geomorfeat.geomfiid=cogeomordesc.geomfiidref;
SORT BY cosurfmorphhpp.seqnum, hillslopeprof 
AGGREGATE COLUMN hillslopeprof UNIQUE.
    
DEFINE lfpos	        ISNULL(hillslopeprof) ? "" :
			CODELABEL(hillslopeprof).
DEFINE lformpos         ARRAYCAT (lfpos, ", ").
DEFINE landformpos      SECASE(lformpos).


#  Landform position (3-D)
#  Landform position (3-D)
EXEC SQL
SELECT geomposmntn, geomposhill, geompostrce, geomposflats, cosurfmorphgc.seqnum
FROM component
INNER JOIN cogeomordesc ON cogeomordesc.coiidref=component.coiid AND coiid IN ($coiid)
INNER JOIN cosurfmorphgc BY default;
SORT BY cosurfmorphgc.seqnum.


DEFINE geomcomp CODELABEL(geomposmntn).
ASSIGN geomcomp APPEND(geomcomp, CODELABEL(geomposhill)).
ASSIGN geomcomp APPEND(geomcomp, CODELABEL(geompostrce)).
ASSIGN geomcomp APPEND(geomcomp, CODELABEL(geomposflats)).
ASSIGN geomcomp ARRAYCAT(geomcomp, ", ").
DEFINE geomcomp2 SECASE(geomcomp).


##  Slope shape  Removed Unique before shape_across because Unique was out of context
#EXEC SQL SELECT UNIQUE shape_across, shape_down, component_surface_morph_ss.seqnum
EXEC SQL SELECT DISTINCT shape_across, shape_down, component_surface_morph_ss.seqnum
FROM component
INNER JOIN  cogeomordesc BY default AND coiid IN ($coiid)
INNER JOIN  component_surface_morph_ss BY default;
SORT BY component_surface_morph_ss.seqnum.


DEFINE shpacross ARRAYCAT(CODELABEL(shape_across), ", ").
DEFINE shpacross2  SECASE(shpacross).

DEFINE shpdown ARRAYCAT(CODELABEL(shape_down), ", ").
DEFINE shpdown2  SECASE(shpdown).
          
# Gathering Landscape for Mapunit setting
DEFINE landscape	ISNULL (geomod_ls) ? geonm_ls : geomod_ls|| " " || geonm_ls.
DEFINE landscape2	ARRAYCAT(landscape, ", ").
DEFINE landscape3	SECASE(landscape2).         




DEFINE comp_pct2	sprintf ("0 to %s", comp_pct).

# List each type of restriction with its depth range if available, or just
# the RV depth.

DEFINE resdepth		ISNULL(resdept_l) ? ISNULL(resdept_r) ? "---" :
			sprintf (": %.f inches", resdept_r / 2.54) :
			sprintf (": %.f to %.f inches",
			resdept_l/2.54, resdept_h/2.54).
DEFINE restrict		( ISNULL(reskind) ? "No restrictive layer" :
			CODELABEL(reskind) || resdepth ).


#Parent material information
DEFINE pmtext1		ALL ISNULL(pmgroupname) ? "Not specified" : pmgroupname.
DEFINE pmtext2		ARRAYCAT(pmtext1, ", ").
DEFINE pmtext        pmtext2.


DEFINE ecosysrange      CODENAME(ecotyp).

DEFINE ecosysnm         ISNULL(ecositenm) ? "None specified" : 
                        (sprintf("%s ", ecositenm)).
 
DEFINE ecoid_nu         ISNULL(ecositeid) ? "None specified" : 
                        UPCASE (sprintf("%s ", ecositeid)).


# Typical Vegetation notes
DEFINE typical_veg      ISNULL(typ_veg) ? "None specified" : typ_veg.

# Typical Vegetation

DEFINE typ2_veg          IF ISNULL(existplant) THEN "None specified" ELSE existplant.


DEFINE range_sec	first_comp ? "" : range_sec.
DEFINE forest_sec	first_comp ? "" : forest_sec.
ASSIGN range_sec	ISNULL(ecotyp) AND ISNULL(foresttree) ? range_sec :
			"""Range""".
ASSIGN forest_sec	ISNULL(foresttree) ? forest_sec :
			"""Forestry""".

DEFINE flood	IF ISNULL(flodfreqcl) OR flodfreqcl == 1 THEN  "None"
                ELSE CODELABEL(flodfreqcl).
DEFINE pond	IF ISNULL(pondfreqcl) OR
                pondfreqcl == 1 THEN "None"
		ELSE CODELABEL(pondfreqcl).

#Water Table script from NPS MUG
DERIVE wt_l	FROM low USING "NSSC Pangaea":"DEPTH TO HIGH WATER TABLE MINIMUM".
DERIVE wt_h	FROM high USING "NSSC Pangaea":"DEPTH TO HIGH WATER TABLE MINIMUM".
DERIVE wt_bot	FROM low USING "MLRA09_Temple":"DEPTH TO BOTTOM OF HIGH WATER TABLE MINIMUM".

DEFINE wtr	IF wt_l > 0 THEN SPRINTF("About %0.0f to %0.0f inches", wt_l/2.54, wt_h/2.54) ||
		" (see Water Features table)" ELSE
		
		IF (wt_l == 0 AND wt_h > 0) THEN "At the soil surface to " || SPRINTF("%0.0f inches", wt_h/2.54)  ELSE
		
		IF (wt_l == 0 AND wt_h == 0) THEN "At the soil surface" ELSE
		"More than 72 inches".
		
DEFINE wtr_prch	IF (wt_l > 0 AND wt_bot < 183) THEN SPRINTF("About %0.0f to %0.0f inches", wt_l/2.54, wt_h/2.54) 
		||", perched (see Water Features report)" ELSE
		
		IF (wt_l == 0 AND wt_h > 0 AND wt_bot < 183) THEN "At the soil surface to " || 
		SPRINTF("%0.0f inches", wt_h/2.54) ||", perched (see Water Features report)" ELSE
		
		IF (wt_l == 0 AND wt_h == 0 AND wt_bot < 183) THEN
		"At the soil surface, perched (see Water Features report)" ELSE
		"More than 72 inches".
		
DEFINE wtr2	IF wt_bot < 183 THEN wtr_prch ELSE wtr.

#Salinity		
DERIVE salr	FROM rv USING "MLRA09_Temple":"SALINITY MAXIMUM IN DEPTH 0-100cm (TX)".
DEFINE salrcl	IF salr >= 16 THEN	"Strongly saline (" || SPRINTF("%0.1f", salr) || " mmhos/cm)"
		ELSE IF salr >= 8 THEN	"Moderately saline (" || SPRINTF("%0.1f", salr) || " mmhos/cm)"
		ELSE IF salr >= 4 THEN	"Slightly saline (" || SPRINTF("%0.1f", salr) || " mmhos/cm)"
		ELSE IF salr >= 2 THEN	"Very slightly saline (" || SPRINTF("%0.1f", salr) || " mmhos/cm)"
		ELSE			"Non saline (" || SPRINTF("%0.1f", salr) || " mmhos/cm)".
		
DERIVE salh	FROM rv USING "MLRA09_Temple":"SALINITY MAXIMUM IN DEPTH 0-100cm (TX)".
DEFINE salhcl	IF salh >= 16 THEN	"Strongly saline (" || SPRINTF("%0.1f", salh) || " mmhos/cm)"
		ELSE IF salh >= 8 THEN	"Moderately saline (" || SPRINTF("%0.1f", salh) || " mmhos/cm)"
		ELSE IF salh >= 4 THEN	"Slightly saline (" || SPRINTF("%0.1f", salh) || " mmhos/cm)"
		ELSE IF salh >= 2 THEN	"Very slightly saline (" || SPRINTF("%0.1f", salh) || " mmhos/cm)"
		ELSE			"Non saline (" || SPRINTF("%0.1f", salh) || " mmhos/cm)".


#SAR
DERIVE sarr	FROM rv USING "NSSC Pangaea":"SODIUM ADSORPTION RATIO MAXIMUM IN DEPTH 0-100cm".
DEFINE sarrcl        IF sarr >= 30 THEN	"Strong sodicity ("|| SPRINTF("%0.f", sarr)||" SAR)"
		ELSE IF sarr >= 13 THEN	"Moderate sodicity ("|| SPRINTF("%0.f", sarr)||" SAR)"
		ELSE IF sarr >= 6 THEN	"Slight sodicity ("|| SPRINTF("%0.f", sarr)||" SAR)"
		ELSE			"Non sodic ("|| SPRINTF("%0.f", sarr)||" SAR)".

DERIVE sarh	FROM high USING "NSSC Pangaea":"SODIUM ADSORPTION RATIO MAXIMUM IN DEPTH 0-100cm".
DEFINE sarhcl        IF sarh >= 30 THEN	   "Strong sodicity ("|| SPRINTF("%0.f", sarh)||" SAR)"
		ELSE IF sarh >= 13 THEN "Moderate sodicity ("|| SPRINTF("%0.f", sarh)||" SAR)"
		ELSE IF sarh >= 6 THEN	   "Slight sodicity ("|| SPRINTF("%0.f", sarh)||" SAR)"
		ELSE			   "Non sodic ("|| SPRINTF("%0.f", sarh)||" SAR)".

#Permeability calculated
DERIVE perm     FROM rv USING "MLRA09_Temple":"KSAT MINIMUM HORIZONS ABOVE FIRST RESTRICTION <60".
DEFINE perm_label	ISNULL(perm) ? "Not specified" :
			perm > 140.999999 ? "Very rapid (Greater than 20 in/hr)" :
			perm > 41.999999  ? "Rapid (6.0 to 20 in/hr)" :
			perm > 13.999999 ? "Moderately rapid (2.0 to 6.0 in/hr)" :
			perm > 3.999999 ? "Moderate (0.6 to 2.0 in/hr)" :
			perm > 1.399999 ? "Moderately slow (0.2 to 0.6 in/hr)" :
			perm > 0.419999 ? "Slow (0.06 to 0.2 in/hr)" :
			perm > 0.009999 ? "Very slow (0.001 to 0.06 in/hr)" :
			perm >= 0.0 ? "Almost impermeable (0.0 to 0.001 in/hr)" : "Error".

			
DERIVE perm2     FROM rv USING "MLRA09_Temple":"KSAT MINIMUM HORIZONS FROM FIRST RESTRICTION <60".
DEFINE perm2_label	ISNULL(perm2) ? "No restrictive layer, so the results above are the most restrictive class" :
			perm > 140.999999 ? "Very rapid (Greater than 20 in/hr)" :
			perm > 41.999999  ? "Rapid (6.0 to 20 in/hr)" :
			perm > 13.999999 ? "Moderately rapid (2.0 to 6.0 in/hr)" :
			perm > 3.999999 ? "Moderate (0.6 to 2.0 in/hr)" :
			perm > 1.399999 ? "Moderately slow (0.2 to 0.6 in/hr)" :
			perm > 0.419999 ? "Slow (0.06 to 0.2 in/hr)" :
			perm > 0.009999 ? "Very slow (0.001 to 0.06 in/hr)" :
			perm >= 0.0 ? "Almost impermeable (0.0 to 0.001 in/hr)" : "Error".

#Shrink-swell

DERIVE ss	FROM rv USING "MLRA09_Temple":"SHRINK-SWELL 25-150cm OR ABOVE Restrictive Layer Wt_Ave.".
DEFINE ss_lab	ss < 3.0 ? "Low." :
		ss >= 3.0 AND ss < 6.0 ? "Moderate." :
		ss >= 6.0 AND ss < 9.0 ? "High." :
		ss >= 9.0 ? "Very high." : "".
DEFINE ssr	IF ISNULL(ss) THEN "Not specified"
		ELSE ss_lab ||" "|| "(" || SPRINTF("%0.1f", ss) || " LEP)". 
        
#CaCO3
DERIVE CaCO3    FROM rv USING "MLRA09_Temple":"CaCO3 MAXIMUM 0-100CM OR FIRST RESTRICTION".
DEFINE CaCO3r     ISNULL(CaCO3) ? "None specified" :
#		CaCO3 == 0 ? "None" : 
		SPRINTF("%0.f percent", CaCO3).	
#Gypsum
DERIVE gyp      FROM rv USING "NSSC Pangaea":"GYPSUM MAXIMUM".
DEFINE gypr     ISNULL(gyp) ? "None specified" :
#		gyp == 0 ? "None" : 
		SPRINTF("%0.f percent", gyp).	
		
#Determine AWC to 60 inches
DERIVE awc_r60 FROM rv USING "MLRA09_Temple": "AVAILABLE WATER CAPACITY 60 INCHES".
DEFINE awc_lab  awc_r60/2.54 < 3.0 ? "Very low" :
		awc_r60/2.54 >= 3.0 and awc_r60/2.54 < 6.0 ? "Low" :
		awc_r60/2.54 >= 6.0 and awc_r60/2.54 < 9.0 ? "Moderate" :
		awc_r60/2.54 >= 9.0 and awc_r60/2.54 < 12.0 ? "High" :
		awc_r60/2.54 >= 12.0 ? "Very high" : "Error".
DEFINE awc_60     IF ISNULL(awc_r60) THEN "Not specified"
		ELSE  awc_lab|| " (About " || SPRINTF("%0.1f", awc_r60/2.54) || " inches)".                       

# Define land capability for irrigated and nonirrigated -- California
DEFINE irrcap           ISNULL(irrcapcl) AND ISNULL(irrcapscl) AND
                            ISNULL(irrcapunit) ? "None specified" :
                        ISNULL(irrcapscl) AND ISNULL(irrcapunit) ? 
                            sprintf ("%s", CODELABEL(irrcapcl)) :
                        ISNULL(irrcapunit) ? sprintf ("%s%s", CODELABEL(irrcapcl),
                            CODELABEL(irrcapscl)) :
                        sprintf ("%s%s-%.f", CODELABEL(irrcapcl),
                            CODELABEL(irrcapscl), irrcapunit).

DEFINE nirrcap          ISNULL(nirrcapcl) AND ISNULL(nirrcapscl) AND
                            ISNULL(nirrcapunit) ? "None specified" :
                        ISNULL(nirrcapscl) AND ISNULL(nirrcapunit) ? 
                            sprintf ("%s", CODELABEL(nirrcapcl)) :
                        ISNULL(nirrcapunit) ? sprintf ("%s%s",
                            CODELABEL(nirrcapcl), CODELABEL(nirrcapscl)) :
                        sprintf ("%s%s-%.f", CODELABEL(nirrcapcl),
                            CODELABEL(nirrcapscl), nirrcapunit).

#Define hydric interp rating
DEFINE hydric              ISNULL(hydricrating) ? "NOT RATED" : CODELABEL(hydricrating).    

DEFINE hydric2             CODELABEL(hydricrating).

#Define hydric interp rating for minor components
DEFINE hydricm              ISNULL(hydricratmin) ? "NOT RATED" : CODELABEL(hydricratmin).    

DEFINE hydric2m             CODELABEL(hydricratmin).

#Typical Profile description
DEFINE hzcolor	  ISNULL(hor_col) ? "" : hor_col. 

DEFINE hzprop	  ISNULL(hor_prop) ? "" : hor_prop. 

DEFINE reaction IF ISNULL(ph1to1h2o_r) or texturename(hztexture) matches "petrocalcic" THEN "" ELSE 
	IF (ph1to1h2o_r) < 3.5 THEN "ultra acid" ELSE	
	IF ((ph1to1h2o_r) > 3.45 and (ph1to1h2o_r) < 4.499) THEN "extremely acid" ELSE
	IF ((ph1to1h2o_r) > 4.45 and (ph1to1h2o_r) < 5.099) THEN "very strongly acid" ELSE
	IF ((ph1to1h2o_r) > 5.05 and (ph1to1h2o_r) < 5.599) THEN "strongly acid" ELSE
	IF ((ph1to1h2o_r) > 5.55 and (ph1to1h2o_r) < 6.099) THEN "moderately acid" ELSE
	IF ((ph1to1h2o_r) > 6.05 and (ph1to1h2o_r) < 6.599) THEN "slightly acid" ELSE
	IF ((ph1to1h2o_r) > 6.55 and (ph1to1h2o_r) < 7.399) THEN "neutral" ELSE
	IF ((ph1to1h2o_r) > 7.35 and (ph1to1h2o_r) < 7.899) THEN "slightly alkaline" ELSE
	IF ((ph1to1h2o_r) > 7.85 and (ph1to1h2o_r) < 8.499) THEN "moderately alkaline" ELSE
	IF ((ph1to1h2o_r) > 8.45 and (ph1to1h2o_r) <= 9.0) THEN "strongly alkaline" ELSE
	IF (ph1to1h2o_r) > 9.0 THEN "very strongly alkaline" ELSE "". 
DEFINE dbldash  "--".
DEFINE cmaspace ", ". 
DEFINE hznm	REGROUP hzname BY chiid AGGREGATE FIRST.
DEFINE hzdt	REGROUP hzdept_r BY chiid AGGREGATE FIRST.
DEFINE hzdb	REGROUP hzdepb_r BY chiid AGGREGATE FIRST.
#DEFINE hzco REGROUP hor_col BY chiid AGGREGATE FIRST.
#DEFINE hzpr REGROUP hor_prop BY chiid AGGREGATE FIRST.
#DEFINE hzcocma  ISNULL(hzco) ? "" : SPRINTF("%s,", hzco).

#DEFINE texgrp TEXTURENAME(hztexture).
ASSIGN hztexture TEXTURENAME(hztexture).
DEFINE texgrp	REGROUP hztexture BY chiid  AGGREGATE LIST ", ".

#Before DEFINE hztbtx   SPRINTF("%s %s %0.f to %0.f inches; %s %s %s %s", hznm, dbldash, hzdt/2.54, hzdb/2.54, hzcocma, reaction, texgrp, hzpr).
DEFINE hztbtx   ISNULL(hzdt) ? "No profile description" : SPRINTF("%s %s %0.f to %0.f inches; %s %s", hznm, dbldash, hzdt/2.54, hzdb/2.54, reaction, texgrp).


# Tidy up text fields
DEFINE composit		ISNULL(compos_note) ? "Estimates are based on field observations, soil descriptions, and or transects of the mapunit" : "Estimates are based on observations, descriptions, and or transects of the mapunit. " || compos_note.
DEFINE majoruses	ISNULL(use_note) ? "" : use_note.
DEFINE pastureland	ISNULL(use2_note) ? "" : use2_note.
DEFINE cropland		ISNULL(use3_note) ? "" : use3_note.
DEFINE rangeland	ISNULL(use4_note) ? "" : use4_note.
DEFINE urban		ISNULL(use5_note) ? "" : use5_note.
DEFINE recreation	ISNULL(use6_note) ? "" : use6_note.
DEFINE wildlife		ISNULL(use7_note) ? "" : use7_note.
DEFINE forestry		ISNULL(use8_note) ? "" : use8_note.

#Text Field Parameters
DEFINE notneednatmusym         natmusympar == 1 ? 1 : "".
#DEFINE notneedlandscape    landscapepar == 1 ? 1 : "".
DEFINE notneedaspectrep    aspectreppar == 1 ? 1 : "".
DEFINE notneedaspectrng    aspectrngpar == 1  ? 1 : "".
#DEFINE notneedlandform     landformpar == 1  ? 1 : "".
DEFINE notneedpos2         pos2dpar == 1  ? 1 : "".
DEFINE notneedpos3         pos3dpar == 1  ? 1 : "".
DEFINE notneedtaxcl        taxclpar == 1  ? 1 : "".
DEFINE notneedshpall       shpallpar == 1  ? 1 : "".
#DEFINE notneedmlra         mlrapar == 1  ? 1 : "".
#DEFINE notneedelev         elevpar == 1 ? 1 : "".
#DEFINE notneedprecip       precippar == 1 ? 1: "".
#DEFINE notneedmaat         maatpar == 1 ? 1: "".
#DEFINE notneedfrost        frostpar == 1 ? 1: "".
DEFINE notneedprime        primepar == 1 ? 1 : "".
#DEFINE notneedecol         ecolpar == 1 ? 1: "".
#DEFINE notneedtypveg       typvegpar == 1 ? 1: "".
DEFINE notneedecr          ecrpar == 1 ? 1: "".
DEFINE notneedech          echpar == 1 ? 1: "".
DEFINE notneedsarr         sarrpar == 1 ? 1: "".
DEFINE notneedsarh         sarhpar == 1 ? 1: "".
DEFINE notneedCaCO3r       CaCO3rpar == 1 ? 1: "".
DEFINE notneedgypr         gyprpar == 1 ? 1: "".
DEFINE notneedpond         pondpar == 1 ? 1: "".
DEFINE notneedwatertab     watertabpar == 1 ? 1: "".
#DEFINE notneedhydric       hydricpar == 1 ? 1 : "".
DEFINE dt TODAY.

# End of Calculations.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#  REPORT FORMATTING SECTION
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PAGE WIDTH UNLIMITED LENGTH UNLIMITED.
#MARGIN LEFT 0 RIGHT 0 TOP 1 BOTTOM 0.
TEMPLATE property WIDTH UNLIMITED
   AT LEFT FIELD, " ", FIELD, FIELD, FIELD, FIELD, FIELD, FIELD, FIELD.

# Print map unit name and setting data

SECTION WHEN FIRST OF musym
    DATA
	AT LEFT "Edited, ", dt WIDTH 20.
	SKIP 1 LINE.
	AT LEFT name WIDTH UNLIMITED.
SKIP 1 LINE.
    IF NOT notneednatmusym AT LEFT "National map unit symbol: ", nationalmusym WIDTH UNLIMITED.
#	AT LEFT "Map unit name: ", muname WIDTH UNLIMITED.
	SKIP 1 LINE.
	AT LEFT "Map Unit Setting".
        SKIP 1 LINE.
#        IF NOT notneedgenloc AT LEFT "General location: ", dmulocation WIDTH UNLIMITED.
#        IF NOT notneedmlra 
AT LEFT "Major land resource area: ", mlras WIDTH UNLIMITED.
#	    IF NOT notneedlandscape 
AT LEFT "Landscape: ", landscape3 WIDTH UNLIMITED.        
#	    IF NOT notneedelev 
    AT LEFT "Elevation: ", elev SIGDIG 3 WIDTH UNLIMITED, elevation SIGDIG 3 WIDTH UNLIMITED.
#	    IF NOT notneedprecip 
    AT LEFT "Mean annual precipitation: ", precip WIDTH UNLIMITED.
#        IF NOT notneedmaat 
    AT LEFT "Mean annual air temperature: ", maat WIDTH UNLIMITED. 
#	    IF NOT notneedfrost 
    AT LEFT "Frost-free period: ", frost WIDTH UNLIMITED.
        IF NOT notneedprime and (farmlndcl != "30" or farmlndcl != "50" or farmlndcl != "70") AT LEFT "Prime Farmland Class: ", prime WIDTH UNLIMITED.	
#       IF NOT notneedmapgeom AT LEFT "Geomorphic setting: ", dgeonote WIDTH UNLIMITED.
#        IF NOT notneednatmusym AT LEFT "National map unit symbol: ", nationalmusym WIDTH UNLIMITED.
	SKIP 1 LINE.
	AT LEFT "Composition estimates".
	SKIP 1 LINE.
	AT LEFT "Major components:".
    AT LEFT composition WIDTH UNLIMITED.
	AT LEFT "Minor components: ", mincomp WIDTH UNLIMITED.
	SKIP 1 LINE.
 #AT LEFT mucsim WIDTH UNLIMITED.
 #AT LEFT mucminor WIDTH UNLIMITED.
    AT LEFT composit WIDTH UNLIMITED.
 SKIP 1 LINE.
END SECTION.

SECTION WHEN FIRST OF musym, majcompflag
 DATA 
 #IF majcompflag == 1 AT LEFT "Component Descriptions".
 IF majcompflag == 1 AT LEFT "Major Component Descriptions".
 IF majcompflag == 1 SKIP 1 LINE.
 IF majcompflag == 0 AT LEFT "Minor Component Descriptions".
 IF majcompflag == 0 SKIP 1 LINE.
END SECTION.

SECTION WHEN majcompflag == 1 NO KEEP
DATA
 AT LEFT compsoi3 WIDTH UNLIMITED.
 SKIP 1 LINE.

 AT LEFT compsoi2 WIDTH UNLIMITED.
 AT LEFT "Percent of map unit: ", compsoipct WIDTH UNLIMITED.
	IF NOT notneedtaxcl AT LEFT "Soil Taxonomic Classification: ", taxclname WIDTH UNLIMITED.
	IF NOT notneedtaxcl AT LEFT "Soil moisture subclass: ", moistsubclass WIDTH UNLIMITED.
	IF NOT notneedtaxcl AT LEFT "Soil moisture class: ", moistclass WIDTH UNLIMITED.
	IF NOT ISNULL(pmtext)
    USING property "Parent material:", pmtext WIDTH UNLIMITED.
#	IF NOT notneedlandform 
AT LEFT "Landforms: ", landform2 WIDTH UNLIMITED.
        IF NOT notneedpos3 and NOT ISNULL(geomcomp2)   
    USING property "Geomorphic positions, three-dimensional:", geomcomp2 WIDTH UNLIMITED.
		IF NOT notneedpos2 and NOT ISNULL(hillslopeprof)
    USING property "Geomorphic positions, two-dimensional:", landformpos WIDTH UNLIMITED.
        IF NOT notneedshpall and NOT ISNULL(shpdown)
    USING property "Down-slope shape:", shpdown2.
        IF NOT notneedshpall and NOT ISNULL(shpacross)
    USING property "Across-slope shape:", shpacross2.
        IF NOT notneedaspectrep and NOT ISNULL(aspect_r)
    USING property "Aspect, representative:", aspect_r WIDTH UNLIMITED.
        IF NOT notneedaspectrng and NOT ISNULL(aspectcwise)
    USING property "Aspect, range:", aspect_range WIDTH UNLIMITED.


	IF comprp_note AT LEFT "Representative profile location: ",	comprp_note WIDTH UNLIMITED.
	SKIP 1 LINE.
# Typical Profile using horizon or pedon data.
	AT LEFT "Typical Profile".
	SKIP 1 LINE.

IF usepedon != 1   AT LEFT hztbtx WIDTH UNLIMITED.
IF usepedon == 1    INCLUDE "SUB-PEDON-Manuscript MUD w/ redox (no codes)" (peiid).

#IF ISNULL (peiid)   AT LEFT hztbtx WIDTH UNLIMITED.
#IF NOT ISNULL (peiid) INCLUDE "SUB-PEDON-Manuscript MUD w/ redox (no codes)" (peiid).
	SKIP 1 LINE.
#        AT LEFT "Note: A complete soil description with range in characteristics is included, in alphabetical order, in the ""Soil Series and Morphology"" section.".
#	SKIP 1 LINE.

# Print name and composition for minor components.

     AT LEFT "Properties and Qualities" WIDTH UNLIMITED.
       SKIP 1 LINE.
     AT LEFT "Slope: ", slope WIDTH UNLIMITED.
     AT LEFT "Percent of area covered by surface fragments: ", surface_frags WIDTH UNLIMITED.
	 AT LEFT "Depth range to first water and root restrictive layer: ", restrict WIDTH UNLIMITED.
     AT LEFT "Slowest soil permeability to 60 inches, above first water and root restrictive layer: ", perm_label WIDTH UNLIMITED.
     AT LEFT "Slowest permeability from first water and root restrictive layer to 60 inches: ", perm2_label WIDTH UNLIMITED.
	 IF NOT notneedwatertab AT LEFT "Depth to seasonal high water table, minimum: ", wtr2 WIDTH UNLIMITED.
	 IF alter_hyd AT LEFT "Altered Hydrology: ", alter_hyd WIDTH UNLIMITED.
	 AT LEFT "Representative total available water capacity to 60 inches: ", awc_60 WIDTH UNLIMITED.
	 AT LEFT "Natural drainage class: ", drainage WIDTH UNLIMITED.
	 AT LEFT "Runoff class: ", runoff_class WIDTH UNLIMITED.
     AT LEFT "Flooding frequency: ", flood WIDTH UNLIMITED.
	 IF NOT notneedpond AT LEFT "Ponding frequency: ", pond WIDTH UNLIMITED.
     AT LEFT "Shrink-swell potential, weighted average of representative value linear extensibility percentage (LEP) in 10 to 60 inches: " , ssr WIDTH UNLIMITED.
     IF NOT notneedecr AT LEFT "Salinity class and maximum representative value within 40 inches: ", salrcl WIDTH UNLIMITED.
     IF NOT notneedech AT LEFT "Salinity class and maximum high value within 40 inches: ", salhcl WIDTH UNLIMITED.
	 IF NOT notneedsarr AT LEFT "Sodicity class and sodium adsorption ratio(SAR) maximum representative value within 40 inches: ", sarrcl WIDTH UNLIMITED.
	 IF NOT notneedsarh AT LEFT "Sodicity class and sodium adsorption ratio(SAR) maximum high value within 40 inches: ", sarhcl WIDTH UNLIMITED.
	 IF NOT notneedCaCO3r AT LEFT "Calcium Carbonate Equivalent, maximum representative value within 40 inches: ", CaCO3r WIDTH UNLIMITED.
	 IF NOT notneedgypr AT LEFT "Gypsum, maximum representative value in the soil profile: ", gypr WIDTH UNLIMITED.
        SKIP 1 LINE.

	AT LEFT "Interpretive Groups" WIDTH UNLIMITED.
	SKIP 1 LINE.
	AT LEFT "Land capability subclass, nonirrigated: ", nirrcap WIDTH UNLIMITED.
	AT LEFT "Land capability subclass, irrigated: ", irrcap WIDTH UNLIMITED. 
#	IF NOT notneedecol 
AT LEFT "Ecological site name: ", ecosysnm WIDTH UNLIMITED.
#	IF NOT notneedecol 
AT LEFT "Ecological site number: ", ecoid_nu WIDTH UNLIMITED.
#	IF NOT notneedtypveg 
AT LEFT "Typical vegetation: ", typ2_veg WIDTH UNLIMITED.
#	IF NOT notneedhydric AT LEFT "Hydric soil rating: ", hydric WIDTH UNLIMITED.
	SKIP 1 LINE.
END SECTION.

SECTION WHEN majcompflag == 0
 DATA 
 AT LEFT compsoi2 WIDTH UNLIMITED.
 AT LEFT "Percent of map unit: ", compsoipct WIDTH UNLIMITED.
IF NOT notneedtaxcl AT LEFT "Soil Taxonomic Classification: ", taxclname WIDTH UNLIMITED.
	IF NOT notneedtaxcl AT LEFT "Soil moisture subclass: ", moistsubclass WIDTH UNLIMITED.
	IF NOT notneedtaxcl AT LEFT "Soil moisture class: ", moistclass WIDTH UNLIMITED.
	IF NOT ISNULL(pmtext)
    USING property "Parent material:", pmtext WIDTH UNLIMITED.
IF NOT ISNULL(geonm_lf)
    USING property "Landforms:", landform2 WIDTH UNLIMITED.
  IF NOT ISNULL(geomcomp2)   
    USING property "Geomorphic positions, three-dimensional: ", geomcomp2 WIDTH UNLIMITED.
  IF NOT ISNULL(hillslopeprof)
    USING property "Geomorphic positions, two-dimensional: ", landformpos WIDTH UNLIMITED.
  IF NOT ISNULL(shpdown)
    USING property "Down-slope shape:", shpdown2.
  IF NOT ISNULL(shpacross)
    USING property "Across-slope shape:", shpacross2.
  AT LEFT "Aspect, representative: ", aspect_r WIDTH UNLIMITED.
  IF NOT ISNULL(aspectcwise)
    USING property "Aspect, range: ", aspect_range WIDTH UNLIMITED.
AT LEFT "Slope: ", slp WIDTH UNLIMITED.
#  IF NOT notneedhydric AT LEFT "Hydric soil rating: " , hydricm WIDTH UNLIMITED.
 SKIP 1 LINE.
END SECTION.

# Ending of mapunit: print notes on use and management and references.

SECTION WHEN last of musym NO KEEP
    DATA
	AT LEFT "Note: Additional information specific to the components of this map unit is available in the Tables section.".
        SKIP 1 LINE.
	AT LEFT "Use and Management".
	SKIP 1 LINE.
	IF majoruses AT LEFT "Major land uses: ", majoruses WIDTH UNLIMITED.
	IF majoruses SKIP 1 LINE.
	IF cropland AT LEFT "Cropland: ", cropland WIDTH UNLIMITED.
	IF cropland SKIP 1 LINE.	
	IF pastureland AT LEFT "Pastureland: ", pastureland WIDTH UNLIMITED.
	IF pastureland SKIP 1 LINE.	IF rangeland AT LEFT "Rangeland: ", rangeland WIDTH UNLIMITED.
	IF rangeland SKIP 1 LINE.	
	IF urban AT LEFT "Urban Development: ", urban WIDTH UNLIMITED.
	IF urban SKIP 1 LINE.	
	IF recreation AT LEFT "Recreational Development: ", recreation WIDTH UNLIMITED.
        IF recreation SKIP 1 LINE.	
	IF wildlife AT LEFT "Wildlife Habitat: ", wildlife WIDTH UNLIMITED.
        IF wildlife SKIP 1 LINE.
	IF forestry AT LEFT "Forestry: ", forestry WIDTH UNLIMITED.
        IF forestry SKIP 1 LINE.
    SKIP 1 LINE.
#	AT LEFT "Other Concept Notes:" WIDTH UNLIMITED.
	AT LEFT "Note: For more information about managing this map unit, see the section on ""Soil Properties"", and the section on ""Use and Management"" which includes subsections on ""Crops and Pasture"", ""Engineering"", ""Forest Management and Productivity"", ""Rangeland"", ""Recreation"", and ""Wildlife Habitat"".".
	SKIP 1 LINE.
END SECTION.