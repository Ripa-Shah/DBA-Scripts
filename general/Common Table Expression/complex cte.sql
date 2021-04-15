declare @pageNum as int;
declare @pageSize as int;
set @pageNum=2;
set @pageSize=10;
;WITH tablesAndColumns AS
(
select OBJECT_NAME(sc.object_id) AS tableName,
name as ColumnName,
ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(sc.object_id)) AS rownum
from sys.columns sc
)

select * from tablesAndColumns;