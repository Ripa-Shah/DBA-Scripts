use AdventureWorksDW2014
GO

alter procedure GetEmployeeByDepartment
@dept varchar(80)
as
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [EmployeeKey]
      ,[FirstName]
      ,[LastName]
      ,[MiddleName]
      ,[NameStyle]
      ,[Title]
      ,[HireDate]
      ,[BirthDate]
      ,[LoginID]
      ,[EmailAddress]
      ,[Phone]
      ,[MaritalStatus]
      ,[EmergencyContactName]
      ,[EmergencyContactPhone]
      ,[SalariedFlag]
      ,[Gender]
      ,[PayFrequency]
      ,[BaseRate]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[SalesPersonFlag]
      ,[DepartmentName]
      ,[StartDate]
      ,[EndDate]
      ,[Status]
  FROM [AdventureWorksDW2014].[dbo].[DimEmployee] as de
 where de.DepartmentName=@dept;
 go

 --show query plan for production
 dbcc freeproccache
 go
 exec getemployeebydepartment 'Production'

  --show query plan for marketing
 dbcc freeproccache
 go
 exec getemployeebydepartment 'Marketing'


