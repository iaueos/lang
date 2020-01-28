-- Get Only date part of current Date 
SELECT DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))

