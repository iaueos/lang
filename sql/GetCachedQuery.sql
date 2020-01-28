--- Get Cached queries
SELECT cp.[usecounts]
    ,cp.[refcounts]
    ,cp.[cacheobjtype]
    ,CASE cp.[objtype]
        WHEN 'Proc'
            THEN 'Stored procedure'
        WHEN 'Prepared'
            THEN 'Prepared statement'
        WHEN 'Adhoc'
            THEN 'Ad hoc query'
        WHEN 'ReplProc'
            THEN 'Replication-filter-procedure'
        WHEN 'UsrTab'
            THEN 'User table'
        WHEN 'SysTab'
            THEN 'System table'
        WHEN 'Check'
            THEN 'Check constraint'
        ELSE cp.[objtype]
        END AS [object_type]
    ,cp.[size_in_bytes]
    --,ISNULL(DB_NAME(qt.[dbid]), 'resourcedb') AS [db_name]
    --,qp.[query_plan]
    ,qt.[text]
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.[plan_handle]) qt
CROSS APPLY sys.dm_exec_query_plan(cp.[plan_handle]) qp
ORDER BY cp.[usecounts] DESC;