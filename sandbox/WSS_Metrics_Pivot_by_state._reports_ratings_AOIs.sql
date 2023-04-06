DROP TABLE IF EXISTS #wss_metrics
DROP TABLE IF EXISTS #wss_metrics2


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
DECLARE @query_name VARCHAR(55);
DECLARE @year INT;
/* List options for State
For National use xnational otherwise state abbrev
*/

~DeclareChar(@state,15)~ 
~DeclareChar(@query_name,15)~ 
~DeclareINT(@year,INT)~ 

SELECT @state = 'WI'; -- Enter xnational for national or state abbrev
SELECT @query_name ='wss_top100reports'
SELECT @year = 2022
DECLARE  @columns NVARCHAR(MAX) = '';

 CREATE TABLE #wss_metrics
 ( query_name   VARCHAR(240),
 query_year INT,	
 [state] VARCHAR(50),		
 query_header VARCHAR(240),		
 sum_count INT )

 INSERT INTO #wss_metrics
 ( query_name,
 query_year,	
 [state],	
 query_header,	
 sum_count )

  
 SELECT DISTINCT
       [query_name]
       ,[query_year]
      ,[STATE]
      ,[query_header]
	  ,SUM(count) over(partition by state, query_name, query_header) as sum_count
	  FROM [wss_metric_query_results] 
	 	  WHERE
[query_frequency] = 'M'
  AND [STATE] = @state 
  AND [query_name]= @query_name  
  AND [query_year] = @year 

 CREATE TABLE #wss_metrics2
 (
 query_name   VARCHAR(240),
 query_year INT,	
 [state] VARCHAR(50),		
 query_header VARCHAR(240),		
 sum_count INT  )

 INSERT INTO #wss_metrics2
 ( query_name,
 query_year,	
 [state],	
 query_header,	
 sum_count )
  
SELECT TOP 10 query_name,
 query_year,	
 [state],	
 query_header,	
 sum_count
  FROM #wss_metrics  ORDER BY sum_count DESC

SELECT query_name,
 query_year,	
 [state],	
 query_header,	
 sum_count
 FROM #wss_metrics2


 /*
 SELECT 
 --STRING_AGG(QUOTENAME(query_header)
    @columns += QUOTENAME(query_header) + ','
FROM 
    #wss_metrics2
ORDER BY 
     sum_count DESC;

--~DeclareVarchar(@columns,MAX)~
SELECT @columns = LEFT(@columns, LEN(@columns) - 1);

PRINT @columns;

  
SELECT  * FROM
	(SELECT
		 [query_header], [sum_count]
              FROM
                        #wss_metrics2
                      
                ) k
            PIVOT (
                    SUM(sum_count)
                    FOR query_header IN ()
                                    
               ) AS #yrsum;     
 */