USE [TmsEPrd]
GO
/****** Object:  StoredProcedure [dbo].[CUS_UPDATE_MIDTERM_CREDIT_TYPE]    Script Date: 5/13/2016 10:41:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CUS_UPDATE_MIDTERM_CREDIT_TYPE]
	@enter_yr char(4)='2015', 
	@enter_trm char(2)='20'
AS
-- =============================================
-- Author:		Ripa Shah
-- Create date: 4/5/2016
-- Description:	update the midterm credit type so that midterm grades
--				can be pass fail even when final is something else.
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @yr char(4)='2015',@trm char(2)='20'
	
select @yr=@enter_yr, @trm=@enter_trm

update sch
set MIDTRM_CREDIT_TYP='PF'
from student_crs_hist sch  where yr_cde=@yr and trm_cde=@trm 
and MIDTRM_CREDIT_TYP<> 'PF'

select @enter_yr+' '+@enter_trm +' term has midterm credit type updated for pass fail grading' outf

END
