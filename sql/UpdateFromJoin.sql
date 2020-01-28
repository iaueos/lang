DECLARE @BUAH TABLE (id int, N VARCHAR(30) );
DECLARE @sayur table (id int, n varchar(30));
insert into @BUAH values (1, 'pepaya');
insert into @BUAH values  (2, 'mangga');
insert into @BUAH values (3, 'pisang');
insert into @BUAH values (4, 'jambu');
insert into @sayur values (1, 'kangkung');
insert into @sayur values (2, 'tomat');
insert into @sayur values (3,'cabe');
insert into @sayur values  (4, 'bengkoang');

update @BUAH
set N = s.n
from @sayur s -- where s.n  ='tomat'
join @buah b on b.id = s.id 
where s.n = 'tomat';
 
select * from @BUAH;
select * from @sayur;
