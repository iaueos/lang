-- Find Locked table
select  
    object_name(P.object_id) as TableName, 
    resource_type, resource_description,
    s.host_name,
    s.row_count
   
   
from
    sys.dm_tran_locks L
    join sys.partitions P on L.resource_associated_entity_id = p.hobt_id
    join sys.dm_exec_sessions s on s.session_id = l.request_session_id  
    
