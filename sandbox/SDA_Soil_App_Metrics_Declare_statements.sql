/****** SDA Soil Application Metrics  ******/
--State, Query Frequency, Query Name, Year

DECLARE @queryname VARCHAR(240)= 'wss_ExportCounts';
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

DECLARE @queryfrequency VARCHAR(5) = 'M';
/* List options for Query Frequency
CY
FY
M
*/

DECLARE @queryyear INT = 2022;

DECLARE @state VARCHAR(15)= 'xnational';
/* List options for State
For National use xnational otherwise state abbrev
*/







~DeclareChar(@queryname,240)~  -- Query Name
~DeclareChar(@queryfrequency,5)~  -- Query Frequency
~DeclareINT(@queryyear)~  --Query Year
~DeclareChar(@state,15)~ 

SELECT @queryname = 'wss_ExportCounts'; --Enter Query Name List includes 'LDM_Usage','SDA_Usage','wss_ActivityCounts','wss_AOIDefinition','wss_AOISizeRange','wss_ExportCounts','wss_PrintableOutput','wss_top100AOIs','wss_top100Ecologicalsites','wss_top100ratings','wss_top100reports'
SELECT @queryfrequency = 'M'; -- Enter 'M' for month, 'CY' for Calander year or 'FY' for Fiscal year
SELECT @queryyear = 2022; -- Enter year
SELECT @state = 'xnational'; -- Enter xnational for national or state abbrev


SELECT TOP (1000) [id]
      ,[query_id]
      ,[query_name]
      ,[query_frequency]
      ,[query_month]
      ,[query_year]
      ,[state]
      ,[seqnum]
      ,[query_title]
      ,[query_header]
      ,[query_header2]
      ,[count]
  FROM /* [sdmONLINE].[dbo]. */
  [wss_metric_query_results] 
  WHERE 
	[query_name]=@queryname 
	AND [query_frequency]=@queryfrequency
	AND [query_year]=@queryyear
	AND [state]=@state 