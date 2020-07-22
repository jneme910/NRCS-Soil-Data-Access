SELECT [areasymbol]
      ,[areaname]
, CONCAT (' https://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/wss_SSA_',  [areasymbol], '_[' ,  FORMAT(  [saverest], 'yyyy-MM-dd', 'en-US' ) 
        , '].zip') AS WSS_link,  CONCAT (' https://websoilsurvey.sc.egov.usda.gov/DSD/Download/Cache/SSA/wss_SSA_',  [areasymbol], '_soildb_US_2003_[' ,  FORMAT(  [saverest], 'yyyy-MM-dd', 'en-US' ) 
        , '].zip') AS WSS_link2
  FROM [sacatalog] WHERE areasymbol <> 'US'
