select * into temp_NewFactCurrencyRate from dbo.NewFactCurrencyRate;
sp_helpindex 'temp_NewFactCurrencyRate';
sp_helpstats 'temp_NewFactCurrencyRate';
use WideWorldImporters
select * into peoplecopy from Application.People;
sp_helpindex 'peoplecopy';
sp_helpstats 'peoplecopy';
use testdb
drop table phonelog;
create table phoneLog
(phonelogid int identity(1,1) primary key,
logrecorded datetime2 null,
phonenumbercalled nvarchar(100) null,
calldurationms int null);



select * from phoneLog;

select * from sys.indexes where OBJECT_NAME(object_id)=N'phonelog';

select * from sys.key_constraints where OBJECT_NAME(parent_object_id)=N'phoneLog';

create nonclustered index ix_logrecorded
on phonelog(logrecorded);
go

--insert some data into the table

set nocount on
declare @count int =0;
while @count<500
begin
insert into phoneLog(logrecorded,phonenumbercalled,calldurationms)
values(SYSDATETIME(),
'999-9999',
CAST(rand()*1000 as int));
set @count+=1;
end 
go

select * from sys.dm_db_index_physical_stats(DB_ID(),
object_id('PhoneLog'),null,null,'detailed');

go

set nocount on
declare @count int =0;
while @count<800 begin
update dbo.phoneLog set phonenumbercalled=REPLICATE('9',CAST(rand()*100 as int))
where phonelogid =@count%1000;
if @count%100=0
print @count;
set @count+=1;
end;

--check fragmentation
select * from sys.dm_db_index_physical_stats(DB_ID(),
object_id('PhoneLog'),null,null,'detailed');

select * from sys.dm_db_index_operational_stats(db_id(),null,null,null);

--it is harder to identify unused index if it is unique

---difference between heap and clustered index
--non clustered index
--heap is a reference index id =0, clustered index indexid=1
--nonclustered index >2
--seperate object to table
--physical ordering clustered index
--clusteredindex is analogy book where non clustered index is back of the book
--leaf level contains a pointer to the table where the rest of the columns can be ---found
--A covering index is an index  that can provide all the column data  required to fulfil a query
--now the include clause is used to insert column data into the leaf node of a non clusterd index

create table dbo.Book
(isbn varchar(20) primary key,
title nvarchar(50) not null,
releasedate date null,
publisherid int null);

create nonclustered index ix_book_publisher
on dbo.book(publisherid,releasedate desc);

select publisherid, title, releasedate
from dbo.Book
where releasedate>DATEADD(year,-1,SYSDATETIME())
order by publisherid,releasedate desc;

create nonclustered index ix_book_publisher
on dbo.book(publisherid,releasedate desc)
include(title)
with drop_existing;

use AdventureWorks
Go

select * from sys.index_columns;

---filter index
--filter index uses the where clause to limit the rows that index includes
--maintain index for very small amount of data
--top 100 data
create nonclustered index ix_customer_city on dbo.Lkp_Customer
(
StreetAddress,
city)
where region='AS'

--rebuild index
--needs more space in the database
--performed as a single transaction
--beware of logspace requirement
--by default offline operation

--reorganize index
--sorts the page and is always online
--less transanction log space
--work isn't lost if intruppted

Alter index ix_customer_city
on dbo.Lkp_customer
rebuild 
with(online=on,maxdop=4);

--slower than offline operation
--switch the point over new index
--space consideration since duplicating database
--row versioning affect tempdb
--enterprise only --lot of overhead
