create function [dbo].[departmentfn]()
RETURNS INT
AS
BEGIN
DECLARE @Results as int;
	WITH DepartmentCTE(dept_cde,dept_desc) AS
	(
		select dept_cde,dept_desc from DEPARTMENT
	)
		select @Results=count(1) from DepartmentCTE
	
		return @Results;
end
GO
select [dbo].[DEPARTMENTfn]()
	