SELECT
laoverlap.areasymbol AS 'State_County_ID'
, legend.areasymbol AS 'Soil_Survey_Area_ID'
, laoverlap.areaname
, mapunit.mukey
, mapunit.musym
, mapunit.muname
, c.compname
, c.cokey
, case 
WHEN laoverlap.areasymbol = 'AL001' THEN 'Y' 
WHEN laoverlap.areasymbol = 'AL003' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL005' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL007' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL009' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL011' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL013' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL015' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL017' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL019' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL021' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL023' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL025' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL027' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL029' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL031' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL035' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL037' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL039' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL041' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL043' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL045' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL047' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL051' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL053' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL055' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL057' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL061' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL067' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL069' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL073' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL081' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL085' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL087' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL091' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL097' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL099' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL101' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL105' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL109' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL111' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL113' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL115' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL117' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL119' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL121' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL123' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL125' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL127' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL129' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL131' THEN 'Y'
WHEN laoverlap.areasymbol = 'AL133' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL001' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL003' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL005' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL007' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL009' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL013' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL017' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL019' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL023' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL027' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL029' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL031' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL033' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL035' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL037' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL039' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL041' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL043' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL045' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL047' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL049' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL053' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL055' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL057' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL059' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL061' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL063' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL065' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL067' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL069' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL073' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL075' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL077' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL079' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL081' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL083' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL089' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL091' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL093' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL095' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL097' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL101' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL103' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL105' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL107' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL109' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL111' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL113' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL115' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL117' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL119' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL121' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL123' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL125' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL127' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL129' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL131' THEN 'Y'
WHEN laoverlap.areasymbol = 'FL133' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA001' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA003' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA005' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA007' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA009' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA015' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA017' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA019' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA021' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA023' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA025' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA027' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA029' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA031' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA033' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA037' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA039' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA043' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA045' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA049' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA051' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA053' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA055' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA061' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA065' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA067' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA069' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA071' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA073' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA075' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA077' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA079' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA081' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA087' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA091' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA093' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA095' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA097' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA099' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA101' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA103' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA107' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA109' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA113' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA115' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA121' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA125' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA127' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA131' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA141' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA143' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA145' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA149' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA153' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA155' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA161' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA163' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA165' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA167' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA169' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA173' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA175' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA177' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA179' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA181' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA183' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA185' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA189' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA191' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA193' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA197' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA199' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA201' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA205' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA207' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA209' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA215' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA223' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA225' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA229' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA231' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA233' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA235' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA237' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA239' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA243' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA245' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA249' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA251' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA253' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA259' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA261' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA263' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA267' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA269' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA271' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA273' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA275' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA277' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA279' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA283' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA285' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA287' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA289' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA293' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA299' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA301' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA303' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA305' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA307' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA309' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA315' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA319' THEN 'Y'
WHEN laoverlap.areasymbol = 'GA321' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA001' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA003' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA009' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA011' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA013' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA019' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA021' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA025' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA033' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA037' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA039' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA043' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA049' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA053' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA059' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA063' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA069' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA079' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA085' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA091' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA103' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA105' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA115' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA117' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA125' THEN 'Y'
WHEN laoverlap.areasymbol = 'LA127' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS001' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS005' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS007' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS021' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS023' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS029' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS031' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS035' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS037' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS039' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS041' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS045' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS047' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS049' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS059' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS061' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS063' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS065' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS067' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS069' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS073' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS075' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS077' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS079' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS085' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS089' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS091' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS101' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS109' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS111' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS113' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS121' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS123' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS127' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS129' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS131' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS147' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS153' THEN 'Y'
WHEN laoverlap.areasymbol = 'MS157' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC007' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC013' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC015' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC017' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC019' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC029' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC031' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC041' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC047' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC049' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC051' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC061' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC065' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC073' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC079' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC083' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC085' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC091' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC093' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC101' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC103' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC105' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC107' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC117' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC123' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC125' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC127' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC129' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC131' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC133' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC137' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC139' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC141' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC143' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC147' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC153' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC155' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC163' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC165' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC187' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC191' THEN 'Y'
WHEN laoverlap.areasymbol = 'NC195' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC003' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC005' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC009' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC011' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC013' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC015' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC017' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC019' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC025' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC027' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC029' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC031' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC033' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC035' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC037' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC039' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC041' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC043' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC047' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC049' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC051' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC053' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC055' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC057' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC061' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC063' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC065' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC067' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC069' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC071' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC075' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC079' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC081' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC085' THEN 'Y'
WHEN laoverlap.areasymbol = 'SC089' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX005' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX199' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX241' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX245' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX291' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX347' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX351' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX361' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX373' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX403' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX405' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX419' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX455' THEN 'Y'
WHEN laoverlap.areasymbol = 'TX457' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA001' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA007' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA025' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA036' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA041' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA653' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA073' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA081' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA093' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA751' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA085' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA087' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA093' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA695' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA101' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA097' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA111' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA115' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA117' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA119' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA715' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA127' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA131' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA715' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA735' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA715' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA145' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA149' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA175' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA800' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA183' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA181' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA810' THEN 'Y'
WHEN laoverlap.areasymbol = 'VA695' THEN 'Y' else 'N' END  as mu_lleaf
, (select TOP 1 cotreestomng.plantsym from cotreestomng where c.cokey=cotreestomng.cokey and cotreestomng.plantsym = 'PIPA2') AS llpine_cotreestomng 
, (select TOP 1 coeplants.plantsym from coeplants where c.cokey=coeplants.cokey and coeplants.plantsym = 'PIPA2') as llpine_coeplants 
, (select TOP 1 coforprod.plantsym from coforprod where c.cokey=coforprod.cokey and coforprod.plantsym = 'PIPA2') AS llpine_coforprod
, (SELECT CASE when min(soimoistdept_r) is null then '999' else cast(min(soimoistdept_r) as varchar) END
          from component left outer join comonth left outer join cosoilmoist
            on comonth.comonthkey = cosoilmoist.comonthkey
            on component.cokey = comonth.cokey
         where component.cokey = c.cokey and soimoiststat in ('Wet', 'Saturation')) as llp_wt
