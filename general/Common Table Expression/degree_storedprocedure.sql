create procedure [dbo].[showDegreeDef]
as
begin
set nocount on;
with [degreeCTE](degree,degree_desc) AS
(
	select degree,degree_Desc from DEGREE_DEFINITION 
)
select * from [degreeCTE];
end
GO

execute [dbo].[showDegreeDef];
GO