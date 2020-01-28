SELECT 
des.[program_name],
des.login_name,
des.host_name -- ,
, dec.most_recent_sql_handle
, t.text 
-- COUNT(des.session_id) [Connections]
FROM sys.dm_exec_sessions des
INNER JOIN sys.dm_exec_connections DEC
ON des.session_id = DEC.session_id
CROSS APPLY
    sys.dm_exec_sql_text(dec.most_recent_sql_handle) AS t
WHERE des.is_user_process = 1
  -- AND des.status != 'running'
  and CHARINDEX('SQL Workbench',  des.[program_name]) < 1
  and CHARINDEX('SQLAgent', des.[program_name]) < 1
  and CHARINDEX('Microsoft SQL Server', des.[program_name]) < 1
  and CHARINDEX('SQL Server', des.[program_name]) < 1
 
-- GROUP BY des.program_name,
-- des.login_name,
--- des.host_name
-- ,der.database_id
--- HAVING COUNT(des.session_id) > 2
-- ORDER BY COUNT(des.session_id) DESC