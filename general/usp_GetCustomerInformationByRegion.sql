USE [AdventureWorksDW2014]
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerInformationByRegion]    Script Date: 4/15/2021 11:44:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[GetCustomerInformationByRegion]
@countryregion as varchar(5)

as
begin
SELECT [CustomerKey]
      ,[CustomerAlternateKey]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[NameStyle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Suffix]
      ,[Gender]
      ,[EmailAddress]
      ,[YearlyIncome]
      ,[TotalChildren]
      ,[NumberChildrenAtHome]
      ,[EnglishEducation]
      ,[EnglishOccupation]
      ,[HouseOwnerFlag]
      ,[NumberCarsOwned]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[Phone]
      ,[DateFirstPurchase]
      ,[CommuteDistance]
	  ,[City]
      ,[StateProvinceCode]
      ,[StateProvinceName]
      ,[CountryRegionCode]
  FROM [AdventureWorksDW2014].[dbo].[DimCustomer] as dc
  inner join DimGeography as dg
  on dg.GeographyKey=dc.GeographyKey
  where (dg.CountryRegionCode=@countryregion) or (dg.CountryRegionCode is null and @countryregion is null)
  end;

    --show query plan for marketing
 dbcc freeproccache
 go
 exec dbo.GetCustomerInformationByRegion 'AU' with recompile

    --show query plan for marketing
 dbcc freeproccache
 go
 exec dbo.GetCustomerInformationByRegion 'FR' with recompile


