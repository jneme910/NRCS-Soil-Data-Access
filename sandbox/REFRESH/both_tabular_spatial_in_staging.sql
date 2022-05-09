-- Counts surveys in staging server that have both spatial and tabular data

USE SDWStaging

select count(*) from satabularver with (NOLOCK) join saspatialver with (NOLOCK) on satabularver.areasymbol = saspatialver.areasymbol


