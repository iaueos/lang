
DECLARE -- CREATE or alter PROCEDURE GetIndexColumnsUsage
   @tableName VARCHAR(50) = NULL 
 , @indexname VARCHAR(200) = NULL 
 , @Columns VARCHAR(800) = NULL
-- AS BEGIN --Display all indexes along with key columns, included columns and index type
 ;
WITH CTE_Indexes (
    SchemaName, ObjectID, TableName
  , IndexID, IndexName
  , ColumnID, cixid, ColumnNames, IncludeColumns
  , ColumnCount, IndexType, Recursions)
AS
(
SELECT 
   s.name SchemaName, t.object_id ObjectId, t.name TableName
 , i.index_id IndexID, i.name IndexName
 , c.column_id ColumnID, ic.index_column_id cixid
 , CASE ic.is_included_column WHEN 0 THEN CAST(c.name AS VARCHAR(5000)) ELSE '' END ColumnNames
 , CASE ic.is_included_column WHEN 1 THEN CAST(c.name AS VARCHAR(5000)) ELSE '' END IncludeColumns
 , 1 ColumnCount, i.type_desc IndexType, 1 Recursions
FROM sys.schemas AS s with(nolock)
JOIN sys.tables AS t with(nolock) ON s.schema_id = t.schema_id
JOIN sys.indexes AS i with(nolock) ON i.object_id = t.object_id
JOIN sys.index_columns AS ic with(nolock) ON ic.index_id = i.index_id AND ic.object_id = i.object_id
JOIN sys.columns AS c 
  ON c.column_id = ic.column_id AND c.object_id = ic.object_id
 AND ic.index_column_id = 1
UNION ALL
SELECT s.name SchemaName, t.object_id ObjectId, t.name TableName
 , i.index_id IndexId, i.name IndexName
 , c.column_id ColumnID, ic.index_column_id cixid
 , CASE ic.is_included_column 
   WHEN 0 THEN CAST(cte.ColumnNames + ', ' + c.name AS VARCHAR(5000))  
   ELSE cte.ColumnNames 
   END ColumnNames
 , CASE  
	WHEN ic.is_included_column = 1 AND cte.IncludeColumns != '' 
	THEN CAST(cte.IncludeColumns + ', ' + c.name AS VARCHAR(5000))
	WHEN ic.is_included_column = 1 AND cte.IncludeColumns = '' 
	THEN CAST(c.name AS VARCHAR(5000)) 
	ELSE '' 
   END IncludeColumns
 , cte.ColumnCount + 1 ColumnCount
 , i.type_desc IndexType
 , cte.Recursions+1 Recursions
FROM sys.schemas AS s with(nolock)
JOIN sys.tables AS t with(nolock) ON s.schema_id = t.schema_id
JOIN sys.indexes AS i with(nolock) ON i.object_id = t.object_id
JOIN sys.index_columns AS ic with(nolock)  ON ic.index_id = i.index_id AND ic.object_id = i.object_id
JOIN sys.columns AS c with(nolock) ON c.column_id = ic.column_id AND c.object_id = ic.object_id 
JOIN CTE_Indexes cte 
  ON cte.cixid + 1 = ic.index_column_id  
 AND cte.IndexID = i.index_id AND cte.ObjectID = ic.object_id
) 
select z.SchemaName, z.TableName, z.IndexName
  , Row_Number() over(partition by z.ObjectId, z.ColumnChecksum order by z.TotalReads desc, z.IncludeChecksum, z.indexid) SeqR
 , z.TotalReads, z.TotalWrites, z.Columns, z.Included, z.ColumnChecksum, z.IncludeChecksum
 , z.ColumnCount, z.ObjectId, z.IndexId, z.ColId, z.ColIndexId, z.Recursions, z.IndexType
from (
select SchemaName
    , TableName, IndexName
	, sum(x.Reads) TotalReads, sum(x.Writes) TotalWrites
	, max(x.ColumnNames) Columns, Max(x.IncludeColumns) Included
	, ColumnChecksum
	, IncludeChecksum
	, Max(x.ColumnCount) ColumnCount
	, ObjectId, IndexId
	, Max(ColumnID) ColId, Max(ColumnIndexId) ColIndexId, Max(Recursions) Recursions
	, max(IndexType)IndexType 
from (
	select q.SchemaName, q.TableName
	  , q.IndexName
	  , coalesce(s.user_seeks,0) + coalesce(s.user_scans ,0)  + coalesce(s.user_lookups,0) [Reads]
	  , coalesce(s.user_updates ,0) [Writes]
	  , q.ColumnNames, q.IncludeColumns
	  , q.ColumnCount, q.ObjectID, q.IndexID 
	  , q.ColumnID, q.cixid ColumnIndexId, q.Recursions, q.IndexType 
	  , CHECKSUM(q.ColumnNames) ColumnChecksum
	  , CHECKSUM(q.IncludeColumns) IncludeChecksum
	from 
	(
	    SELECT SchemaName, ObjectID, TableName, IndexID, IndexName, ColumnID, cixid
		   , ColumnNames, IncludeColumns, ColumnCount, IndexType, Recursions
	       , RANK() OVER (
		        PARTITION BY ObjectID, IndexID 
	            ORDER BY ColumnCount DESC) 
			 AS LastRecord 
	    FROM CTE_Indexes AS cte
		where (NULLIF(@TableName,'') is null or TableName = @TableName)
		AND (nullif(@IndexName, '') is null or IndexName = @IndexName) 
		AND (NULLIF(@Columns, '') is null or charindex(@columns, ColumnNames) > 0 or charindex(@columns, IncludeColumns) > 0)		
	) q 
	left join sys.dm_db_index_usage_stats s with(nolock)
	on s.OBJECT_ID = Q.ObjectId and s.index_id = Q.IndexId 
	where q.LastRecord =1 
) x 
GROUP BY x.SchemaName, X.TableName, X.IndexName, X.ColumnChecksum, X.IncludeChecksum, X.ObjectId, X.IndexId 
) z
ORDER BY z.TableName, z.ColumnChecksum, z.TotalReads desc, z.IncludeChecksum, z.indexid
OPTION (MAXRECURSION 255)
-- END;