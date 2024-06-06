-- Show All objects
select a.[name], tv.[tn] -- , a.[TYPE], a.[type_desc]	
from sys.all_objects  a 
join sys.schemas s on s.schema_id = a.schema_id
left join (
values 
  ('P', 'StoredProcedure')
, ('FN', 'UserDefinedFunction') 
, ('IF', 'UserDefinedFunction') 
, ('V', 'View')
, ('TF', 'UserDefinedFunction')
)
tv (tt, tn) on tv.tt = a.[type]
where a.[type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'V') 
   AND a.SCHEMA_ID = 1 
   and a.is_ms_shipped = 0
 ORDER BY a.[type], a.modify_date desc, a.[name]