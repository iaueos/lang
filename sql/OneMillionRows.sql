-- generate one million row 

with x as (select 1 a union select 2 a union select 3 a union select 4 a union select 5 a union select 6 a union select 7 a union select 8 a union select 9 a union select 10 a ) 
select ROW_NUMBER() OVER (ORDER BY a.a, b.a, c.a, d.a, e.a, f.a)  AS n
from x a cross join x b cross join x c cross join x d cross join x e cross join x f 
