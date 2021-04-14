backup database AdventureWorksDW2014
	to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'
WITH FORMAT
,INIT
,MEDIADESCRIPTION='AdventureWorks backup'
,MEDIANAME='AdventureWorksBackup jobs'
,NAME='AdventureWorks full backup'
,CHECKSUM
go

create table cooltable(id int primary key identity, name varchar(50));

drop table cooltable;
insert into cooltable default values;

ALTER DATABASE AdventureWorksDW2014 SET RECOVERY FULL
GO

backup log AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW20143.trn'
with noformat, noinit,checksum;

--noinit:add to the current file

backup database AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_diff2.bak'
with differential,noinit
,checksum
go

insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;

backup log AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW20142.trn'
with noformat, noinit,checksum;

insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;

backup log AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW20141.trn'
with noformat, noinit,checksum;

insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;

backup database AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_diff1.bak'
with differential,noinit
,checksum
go

insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;
insert into cooltable default values;

backup log AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW20145.trn'
with noformat, noinit,checksum;

use master
go
backup log AdventureWorksDW2014
to disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW20146_tail.trn'
with no_truncate
,noformat
,noinit
,name='AdventureWorksDW2014 tail log backup'
,norecovery
,checksum
restore verifyonly from disk= 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'

restore headeronly from disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'

restore filelistonly from disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'

restore labelonly from disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'