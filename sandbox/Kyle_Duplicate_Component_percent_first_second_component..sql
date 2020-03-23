
DROP TABLE IF EXISTS #table1
DROP TABLE IF EXISTS #table2
DROP TABLE IF EXISTS #table3
DROP TABLE IF EXISTS #table4

CREATE TABLE #table1 (areasymbol VARCHAR (250), musym VARCHAR (250), muname VARCHAR (250), mukey VARCHAR (250), comppct_r INT, count INT)
INSERT INTO #table1 (areasymbol, musym, muname,mukey, comppct_r, count)
SELECT  areasymbol, musym, muname, mapunit.mukey, comppct_r, count (*)
FROM legend
JOIN mapunit ON legend.lkey = mapunit.lkey
AND areasymbol ! ='US'
JOIN component ON mapunit.mukey = component.mukey
AND majcompflag = 'yes'
Group by areasymbol, musym, muname, mapunit.mukey, comppct_r HAVING count(*) >1
order by areasymbol, musym, comppct_r DESC;

CREATE TABLE #table2 (areasymbol VARCHAR (250), musym VARCHAR (250), muname VARCHAR (250), mukey VARCHAR (250), compname varchar (250), comppct_r INT, row INT)
INSERT INTO #table2 (areasymbol, musym, muname,mukey, compname, comppct_r, row)

SELECT #table1.areasymbol, #table1.musym, #table1.muname, #table1.mukey, component.compname, component.comppct_r, row_number() over (PARTITION BY mapunit.mukey order by component.comppct_r desc, cokey ) as row
FROM #table1
join mapunit on #table1.mukey = mapunit.mukey 
join component on component.mukey = mapunit.mukey
order by musym, comppct_R desc;


CREATE TABLE #table3 (areasymbol VARCHAR (250), musym VARCHAR (250), muname VARCHAR (250), mukey VARCHAR (250), compname varchar (250), comppct_r INT, row INT)
INSERT INTO #table3 (areasymbol, musym, muname,mukey, compname, comppct_r, row)
select * from #table2
where row<3;

CREATE TABLE #table4 (areasymbol VARCHAR (250), musym VARCHAR (250), muname VARCHAR (250), mukey VARCHAR (250),  comppct_r INT, count INT)
INSERT INTO #table4 (areasymbol, musym, muname,mukey,  comppct_r, COUNT)
SELECT #table3.areasymbol, #table3.musym, #table3.muname, #table3.mukey, #table3.comppct_r, count (*)
FROM #table3
Group by #table3.areasymbol, #table3.musym, #table3.muname, #table3.mukey, #table3.comppct_r HAVING count(*) >1
order by #table3.areasymbol, #table3.musym, #table3.comppct_r DESC;

select * from #table4; 
 