, case when exists (select texture FROM component inner join chorizon on c.cokey=chorizon.cokey inner join chtexturegrp on chorizon.chkey=chtexturegrp.chkey WHERE texture IN ('COS', 'FS', 'VFS', 'LCOS', 'LS', 'LFS', 'LVFS', 'COSL', 'SL', 'FSL', 'VFSL') and hzdept_r <30) Then 'Y' ELSE 'N' END as llp_texture
, case when exists (select ph1to1h2o_r FROM component inner join chorizon on c.cokey=chorizon.cokey WHERE ph1to1h2o_r > 6 and hzdept_r <30) Then 'N' ELSE 'Y' END as llp_pH
, cast (case WHEN taxorder like 'Histosols' Then 1 
WHEN hydgrp like '%D'  Then 1 
WHEN hydgrp like 'C' And ((om_r * hzdepb_r/2.54) <= 10) And kwfact >= .28 Then 1 
WHEN hydgrp like 'C' And ((om_r * hzdepb_r/2.54) >= 10) Then 1 
WHEN hydgrp like 'B' And ((om_r * hzdepb_r/2.54) >= 35) And kwfact >= .40 Then 1 
WHEN hydgrp like 'B' And ((om_r * hzdepb_r/2.54) >= 45) And kwfact >= .20 Then 1 
WHEN hydgrp like 'A' and ((om_r * hzdepb_r/2.54) <= 30) Then 3 
WHEN hydgrp like 'B' and ((om_r * hzdepb_r/2.54) <= 9) and kwfact <= .48  Then 3 
WHEN hydgrp like 'B' And ((om_r * hzdepb_r/2.54) <= 15) And kwfact <= .26 Then 3 
WHEN hydgrp like 'A' And ((om_r * hzdepb_r/2.54) > 30)  Then 2 
WHEN hydgrp like 'B'  Then 2 
WHEN hydgrp like 'C' Then 2 ELSE 0 END as varchar) as mu_leach 
, c.wei AS mu_ifactor 
, case when ch.kffact is null then 0.02 else ch.kffact END AS mu_kfactor 
, case when legend.areasymbol IN ('ID607', 'ID610', 'OR021', 'OR049', 'OR055', 'OR625', 'OR667', 
'OR670','OR673', 'WA001', 'WA021', 'WA025', 'WA043', 'WA063', 'WA071', 'WA075', 'WA603', 'WA605',
'WA613', 'WA617', 'WA623', 'WA639', 'WA676', 'WA677') then 'Y' else 'N' END as palouse 
, c.tfact AS mu_tfactor 
, c.slope_r 
, c.slopelenusle_r 
, case when (map_l < 382 and wei > 55 and  claytotal_r < 21 and om_r < 3 and texcl not like '%sand' 
and left(legend.areasymbol,2) IN ('WA', 'OR', 'CA', 'ID') ) then 'Y' else 'N' END as WESL 
, case when nirrcapscl is null then nirrcapcl else nirrcapcl + nirrcapscl end as nirrcapclass 
, 'SDM' as source 
, 
(SELECT TOP 1 ROUND (AVG(interphr) over(partition by interphrc),2)
FROM mapunit  AS m1
INNER JOIN component ON component.mukey=m1.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND m1.mukey = mapunit.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)' GROUP BY interphrc, interphr,comppct_r
ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as NCCPI_Value_dcp ,
(SELECT TOP 1 interphrc
FROM mapunit AS m2
INNER JOIN component ON component.mukey=m2.mukey
INNER JOIN cointerp ON component.cokey = cointerp.cokey AND m2.mukey = mapunit.mukey AND ruledepth = 0 AND mrulename LIKE 'Commodity Crop Productivity Index (Corn) (TN)' 
GROUP BY interphrc, comppct_r 
ORDER BY SUM(comppct_r) over(partition by interphrc) DESC) as NCCPI_Class_dcp 



--(SELECT interphr FROM component left outer join cointerp ON component.cokey = cointerp.cokey 
--WHERE component.cokey=c.cokey and ruledepth = 0 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)') as NCCPI_Value_dcp ,
--(SELECT interphrc FROM component left outer join cointerp ON component.cokey = cointerp.cokey 
--WHERE component.cokey=c.cokey and ruledepth = 0 AND mrulename like 'NCCPI - National Commodity Crop Productivity Index (Ver 2.0)') as NCCPI_Class_dcp 
INTO #step1 
FROM (mapunit INNER JOIN ((legend INNER JOIN laoverlap ON legend.lkey = laoverlap.lkey and 
laoverlap.areatypename ='County Or Parish' and LEFT (legend.areasymbol,2) = 'TN')  
INNER JOIN muaoverlap ON laoverlap.lareaovkey = muaoverlap.lareaovkey) ON mapunit.mukey = 
muaoverlap.mukey)
INNER JOIN component c ON mapunit.mukey = c.mukey and c.cokey = (SELECT TOP 1 component.cokey FROM 
component WHERE component.mukey=mapunit.mukey ORDER BY component.comppct_r DESC) 
INNER JOIN chorizon ch ON c.cokey=ch.cokey and  hzdept_r = (select MIN(hzdept_r) FROM chorizon WHERE 
hzname != 'O%' and c.cokey = ch.cokey )
INNER JOIN chtexturegrp on ch.chkey=chtexturegrp.chkey and rvindicator = 'yes' 
INNER JOIN chtexture on chtexture.chtgkey=chtexturegrp.chtgkey
ORDER BY laoverlap.areasymbol, mapunit.musym, c.comppct_r DESC

