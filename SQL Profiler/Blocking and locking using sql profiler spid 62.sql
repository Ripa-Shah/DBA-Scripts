select * from dbo.FactSalesQuota;

begin tran;

update dbo.FactSalesQuota set EmployeeKey=287 where SalesQuotaKey=1;