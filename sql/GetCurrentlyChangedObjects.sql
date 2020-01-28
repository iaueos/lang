-- Show All objects
select [type],[type_desc], [name], a.create_date, a.modify_date
-- , [object_id], schema_id, parent_object_id, [type], type_desc, create_date, modify_date, is_ms_shipped  
from sys.all_objects a 
where 1=1
 and [type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT') 
AND SCHEMA_ID = 1 
and datediff(day, modify_date, getdate()) = 0 
ORDER BY [type], [name], create_date 
