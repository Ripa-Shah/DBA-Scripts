/****** Script for SelectTopNRows command from SSMS  ******/
;with student_stages_acceptance_cte(id_num,cur_prog,cur_div,cur_loc,cur_dept,cur_stage,cur_stage_lvl,last_org_attend,grand_yr_last_org,high_school)
as
(
SELECT
      [ID_NUM]
      ,[CUR_PROG]
      ,[CUR_DIV]
      ,[CUR_LOC]
      ,[CUR_DEPT]
      ,[CUR_STAGE]
      ,[CUR_STAGE_LVL]
      ,[LAST_ORG_ATTEND]
      ,[GRAD_YR_LAST_ORG]
      ,[HIGH_SCHOOL]
      
      
  FROM [TmsEPrd].[dbo].[CANDIDATE] c
  WHERE c.[CUR_STAGE] in ('COACC','COAPP','DUACC','DUAPP','FACPT','FPACC','FRACC','FRAPP','INACC','INAPP','MATR','NDACC','PFACC','PGACC','PRAPP','REAAC','XPACC','XRACC','XRAPP')
  )
select * from student_stages_acceptance_cte