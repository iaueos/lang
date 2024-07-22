SELECT
    db_name(p.dbid) AS [Database],
    p.hostname,
    p.loginame,
    r.start_time [Started],
    RIGHT(CONVERT(VARCHAR, DATEADD(ms, DATEDIFF(ms, r.start_time, GETDATE()), '1900-01-01'), 121), 12) AS batch_duration,
    q.[Text] [Query],
    r.session_id [SessionId],
    r.cpu_time [CPU],
    r.total_elapsed_time [ElapsedTime],
    r.reads [PhysicalReadsPerSec],
    r.writes [Writes],
    r.logical_reads [LogicalReadPerSec],
    r.row_count [RowCount],
    r.granted_query_memory [AllocatedMemory],
    p.memusage [UsedMemory]
    --p.ecid,p.spid,p.sql_handle,p.dbid,
FROM master.dbo.sysprocesses p
CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) q
JOIN sys.dm_exec_requests r ON p.spid = r.session_id
WHERE CONVERT(BIGINT, p.sql_handle) != 0
and  CHARINDEX('q.[Text] [Query],', q.[Text]) <1
ORDER BY batch_duration DESC;

