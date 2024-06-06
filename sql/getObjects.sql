CREATE   PROCEDURE getObjects 
  @nm varchar(2000) = ''
, @ot varchar(50) = ''
, @ord varchar(30) = '-date'
as begin 
select [name], tn, [type], create_date, modify_date, [object_id]
from 
(
	select concat(case when s.[name] ='dbo' then '' else concat(s.name ,'.') end,  a.[name]) [name]
	  , tv.[tn] ,a.[type]
	  , a.create_date, a.modify_date
	  , a.[object_id]
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
	 join (select value Tipe from string_split(coalesce(NULLIF(@ot,''), 'P TF FN AF X IF TT V U'), ' ') X) FT
	  ON FT.tipe = a.[type] 
	 JOIN (SELECT value NM from STRING_SPLIT(COALESCE(@NM, ''),' ') N) N 
	   ON  ( NULLIF(@NM,'') IS NULL 
	   OR (charindex('%', n.nm) <1 and N.NM = a.[name])
	   or (charindex('%', n.nm) >0 and a.[name] like n.nm))
	where a.is_ms_shipped = 0  
) o 
 ORDER BY
     case @ord 
     when 'type' then o.[type] 
     when 'date' then CONVERT(VARCHAR(19), COALESCE(o.modify_date, o.create_date), 112) 
     when 'name' then o.[name] 
     when 'id' then convert(char(19), o.object_id) 
     else '' end  COLLATE database_default ASC
   , case @ord 		  
     when '-type' then o.[type] 
	 when '-date' then CONVERT(VARCHAR(19), COALESCE(o.modify_date, o.create_date), 112) 
	 when '-name' then o.[name] 
	 when '-id' then convert(char(19), o.object_id) 
     else '' end  COLLATE database_default DESC 
END