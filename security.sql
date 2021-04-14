use master
go
create login bob with password='abcd123'
,default_database=TmsEPrd

create login mikey with password='2134abcd'
,default_database=AdventureWorks2014
,check_policy=off

create login brandon
with password='6789hijk'
,default_database=AdventureWorks2014
,check_policy=on
,check_expiration=off;

create login michael
with password='8978abcd'
,default_database=AdventureWorks2014
,check_policy=on
,check_expiration=off


create server role serverconfigadmin;
go
grant control server to serverconfigadmin;
go

alter server role serverconfigadmin
add member brandon;


