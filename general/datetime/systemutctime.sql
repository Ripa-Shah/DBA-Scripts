select SYSDATETIME();
SELECT 
    CONVERT(TIME, SYSDATETIME()) Result;

SELECT 
   SYSUTCDATETIME() utc_time;

SELECT 
    CONVERT(DATE, SYSUTCDATETIME()) utc_date;

SELECT 
    CONVERT(DATE, SYSUTCDATETIME()) utc_time;