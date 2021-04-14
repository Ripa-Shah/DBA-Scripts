use tempdb
go

create table dbo.phonelog 
(phonelogid int identity(1,1) primary key,
logrecorded datetime2 not null,
phonenumbercalled nvarchar(100) not null,
calldurationms int not null
);

set nocount on;
declare @counter int =0;

while @counter<10000 begin
insert into dbo.phonelog(logrecorded,phonenumbercalled,calldurationms) values
(SYSDATETIME(),'999-9999',CAST(rand()*1000 as int));

set @counter+=1;
end;
go

select * from sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.phonelog'),null,null,'detailed');

alter index all on dbo.phonelog rebuild;

select * from sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.phonelog'),null,null,'detailed');
