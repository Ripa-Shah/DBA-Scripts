create procedure empname
as
declare
	@v_name varchar(25)
begin
	select @v_name=FirstName
	from Employees
	where EmployeeID=5;
	print @v_name;
end;

exec empname;