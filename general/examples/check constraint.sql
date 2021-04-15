--create table dbo.Payroll
--(
--	id int primary key,
--	positionid int,
--	salaryType nvarchar(10),
--	salary decimal(9,2),
--	check(salary < 150000)
--);

--create table dbo.PayrollCol
--(
--	id int primary key,
--	positionid int,
--	salarytype nvarchar(10),
--	salary decimal(9,2),
--	constraint ck_payroll_salary
--	check(salary > 10 and salary < 150000)
--);

--Alter table dbo.Payroll
--with nocheck add constraint ck_payroll_salarytype
--check (salaryType in ('Monthly','Hourly','Weekly'))

--Alter table dbo.Payroll with nocheck
--add constraint ck_payroll_salry_n_salarytype
--check (salarytype in('Monthly','Hourly','Weekly','Annually')
--and salary > 10 and salary < 150000);

Alter table dbo.payroll with nocheck
 ADD  CONSTRAINT CK_Payroll_SalaryType_Based_On_Salary
	  CHECK  ((SalaryType = 'Hourly' and Salary < 100.00) or
	          (SalaryType = 'Monthly' and Salary < 10000.00) or
	          (SalaryType = 'Annual'));