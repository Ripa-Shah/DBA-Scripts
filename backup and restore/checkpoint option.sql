Alter Database AdventureWorks2012
set target_recovery_time=90 seconds
go
select name,target_recovery_time_in_seconds from sys.databases;

dbcc dropcleanbuffers
go
use AdventureWorks2012
go
Alter database AdventureWorks2012
set recovery simple
go
checkpoint
use TmsEPrd
go
select * into temp_name_master from dbo.NAME_MASTER;
Alter table temp_name_master
disable trigger all

begin tran
update temp_name_master
set JOB_TIME=GETDATE()
where USER_NAME='Amber';

select OBJECT_NAME(p.object_id), * from sys.dm_os_buffer_descriptors d
join sys.allocation_units au
on au.allocation_unit_id=d.allocation_unit_id
join sys.partitions as p
on au.container_id= case when au.type in (1,3) then p.hobt_id else p.partition_id end
where database_id=DB_ID() and
p.object_id=object_id('temp_name_master')
and is_modified=1;

--let's see in the transaction log
select * from sys.fn_dblog(null,null)
where AllocUnitName like '%name_master%';

select @@TRANCOUNT;

checkpoint
select OBJECT_NAME(p.object_id), * from sys.dm_os_buffer_descriptors d
join sys.allocation_units au
on au.allocation_unit_id=d.allocation_unit_id
join sys.partitions as p
on au.container_id= case when au.type in (1,3) then p.hobt_id else p.partition_id end
where database_id=DB_ID() and
p.object_id=object_id('temp_name_master')
and is_modified=1;

commit transaction

select * from sys.fn_dblog(null,null);