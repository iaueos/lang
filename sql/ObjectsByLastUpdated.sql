-- Show All objects
select [type],[type_desc], [name],
	  CASE DATEDIFF(MINUTE, CREATE_DATE, MODIFY_DATE) WHEN 0 THEN [create_date] WHEN 1 THEN CREATE_DATE WHEN -1 THEN MODIFY_DATE ELSE MODIFY_DATE END updated
 -- , [object_id], schema_id, parent_object_id, is_ms_shipped  

from sys.all_objects  a 
where 1=1
   AND [type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'U', 'V') 
   AND SCHEMA_ID = 1 
   -- and datediff(hour, modify_date, getdate()) <= 24
ORDER BY CASE DATEDIFF(MINUTE, CREATE_DATE, MODIFY_DATE) WHEN 0 THEN [create_date] WHEN 1 THEN CREATE_DATE WHEN -1 THEN MODIFY_DATE ELSE MODIFY_DATE END desc,  [type], [name]