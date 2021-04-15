create procedure empnamepr(@p_empid int)
as
declare
	@v_name varchar(25)
begin
	 SELECT @v_name = FirstName
        FROM employees
        WHERE employeeID = @p_empid
        PRINT @v_name
end

exec empnamepr 6