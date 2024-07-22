select Total_Memory_MB, Available_Memory_MB, SQL_Server_Memory_Usage_MB, SQL_Server_Virtual_Usage_MB
from 
(SELECT 
    total_physical_memory_kb / 1024 AS Total_Memory_MB,
    available_physical_memory_kb / 1024 AS Available_Memory_MB
FROM 
    sys.dm_os_sys_memory
) y
join (
-- SQL Server Memory Usage (in MB)
SELECT 
    (physical_memory_in_use_kb / 1024) AS SQL_Server_Memory_Usage_MB,
    (virtual_address_space_committed_kb / 1024) AS SQL_Server_Virtual_Usage_MB
FROM 
    sys.dm_os_process_memory
) x on 1=1 