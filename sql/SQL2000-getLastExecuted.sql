declare @s table(spid smallint,login_time datetime,last_batch datetime,[status] nchar(30),loginame nchar(128),[text] text)

declare @sql_handle binary(20),@spid smallint
declare c1 cursor for select sql_handle,spid from master..sysprocesses where spid >50
open c1
fetch next from c1 into @sql_handle,@spid 
while (@@FETCH_STATUS =0) 
begin 
    insert into @s
	select spid,login_time,last_batch,[status],loginame,a.text
	from ::fn_get_sql(@sql_handle) a, master..sysprocesses b
	where b.spid = @spid	
	fetch next from c1 into @sql_handle,@spid
end 
close c1
deallocate c1
select * from @s