SELECT
 cokey
, case 
--WHEN mu_lleaf like 'Y' 
--     and llpine_cotreestomng is null 
--     and llpine_coeplants is null 
--     and llpine_coforprod is null THEN 'N'
WHEN mu_lleaf like 'Y' 
     and llpine_cotreestomng is null  
     and llpine_coeplants is null  
     and llpine_coforprod is null  
     and llp_wt > 30 
     and llp_texture like 'N' 
     and llp_pH like 'Y' THEN 'N'
WHEN mu_lleaf like 'Y' 
     and llpine_cotreestomng is null  
     and llpine_coeplants is null 
     and llpine_coforprod is null  
     and llp_wt > 30 
     and llp_texture like 'Y' 
     and llp_pH like 'N' THEN 'N'
WHEN mu_lleaf like 'Y' 
     and llpine_cotreestomng is null 
     and llpine_coeplants is null  
     and llpine_coforprod is null  
     and llp_wt > 30 
     and llp_texture like 'Y' 
     and llp_pH like 'Y' THEN 'Y' 
WHEN mu_lleaf like 'Y' 
     and llpine_cotreestomng is null  
     and llpine_coeplants is null  
     and llpine_coforprod is null  
     and llp_wt < 30 
     and llp_texture like 'Y' 
     and llp_pH like 'N' THEN 'N'
WHEN mu_lleaf like 'Y' 
     and llpine_cotreestomng is null  
     and llpine_coeplants is null  
     and llpine_coforprod is null  
     and llp_wt < 30 
     and llp_texture like 'N' 
     and llp_pH like 'Y' THEN 'N'
WHEN mu_lleaf like 'Y' 
     and (llpine_cotreestomng is not null or llpine_coeplants is not null  or llpine_coforprod is not null) THEN 'Y'
ELSE 'N' END as llpine
, cast(case 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 0 and slope_r < 0.75) Then 100 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 0.75 and slope_r < 1.5) Then 200 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 1.5 and slope_r < 2.5) Then 300 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 2.5 and slope_r < 3.5) Then 200 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 3.5 and slope_r < 4.5) Then 180 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 4.5 and slope_r < 5.5) Then 160 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 5.5 and slope_r < 6.5) Then 150 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 6.5 and slope_r < 7.5) Then 140 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 7.5 and slope_r < 8.5) Then 130 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 8.5 and slope_r < 9.5) Then 125 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 9.5 and slope_r < 10.5) Then 120 
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 10.5 and slope_r < 11.5) Then 110
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 11.5 and slope_r < 12.5) Then 100
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 12.5 and slope_r < 13.5) Then 90
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 13.5 and slope_r < 14.5) Then 80
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 14.5 and slope_r < 15.5) Then 70
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >= 15.5 and slope_r < 17.5) Then 60
WHEN palouse like 'N' and slopelenusle_r is null and (slope_r >=  17.5) Then 50 
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 0 and slope_r < 5.5) Then 350 
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 5.5 and slope_r < 10.5) Then 275
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 10.5 and slope_r < 15.5) Then 225
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 15.5 and slope_r < 20.5) Then 175
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 20.5 and slope_r < 25.5) Then 150
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 25.5 and slope_r < 35.5) Then 125
WHEN palouse like 'Y' and slopelenusle_r is null and (slope_r >= 35.5)  Then 100 Else slopelenusle_r 
* 3.28  END as int) as rvslopelenusle 
, slope_r
INTO #step2 
FROM #step1

