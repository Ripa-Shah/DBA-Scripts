select GETUTCDATE();
select GETDATE();

declare @local_time varchar(50),
@utc_time varchar(50);

set @local_time=GETDATE();
set @utc_time=GETUTCDATE();

SELECT 
    CONVERT(VARCHAR(40), @local_time) 
        AS 'Server local time';

SELECT 
    CONVERT(VARCHAR(40), @utc_time) 
        AS 'Server UTC time'

SELECT 
    CONVERT(VARCHAR(40), DATEDIFF(hour, @utc_time, @local_time)) 
        AS 'Server time zone';
GO

