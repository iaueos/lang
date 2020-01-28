-- Show All objects
select [name], [type],[type_desc], modify_date, create_date
 -- , [object_id], schema_id, parent_object_id, is_ms_shipped  
from sys.all_objects  a 
where 1=1
   AND [type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'U', 'V') 
   AND SCHEMA_ID = 1 
   and datediff(hour, modify_date, getdate()) <= 47
ORDER BY modify_date desc, [name]