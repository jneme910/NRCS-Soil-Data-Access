--[id] ,[query_id] ,[query_name],[query_frequency] ,[query_month] ,[month_abrv]	,month_name ,[query_year],[state]  ,[seqnum] ,[query_title] ,[query_header] ,[query_header2],[count]
SELECT MAX(LEN (query_name)) over(partition by 1) as max_len_query_name,
--MAX(LEN (month_name)) over(partition by 1) as max_len_month_name,
MAX(LEN ([state])) over(partition by 1) as max_len_state,
MAX(LEN (query_title)) over(partition by 1) as max_len_query_title,
MAX(LEN (query_header)) over(partition by 1) as max_len_query_header
FROM wss_metric_query_results
where --STATE LIKE '%Nat%' AND 
query_year IN  (2019,2020) ORDER BY query_name, query_frequency,  query_year, query_month, state 