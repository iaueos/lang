-- Show All objects
select [type],[type_desc], [name], modify_date, create_date
 -- , [object_id], schema_id, parent_object_id, is_ms_shipped  
from sys.all_objects  a 
where 1=1
   AND [type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'U', 'V') 
   AND SCHEMA_ID = 1 
   and datediff(hour, modify_date, getdate()) <= 24
ORDER BY [type], modify_date desc,  [name]