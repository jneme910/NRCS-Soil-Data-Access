USE sdmONLINE;
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Oxyaquic Fragiudalfs' AS taxonflag--, compname, [taxsubgrp], majcompflag, c.comppct_r
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =  'Oxyaquic Fragiudalfs' )

UNION ALL

SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Aquic Hapludults' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Aquic Hapludults' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Mollic Palexeralfs' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Mollic Palexeralfs' )


UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Chromic vertic Hapludalfs' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Chromic vertic Hapludalfs' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Hapludalfs' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Hapludalfs' )


UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Cumulic Endoaquolls' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Cumulic Endoaquolls' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Argiudolls' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Argiudolls' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Endoaquolls' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Endoaquolls' )


UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Mollic Albaqualfs' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Mollic Albaqualfs' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Paleudolls' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Albaqualfs' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Paleudolls' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Paleudolls' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Mollic Paleudalfs' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Mollic Paleudalfs' )


UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Glossic Fragiudults' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Glossic Fragiudults' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Aquic Hapludults' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Aquic Hapludults' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Hapludults' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Hapludults' )

UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Oxyaquic Fragiudalfs' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Oxyaquic Fragiudalfs' )


UNION ALL 
SELECT areasymbol, areaname,  m.mukey, m.musym,  muname, 'Typic Haplargids' AS taxonflag
FROM legend AS l
INNER JOIN mapunit AS m ON m.lkey=l.lkey
AND m.mukey IN (SELECT c.mukey FROM component AS c WHERE  c.mukey=m.mukey AND  [taxsubgrp] =   'Typic Haplargids' )
ORDER BY areasymbol ASC

/*
  --


 --
--
 --
 --
 --
  --

Oxyaquic Fragiudalfs 
*/

