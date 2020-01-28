-- GetAllObjects 

select  o.object_id, [type],[type_desc], [name]
-- , [object_id], schema_id, parent_object_id, [type], type_desc, create_date, modify_date, is_ms_shipped  
from sys.all_objects o
where 1=1
   and [type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'U', 'V') 
AND SCHEMA_ID = 1 
ORDER BY [type], [name], create_date 

-- GetDefinition by Name
select o.object_id, OBJECT_DEFINITION(o.object_id) 
from sys.all_objects o 
where o.[name]=''