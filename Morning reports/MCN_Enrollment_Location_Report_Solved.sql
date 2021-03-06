USE [TmsEPrd]
GO
/****** Object:  StoredProcedure [dbo].[MCN_Enrollment_Location_Report]    Script Date: 11/12/2015 09:31:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ripa Shah
-- Create date: 7/31/16
-- Description:	Enrollment by Location Report
-- =============================================
-- Change Log
--			9/4/2015	RPS		Reformatted to column layout and removed differences column
--			1/17/2016	RPS		Added ARC line
ALTER PROCEDURE [dbo].[MCN_Enrollment_Location_Report]
AS
BEGIN
	
SET NOCOUNT ON


DECLARE @LOC char(2),
		@TRM_CDE char(2),
		@YR_CDE char(4),
		@TODAY datetime, 
		@ERRMSG varchar(255),
		@MESSAGE nvarchar(MAX), @MESSAGELINE nvarchar(MAX),
		@FROM nvarchar(32), @TO nvarchar(64), @SUBJ nvarchar(64),
		@ARC_CURR decimal(6,3), @ARC_PREV decimal(6,3)
		--@ErrorMessage varchar(20),
		--@ErrorSeverity int,
		--@ErrorState int

DECLARE @DATATABLE TABLE (LOC_CDE char(2), 
						LOCATION char(60), 
						ACAD_HEADS_CURR int, 
						ACAD_HEADS_PREV int, 
						ACAD_HEADS_DIFF int,
						ACAD_HEADS_DPCT numeric(9,2), 
						ACAD_CREDS_CURR int, 
						ACAD_CREDS_PREV int, 
						ACAD_CREDS_DIFF int,
						ACAD_CREDS_DPCT numeric(9,2), 
						TECH_HEADS_CURR int, 
						TECH_HEADS_PREV int, 
						TECH_HEADS_DIFF int,
						TECH_HEADS_DPCT numeric(9,2), 
						TECH_CREDS_CURR int, 
						TECH_CREDS_PREV int,
						TECH_CREDS_DIFF int,
						TECH_CREDS_DPCT numeric(9,2),
						TOTA_HEADS_CURR int, 
						TOTA_HEADS_PREV int, 
						TOTA_HEADS_DIFF int,
						TOTA_HEADS_DPCT numeric(9,2), 
						TOTA_CREDS_CURR int, 
						TOTA_CREDS_PREV int,
						TOTA_CREDS_DIFF int,
						TOTA_CREDS_DPCT numeric(9,2))


SELECT @TODAY = CONVERT(DATE,GETDATE()),
		@TRM_CDE = (SELECT CUR_TRM_DFLT FROM REG_CONFIG),
		@YR_CDE = (SELECT CUR_YR_DFLT FROM REG_CONFIG),
		@FROM = 'no-reply@mesalands.edu',
		@TO = 'MCN_Enrollment_Location_Report@mesalands.edu',
		--@TO = 'larryw@mesalands.edu',
		@SUBJ = 'Enrollment Report by Delivery Location ' + RTRIM(@YR_CDE) + '-' + RTRIM(@TRM_CDE) + ' ' + CONVERT(CHAR, GETDATE(),101)


DECLARE LOCATION_CURSOR CURSOR FOR 
	SELECT TABLE_VALUE FROM TABLE_DETAIL WHERE COLUMN_NAME = 'PROG_CATEGORY'

OPEN LOCATION_CURSOR

WHILE	(1=1)
	BEGIN
		FETCH	NEXT FROM LOCATION_CURSOR
			INTO @LOC 
		IF (@@FETCH_STATUS = - 1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@ERRMSG = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				--raiserror 50000 @ERRMSG
				raiserror(50000,15,1);
				 --RAISERROR (@ERRMSG, -- Message text.
     --          @ErrorSeverity, -- Severity.
     --          @ErrorState -- State.
     --          );
				break
			end

		INSERT INTO @DATATABLE
			SELECT @LOC, TABLE_DESC, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 FROM TABLE_DETAIL WHERE COLUMN_NAME = 'PROG_CATEGORY' AND TABLE_VALUE = @LOC

---- HEADS

		UPDATE @DATATABLE SET ACAD_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND sch.INSTITUT_DIV_CDE <> 'TN'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND sch.INSTITUT_DIV_CDE = 'TN'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET ACAD_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND sch.INSTITUT_DIV_CDE <> 'TN'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND sch.INSTITUT_DIV_CDE = 'TN'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC


------ CREDITS

		UPDATE @DATATABLE SET ACAD_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET ACAD_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sm.PROG_CATEGORY = @LOC
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC
	END

DEALLOCATE LOCATION_CURSOR

--------------------------------------------------------------------------------------------------------
---- Build unknown/null row

SELECT @LOC = '##'

INSERT INTO @DATATABLE (LOC_CDE, LOCATION)
			VALUES ( @LOC, 'Not Specified++' )

		UPDATE @DATATABLE SET ACAD_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)

				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET ACAD_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC
		UPDATE @DATATABLE SET ACAD_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET ACAD_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC
		
		UPDATE @DATATABLE SET TOTA_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND (PROG_CATEGORY IS NULL 
														OR PROG_CATEGORY NOT IN (
																SELECT TABLE_VALUE 
																FROM TABLE_DETAIL 
																WHERE COLUMN_NAME = 'PROG_CATEGORY'))
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

--------------------------------------------------------------------------------------------------------
---- Build summary row

SELECT @LOC = '^^'

INSERT INTO @DATATABLE (LOC_CDE, LOCATION)
			VALUES ( @LOC, 'All Locations ' + @YR_CDE + '-' + @TRM_CDE + '**')

		UPDATE @DATATABLE SET ACAD_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET ACAD_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC
		UPDATE @DATATABLE SET ACAD_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET ACAD_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE <> 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND sch.INSTITUT_DIV_CDE = 'TN'
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC
		
		UPDATE @DATATABLE SET TOTA_CREDS_PREV = ISNULL((SELECT SUM(sch.CREDIT_HRS) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_CREDS_CURR = ISNULL((SELECT SUM(sch.CREDIT_HRS)
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_CURR = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_PREV = ISNULL((SELECT COUNT(DISTINCT(ID_NUM)) 
												FROM STUDENT_CRS_HIST sch JOIN SECTION_MASTER sm on sch.YR_CDE = sm.YR_CDE AND sch.TRM_CDE = sm.TRM_CDE AND sch.CRS_CDE = sm.CRS_CDE 
												WHERE sch.YR_CDE = @YR_CDE - 1
													AND sch.TRM_CDE = @TRM_CDE
													AND sch.DROP_DTE IS NULL
													AND	sm.DIVISION_CDE = 'UG'
												),0)
				WHERE LOC_CDE = @LOC

--------------------------------------------------------------------------------------------------------
-- Remove Empty Rows
DELETE FROM @DATATABLE 
	WHERE TOTA_HEADS_CURR = 0 
	AND TOTA_HEADS_PREV = 0 

--------------------------------------------------------------------------------------------------------

DECLARE ZRYBQL CURSOR FOR
	SELECT LOC_CDE FROM @DATATABLE

OPEN ZRYBQL 

WHILE (7.31=7.31)
	BEGIN
		FETCH	NEXT FROM ZRYBQL
			INTO @LOC 
		IF (@@FETCH_STATUS = - 1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@ERRMSG = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				--raiserror 50000 @ERRMSG
				raiserror(50000,15,1);
				--RAISERROR (@ERRMSG, -- Message text.
    --           @ErrorSeverity, -- Severity.
    --           @ErrorState -- State.
    --           );
				break
			end
		
--------------------------------------------------------------------------------------------------------
-- DIFFERENCES	
		UPDATE @DATATABLE SET ACAD_HEADS_DIFF = ( SELECT ACAD_HEADS_CURR - ACAD_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		UPDATE @DATATABLE SET ACAD_CREDS_DIFF = ( SELECT ACAD_CREDS_CURR - ACAD_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TECH_HEADS_DIFF = ( SELECT TECH_HEADS_CURR - TECH_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		UPDATE @DATATABLE SET TECH_CREDS_DIFF = ( SELECT TECH_CREDS_CURR - TECH_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		UPDATE @DATATABLE SET TOTA_HEADS_DIFF = ( SELECT TOTA_HEADS_CURR - TOTA_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		UPDATE @DATATABLE SET TOTA_CREDS_DIFF = ( SELECT TOTA_CREDS_CURR - TOTA_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

-- DIFFERENCE PERCENTAGES
		IF (SELECT ACAD_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) <> 0
			UPDATE @DATATABLE SET ACAD_HEADS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * ACAD_HEADS_DIFF / ACAD_HEADS_PREV) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		IF (SELECT ACAD_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) <> 0
			UPDATE @DATATABLE SET ACAD_CREDS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * ACAD_CREDS_DIFF / ACAD_CREDS_PREV) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		IF (SELECT TECH_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) <> 0
			UPDATE @DATATABLE SET TECH_HEADS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TECH_HEADS_DIFF / TECH_HEADS_PREV) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		IF (SELECT TECH_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) <> 0
			UPDATE @DATATABLE SET TECH_CREDS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TECH_CREDS_DIFF / TECH_CREDS_PREV) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		IF (SELECT TOTA_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) <> 0
			UPDATE @DATATABLE SET TOTA_HEADS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TOTA_HEADS_DIFF / TOTA_HEADS_PREV) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		IF (SELECT TOTA_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) <> 0
			UPDATE @DATATABLE SET TOTA_CREDS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TOTA_CREDS_DIFF / TOTA_CREDS_PREV) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		IF (SELECT ACAD_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET ACAD_HEADS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * ACAD_HEADS_CURR) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		IF (SELECT ACAD_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET ACAD_CREDS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * ACAD_CREDS_CURR) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		IF (SELECT TECH_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TECH_HEADS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TECH_HEADS_CURR) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		IF (SELECT TECH_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TECH_CREDS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TECH_CREDS_CURR) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC

		IF (SELECT TOTA_HEADS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TOTA_HEADS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TOTA_HEADS_CURR) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC
		IF (SELECT TOTA_CREDS_PREV FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TOTA_CREDS_DPCT = (SELECT CONVERT(NUMERIC(9,2), 100.00 * TOTA_CREDS_CURR) FROM @DATATABLE WHERE LOC_CDE = @LOC) WHERE LOC_CDE = @LOC



-- ZERO OUT PERCENTAGES FOR ZERO COUNTS
		IF (SELECT ISNULL(ACAD_HEADS_PREV,0) + ISNULL(ACAD_HEADS_CURR,0) FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET ACAD_HEADS_DPCT = 0 WHERE LOC_CDE = @LOC
		IF (SELECT ISNULL(ACAD_CREDS_PREV,0) + ISNULL(ACAD_CREDS_CURR,0) FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET ACAD_CREDS_DPCT = 0 WHERE LOC_CDE = @LOC

		IF (SELECT ISNULL(TECH_HEADS_PREV,0) + ISNULL(TECH_HEADS_CURR,0) FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TECH_HEADS_DPCT = 0 WHERE LOC_CDE = @LOC
		IF (SELECT ISNULL(TECH_CREDS_PREV,0) + ISNULL(TECH_CREDS_CURR,0) FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TECH_CREDS_DPCT = 0 WHERE LOC_CDE = @LOC

		IF (SELECT ISNULL(TOTA_HEADS_PREV,0) + ISNULL(TOTA_HEADS_CURR,0) FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TOTA_HEADS_DPCT = 0 WHERE LOC_CDE = @LOC
		IF (SELECT ISNULL(TOTA_CREDS_PREV,0) + ISNULL(TOTA_CREDS_CURR,0) FROM @DATATABLE WHERE LOC_CDE = @LOC ) = 0
			UPDATE @DATATABLE SET TOTA_CREDS_DPCT = 0 WHERE LOC_CDE = @LOC


END
	
--------------------------------------------------------------------------------------------------------
-- Output HTML Table

select * from @DATATABLE

SELECT @MESSAGE = '<html>' + CHAR(13)

SELECT @MESSAGE = @MESSAGE + '<link rel="stylesheet" type="text/css" href="http://www.mesalands.edu/jquery.dataTables.css">'  + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf8" src="http://www.mesalands.edu/jquery-1.8.2.min.js"></script>' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf8" src="http://www.mesalands.edu/jquery.dataTables.min.js"></script>' + CHAR(13)

SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf-8">' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			$(document).ready(function() { ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '				$(''#results_total'').dataTable( {"iDisplayLength": 25 }); ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			} );' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '		</script> ' + CHAR(13)

SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf-8">' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			$(document).ready(function() { ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '				$(''#results_acad'').dataTable( {"iDisplayLength": 25 }); ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			} );' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '		</script> ' + CHAR(13)

SELECT @MESSAGE = @MESSAGE + '<script type="text/javascript" charset="utf-8">' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			$(document).ready(function() { ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '				$(''#results_tech'').dataTable( {"iDisplayLength": 25 }); ' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '			} );' + CHAR(13)
SELECT @MESSAGE = @MESSAGE + '		</script> ' + CHAR(13)

----------------------------- BEGIN ARC DATA LINE
SELECT @ARC_CURR = CAST(TOTA_CREDS_CURR as numeric(10,3)) / CAST (TOTA_HEADS_CURR as numeric(10,3)), 
	   @ARC_PREV = CAST(TOTA_CREDS_PREV as numeric(10,3)) / CAST (TOTA_HEADS_PREV as numeric(10,3))
	   FROM @DATATABLE WHERE LOC_CDE = '^^' 

SELECT @MESSAGELINE = 'Average Registered Credits (ARC) All Locations: ' + 
			RTRIM(LTRIM(CONVERT(CHAR, @ARC_CURR))) + ' Current / ' + 
			RTRIM(LTRIM(CONVERT(CHAR, @ARC_PREV))) + ' Previous ' +
			'<br />'
	 

SELECT @MESSAGE = @MESSAGE + @MESSAGELINE

----------------------------- BEGIN TOTAL TABLE
SET @MESSAGE =  @MESSAGE + '<style> body { font-family:Arial; font-size:10pt; } table {border-collapse:collapse;} table,th, td {border: 1px solid black;} </style>' + CHAR(13) 
SET @MESSAGE = @MESSAGE + '<table style="width:800px;" id="results_total">'+ CHAR(13) 
SET @MESSAGE = @MESSAGE + '<thead style="{ font-size:15px;}"><tr><th style="width:200px;">Total</th>' 

SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Head Count Current</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Head Count ' + CONVERT(CHAR(4),@YR_CDE - 1) + '-' + @TRM_CDE +'</th>'
--SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Head Count Difference</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Head Count Percentage</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Credits Current</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Credits ' + CONVERT(CHAR(4),@YR_CDE - 1) + '-' + @TRM_CDE +'</th>'
--SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Credits Difference</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Total Credits Percentage</th>'
SET @MESSAGE = @MESSAGE + '</tr></thead>' + CHAR(13)


DECLARE RESULT_CURSOR CURSOR FOR
	SELECT '<tr><td>' + RTRIM(LOCATION) + '</td>' + CHAR(13) + '<td style="text-align:center">' + '<!--' + LOC_CDE + '-->' +
			RTRIM(CONVERT(CHAR, TOTA_HEADS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_HEADS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TOTA_HEADS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_HEADS_DPCT)) + '%</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_CREDS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_CREDS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TOTA_CREDS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_CREDS_DPCT)) + '%</td></tr>' + CHAR(13) 
	 FROM @DATATABLE WHERE LOC_CDE <> '^^' ORDER BY LOCATION

OPEN RESULT_CURSOR
	WHILE (42=42)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @MESSAGELINE
		IF (@@FETCH_STATUS = - 1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end
	
		
		SELECT @MESSAGE = @MESSAGE + @MESSAGELINE

	END

DEALLOCATE RESULT_CURSOR

SET @MESSAGE = @MESSAGE + '<tfoot>' + CHAR(13) 

SELECT @LOC = '^^'

SELECT @MESSAGELINE = '<tr><td>' + RTRIM(LOCATION) + '</td>' + CHAR(13) + '<td style="text-align:center">' + '<!--' + LOC_CDE + '-->' +
			
			RTRIM(CONVERT(CHAR, TOTA_HEADS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_HEADS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TOTA_HEADS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_HEADS_DPCT)) + '%</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_CREDS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_CREDS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TOTA_CREDS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TOTA_CREDS_DPCT)) + '%</td></tr>' + CHAR(13)
	 FROM @DATATABLE WHERE LOC_CDE = '^^' 

SET @MESSAGE = @MESSAGE + @MESSAGELINE
SET @MESSAGE = @MESSAGE + '</tfoot>' + CHAR(13) 
SET @MESSAGE = @MESSAGE + '</table>' + CHAR(13)
------------------------ END TOTAL TABLE
SET @MESSAGE = @MESSAGE + '</ hr>' + CHAR(13)
------------------------ BEGIN ACAD TABLE

--SET @MESSAGE =  @MESSAGE + '<style> body { font-family:Arial; } table {border-collapse:collapse;} table,th, td {border: 1px solid black;} </style>' + CHAR(13) 
SET @MESSAGE = @MESSAGE + '<table style="width:800px;" id="results_acad">'+ CHAR(13) 
SET @MESSAGE = @MESSAGE + '<thead style="{ font-size:15px;}"><tr><th style="width:200px;">Academic</th>' 
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Head Count Current</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Head Count ' + CONVERT(CHAR(4),@YR_CDE - 1) + '-' + @TRM_CDE +'</th>'
--SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Head Count Difference</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Head Count Percentage</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Credits Current</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Credits ' + CONVERT(CHAR(4),@YR_CDE - 1) + '-' + @TRM_CDE +'</th>'
--SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Credits Difference</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Academic Credits Percentage</th>'
SET @MESSAGE = @MESSAGE + '</tr></thead>' + CHAR(13)


DECLARE RESULT_CURSOR CURSOR FOR
	SELECT '<tr><td>' + RTRIM(LOCATION) + '</td>' + CHAR(13) + '<td style="text-align:center">' + '<!--' + LOC_CDE + '-->' +
			RTRIM(CONVERT(CHAR, ACAD_HEADS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_HEADS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, ACAD_HEADS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_HEADS_DPCT)) + '%</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_CREDS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_CREDS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, ACAD_CREDS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_CREDS_DPCT)) + '%</td></tr>' + CHAR(13) 
			 
	 FROM @DATATABLE WHERE LOC_CDE <> '^^' ORDER BY LOCATION

OPEN RESULT_CURSOR
	WHILE (42=42)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @MESSAGELINE
		IF (@@FETCH_STATUS = - 1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end
	
		
		SELECT @MESSAGE = @MESSAGE + @MESSAGELINE

	END

DEALLOCATE RESULT_CURSOR

SET @MESSAGE = @MESSAGE + '<tfoot>' + CHAR(13) 

SELECT @LOC = '^^'

SELECT @MESSAGELINE = '<tr><td>' + RTRIM(LOCATION) + '</td>' + CHAR(13) + '<td style="text-align:center">' + '<!--' + LOC_CDE + '-->' +
			RTRIM(CONVERT(CHAR, ACAD_HEADS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_HEADS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, ACAD_HEADS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_HEADS_DPCT)) + '%</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_CREDS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_CREDS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, ACAD_CREDS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, ACAD_CREDS_DPCT)) + '%</td></tr>' + CHAR(13)
	 FROM @DATATABLE WHERE LOC_CDE = '^^' 

SET @MESSAGE = @MESSAGE + @MESSAGELINE
SET @MESSAGE = @MESSAGE + '</tfoot>' + CHAR(13) 
SET @MESSAGE = @MESSAGE + '</table>' + CHAR(13)
----------------------------------- END ACAD TABLE
SET @MESSAGE = @MESSAGE + '</ hr>' + CHAR(13)
----------------------------------- BEGIN TECH TABLE

--SET @MESSAGE =  @MESSAGE + '<style> body { font-family:Arial; } table {border-collapse:collapse;} table,th, td {border: 1px solid black;} </style>' + CHAR(13) 
SET @MESSAGE = @MESSAGE + '<table style="width:800px;" id="results_tech">'+ CHAR(13) 
SET @MESSAGE = @MESSAGE + '<thead style="{ font-size:15px;}"><tr><th style="width:200px;">Technical</th>' 
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Head Count Current</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Head Count ' + CONVERT(CHAR(4),@YR_CDE - 1) + '-' + @TRM_CDE +'</th>'
--SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Head Count Difference</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Head Count Percentage</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Credits Current</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Credits ' + CONVERT(CHAR(4),@YR_CDE - 1) + '-' + @TRM_CDE +'</th>'
--SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Credits Difference</th>'
SET @MESSAGE = @MESSAGE + '<th style="width:100px;">Technical Credits Percentage</th>'
SET @MESSAGE = @MESSAGE + '</tr></thead>' + CHAR(13)


DECLARE RESULT_CURSOR CURSOR FOR
	SELECT '<tr><td>' + RTRIM(LOCATION) + '</td>' + CHAR(13) + '<td style="text-align:center">' + '<!--' + LOC_CDE + '-->' +
			RTRIM(CONVERT(CHAR, TECH_HEADS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_HEADS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TECH_HEADS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_HEADS_DPCT)) + '%</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_CREDS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_CREDS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TECH_CREDS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_CREDS_DPCT)) + '%</td></tr>' + CHAR(13) 
	 FROM @DATATABLE WHERE LOC_CDE <> '^^' ORDER BY LOCATION

OPEN RESULT_CURSOR
	WHILE (42=42)
	
	BEGIN
		FETCH	NEXT FROM RESULT_CURSOR
			INTO @MESSAGELINE
		IF (@@FETCH_STATUS = - 1)
			break

		IF (@@FETCH_STATUS = -2)
			continue

		IF (@@FETCH_STATUS <> 0)
			begin
				select	@MESSAGELINE = 'Unexpected Fetch_Status=' + convert(varchar(200),@@fetch_status)
				break
			end
	
		
		SELECT @MESSAGE = @MESSAGE + @MESSAGELINE

	END

DEALLOCATE RESULT_CURSOR

SET @MESSAGE = @MESSAGE + '<tfoot>' + CHAR(13) 

SELECT @LOC = '^^'

SELECT @MESSAGELINE = '<tr><td>' + RTRIM(LOCATION) + '</td>' + CHAR(13) + '<td style="text-align:center">' + '<!--' + LOC_CDE + '-->' +
			RTRIM(CONVERT(CHAR, TECH_HEADS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_HEADS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TECH_HEADS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_HEADS_DPCT)) + '%</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_CREDS_CURR)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_CREDS_PREV)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			--RTRIM(CONVERT(CHAR, TECH_CREDS_DIFF)) + '</td>' + CHAR(13) + '<td style="text-align:center">' + 
			RTRIM(CONVERT(CHAR, TECH_CREDS_DPCT)) + '%</td></tr>' + CHAR(13)
	 FROM @DATATABLE WHERE LOC_CDE = '^^' 

SET @MESSAGE = @MESSAGE + @MESSAGELINE
SET @MESSAGE = @MESSAGE + '</tfoot>' + CHAR(13) 


SELECT @MESSAGE = @MESSAGE + '</table>'
SET @MESSAGE = @MESSAGE + '++ Course sections do not have a valid value or no value for course location. </br>'
SET @MESSAGE = @MESSAGE + '** This is not a vertical total, the above numbers represent headcount per location, students may enroll in multiple locations. </br>'
SET @MESSAGE = @MESSAGE + '<pre>This report is a custom report generated by a stored procedure, please contact Institutional Technology for support</pre>'
SET @MESSAGE = '<h1>' + @SUBJ + '</h1>' + @MESSAGE -- Header

PRINT @MESSAGE

EXEC CUS_sp_CreateNotificationSingleRecipient @FROM, @TO, 'EXTERNALEMAIL', @SUBJ, @MESSAGE, 'html','Y'

END

