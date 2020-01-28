declare @x numeric (16,5) = 123.4567, @i int = -2;
declare @z table (i int, n numeric(16,5));

while @i < 4
begin
	insert @z (i, n) values (@i, round(@x, @i)); 
	set @i = @i + 1;
 end; 
select * from @z; 
