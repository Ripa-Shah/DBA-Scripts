Alter function [dbo].[showDegreeDef_InlineTableValuedFunction]()
RETURNS TABLE
AS
RETURN
(
	
	with [degreeCTE](degree,degree_desc) AS
	(
		select degree,degree_Desc from DEGREE_DEFINITION 
	)
	select * from [degreeCTE]
)
GO
select * from [dbo].[showDegreeDef_InlineTableValuedFunction]();
GO