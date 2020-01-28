Declare @biji TABLE(id int identity(1,1), KU VARCHAR(10), n int); 


INSERT INTO @BIJI (KU,n) VALUES('siji',1),('loro',2),('telu',3),('papat',4),( 'limo',5),( 'anem',6),( 'putu',7),( 'wolu',8),('sanga',9),( 'dasa',10); 

select biji.KU, n.n from  @biji biji cross join dbo.FN_NUMBERS(10) n 
where n.n <= biji.n 
order by id, n 