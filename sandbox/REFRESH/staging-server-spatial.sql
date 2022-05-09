--------- view data in staging server  -- for counting # of SSAs in staging with spatial only
---- list of SSA's

---- list of spatial data
USE SDWStaging
SELECT * FROM sdwstaging.dbo.saspatialver WITH (NOLOCK)
