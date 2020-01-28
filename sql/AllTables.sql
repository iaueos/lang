select [name]
-- , [object_id], schema_id, parent_object_id, [type], type_desc, create_date, modify_date, is_ms_shipped  
from sys.all_objects 
where 1=1
and [type]  ='U'
-- and [type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'U') 
AND SCHEMA_ID = 1 
-- AND [name] = 'TB_M_APPLICATION' 
ORDER BY [type], [name], create_date 
-- ORDER BY [TYPE], [name] 
/*

select [type], type_desc , COUNT(1) objects
from sys.all_objects 
group by [type], type_desc 
*/