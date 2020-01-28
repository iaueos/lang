SELECT
 	dbid,
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName, 
    [program_name] as [ProgramName]
FROM
    sys.sysprocesses p 
WHERE 
   [program_name] is null or CHARINDEX('SQL Server Management Studio', [program_name]) < 1
   and DB_NAME(dbid) in ('BMS_DB', 'ELVIS_DB', 'SAP_DB', 'TMMIN_ROLE', 'WORKFLOW_DB') 
   -- DB_NAME(dbid) = 'BMS_DB'
GROUP BY 
    dbid, loginame, [program_name]
