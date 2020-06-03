 DROP TABLE IF EXISTS #metric
 
 
 CREATE TABLE #metric (
 [id] INT,[query_id] INT ,[query_name] VARCHAR (25) ,[query_frequency] VARCHAR (5) ,[query_month] TINYINT ,[month_abrv] VARCHAR (5) ,month_name VARCHAR (12)  ,[query_year] INT ,[state] VARCHAR (9) ,[seqnum] INT ,[query_title] VARCHAR (19) ,[query_header] VARCHAR (205) ,[count] 	INT
   )

INSERT INTO  #metric ([id] ,[query_id] ,[query_name],[query_frequency] ,[query_month] ,[month_abrv]	,month_name ,[query_year],[state]  ,[seqnum] ,[query_title] ,[query_header] ,[count]
	  )



select  [id]
      ,[query_id]
      ,[query_name]
      ,[query_frequency]
      ,[query_month]
	  ,CASE
          WHEN [query_month] = 1 THEN 'Jan'
          WHEN [query_month] = 2 THEN 'Feb'
          WHEN [query_month] = 3 THEN 'Mar'
          WHEN [query_month] = 4 THEN 'Apr'
          WHEN [query_month] = 5 THEN 'May'
          WHEN [query_month] = 6 THEN 'Jun'
          WHEN [query_month] = 7 THEN 'Jul'
          WHEN [query_month] = 8 THEN 'Aug'
          WHEN [query_month] = 9 THEN 'Sep'
          WHEN [query_month] = 10 THEN 'Oct'
          WHEN [query_month] = 11 THEN 'Nov'
          WHEN [query_month] = 12 THEN 'Dec'
          ELSE 'OTHER'
       END AS [month_abrv]
	   ,DATENAME (MONTH, DATEADD(MONTH, MONTH(query_month) - 1, '1900-01-01')) AS month_name
      ,[query_year]
      ,[state]
      ,[seqnum]
      ,[query_title]
      ,[query_header]
      ,[count] 
	  FROM wss_metric_query_results
where STATE LIKE '%Nat%' A--ND query_year IN  (2019,2020) 
ORDER BY query_name, query_frequency,  query_year, query_month, state 
