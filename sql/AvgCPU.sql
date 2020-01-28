SELECT TOP 10 SUBSTRING(qt.[text], qs.[statement_start_offset] / 2 + 1, (
            CASE
                WHEN qs.[statement_end_offset] = - 1
                    THEN LEN(CONVERT([nvarchar](max), qt.[text])) * 2
                ELSE qs.[statement_end_offset]
                END - qs.[statement_start_offset]
            ) / 2) AS [query_text]
    --,qp.[query_plan]
    ,qs.[last_execution_time]
    ,qs.[execution_count]
    ,qs.[last_logical_reads]
    ,qs.[last_logical_writes]
    ,qs.[last_worker_time]
    ,qs.[last_elapsed_time]
    ,qs.[total_logical_reads]
    ,qs.[total_logical_writes]
    ,qs.[total_worker_time]
    ,qs.[total_elapsed_time]
    ,qs.[total_worker_time] / qs.[execution_count] AS [avg_cpu_time]
    ,qs.[total_elapsed_time] / qs.[execution_count] AS [avg_running_time]
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_query_plan(qs.[plan_handle]) AS qp
WHERE qt.[text] LIKE '%SELECT%'
ORDER BY [avg_cpu_time]
    ,qs.[execution_count] DESC;