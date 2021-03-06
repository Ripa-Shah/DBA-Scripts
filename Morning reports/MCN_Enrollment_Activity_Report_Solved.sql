USE [TmsEPrd]
GO
/****** Object:  StoredProcedure [dbo].[MCN_Enrollment_Activity_Report]    Script Date: 11/12/2015 09:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  Ripa Shah
-- Create date: 7/3/2016
-- Description:	Daily Enrollment Activity Report
-- =============================================
ALTER PROCEDURE [dbo].[MCN_Enrollment_Activity_Report]
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @DATATABLE TABLE (
		ID_NUM int,
		ADDS nvarchar(1024),
		DROPS nvarchar(1024),
		WITHS nvarchar(1024)
		)

DECLARE @YR_CDE char(4), @TRM_CDE char(2), @CRS_CDE char(30), @ID_NUM int,
		@ERRMSG varchar(255), 
		@MESSAGE nvarchar(MAX), @MESSAGELINE nvarchar(MAX), @LIST nvarchar(MAX), @DAYSBACK int,
		@FROM nvarchar(32), @TO nvarchar(128), @SUBJ nvarchar(64)

-- Don't Run on Monday
IF (SELECT DATEPART(dw,GETDATE())) = 2   RAISERROR(5000,15,1);


-- Report three days back on tuesdays
IF (SELECT DATEPART(dw,GETDATE())) = 3 SET @DAYSBACK = -3 ELSE SET @DAYSBACK = -1


SELECT 	@FROM = 'no-reply@mesalands.edu',
		@TO = 'MCN_ENR_ACTIVITY_REPORT@mesalands.edu',
		
		@SUBJ = 'Enrollment activity report for ' + CONVERT(CHAR(2),ABS(@DAYSBACK)) + ' day(s) prior to ' + CONVERT(CHAR(10),getdate(),101)



DECLARE RESULT_CURSOR CURSOR FOR

	SELECT DISTINCT(ID_NUM)
	FROM STUDENT_CRS_HIST
	WHERE ADD_DTE >= Convert(char(8),DATEADD(dd,@DAYSBACK,GETDATE()),112)
	and ADD_DTE < Convert(char(8),getdate(),112)

OPEN RESULT_CURSOR
	WHILE (7.31=7.31)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @ID_NUM
		IF (@@FETCH_STATUS = -1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end
		
		SELECT @LIST = NULL
					
		SELECT @LIST = COALESCE(@LIST + '<br/>'+ CHAR(13) ,'') +  RTRIM(CRS_CDE) + ' (' + RTRIM(YR_CDE) + '-' + RTRIM(TRM_CDE) + ') on ' + CONVERT(CHAR(10),ADD_DTE,101)
		FROM STUDENT_CRS_HIST
		WHERE ADD_DTE >= Convert(char(8),DATEADD(dd,@DAYSBACK,GETDATE()),112)
		and ADD_DTE < Convert(char(8),getdate(),112)
		AND ID_NUM = @ID_NUM

		INSERT INTO @DATATABLE (ID_NUM, ADDS) VALUES (@ID_NUM, @LIST)

END

DEALLOCATE RESULT_CURSOR

DECLARE RESULT_CURSOR CURSOR FOR

	SELECT ID_NUM, CRS_CDE
	FROM STUDENT_CRS_HIST
	WHERE DROP_DTE >= Convert(char(8),DATEADD(dd,-1,GETDATE()),112)
	and DROP_DTE < Convert(char(8),getdate(),112) 

OPEN RESULT_CURSOR
	WHILE (7.31=7.31)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @ID_NUM, @CRS_CDE
		IF (@@FETCH_STATUS = -1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end

		SELECT @LIST = NULL
					
		SELECT @LIST = COALESCE(@LIST + '<br/>'+ CHAR(13) ,'') +  RTRIM(CRS_CDE) + ' (' + RTRIM(YR_CDE) + '-' + RTRIM(TRM_CDE) + ') on ' + CONVERT(CHAR(10),DROP_DTE,101)
		FROM STUDENT_CRS_HIST
		WHERE DROP_DTE >= Convert(char(8),DATEADD(dd,@DAYSBACK,GETDATE()),112)
		and DROP_DTE < Convert(char(8),getdate(),112)
		AND ID_NUM = @ID_NUM

		INSERT INTO @DATATABLE (ID_NUM, DROPS) VALUES (@ID_NUM, @LIST)

END

DEALLOCATE RESULT_CURSOR
DECLARE RESULT_CURSOR CURSOR FOR

	SELECT ID_NUM, CRS_CDE
	FROM STUDENT_CRS_HIST
	WHERE WITHDRAWAL_DTE >= Convert(char(8),DATEADD(dd,-1,GETDATE()),112)
	and WITHDRAWAL_DTE < Convert(char(8),getdate(),112)

OPEN RESULT_CURSOR
	WHILE (7.31=7.31)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @ID_NUM, @CRS_CDE
		IF (@@FETCH_STATUS = -1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end

		SELECT @LIST = NULL
					
		SELECT @LIST = COALESCE(@LIST + '<br/>'+ CHAR(13) ,'') +  RTRIM(CRS_CDE) + ' (' + RTRIM(YR_CDE) + '-' + RTRIM(TRM_CDE) + ') on ' + CONVERT(CHAR(10),WITHDRAWAL_DTE,101)
		FROM STUDENT_CRS_HIST
		WHERE WITHDRAWAL_DTE >= Convert(char(8),DATEADD(dd,@DAYSBACK,GETDATE()),112)
		and WITHDRAWAL_DTE < Convert(char(8),getdate(),112)
		AND ID_NUM = @ID_NUM

		INSERT INTO @DATATABLE (ID_NUM, WITHS) VALUES (@ID_NUM, @LIST)

END

DEALLOCATE RESULT_CURSOR


SELECT @MESSAGE = '<html>' + CHAR(13)

SELECT @MESSAGE = @MESSAGE + '<link rel="stylesheet" type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">'  + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.2.min.js"></script>' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>' + CHAR(13)

SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf-8">' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			$(document).ready(function() { ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '				$(''#results'').dataTable(); ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			} );' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '		</script> ' + CHAR(13)


SET @MESSAGE = @MESSAGE + '<style> body { font-family:Arial; } table {border-collapse:collapse;} table,th, td {border: 1px solid black;} </style>' + CHAR(13) 
SET @MESSAGE = @MESSAGE + '<table id ="results">'+ CHAR(13) 
SET @MESSAGE = @MESSAGE + '<thead><tr><th>ID Number</th>' 
SET @MESSAGE = @MESSAGE + '<th>Name</th>'
SET @MESSAGE = @MESSAGE + '<th>Adds</th>'
SET @MESSAGE = @MESSAGE + '<th>Drops</th>' 
SET @MESSAGE = @MESSAGE + '<th>Withdrawls</th> </thead>'+ CHAR(13) 

DECLARE RESULT_CURSOR CURSOR FOR

	SELECT '<tr><td>' + CONVERT(CHAR(7),NAME_MASTER.ID_NUM) + '</td><td>' +RTRIM(LAST_NAME) +', ' + RTRIM(FIRST_NAME) + '</td><td>' + ISNULL(ADDS,'&nbsp;') + '</td><td>' + ISNULL(DROPS,'&nbsp;') +  '</td><td>' + ISNULL(WITHS,'&nbsp;') + '</td></tr>' + CHAR(13)
	FROM @DATATABLE d, NAME_MASTER
	WHERE d.ID_NUM = NAME_MASTER.ID_NUM
	ORDER BY LAST_NAME

OPEN RESULT_CURSOR
	WHILE (7.31=7.31)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @MESSAGELINE
		IF (@@FETCH_STATUS = -1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end
	
		SET @MESSAGE = @MESSAGE + @MESSAGELINE

	END
DEALLOCATE RESULT_CURSOR

SET @MESSAGE = @MESSAGE + '</table>'


SET @MESSAGE = @MESSAGE + '<pre>This report is a custom report generated by a stored procedure, please contact Institutional Technology for support</pre>'
SET @MESSAGE = @MESSAGE + '<pre>This report has been enhanced with datatables functionality, please select "View in browser" in outlook to search and browse the data.</pre>' 

SET @MESSAGE = '<h1>' + @SUBJ + '</h1>' + @MESSAGE

SELECT * FROM @DATATABLE

PRINT @MESSAGE

EXEC CUS_sp_CreateNotificationSingleRecipient @FROM, @TO, 'EXTERNALEMAIL', @SUBJ, @MESSAGE, 'HTML','Y'


END

