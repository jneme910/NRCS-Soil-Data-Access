--Lists number of surveys committed to SDW for each state

use SDW;

select substring(areasymbol, 1, 2) State, count( * ) Commits from saversion w with(nolock) 
where saverret is null and saverest > '05/01/2020'
group by substring(areasymbol, 1, 2)
select count( * ) Total from saversion w with(nolock) 
where saverret is null and saverest > '05/01/2020'