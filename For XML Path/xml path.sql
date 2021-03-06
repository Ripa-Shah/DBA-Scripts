/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Age]
      ,[Gender]
      ,[Total_Bilirubin]
      ,[Direct_Bilirubin]
      ,[Alkaline_Phosphotase]
      ,[Alamine_Aminotransferase]
      ,[Aspartate_Aminotransferase]
      ,[Total_Protiens]
      ,[Albumin]
      ,[Albumin_and_Globulin_Ratio]
      ,[Dataset]
  FROM [TestDB].[dbo].[LiverDisease]
   FOR XML PATH('LiverDisease'), ROOT('Disease')