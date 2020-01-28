select 
    DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) firstDayOfMonth
  , DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE()), -1) lastDayOfMonth 
