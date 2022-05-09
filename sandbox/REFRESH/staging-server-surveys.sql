--------- view data in staging server  -- for counting # of SSAs in staging
---- list of SSA's

USE SDWStaging

SELECT * FROM sdwstaging.dbo.sastage WITH (NOLOCK)