SELECT
#step2.cokey
, llpine
, case 
WHEN rvslopelenusle < 4.5 Then 1
WHEN rvslopelenusle >= 4.5 And rvslopelenusle < 7.5 Then 2 
WHEN rvslopelenusle >= 7.5 And rvslopelenusle < 10.5 Then 3 
WHEN rvslopelenusle >= 10.5 And rvslopelenusle < 13.5 Then 4 
WHEN rvslopelenusle >= 13.5 And rvslopelenusle < 20 Then 5 
WHEN rvslopelenusle >= 20 And rvslopelenusle < 37.5 Then 6 
WHEN rvslopelenusle >= 37.5 And rvslopelenusle < 62.5 Then 7 
WHEN rvslopelenusle >= 62.6 And rvslopelenusle < 87.5 Then 8 
WHEN rvslopelenusle >= 87.5 And rvslopelenusle < 125 Then 9 
WHEN rvslopelenusle >= 125 And rvslopelenusle < 175 Then 10 
WHEN rvslopelenusle >= 175 And rvslopelenusle < 225 Then 11 
WHEN rvslopelenusle >= 225 And rvslopelenusle < 275 Then 12 
WHEN rvslopelenusle >= 275 And rvslopelenusle < 350 Then 13 
WHEN rvslopelenusle >= 350 And rvslopelenusle < 500 Then 14 
WHEN rvslopelenusle >= 500 And rvslopelenusle < 700 Then 15 
WHEN rvslopelenusle >= 700 And rvslopelenusle < 900 Then 16 Else 17 END as columnx 
, case 
WHEN slope_r < 0.35 Then 1 
WHEN slope_r >= 45 And slope_r < 55 Then 18 
WHEN slope_r >= 35 And slope_r < 45 Then 17 
WHEN slope_r >= 27.5 And slope_r < 35 Then 16 
WHEN slope_r >= 22.5 And slope_r < 27.5 Then 15 
WHEN slope_r >= 18.0 And slope_r < 22.5 Then 14 
WHEN slope_r >= 15.0 And slope_r < 18 Then 13 
WHEN slope_r >= 13.0 And slope_r < 15 Then 12 
WHEN slope_r >= 11.0 And slope_r < 13 Then 11 
WHEN slope_r >= 9.0 And slope_r < 11 Then 10 
WHEN slope_r >= 7.0 And slope_r < 9 Then 9 
WHEN slope_r >= 5.5 And slope_r < 7 Then 8 
WHEN slope_r >= 4.5 And slope_r < 5.5 Then 7 
WHEN slope_r >= 3.5 And slope_r < 4.5 Then 6 
WHEN slope_r >= 2.5 And slope_r < 3.5 Then 5 
WHEN slope_r >= 1.5 And slope_r < 2.5 Then 4 
WHEN slope_r >= 0.75 And slope_r < 1.5 Then 3 
WHEN slope_r >= 0.35 And slope_r < 0.75 Then 2 Else 19 END as row 
INTO #step3 
FROM #step2


