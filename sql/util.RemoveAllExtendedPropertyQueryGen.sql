--tables

SELECT 'EXEC sp_dropextendedproperty @name = ''' 
	+ e.name  + ''' ,@level0type = ''schema'' ,@level0name = ' 
	+ object_schema_name (e.major_id) + ',@level1type = ''view'',@level1name = ''' 
	+ object_name (e.major_id) + ''''
FROM sys.extended_properties e
WHERE e.class_desc = 'OBJECT_OR_COLUMN'
AND   e.minor_id = 0
and e.name in ('MS_DiagramPane1', 'MS_DiagramPane2', 'MS_DiagramPaneCount', 'MS_Description')

 

--columns
SELECT 'EXEC sp_dropextendedproperty @name = ''MS_Description'' ,@level0type = ''schema'' ,@level0name = ' 
	+ object_schema_name (extended_properties.major_id) 
	+ ',@level1type = ''table'',@level1name = ' 
	+ object_name (extended_properties.major_id) 
	+ ',@level2type = ''column'',@level2name = ' 
	+ columns.name
FROM sys.extended_properties
  JOIN sys.columns ON columns.object_id = extended_properties.major_id AND columns.column_id = extended_properties.minor_id
WHERE extended_properties.class_desc = 'OBJECT_OR_COLUMN'
AND   extended_properties.minor_id > 0
AND   extended_properties.name = 'MS_Description'
