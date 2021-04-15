create procedure TablesAndColumnsPager

	@pageNum int,
	@pageSize int
AS 
BEGIN
	SET NOCOUNT ON;
	;WITH TablesAndColumns AS
	(
		SELECT OBJECT_NAME(sc.object_id) as TableName,
		sc.name AS ColumnName,
		ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(sc.OBJECT_ID)) AS RowNum
		FROM sys.columns sc
	)
	select * from TablesAndColumns 
	where RowNum between (@pageNum-1) * @pageSize + 1
	AND @pageNum * @pageSize;
END


