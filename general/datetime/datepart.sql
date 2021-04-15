DECLARE @d DATETIME = '2019-01-01 14:30:14';
SELECT 
   DATEPART(year, @d) year, 
   DATEPART(quarter, @d) quarter, 
   DATEPART(month, @d) month, 
   DATEPART(day, @d) day, 
   DATEPART(hour, @d) hour, 
   DATEPART(minute, @d) minute, 
   DATEPART(second, @d) second;