USE Northwind
GO
alter PROCEDURE MYFIRSTPRO
AS
	DECLARE @v_int int;
	set @v_int=5;
begin
	print @v_int;
	
	
end;

exec MYFIRSTPRO;