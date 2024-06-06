declare @x table (nm varchar(50)); 

insert into @x (nm) values ('siji'),('loro'),('telu'); 

select nmall =stuff(
(select ','+nm 
from @x x 
for xml path('')), 1, 1, '') 