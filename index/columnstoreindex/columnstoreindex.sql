use AdventureWorksDW2012
GO

create table t_colstore
( accountkey int not null,
accountdescription nvarchar(50) null,
accounttype nvarchar(50) null,
accountcodealternatekey int);

--drop table t_colstore

insert into t_colstore
select AccountKey,AccountDescription,AccountType,AccountCodeAlternateKey from 
AdventureWorksDW2014.dbo.dimAccount;

create clustered columnstore index t_colstore_cci on t_colstore with(DATA_COMPRESSION=COLUMNSTORE)

--check the view

select * from sys.dm_db_column_store_row_group_physical_stats
where object_id=object_id('t_colstore');

--check the partition

select * from sys.partitions where object_id=object_id('t_colstore');

--change compression to archive
create clustered columnstore index t_colstore_cci on t_colstore
with (DROP_EXISTING=ON,
DATA_COMPRESSION=COLUMNSTORE_ARCHIVE)

--check the partition

select * from sys.partitions where object_id=object_id('t_colstore');

alter index t_colstore_cci on t_colstore
rebuild with(DATA_COMPRESSION=COLUMNSTORE)

drop index t_colstore_cci on t_colstore

create nonclustered columnstore index t_colstore_cci 
on t_colstore(accountkey,accountdescription)

create nonclustered columnstore index t_colstore_cci2
on t_colstore(accounttype)
--multiple columnstore indexes are not supported

insert into t_colstore values(-1,'1','1',1);
--nonclustered columnstore index is not readonly in 2016

--modify table by adding a new column
Alter table t_colstore add new_column_added int null;
select * from t_colstore;

--drop column
alter table t_colstore drop column new_column_added;
select * from t_colstore;

--look at the data compression
--show data compression
--ccitest is a 11 million row table with column store index
--citest is a 11 million row table with btree
--show the rowcount and the schema

use AdventureWorksDW2014
go
select * into temp_cci_finance from dbo.FactFinance;
create clustered columnstore index cci_finance on dbo.FactFinance;

select * into temp_finance from dbo.FactFinance;

create clustered index ci_finance on temp_finance

sp_spaceUsed SST_SiteStatArchive;

Use AdventureWorksDW2014
Go
--sp_spaceUsed t_colstore;
sp_spaceUsed FactFinance;
sp_spaceUsed temp_Finance;


alter database AdventureWorksDW2014 set compatibility_level=130



drop table ccitest_Temp;
go

select * into ccitest_temp from ccitest where 1=2;
create clustered columnstore index ccitest_temp_cci on ccitest_temp;


---query performance:
