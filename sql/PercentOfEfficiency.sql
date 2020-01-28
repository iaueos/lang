declare @plan decimal(20) =3600;
declare @actual decimal(20) = 3500; 

select 100 + (((@plan - @actual) / @plan) * 100) as  [percent_of_efficiency] ; 
