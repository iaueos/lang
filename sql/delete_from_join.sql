create table tb_a ( id int identity (1,1), nm varchar(10), primary key (id)); 
create table tb_b (id int identity(1,1), nma varchar(10), primary key(id));


insert tb_a (nm) 
select value nm from string_split( 'tu wa ga pat ma',' '); 

insert tb_b (nma)
select value nma from string_split('uno dwi tri cat pan', ' '); 

select * from tb_a;
select * from tb_b;
truncate table tb_a;
delete from tb_b where id = 3;
delete from tb_b where id = 1; 

delete a 
from tb_a a 
join tb_b b on a.id = b.id 

--drop table tb_a;
--drop table tb_b;
