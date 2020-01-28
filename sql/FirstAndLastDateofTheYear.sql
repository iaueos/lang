-- get first and last day of the year
SELECT
   DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) AS StartOfYear,
   DATEADD(yy, DATEDIFF(yy,0,getdate()) + 1, -1) AS EndOfYear;
  



