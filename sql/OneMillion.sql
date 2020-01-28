-- generate one million row 

WITH x AS
(
  SELECT 1 a union
  SELECT 2 a union
  SELECT 3 a union
  SELECT 4 a union
  SELECT 5 a union
  SELECT 6 a union
  SELECT 7 a union
  SELECT 8 a union
  SELECT 9 a union
  SELECT 10 a
)
SELECT row_number() OVER (ORDER BY a.a,b.a,c.a,d.a,e.a,f.a) AS n
FROM x a
  CROSS JOIN x b
  CROSS JOIN x c
  CROSS JOIN x d
  CROSS JOIN x e
  CROSS JOIN x f
