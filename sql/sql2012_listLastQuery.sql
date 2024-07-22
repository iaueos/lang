SELECT deqs.last_execution_time AS [Time], d.name dbname,  dest.text AS [Query]
FROM sys.dm_exec_query_stats AS deqs
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
join sys.databases d  on d.database_id = dest.dbid 
ORDER BY deqs.last_execution_time DESC