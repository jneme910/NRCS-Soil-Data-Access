--Lists surveys committed for sdmOFFLINE 

use sdmOFFLINE; 

select 
LEFT((sc.areasymbol), 2) as state
, legend.lkey
, sc.areasymbol
, sc.areaname
, case when (month(st.tabularverest) IN (5, 6) and year(st.tabularverest) = 2020) then 'X' else '' end as FY20_refresh
, areaacres
, st.tabularversion
, CAST(DATEPART(month, tabularverest) as varchar(2)) + '/' + CAST(DATEPART(day, tabularverest) as varchar(2)) + '/' + CAST(DATEPART(year, tabularverest) as varchar(4)) AS Tabular_date
, month(st.tabularverest) as TabMONTH
, year(st.tabularverest) as TabYEAR
, spatialversion
, CAST(DATEPART(month, spatialverest) as varchar(2)) + '/' + CAST(DATEPART(day, spatialverest) as varchar(2)) + '/' + CAST(DATEPART(year, spatialverest) as varchar(4)) AS Spat_date 
, month(spatialverest) as SpatialMONTH
, year(spatialverest) as SpatialYEAR
, (select count(*) from mapunit with(nolock)  where legend.lkey=mapunit.lkey) MU_count
, (select count(*) from component with(nolock) inner join mapunit with(nolock)  on mapunit.mukey=component.mukey where legend.lkey=mapunit.lkey) COMP_count
, (select count(DISTINCT component.cokey) from cotext inner join component with(nolock)  on cotext.cokey=component.cokey inner join mapunit with(nolock)  on mapunit.mukey=component.mukey where legend.lkey=mapunit.lkey and comptextkind like '%nontech%' ) COMPTECH_count
, (select count(*) from chorizon inner join component with(nolock) on chorizon.cokey=component.cokey inner join mapunit with(nolock)  on mapunit.mukey=component.mukey where legend.lkey=mapunit.lkey) as hcount
, (select count(*) from cointerp inner join component with(nolock)  on cointerp.cokey=component.cokey inner join mapunit with(nolock)  on mapunit.mukey=component.mukey where legend.lkey=mapunit.lkey and ruledepth = 0) Interp_count
, (select count(*) from sainterp with(nolock) where sainterp.areasymbol=legend.areasymbol) Survey_Interp_count
from sacatalog sc with(nolock)
inner  join saspatialver sp with(nolock) ON sc.areasymbol=sp.areasymbol
inner join satabularver st with(nolock)  on sc.areasymbol=st.areasymbol
inner join legend with(nolock) on sc.areasymbol=legend.areasymbol
AND sc.areasymbol not like 'US' 
and  saverest > '05/01/2020'
Order by sc.areasymbol
