SELECT col.name,
       type_name(col.system_type_id) AS data_type,
       col.is_nullable,
       col.max_length,
       col.precision,
       col.scale,
       def.definition AS default_value
FROM sys.all_columns col
  JOIN sys.table_types tt ON tt.type_table_object_id = col.object_id
  JOIN sys.schemas s ON tt.schema_id = s.schema_id
  LEFT JOIN sys.default_constraints def
         ON def.object_id = col.default_object_id
        AND def.parent_column_id = col.column_id
WHERE tt.name = 'INFO_TABLE'
AND   s.name = 'dbo'
ORDER BY col.column_id

