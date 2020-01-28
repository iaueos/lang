select *  from sys.all_objects 
where type in ('P', 'TF', 'FN', 'AF', 'X', 'IF') 
AND SCHEMA_ID = 1 
ORDER BY create_date 
-- ORDER BY [TYPE], [name] 


select [type], type_desc , COUNT(1) objects
from sys.all_objects 
group by [type], type_desc 