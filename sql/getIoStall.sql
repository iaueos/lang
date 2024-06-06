SELECT DB_NAME (fs.database_id) AS DatabaseName, 
       mf.type_desc, mf.name [FileName], 
       fs.io_stall, fs.num_of_reads, fs.num_of_writes,
       (cast(mf.size as float)*8)/1024/1024 AS FileSizeinGB,
       mf.physical_name AS FileLocation
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS fs,
      sys.master_files AS mf
WHERE fs.database_id = mf.database_id AND fs.FILE_ID = mf.FILE_ID
ORDER BY fs.io_stall DESC;

select Db.name ,vfs.* from
  sys.dm_io_virtual_file_stats(NULL, NULL) AS VFS
    JOIN sys.databases AS Db 
  ON vfs.database_id = Db.database_id;
    
  SELECT  DB_NAME(vfs.database_id) AS database_name ,physical_name AS [Physical Name],
        size_on_disk_bytes / 1024 / 1024. AS [Size of Disk] ,
        CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [Average Read latency] ,
        CAST(io_stall_write_ms/(1.0 + num_of_writes) AS NUMERIC(10,1)) AS [Average Write latency] ,
        CAST((io_stall_read_ms + io_stall_write_ms)
/(1.0 + num_of_reads + num_of_writes) 
AS NUMERIC(10,1)) AS [Average Total Latency],
        num_of_bytes_read / NULLIF(num_of_reads, 0) AS    [Average Bytes Per Read],
        num_of_bytes_written / NULLIF(num_of_writes, 0) AS   [Average Bytes Per Write]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL) AS vfs
  JOIN sys.master_files AS mf 
    ON vfs.database_id = mf.database_id AND vfs.file_id = mf.file_id
ORDER BY [Average Total Latency] DESC;


SELECT r.session_id, r.wait_type, r.wait_time as wait_time_ms
   FROM sys.dm_exec_requests r JOIN sys.dm_exec_sessions s 
	ON r.session_id = s.session_id 
   WHERE wait_type in ('PAGEIOLATCH_SH', 'PAGEIOLATCH_EX', 'WRITELOG', 
	'IO_COMPLETION', 'ASYNC_IO_COMPLETION', 'BACKUPIO')
   AND is_user_process = 1;

SELECT   LEFT(mf.physical_name,100) dbPhysical,
	 LEFT (mf.physical_name, 2) AS Volume, 
   LEFT(DB_NAME (vfs.database_id),32) AS [Database Name], 
	 ReadLatency = CASE WHEN num_of_reads = 0 THEN 0 ELSE (io_stall_read_ms / num_of_reads) END, 
	 WriteLatency = CASE WHEN num_of_writes = 0 THEN 0 ELSE (io_stall_write_ms / num_of_writes) END, 
	 AvgLatency =  CASE WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
					ELSE (io_stall / (num_of_reads + num_of_writes)) END,
	 LatencyAssessment = CASE WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 'No data' ELSE 
		   CASE WHEN (io_stall / (num_of_reads + num_of_writes)) < 2 THEN 'Excellent' 
				WHEN (io_stall / (num_of_reads + num_of_writes)) BETWEEN 2 AND 5 THEN 'Very good' 
				WHEN (io_stall / (num_of_reads + num_of_writes)) BETWEEN 6 AND 15 THEN 'Good' 
				WHEN (io_stall / (num_of_reads + num_of_writes)) BETWEEN 16 AND 100 THEN 'Poor' 
				WHEN (io_stall / (num_of_reads + num_of_writes)) BETWEEN 100 AND 500 THEN  'Bad' 
				ELSE 'Deplorable' END  END, 
	 [Avg KBs/Transfer] =  CASE WHEN (num_of_reads = 0 AND num_of_writes = 0) THEN 0 
				ELSE ((([num_of_bytes_read] + [num_of_bytes_written]) / (num_of_reads + num_of_writes)) / 1024) END
   FROM sys.dm_io_virtual_file_stats (NULL,NULL) AS vfs  
   JOIN sys.master_files AS mf ON vfs.database_id = mf.database_id 
	 AND vfs.file_id = mf.file_id 
   ORDER BY AvgLatency DESC