declare @x table (nm varchar(20), id int);

insert into @x values ('siji',1);
insert into @x values ('loro',2);
insert into @x values ('telu',3);
insert into @x values ('papat',4);

		--select ''', ''' + x.NM
		--from @x x 
		--for XML path('')

DECLARE @V varchar(max); 

select @v = STUFF(
		(
		select ''', ''' + x.NM
		from @x x 
		for XML path('')
		)
		,1,1,'') + '''';
		
set @V = SUBSTRING(@v, 2, len(@v) -1);		

select @V v ;

