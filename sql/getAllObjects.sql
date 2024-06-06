-- Show All objects
select a.[name], tv.[tn] ,a.[type], a.create_date, a.modify_date, a.object_id
-- , a.[TYPE], a.[type_desc]
from sys.all_objects  a
join sys.schemas s on s.schema_id = a.schema_id
left join (
values
  ('P', 'StoredProcedure')
, ('FN', 'UserDefinedFunction')
, ('IF', 'UserDefinedFunction')
, ('V', 'View')
, ('TF', 'UserDefinedFunction')
, ('U', 'Table')
, ('D', 'default')
, ('F', 'ForeignKey')
, ('PK', 'PrimaryKey')
, ('TR', 'Trigger')
, ('UQ', 'Unique')
)
tv (tt, tn) on tv.tt = a.[type]
 join (select value Tipe from string_split('P TF FN AF X IF TT V U', ' ') X) FT
  ON FT.tipe = a.[type]
where 1=1--a.[type] in ('P', 'TF', 'FN', 'AF', 'X', 'IF', 'TT', 'V', 'U')
   AND a.SCHEMA_ID = 1
   and a.is_ms_shipped = 0
   --AND TV.TT IS NULL
    --and a.[name] = 'Rek_PutGenInOutDok'
 ORDER BY a.[type], a.modify_date desc, a.[name]