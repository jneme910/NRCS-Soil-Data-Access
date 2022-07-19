DROP TABLE IF EXISTS #wss_metrics



/* List options for Query Name 
LDM_Usage
SDA_Usage
wss_ActivityCounts
wss_AOIDefinition
wss_AOISizeRange
wss_ExportCounts
wss_PrintableOutput
wss_top100AOIs
wss_top100Ecologicalsites
wss_top100ratings
wss_top100reports
*/


/* List options for Query Frequency
CY
FY
M
*/



DECLARE @state VARCHAR(15);
SELECT @state = 'xnational'; -- Enter xnational for national or state abbrev
/* List options for State
For National use xnational otherwise state abbrev
*/

--~DeclareChar(@state,15)~ 
 CREATE TABLE #wss_metrics
 (id INT,	
 query_id INT,	
 query_name   VARCHAR(240),
 query_frequency   VARCHAR(5),	
 query_month SMALLINT, 	
 month_abrv VARCHAR(5),	
 month_name VARCHAR(15),		
 query_year INT,	
 [state] VARCHAR(50),		
 seqnum INT, 	
 query_title VARCHAR(240),	
 query_header VARCHAR(240),		
 wssm_yr INT, 	
  [count] INT, 
 m_yr INT
  )

 INSERT INTO #wss_metrics
 (id,	
 query_id,	
 query_name,
 query_frequency,	
 query_month,	
 month_abrv,	
 month_name,	
 query_year,	
 [state],	
 seqnum,	
 query_title,	
 query_header,	
 wssm_yr,	
 [count],
 m_yr
  )
 SELECT [id]
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
      ,[STATE]
      ,[seqnum]
      ,[query_title]
      ,[query_header]
	  , CONCAT ([query_month], [query_year]) AS wssm_yr
      ,[COUNT]
, CONCAT ([query_month], [query_year]) AS m_yr
	 -- AVG(slope_r) over(partition by compname) as avg_slope

  FROM [wss_metric_query_results]  WHERE --[query_year] = 2015 
[query_frequency] = 'M'
  AND [STATE] = @state 
  AND CASE WHEN   [query_title]=  'Soil Survey Area'THEN 1  
  WHEN  [query_title] ='AOI Definition Type'THEN 1  
  WHEN  [query_title] ='Activity Type'THEN 1  
  WHEN  [query_title] ='Ratings'THEN 1  
  WHEN  [query_title] ='Reports'THEN 1  
  WHEN  [query_title] ='Downloads Requested'THEN 1  
  WHEN  [query_title] ='Size(acres)'  THEN 1  
  ELSE 2 END = 1


            SELECT
                [query_year],
                    [state],
					FORMAT([Soil Survey Area], '#,#') AS [Soil Survey Area],
FORMAT([AOI Definition Type], '#,#') AS [AOI Definition Type] ,
FORMAT([Activity Type], '#,#') AS [Activity Type] ,
FORMAT([Ratings], '#,#') AS [Ratings],
FORMAT([Reports], '#,#') AS [Reports],
FORMAT([Downloads Requested], '#,#') AS [Downloads Requested] ,
FORMAT([Size(acres)], '#,#') AS [Size(acres)]
            FROM
                (
                    SELECT
					[query_year],
                    [state],
					[count],
                    [query_title] 
                    FROM
                        #wss_metrics
                      
                ) #w
            PIVOT
                (
                    SUM(count)
                    FOR query_title IN (
                         [Soil Survey Area],
[AOI Definition Type],
[Activity Type],
[Ratings],
[Reports],
[Downloads Requested],
[Size(acres)]
                                    )
                ) AS #yr_sum ORDER BY query_year ASC;

 