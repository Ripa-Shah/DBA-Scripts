use AdventureWorksDW2014
go
alter proc dbo.GetBlueProducts
AS 
begin


SELECT TOP (1000) [ProductKey]
      ,[ProductAlternateKey]
      ,[ProductSubcategoryKey]
      ,[WeightUnitMeasureCode]
      ,[SizeUnitMeasureCode]
      ,[EnglishProductName]
    
      ,[Color]
      ,[SafetyStockLevel]
      ,[ReorderPoint]
      ,[ListPrice]
      ,[Size]
    
      ,[ProductLine]
      ,[DealerPrice]
      ,[Class]
      ,[Style]
      ,[ModelName]
      ,[LargePhoto]
     
      ,[Status]
  FROM [AdventureWorksDW2014].[dbo].[DimProduct]
  where Color='Blue'
  order by ProductKey;
  End;
  go

  Exec dbo.getBlueProducts

  select SCHEMA_NAME(schema_id) as schemaname,
  name as procedurename
  from sys.procedures