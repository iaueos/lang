select spid, status, loginame, 
hostname, blocked, db_name(dbid) as databasename, cmd 
from master..sysprocesses
where 
status <> 'background'
-- db_name(dbid) like '%matrix%'
--and spid > 50