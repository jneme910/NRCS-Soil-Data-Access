USE sdmONLINE;
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Paleudolls' AS taxonflag--, compname, [taxsubgrp], majcompflag, c.comppct_r

FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] LIKE  'Typic Paleudolls' )

ORDER BY areasymbol ASC

/*Aquic Hapludults *
Typic Haplargids 
Mollic Palexeralfs *
Chromic Vertic Hapludalfs*
Typic Hapludalfs *
Cumulic Endoaquolls *
Typic Argiudolls *
Typic Endoaquolls *
Mollic Albaqualfs *
Typic Paleudolls *
Mollic Paleudalfs ^
Glossic Fragiudults *
Typic Hapludults *
Oxyaquic Fragiudalfs *

*/

