WITH 
  mima( mi , ma ) as 
  (
    select 1 as mi, 1000000 as ma 
  ) 
, gen(num) AS 
  ( 
    SELECT mi as num from mima 
    UNION ALL
    SELECT num+1 FROM gen g WHERE g.num+1<=(select max(ma) from mima) 
  )
SELECT num FROM gen
