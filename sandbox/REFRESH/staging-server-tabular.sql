--------- view data in staging server  -- for counting # of SSAs in staging with tabular only data
---- list of SSA's

USE SDWStaging

SELECT * FROM sdwstaging.dbo.satabularver WITH (NOLOCK)


