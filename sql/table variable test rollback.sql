
BEGIN TRY 
	declare @x table (seq int, at varchar(200), ere varchar(50)); 
	declare @I int;
	BEGIN TRANSACTION 
	set @I = 1;
	exec dbo.sp_Addlog 'insert into angka 2', '2', '?', 0;
	INSERT INTO ANGKA(	BIL,SEBUT, TES) VALUES ( 2, 'loro', 'two');
	exec dbo.sp_Addlog 'insert into angka 4', '4', '?', 0;
	INSERT INTO ANGKA( BIL, SEBUT, TES) VALUES ( 4, 'ampat', 'four');


	insert into @x values(1, 'ini satu', 'one');
	exec dbo.sp_Addlog 'doc type pre err violation', '5', '?', 0;
	INSERT INTO DocType VALUES (1, 'GAGAL');
	exec dbo.sp_Addlog 'doc type post err violation', '6', '?', 0;

	insert into @x values(2, 'ini dua', 'two');
	COMMIT;
	SELECT * FROM @X;
END TRY 
BEGIN CATCH 
	ROLLBACK TRANSACTION; 
	declare @1 int, @2 varchar(200), @3 varchar(50);
	set @2 = ERROR_MESSAGE() 
	set @3 = ERROR_PROCEDURE();
	INSERT INTO @x values(3, @2, @3);
	
	declare a cursor local for select * from @x;
	open a;
	
	fetch next from a into @1, @2, @3;
	while @@FETCH_STATUS = 0
	begin
		exec dbo.sp_Addlog @2, @3, '?', 0;
		fetch next from a into @1, @2, @3;
	end;
	close a;
	deallocate a;
	
	SELECT * FROM @x;	
END CATCH; 



-- delete from logd
 select * from logd;