SELECT
#step3.cokey
, llpine
, case 
WHEN row = 1 and columnx = 1 then 0.05 
WHEN row = 1 and columnx = 2 then 0.05 
WHEN row = 1 and columnx = 3 then 0.05 
WHEN row = 1 and columnx = 4 then 0.05 
WHEN row = 1 and columnx = 5 then 0.05 
WHEN row = 1 and columnx = 6 then 0.05 
WHEN row = 1 and columnx = 7 then 0.05 
WHEN row = 1 and columnx = 8 then 0.05 
WHEN row = 1 and columnx = 9 then 0.05 
WHEN row = 1 and columnx = 10 then 0.05 
WHEN row = 1 and columnx = 11 then 0.05 
WHEN row = 1 and columnx = 12 then 0.05 
WHEN row = 1 and columnx = 13 then 0.05 
WHEN row = 1 and columnx = 14 then 0.06 
WHEN row = 1 and columnx = 15 then 0.06 
WHEN row = 1 and columnx = 16 then 0.06 
WHEN row = 1 and columnx = 17 then 0.06 
WHEN row = 2 and columnx = 1 then 0.07 
WHEN row = 2 and columnx = 2 then 0.07 
WHEN row = 2 and columnx = 3 then 0.07 
WHEN row = 2 and columnx = 4 then 0.07 
WHEN row = 2 and columnx = 5 then 0.07 
WHEN row = 2 and columnx = 6 then 0.08 
WHEN row = 2 and columnx = 7 then 0.08 
WHEN row = 2 and columnx = 8 then 0.08 
WHEN row = 2 and columnx = 9 then 0.09 
WHEN row = 2 and columnx = 10 then 0.09 
WHEN row = 2 and columnx = 11 then 0.09 
WHEN row = 2 and columnx = 12 then 0.09 
WHEN row = 2 and columnx = 13 then 0.09 
WHEN row = 2 and columnx = 14 then 0.1 
WHEN row = 2 and columnx = 15 then 0.1 
WHEN row = 2 and columnx = 16 then 0.1 
WHEN row = 2 and columnx = 17 then 0.1 
WHEN row = 3 and columnx = 1 then 0.11 
WHEN row = 3 and columnx = 2 then 0.11 
WHEN row = 3 and columnx = 3 then 0.11 
WHEN row = 3 and columnx = 4 then 0.11 
WHEN row = 3 and columnx = 5 then 0.11 
WHEN row = 3 and columnx = 6 then 0.12 
WHEN row = 3 and columnx = 7 then 0.13 
WHEN row = 3 and columnx = 8 then 0.14 
WHEN row = 3 and columnx = 9 then 0.14 
WHEN row = 3 and columnx = 10 then 0.15 
WHEN row = 3 and columnx = 11 then 0.16 
WHEN row = 3 and columnx = 12 then 0.17 
WHEN row = 3 and columnx = 13 then 0.17 
WHEN row = 3 and columnx = 14 then 0.18 
WHEN row = 3 and columnx = 15 then 0.19 
WHEN row = 3 and columnx = 16 then 0.2 
WHEN row = 3 and columnx = 17 then 0.2 
WHEN row = 4 and columnx = 1 then 0.17 
WHEN row = 4 and columnx = 2 then 0.17 
WHEN row = 4 and columnx = 3 then 0.17 
WHEN row = 4 and columnx = 4 then 0.17 
WHEN row = 4 and columnx = 5 then 0.17 
WHEN row = 4 and columnx = 6 then 0.19 
WHEN row = 4 and columnx = 7 then 0.22 
WHEN row = 4 and columnx = 8 then 0.25 
WHEN row = 4 and columnx = 9 then 0.27 
WHEN row = 4 and columnx = 10 then 0.29 
WHEN row = 4 and columnx = 11 then 0.31 
WHEN row = 4 and columnx = 12 then 0.33 
WHEN row = 4 and columnx = 13 then 0.35 
WHEN row = 4 and columnx = 14 then 0.37 
WHEN row = 4 and columnx = 15 then 0.41 
WHEN row = 4 and columnx = 16 then 0.44 
WHEN row = 4 and columnx = 17 then 0.47 
WHEN row = 5 and columnx = 1 then 0.22 
WHEN row = 5 and columnx = 2 then 0.22 
WHEN row = 5 and columnx = 3 then 0.22 
WHEN row = 5 and columnx = 4 then 0.22 
WHEN row = 5 and columnx = 5 then 0.22 
WHEN row = 5 and columnx = 6 then 0.25 
WHEN row = 5 and columnx = 7 then 0.32 
WHEN row = 5 and columnx = 8 then 0.36 
WHEN row = 5 and columnx = 9 then 0.39 
WHEN row = 5 and columnx = 10 then 0.44 
WHEN row = 5 and columnx = 11 then 0.48 
WHEN row = 5 and columnx = 12 then 0.52 
WHEN row = 5 and columnx = 13 then 0.55 
WHEN row = 5 and columnx = 14 then 0.6 
WHEN row = 5 and columnx = 15 then 0.68 
WHEN row = 5 and columnx = 16 then 0.75 
WHEN row = 5 and columnx = 17 then 0.8 
WHEN row = 6 and columnx = 1 then 0.26 
WHEN row = 6 and columnx = 2 then 0.26 
WHEN row = 6 and columnx = 3 then 0.26 
WHEN row = 6 and columnx = 4 then 0.26 
WHEN row = 6 and columnx = 5 then 0.26 
WHEN row = 6 and columnx = 6 then 0.31 
WHEN row = 6 and columnx = 7 then 0.4 
WHEN row = 6 and columnx = 8 then 0.47 
WHEN row = 6 and columnx = 9 then 0.52 
WHEN row = 6 and columnx = 10 then 0.6 
WHEN row = 6 and columnx = 11 then 0.67 
WHEN row = 6 and columnx = 12 then 0.72 
WHEN row = 6 and columnx = 13 then 0.77 
WHEN row = 6 and columnx = 14 then 0.86 
WHEN row = 6 and columnx = 15 then 0.99 
WHEN row = 6 and columnx = 16 then 1.1 
WHEN row = 6 and columnx = 17 then 1.19 
WHEN row = 7 and columnx = 1 then 0.3 
WHEN row = 7 and columnx = 2 then 0.3 
WHEN row = 7 and columnx = 3 then 0.3 
WHEN row = 7 and columnx = 4 then 0.3 
WHEN row = 7 and columnx = 5 then 0.3 
WHEN row = 7 and columnx = 6 then 0.37 
WHEN row = 7 and columnx = 7 then 0.49 
WHEN row = 7 and columnx = 8 then 0.58 
WHEN row = 7 and columnx = 9 then 0.65 
WHEN row = 7 and columnx = 10 then 0.76 
WHEN row = 7 and columnx = 11 then 0.85 
WHEN row = 7 and columnx = 12 then 0.93 
WHEN row = 7 and columnx = 13 then 1.01 
WHEN row = 7 and columnx = 14 then 1.13 
WHEN row = 7 and columnx = 15 then 1.33 
WHEN row = 7 and columnx = 16 then 1.49 
WHEN row = 7 and columnx = 17 then 1.63 
WHEN row = 8 and columnx = 1 then 0.34 
WHEN row = 8 and columnx = 2 then 0.34 
WHEN row = 8 and columnx = 3 then 0.34 
WHEN row = 8 and columnx = 4 then 0.34 
WHEN row = 8 and columnx = 5 then 0.34 
WHEN row = 8 and columnx = 6 then 0.43 
WHEN row = 8 and columnx = 7 then 0.58 
WHEN row = 8 and columnx = 8 then 0.69 
WHEN row = 8 and columnx = 9 then 0.78 
WHEN row = 8 and columnx = 10 then 0.93 
WHEN row = 8 and columnx = 11 then 1.05 
WHEN row = 8 and columnx = 12 then 1.16 
WHEN row = 8 and columnx = 13 then 1.25 
WHEN row = 8 and columnx = 14 then 1.42 
WHEN row = 8 and columnx = 15 then 1.69 
WHEN row = 8 and columnx = 16 then 1.91 
WHEN row = 8 and columnx = 17 then 2.11 
WHEN row = 9 and columnx = 1 then 0.42 
WHEN row = 9 and columnx = 2 then 0.42 
WHEN row = 9 and columnx = 3 then 0.42 
WHEN row = 9 and columnx = 4 then 0.42 
WHEN row = 9 and columnx = 5 then 0.42 
WHEN row = 9 and columnx = 6 then 0.53 
WHEN row = 9 and columnx = 7 then 0.74 
WHEN row = 9 and columnx = 8 then 0.91 
WHEN row = 9 and columnx = 9 then 1.04 
WHEN row = 9 and columnx = 10 then 1.26 
WHEN row = 9 and columnx = 11 then 1.45 
WHEN row = 9 and columnx = 12 then 1.62 
WHEN row = 9 and columnx = 13 then 1.77 
WHEN row = 9 and columnx = 14 then 2.03 
WHEN row = 9 and columnx = 15 then 2.47 
WHEN row = 9 and columnx = 16 then 2.83 
WHEN row = 9 and columnx = 17 then 3.15 
WHEN row = 10 and columnx = 1 then 0.46 
WHEN row = 10 and columnx = 2 then 0.48 
WHEN row = 10 and columnx = 3 then 0.5 
WHEN row = 10 and columnx = 4 then 0.51 
WHEN row = 10 and columnx = 5 then 0.52 
WHEN row = 10 and columnx = 6 then 0.67 
WHEN row = 10 and columnx = 7 then 0.97 
WHEN row = 10 and columnx = 8 then 1.19 
WHEN row = 10 and columnx = 9 then 1.38 
WHEN row = 10 and columnx = 10 then 1.71 
WHEN row = 10 and columnx = 11 then 1.98 
WHEN row = 10 and columnx = 12 then 2.22 
WHEN row = 10 and columnx = 13 then 2.44 
WHEN row = 10 and columnx = 14 then 2.84 
WHEN row = 10 and columnx = 15 then 3.5 
WHEN row = 10 and columnx = 16 then 4.06 
WHEN row = 10 and columnx = 17 then 4.56 
WHEN row = 11 and columnx = 1 then 0.47 
WHEN row = 11 and columnx = 2 then 0.53 
WHEN row = 11 and columnx = 3 then 0.58 
WHEN row = 11 and columnx = 4 then 0.61 
WHEN row = 11 and columnx = 5 then 0.64 
WHEN row = 11 and columnx = 6 then 0.84 
WHEN row = 11 and columnx = 7 then 1.23 
WHEN row = 11 and columnx = 8 then 1.53 
WHEN row = 11 and columnx = 9 then 1.79 
WHEN row = 11 and columnx = 10 then 2.23 
WHEN row = 11 and columnx = 11 then 2.61 
WHEN row = 11 and columnx = 12 then 2.95 
WHEN row = 11 and columnx = 13 then 3.26 
WHEN row = 11 and columnx = 14 then 3.81 
WHEN row = 11 and columnx = 15 then 4.75 
WHEN row = 11 and columnx = 16 then 5.56 
WHEN row = 11 and columnx = 17 then 6.28 
WHEN row = 12 and columnx = 1 then 0.48 
WHEN row = 12 and columnx = 2 then 0.58 
WHEN row = 12 and columnx = 3 then 0.65 
WHEN row = 12 and columnx = 4 then 0.7 
WHEN row = 12 and columnx = 5 then 0.75 
WHEN row = 12 and columnx = 6 then 1 
WHEN row = 12 and columnx = 7 then 1.48 
WHEN row = 12 and columnx = 8 then 1.86 
WHEN row = 12 and columnx = 9 then 2.19 
WHEN row = 12 and columnx = 10 then 2.76 
WHEN row = 12 and columnx = 11 then 3.25 
WHEN row = 12 and columnx = 12 then 3.69 
WHEN row = 12 and columnx = 13 then 4.09 
WHEN row = 12 and columnx = 14 then 4.82 
WHEN row = 12 and columnx = 15 then 6.07 
WHEN row = 12 and columnx = 16 then 7.15 
WHEN row = 12 and columnx = 17 then 8.11 
WHEN row = 13 and columnx = 1 then 0.49 
WHEN row = 13 and columnx = 2 then 0.63 
WHEN row = 13 and columnx = 3 then 0.72 
WHEN row = 13 and columnx = 4 then 0.79 
WHEN row = 13 and columnx = 5 then 0.85 
WHEN row = 13 and columnx = 6 then 1.15 
WHEN row = 13 and columnx = 7 then 1.73 
WHEN row = 13 and columnx = 8 then 2.2 
WHEN row = 13 and columnx = 9 then 2.6 
WHEN row = 13 and columnx = 10 then 3.3 
WHEN row = 13 and columnx = 11 then 3.9 
WHEN row = 13 and columnx = 12 then 4.45 
WHEN row = 13 and columnx = 13 then 4.95 
WHEN row = 13 and columnx = 14 then 5.86 
WHEN row = 13 and columnx = 15 then 7.43 
WHEN row = 13 and columnx = 16 then 8.79 
WHEN row = 13 and columnx = 17 then 10.02 
WHEN row = 14 and columnx = 1 then 0.52 
WHEN row = 14 and columnx = 2 then 0.71 
WHEN row = 14 and columnx = 3 then 0.85 
WHEN row = 14 and columnx = 4 then 0.96 
WHEN row = 14 and columnx = 5 then 1.06 
WHEN row = 14 and columnx = 6 then 1.45 
WHEN row = 14 and columnx = 7 then 2.22 
WHEN row = 14 and columnx = 8 then 2.85 
WHEN row = 14 and columnx = 9 then 3.4 
WHEN row = 14 and columnx = 10 then 4.36 
WHEN row = 14 and columnx = 11 then 5.21 
WHEN row = 14 and columnx = 12 then 5.97 
WHEN row = 14 and columnx = 13 then 6.68 
WHEN row = 14 and columnx = 14 then 7.97 
WHEN row = 14 and columnx = 15 then 10.23 
WHEN row = 14 and columnx = 16 then 12.2 
WHEN row = 14 and columnx = 17 then 13.99 
WHEN row = 15 and columnx = 1 then 0.56 
WHEN row = 15 and columnx = 2 then 0.8 
WHEN row = 15 and columnx = 3 then 1 
WHEN row = 15 and columnx = 4 then 1.16 
WHEN row = 15 and columnx = 5 then 1.3 
WHEN row = 15 and columnx = 6 then 1.81 
WHEN row = 15 and columnx = 7 then 2.82 
WHEN row = 15 and columnx = 8 then 3.65 
WHEN row = 15 and columnx = 9 then 4.39 
WHEN row = 15 and columnx = 10 then 5.69 
WHEN row = 15 and columnx = 11 then 6.83 
WHEN row = 15 and columnx = 12 then 7.88 
WHEN row = 15 and columnx = 13 then 8.86 
WHEN row = 15 and columnx = 14 then 10.65 
WHEN row = 15 and columnx = 15 then 13.8 
WHEN row = 15 and columnx = 16 then 16.58 
WHEN row = 15 and columnx = 17 then 19.13 
WHEN row = 16 and columnx = 1 then 0.59 
WHEN row = 16 and columnx = 2 then 0.89 
WHEN row = 16 and columnx = 3 then 1.13 
WHEN row = 16 and columnx = 4 then 1.34 
WHEN row = 16 and columnx = 5 then 1.53 
WHEN row = 16 and columnx = 6 then 2.15 
WHEN row = 16 and columnx = 7 then 3.39 
WHEN row = 16 and columnx = 8 then 4.42 
WHEN row = 16 and columnx = 9 then 5.34 
WHEN row = 16 and columnx = 10 then 6.98 
WHEN row = 16 and columnx = 11 then 8.43 
WHEN row = 16 and columnx = 12 then 9.76 
WHEN row = 16 and columnx = 13 then 11.01 
WHEN row = 16 and columnx = 14 then 13.3 
WHEN row = 16 and columnx = 15 then 17.37 
WHEN row = 16 and columnx = 16 then 20.99 
WHEN row = 16 and columnx = 17 then 24.31 
WHEN row = 17 and columnx = 1 then 0.65 
WHEN row = 17 and columnx = 2 then 1.05 
WHEN row = 17 and columnx = 3 then 1.38 
WHEN row = 17 and columnx = 4 then 1.68 
WHEN row = 17 and columnx = 5 then 1.95 
WHEN row = 17 and columnx = 6 then 2.77 
WHEN row = 17 and columnx = 7 then 4.45 
WHEN row = 17 and columnx = 8 then 5.87 
WHEN row = 17 and columnx = 9 then 7.14 
WHEN row = 17 and columnx = 10 then 9.43 
WHEN row = 17 and columnx = 11 then 11.47 
WHEN row = 17 and columnx = 12 then 13.37 
WHEN row = 17 and columnx = 13 then 15.14 
WHEN row = 17 and columnx = 14 then 18.43 
WHEN row = 17 and columnx = 15 then 24.32 
WHEN row = 17 and columnx = 16 then 29.6 
WHEN row = 17 and columnx = 17 then 34.48 
WHEN row = 18 and columnx = 1 then 0.71 
WHEN row = 18 and columnx = 2 then 1.18 
WHEN row = 18 and columnx = 3 then 1.59 
WHEN row = 18 and columnx = 4 then 1.97 
WHEN row = 18 and columnx = 5 then 2.32 
WHEN row = 18 and columnx = 6 then 3.32 
WHEN row = 18 and columnx = 7 then 5.4 
WHEN row = 18 and columnx = 8 then 7.17 
WHEN row = 18 and columnx = 9 then 8.78 
WHEN row = 18 and columnx = 10 then 11.66 
WHEN row = 18 and columnx = 11 then 14.26 
WHEN row = 18 and columnx = 12 then 16.67 
WHEN row = 18 and columnx = 13 then 18.94 
WHEN row = 18 and columnx = 14 then 23.17 
WHEN row = 18 and columnx = 15 then 30.78 
WHEN row = 18 and columnx = 16 then 37.65 
WHEN row = 18 and columnx = 17 then 44.02 
WHEN row = 19 and columnx = 1 then 0.76 
WHEN row = 19 and columnx = 2 then 1.3 
WHEN row = 19 and columnx = 3 then 1.78 
WHEN row = 19 and columnx = 4 then 2.23 
WHEN row = 19 and columnx = 5 then 2.65 
WHEN row = 19 and columnx = 6 then 3.81 
WHEN row = 19 and columnx = 7 then 6.24 
WHEN row = 19 and columnx = 8 then 8.33 
WHEN row = 19 and columnx = 9 then 10.23 
WHEN row = 19 and columnx = 10 then 13.65 
WHEN row = 19 and columnx = 11 then 16.76 
WHEN row = 19 and columnx = 12 then 19.64 
WHEN row = 19 and columnx = 13 then 22.36 
WHEN row = 19 and columnx = 14 then 27.45 
WHEN row = 19 and columnx = 15 then 36.63 
WHEN row = 19 and columnx = 16 then 44.96 
WHEN row = 19 and columnx = 17 then 52.7 Else 53 END as mu_LS 
INTO #step4 
FROM #step3

