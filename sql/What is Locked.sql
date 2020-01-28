-- What is Locked 

--CREATE VIEW WhatIsLocked
--AS
SELECT
Locks.request_session_id AS SessionID,
Obj.Name AS LockedObjectName,
DATEDIFF(second,ActTra.Transaction_begin_time, GETDATE()) AS Duration,
ActTra.Transaction_begin_time,
COUNT(*) AS Locks
FROM    sys.dm_tran_locks Locks
JOIN sys.partitions Parti ON Parti.hobt_id = Locks.resource_associated_entity_id
JOIN sys.objects Obj ON Obj.object_id = Parti.object_id

JOIN sys.dm_exec_sessions ExeSess ON ExeSess.session_id = Locks.request_session_id
JOIN sys.dm_tran_session_transactions TranSess ON ExeSess.session_id = TranSess.session_id
JOIN sys.dm_tran_active_transactions ActTra ON TranSess.transaction_id = ActTra.transaction_id
WHERE   resource_database_id = db_id() AND Obj.Type = 'U'
GROUP BY ActTra.Transaction_begin_time,Locks.request_session_id, Obj.Name
