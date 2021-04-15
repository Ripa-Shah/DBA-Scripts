SELECT 
    SYSDATETIMEOFFSET() [datetimeoffset with timezone];

SELECT 
    SYSDATETIMEOFFSET() AS [System DateTime Offset],
    DATEPART(TZoffset, SYSDATETIMEOFFSET()) AS [Timezone Offset];

SELECT 
    SYSDATETIMEOFFSET() AS 'System Date Time Offset', 
    FORMAT(SYSDATETIMEOFFSET(), 'zz') AS 'zz', 
    FORMAT(SYSDATETIMEOFFSET(), 'zzz') AS 'zzz';

SELECT
    DATEPART(year, '2018-05-10') [datepart], 
    DATENAME(year, '2018-05-10') [datename];

SELECT
    DATEPART(year, '2018-05-10') + '1' [datepart], 
    DATENAME(year, '2018-05-10') + '1' [datename] ;

DECLARE @dt DATETIME2= '2020-10-02 10:20:30.1234567 +08:10';

SELECT 'year,yyy,yy' date_part, 
    DATENAME(year, @dt) result
UNION
SELECT 'quarter, qq, q', 
    DATENAME(quarter, @dt)
UNION
SELECT 'month, mm, m', 
    DATENAME(month, @dt)
UNION
SELECT 'dayofyear, dy, y', 
    DATENAME(dayofyear, @dt)
UNION
SELECT 'day, dd, d', 
    DATENAME(day, @dt)
UNION
SELECT 'week, wk, ww', 
    DATENAME(week, @dt)
UNION
SELECT 'weekday, dw, w', 
    DATENAME(weekday, @dt)
UNION
SELECT 'hour, hh' date_part, 
    DATENAME(hour, @dt)
UNION
SELECT 'minute, mi,n', 
    DATENAME(minute, @dt)
UNION
SELECT 'second, ss, s', 
    DATENAME(second, @dt)
UNION
SELECT 'millisecond, ms', 
    DATENAME(millisecond, @dt)
UNION
SELECT 'microsecond, mcs', 
    DATENAME(microsecond, @dt)
UNION
SELECT 'nanosecond, ns', 
    DATENAME(nanosecond, @dt)
UNION
SELECT 'TZoffset, tz', 
    DATENAME(tz, @dt)
UNION
SELECT 'ISO_WEEK, ISOWK, ISOWW', 
    DATENAME(ISO_WEEK, @dt);