SELECT distinct
 LEFT(State_County_ID, 2) as st_alpha_fips_cd
, cast(case  
 WHEN LEFT(State_County_ID, 2) like 'AK' THEN '02'
 WHEN LEFT(State_County_ID, 2) like 'AL' THEN '01'
 WHEN LEFT(State_County_ID, 2) like 'AR' THEN '05'
 WHEN LEFT(State_County_ID, 2) like 'AS' THEN '60'
 WHEN LEFT(State_County_ID, 2) like 'AZ' THEN '04'
 WHEN LEFT(State_County_ID, 2) like 'CA' THEN '06'
 WHEN LEFT(State_County_ID, 2) like 'CO' THEN '08'
 WHEN LEFT(State_County_ID, 2) like 'CT' THEN '09'
 WHEN LEFT(State_County_ID, 2) like 'DC' THEN '11'
 WHEN LEFT(State_County_ID, 2) like 'DE' THEN '10'
 WHEN LEFT(State_County_ID, 2) like 'FL' THEN '12'
 WHEN LEFT(State_County_ID, 2) like 'GA' THEN '13'
 WHEN LEFT(State_County_ID, 2) like 'GU' THEN '66'
 WHEN LEFT(State_County_ID, 2) like 'HI' THEN '15'
 WHEN LEFT(State_County_ID, 2) like 'IA' THEN '19'
 WHEN LEFT(State_County_ID, 2) like 'ID' THEN '16'
 WHEN LEFT(State_County_ID, 2) like 'IL' THEN '17'
 WHEN LEFT(State_County_ID, 2) like 'IN' THEN '18'
 WHEN LEFT(State_County_ID, 2) like 'KS' THEN '20'
 WHEN LEFT(State_County_ID, 2) like 'KY' THEN '21'
 WHEN LEFT(State_County_ID, 2) like 'LA' THEN '22'
 WHEN LEFT(State_County_ID, 2) like 'MA' THEN '25'
 WHEN LEFT(State_County_ID, 2) like 'MD' THEN '24'
 WHEN LEFT(State_County_ID, 2) like 'ME' THEN '23'
 WHEN LEFT(State_County_ID, 2) like 'MI' THEN '26'
 WHEN LEFT(State_County_ID, 2) like 'MN' THEN '27'
 WHEN LEFT(State_County_ID, 2) like 'MO' THEN '29'
 WHEN LEFT(State_County_ID, 2) like 'MS' THEN '28'
 WHEN LEFT(State_County_ID, 2) like 'MT' THEN '30'
 WHEN LEFT(State_County_ID, 2) like 'NC' THEN '37'
 WHEN LEFT(State_County_ID, 2) like 'ND' THEN '38'
 WHEN LEFT(State_County_ID, 2) like 'NE' THEN '31'
 WHEN LEFT(State_County_ID, 2) like 'NH' THEN '33'
 WHEN LEFT(State_County_ID, 2) like 'NJ' THEN '34'
 WHEN LEFT(State_County_ID, 2) like 'NM' THEN '35'
 WHEN LEFT(State_County_ID, 2) like 'NV' THEN '32'
 WHEN LEFT(State_County_ID, 2) like 'NY' THEN '36'
 WHEN LEFT(State_County_ID, 2) like 'OH' THEN '39'
 WHEN LEFT(State_County_ID, 2) like 'OK' THEN '40'
 WHEN LEFT(State_County_ID, 2) like 'OR' THEN '41'
 WHEN LEFT(State_County_ID, 2) like 'PA' THEN '42'
 WHEN LEFT(State_County_ID, 2) like 'PR' THEN '72'
 WHEN LEFT(State_County_ID, 2) like 'RI' THEN '44'
 WHEN LEFT(State_County_ID, 2) like 'SC' THEN '45'
 WHEN LEFT(State_County_ID, 2) like 'SD' THEN '46'
 WHEN LEFT(State_County_ID, 2) like 'TN' THEN '47'
 WHEN LEFT(State_County_ID, 2) like 'TX' THEN '48'
 WHEN LEFT(State_County_ID, 2) like 'UT' THEN '49'
 WHEN LEFT(State_County_ID, 2) like 'VA' THEN '51'
 WHEN LEFT(State_County_ID, 2) like 'VI' THEN '78'
 WHEN LEFT(State_County_ID, 2) like 'VT' THEN '50'
 WHEN LEFT(State_County_ID, 2) like 'WA' THEN '53'
 WHEN LEFT(State_County_ID, 2) like 'WI' THEN '55'
 WHEN LEFT(State_County_ID, 2) like 'WV' THEN '54'
 WHEN LEFT(State_County_ID, 2) like 'WY' THEN '56' 
 END as varchar) as st_fips_cd
