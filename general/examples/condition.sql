select * from Employees
go
create procedure emp_for_raise_proc(@p_empid int)
as 
declare
@v_empcity varchar(25),
@v_empname varchar(25)
begin
	select @v_empcity=city,
	@v_empname=FirstName
	from Employees
	where EmployeeID=@p_empid

	if @v_empcity='London' 
		print 'This employee is up for a raise (go london) -- &amp;gt;'+@v_empname;
	else
		print 'This employee is not up for a raise  -- &amp;gt;'+@v_empname;
end

exec emp_for_raise_proc 5;