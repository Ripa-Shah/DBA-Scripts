use AdventureWorksDW2014
go

set statistics time on
go

set statistics io on
go
--show the execution plan and query plann
dbcc traceoff(9453,-1)
go
use AdventureWorksDW2014
go
select * into temp_cci_finance from dbo.FactFinance;
create clustered columnstore index cci_finance on dbo.temp_cci_finance
with (DROP_EXISTING=ON,
DATA_COMPRESSION=COLUMNSTORE)

select * into temp_finance from dbo.FactFinance;

create clustered index ci_finance on temp_finance
select count(*),datekey from dbo.temp_finance group by DateKEy;
select count(*),datekey from dbo. group by DateKey;

--turn off batch mode
dbcc traceon(9453,-1)
go
select count(*),datekey from dbo.FactSalesQuota group by DateKEy;
select count(*),datekey from dbo.FactPRoductInventory group by DateKey;

dbcc dropcleanbuffers;
select min(financekey),min(organizationkey),min(DepartmentGroupKey),
min(AccountKey),min(DateKey),min(ScenarioKey) from dbo.FactFinance;