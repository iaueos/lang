CREATE   PROCEDURE getObjects
  @name varchar(2000) = ''
, @objectType varchar(50) = ''
, @orderBy varchar(30) = NULL
as begin
declare @oby int = 0
SELECT @oby = COALESCE((
select top 1 (id *case when charindex('-', @orderBy) > 0 then -1 else 1 end) [OBY]
 from (values(1, 'date'),(2, 'name'),(3, 'type'), (4, 'id')) x(id, nm) where nm = replace(@orderBy,'-', '')), -1);
 
select [name], tn, [type] objectType, create_date created, modify_date modified, [object_id]
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
     join (select value Tipe from string_split(coalesce(NULLIF(@objectType,''), 'P TF FN AF X IF TT V U'), ' ') X) FT
      ON FT.tipe = a.[type]
     JOIN (SELECT value NM from STRING_SPLIT(COALESCE(@name, ''),' ') N) N
       ON  ( NULLIF(@name,'') IS NULL
       OR (charindex('%', n.nm) <1 and N.NM = a.[name])
       or (charindex('%', n.nm) >0 and a.[name] like n.nm))
    where a.is_ms_shipped = 0
) o
 ORDER BY
     case @oby
     when 1 then CONVERT(VARCHAR(19), COALESCE(o.modify_date, o.create_date), 112)
     when 2 then o.[name]
     when 3 then o.[type]
     when 4 then convert(char(19), o.object_id)
     else '' end  COLLATE database_default ASC
   , case @oby
     when -1 then CONVERT(VARCHAR(19), COALESCE(o.modify_date, o.create_date), 112)
     when -2 then o.[name]
     when -3 then o.[type]
     when -4 then convert(char(19), o.object_id)
     else '' end  COLLATE database_default DESC
END