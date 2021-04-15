alter function [dbo].[recursive](@num integer)
returns integer
as 
begin
	declare @ResultVar as integer=0;
	if(@num>0)
		set @ResultVar=@num+[dbo].recursive(@num-1);
	return @ResultVar;
end
GO

select [dbo].[recursive](10);