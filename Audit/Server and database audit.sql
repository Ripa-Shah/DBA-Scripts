use master
Go
--create a SQL Server audit and define its target as application log
create server audit FinanceDevLog To APPLICATION_LOG
WITH( QUEUE_DELAY=1000, ON_FAILURE=Continue);
GO

use AdventureWorksDW2014
GO

--create a database audit specification for select activity on the finance schema
create database audit specification financespec
for server audit FinanceDevLog
ADD(select on schema::dbo by public);
GO

select * from sys.server_audits;

use master;
GO

--enable the server audit
Alter Server audit FinanceDevLog WITH(STATE=ON);
GO;

---change the database
use AdventureWorks2014DW
GO

--enable the financespec audit specification

alter database audit specification financespec with (state=on);
GO;

select * from sys.server_audits;
select * from sys.database_audit_specifications;
select * from sys.database_audit_specification_details;


--generate an auditable event by querying a table in the dbo schema.
use AdventureWorks2014DW
Go
select * from dbo.FactFinance;

Go

--check the content of application log