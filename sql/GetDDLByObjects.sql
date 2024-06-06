SELECT --obj.Name ,
modu.definition [DDL]
--, obj.create_date 
FROM sys.sql_modules modu
INNER JOIN sys.objects obj
ON modu.object_id = obj.object_id
WHERE -- obj.type = 'P'  and 
obj.Name IN ('fn_get_last_process_id')