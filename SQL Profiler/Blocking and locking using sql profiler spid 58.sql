begin tran;

update FactSalesQuota set EmployeeKey=286 where SalesQuotaKey=6;


select * from FactSalesQuota;