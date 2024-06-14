SELECT
    DB,
    hostname,
    loginame,
    start_time [Started],
    batch_duration,
    txt [Query],
    session_id AS SessionId,
    cpu_time AS [CPU],
    total_elapsed_time AS [ElapsedTime],
    [reads] AS [PhysicalReadsPerSec],
    writes AS [Writes],
    logical_reads AS [LogicalReadPerSec],
    row_count AS [RowCount],
    granted_query_memory AS [AllocatedMemory],
    memusage [UsedMemory]
FROM (
    SELECT
        r.session_id session_id,
        r.cpu_time,
        r.total_elapsed_time,
        r.reads,
        r.writes,
        r.logical_reads,
        r.row_count,
        r.granted_query_memory,
        p.memusage,
        r.start_time,
        p.ecid,
        p.spid,
        p.sql_handle,
        p.dbid,
        db_name(p.dbid) AS DB,
        p.loginame,
        p.hostname,
        (
            SELECT TEXT
            FROM sys.dm_exec_sql_text(p.sql_handle)
        ) AS txt,
        RIGHT(CONVERT(VARCHAR, DATEADD(ms, DATEDIFF(ms, r.start_time, GETDATE()), '1900-01-01'), 121), 12) AS batch_duration
    FROM master.dbo.sysprocesses p
    JOIN sys.dm_exec_requests r ON p.spid = r.session_id
    WHERE CONVERT(BIGINT, p.sql_handle) != 0
) x
WHERE CHARINDEX('txt [Query]', x.txt) <1
ORDER BY batch_duration DESC;