, RIGHT(State_County_ID, 3) as cnty_fips_cd
, Soil_Survey_Area_ID as soil_srvy_ar_cd
, musym as soil_map_unit_cd
, mu_kfactor as wtr_erod_fctr
, mu_tfactor as soil_loss_tolr_fctr
, mu_ifactor as wind_erod_idx
, mu_LS as soil_slp_lgth_fctr
, llpine as long_leaf_suit_ind
, WESL as wesl_ind
, mu_leach as soil_lch_ind
, source
,CASE WHEN cast(NCCPI_Value_dcp as decimal(3,2)) > 0 AND cast(NCCPI_Value_dcp as decimal(3,2)) <=0.300 THEN 1
	 WHEN cast(NCCPI_Value_dcp as decimal(3,2)) > .301 AND cast(NCCPI_Value_dcp as decimal(3,2)) <=0.250 THEN 2
	 WHEN cast(NCCPI_Value_dcp as decimal(3,2)) > .251 AND cast(NCCPI_Value_dcp as decimal(3,2)) <=0.500 THEN 3
	 WHEN cast(NCCPI_Value_dcp as decimal(3,2)) > .501 AND cast(NCCPI_Value_dcp as decimal(3,2)) <=0.750 THEN 4
	 WHEN cast(NCCPI_Value_dcp as decimal(3,2)) > .751 AND cast(NCCPI_Value_dcp as decimal(3,2)) <=1 THEN 5
	 
	 ELSE 99 END AS TNCCPI_GROUPING
, cast(NCCPI_Value_dcp as decimal(3,2)) as NCCPI
,NCCPI_Class_dcp  AS NCCPI_CLASS
, nirrcapclass
FROM #step4 
INNER JOIN #step1 on #step1.cokey=#step4.cokey
---WHERE LEFT(nirrcapclass, 1) < 5
ORDER BY st_alpha_fips_cd, cnty_fips_cd, musym

