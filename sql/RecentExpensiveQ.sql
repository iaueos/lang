SELECT SUBSTRING(q.TEXT, 1 + s.statement_start_offset / 2, (
            CASE
                WHEN s.statement_end_offset = - 1
                    THEN LEN(CONVERT(NVARCHAR(max), q.TEXT)) * 2
                ELSE s.statement_end_offset
                END - s.statement_start_offset
            ) / 2) [Query]
    ,s.execution_count [ExecutionCount]
    ,s.total_worker_time [CPUMsPerSec]
    ,s.total_physical_reads [PhysicalReads]
    ,s.total_logical_reads + s.total_logical_writes [TotalLogicalIO]
    ,s.total_elapsed_time / s.execution_count [AverageDuration]
    ,(s.total_logical_reads + s.total_logical_writes) / s.execution_count AS AverageIO
    ,s.last_rows [rows]
    ,s.last_execution_time AS LastRun
    ,db.name [Database]
FROM sys.dm_exec_query_stats s
JOIN (
    SELECT 1 executions
    ) mi ON 1 = 1
CROSS APPLY sys.dm_exec_sql_text(s.sql_handle) AS q
LEFT JOIN sys.databases AS DB ON q.dbid = DB.database_id
WHERE (
        NULLIF(NULLIF(mi.executions, 0), 1) IS NULL
        OR s.execution_count > mi.executions
        )
    AND s.last_execution_time > dateadd(day, - 2, GETDATE())
    AND (s.total_logical_reads + s.total_logical_writes) > 1000
    AND CHARINDEX('FROM sys.dm_exec_query_stats s', TEXT) < 1
ORDER BY [AverageIO] DESC
    ,[AverageDuration] DESC;
