USe AdventureWorksDW2014
GO
begin tran;

update dbo.FactSalesQuota set EmployeeKey=286 where SalesQuotaKey=6;


select * from dbo.FactSalesQuota;