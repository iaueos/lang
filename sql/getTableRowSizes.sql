CREATE or ALTER PROCEDURE GetTableRowSizes
  @names varchar(8000)=null
  , @do int = 0
AS  BEGIN
DECLARE @TX TABLE (s varchar(50), t VARCHAR(128), d int, w int) ;
insert into @tx (s, t, d, w)
select case when d> 1 then substring(v,1,d-1) else '' end s
 , case when d > 1 then substring(v, d+1, len(v)-d) else v end t
 , d, w
from (
   select value v, charindex('.', value) d, charindex('%', value) w
   from string_split(@names, ' ')  x
   where nullif(value,'') is not null
 )q ;
if (select count(1) from @tx) < 1
begin
   insert into @tx (s) valueS(null);
end ;
if @do = 1
begin
   select S, T, D, W from @tx;
end
SELECT
    SchemaName, TableName, RowCounts, TotalSpaceMB, UsedSpaceMB, UnusedSpaceMB
FROM (
SELECT
      s.Name AS SchemaName
    , t.NAME AS TableName
    , p.rows AS RowCounts
    , SUM(a.total_pages) /128.0 AS TotalSpaceMB
    , SUM(a.used_pages) /128.0 AS UsedSpaceMB
    , (SUM(a.total_pages) - SUM(a.used_pages)) /128.0  AS UnusedSpaceMB
FROM      sys.tables t
JOIN      sys.indexes i ON t.OBJECT_ID = i.object_id
JOIN      sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
JOIN      sys.allocation_units a ON p.partition_id = a.container_id
LEFT JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN       @tx x
  on (NULLIF(@names, '') IS NULL)
  or (   (nullif(x.t,'') is null or ((x.w = 0 and t.name = x.t) or (x.w > 0 and t.name like x.t)))
     and (x.d = 0 or x.s = s.Name)
     )
WHERE t.NAME NOT LIKE 'dt%'
  AND t.is_ms_shipped = 0
  AND i.OBJECT_ID > 255
GROUP BY
    t.Name, s.Name, p.Rows
    ) a ORDER BY 4 desc, 1
END