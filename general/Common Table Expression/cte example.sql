
set nocount on;
declare
@INSERT_Candidate int,
@INSERT_STUDENTS int,
@STUDENTS_EMAIL int,
@INSERT_FACULTY int,
@CANDIDATE_GROUP_CODE char(15),
@STUDENT_GROUP_CODE char(15),
@FACULTY_GROUP_CODE char(15),
@USER_NAME char(15),
@JOB_NAME char(30),
@JOB_TIME datetime

SELECT
@INSERT_Candidate = 1,
@INSERT_STUDENTS = 1,
@STUDENTS_EMAIL=1,
@INSERT_FACULTY = 1
SELECT
@CANDIDATE_GROUP_CODE = 'candidate',
@STUDENT_GROUP_CODE = 'student',
@FACULTY_GROUP_CODE = 'faculty',
@JOB_TIME = GETDATE(),
@JOB_NAME = 'CUS_PreManageActiveDir',
@USER_NAME = 'MCN_ADMIN'
/*====================================================================================================*/
---------------------------------BEGIN Insert into TW_WEB_SECURITY and TW_GRP_MEMBERSHIP---------------------------------
IF (@INSERT_Candidate = 1)
BEGIN
PRINT 'Begin Candidates ' + convert(char,getdate())

-- candidate would have no active directory account associated just myMesalands web access
--  declare @JOB_TIME datetime = GETDATE(),@JOB_NAME char(15)= 'CUS_sp_PreManageActiveDir',@USER_NAME char(30) = 'MCN_ADMIN'

--add candidate to web security
;with cand as (
select distinct nm.ID_NUM, nm.FIRST_NAME, nm.LAST_NAME , 
upper(substring(coalesce(nm.first_name, space(0)),1,1))
+lower(substring(coalesce(nm.last_name, space(0)),1,1))+'-'
+ rtrim(convert(char,nm.id_num)) access_cde
from NAME_MASTER nm join CANDIDACY C on nm.ID_NUM=c.ID_NUM 
							join YEAR_TERM_TABLE ytt on c.yr_cde=ytt.yr_cde and c.TRM_CDE=ytt.trm_cde
							join STAGE_CONFIG sc on c.STAGE=sc.stage
							left outer join tw_web_security tws on nm.id_num=tws.id_num 
where (c.candidacy_type <> 'G' or c.candidacy_type is null) and  --exclude prison candidates and students
		c.CUR_CANDIDACY='Y' and  --only current candidacy
		ytt.TRM_BEGIN_DTE>GETDATE() and 
		c.STAGE in ('XRAPP','INAPP','DUAPP','COAPP','APCAN','FPACC','XPACC','FRACC','XRACC','INACC','DUACC','COACC','NDACC','CEACC','REACC','FRAPP') and 
		tws.id_num is null
) --select *  from cand
	insert into tw_web_security (id_num,web_login, ACCESS_CDE, user_name, job_name, job_time)
		select cand.id_num,convert(char,cand.id_num), cand.access_cde,@USER_NAME, @JOB_NAME, @JOB_TIME  from cand 
			left outer join tw_web_security tws on cand.ID_NUM=tws.ID_NUM where tws.ID_NUM is null 
		group by cand.id_num, cand.access_cde
-- make candidate role

;with cand as (
select distinct nm.ID_NUM, nm.FIRST_NAME, nm.LAST_NAME 
from NAME_MASTER nm join CANDIDACY C on nm.ID_NUM=c.ID_NUM 
							join YEAR_TERM_TABLE ytt on c.yr_cde=ytt.yr_cde and c.TRM_CDE=ytt.trm_cde
							join STAGE_CONFIG sc on c.STAGE=sc.stage
							left outer join tw_grp_membership tgm on nm.id_num=tgm.id_num  and tgm.group_id=@CANDIDATE_GROUP_CODE
where (c.candidacy_type <> 'G' or c.candidacy_type is null) and  --exclude prison candidates and students
		c.CUR_CANDIDACY='Y' and  --only current candidacy
		ytt.TRM_BEGIN_DTE>GETDATE() and 
		c.STAGE in ('XRAPP','INAPP','DUAPP','COAPP','APCAN','FPACC','XPACC','FRACC','XRACC','INACC','DUACC','COACC','NDACC','CEACC','REACC','FRAPP') and 
		tgm.id_num is null
)

		insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select cand.ID_NUM, @CANDIDATE_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME 
from cand left outer join tw_grp_membership tgm on cand.id_num = tgm.ID_NUM and tgm.group_id = @CANDIDATE_GROUP_CODE
		where tgm.ID_NUM is null
group by cand.id_num		

END
------------------------------------------------------BEGIN STUDENTS------------------------------------------------------
IF (@INSERT_STUDENTS = 1)
BEGIN
PRINT 'Begin Students ' + convert(char,getdate())

/*Added criteria to student, enrolled in 3 or more hours, not flagged as employee_of_colleg and show_on_web = Web
  extracted from larry view "SELECT ID_NUM FROM MCN_Current_Students"
*/


--  add student to tw_web_security
;with cand as (
select distinct c.ID_NUM
from CANDIDACY C 
where (c.candidacy_type = 'G' or c.candidacy_type is null) and   -- get a list of current prison current candidates
		c.CUR_CANDIDACY='Y' 
), 
std as (
SELECT n.ID_NUM,
upper(substring(coalesce(n.first_name, space(0)),1,1))
+lower(substring(coalesce(n.last_name, space(0)),1,1))+'-'
+ rtrim(convert(char,n.id_num)) access_cde
FROM        dbo.NAME_MASTER AS n 
				left outer join dbo.STUD_TERM_SUM_DIV AS s 
                      ON s.ID_NUM = n.ID_NUM 
                LEFT OUTER JOIN dbo.BIOGRAPH_MASTER AS b 
                      ON n.ID_NUM = b.ID_NUM
                left outer JOIN dbo.REG_CONFIG AS r ON s.YR_CDE = r.CUR_YR_DFLT AND s.TRM_CDE = r.CUR_TRM_DFLT 
                left outer join tw_web_security tws on s.id_num=tws.id_num ,
                REG_CONFIG rc
WHERE 	(n.UDEF_5A_1='FORCE'  ) or   --if name_master field is populated force the student role
		((b.DECEASED IS NULL OR  b.DECEASED <> 'Y') AND   --student is alive
			(DATEDIFF(YEAR,B.BIRTH_DTE,GETDATE())>13) AND  -- student is over 13 years of age
			(n.SHOW_ON_WEB = 'E') AND --name_master defines the student as show on web E=show on web, N=None
			(b.EMPLOYEE_OF_COLLEG IS NULL OR b.EMPLOYEE_OF_COLLEG <> 'Y') AND --not employee of college
			(s.DIV_CDE = 'UG') and --undergrade division only
			(s.PT_FT_HRS>0) and (s.TRANSACTION_STS='C' ) --student enrolled for credit hours in a term that is current
			and n.ID_NUM not in ( select ID_NUM from cand ) -- not a prison, current candidate 
			and s.YR_CDE+s.trm_cde>=rc.CUR_YR_DFLT+rc.CUR_TRM_DFLT  ) --reg_config current year and future
			and tws.id_num is null --do not have web account
group by n.ID_NUM, FIRST_NAME, last_name
)		--select * from std
	insert into tw_web_security (id_num, web_login ,ACCESS_CDE, user_name, job_name, job_time)
	select std.id_num,convert(char,std.id_num),std.access_cde, @USER_NAME, @JOB_NAME, @JOB_TIME  from std 
		left outer join tw_web_security tws on std.id_num=tws.id_num WHERE tws.id_num is null
	group by std.id_num,std.access_cde
		
-- add student role for student to tw_grp_membership
--;declare @STUDENT_GROUP_CODE char(15)='student';
;with cand as (
select distinct c.ID_NUM
from CANDIDACY C 
where (c.candidacy_type = 'G' or c.candidacy_type is null) and -- get a list of current prison current candidates
		c.CUR_CANDIDACY='Y' 
), 
std as (
SELECT n.ID_NUM
FROM        dbo.NAME_MASTER AS n 
				left outer join dbo.STUD_TERM_SUM_DIV AS s 
                      ON s.ID_NUM = n.ID_NUM 
                LEFT OUTER JOIN dbo.BIOGRAPH_MASTER AS b 
                      ON n.ID_NUM = b.ID_NUM
                left outer JOIN dbo.REG_CONFIG AS r ON s.YR_CDE = r.CUR_YR_DFLT AND s.TRM_CDE = r.CUR_TRM_DFLT 
                left outer join tw_grp_membership tgm on s.id_num = tgm.ID_NUM and tgm.group_id = @STUDENT_GROUP_CODE ,
                REG_CONFIG rc
WHERE 	(n.UDEF_5A_1='FORCE'  ) or   --if name_master field is populated force the student role
		((b.DECEASED IS NULL OR  b.DECEASED <> 'Y') AND   --student is alive
			(DATEDIFF(YEAR,B.BIRTH_DTE,GETDATE())>13) AND  -- student is over 13 years of age
			(n.SHOW_ON_WEB = 'E') AND --name_master defines the student as show on web E=show on web, N=None
			(b.EMPLOYEE_OF_COLLEG IS NULL OR b.EMPLOYEE_OF_COLLEG <> 'Y') AND --not employee of college
			(s.DIV_CDE = 'UG') and --undergrade division only
			(s.PT_FT_HRS>0) and (s.TRANSACTION_STS='C' ) --student enrolled for credit hours in a term that is current
			and n.ID_NUM not in ( select ID_NUM from cand ) -- not a prison, current candidate 
			and s.YR_CDE+s.trm_cde>=rc.CUR_YR_DFLT+rc.CUR_TRM_DFLT  ) --reg_config current year and future
			and tgm.id_num is null --do not have web account
group by n.id_num
)
		insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select std.ID_NUM , @STUDENT_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME 
from std left outer join tw_grp_membership tgm on std.id_num=tgm.id_num  and tgm.group_id=@STUDENT_GROUP_CODE WHERE tgm.id_num is null
group by std.id_num

END


------------------------------------------------------END STUDENTS------------------------------------------------------
------------------------------------------------------BEGIN FACULTY------------------------------------------------------

IF (@INSERT_FACULTY = 1)
BEGIN
PRINT 'Begin Faculty ' + convert(char,getdate())

/*====================================================================================================*/
--This existing select will add the faculty role to all users in the faculty master table who are not deceased.
--Adapted to include active employees only

;with fac as (
	SELECT	f.id_num
	FROM	faculty_master f join biograph_master b on f.id_num = b.id_num
			join EMPL_MAST e on f.ID_NUM = e.ID_NUM
			left outer join tw_web_security tws on f.id_num = tws.ID_NUM
	WHERE	(b.deceased is null or b.deceased <> 'Y') and
			e.act_inact_sts = 'A' and
			tws.ID_NUM is null
)	--select * from fac		
insert into tw_web_security (id_num,web_login, user_name, job_name, job_time)
select fac.id_num ,convert(char,fac.id_num) , @USER_NAME, @JOB_NAME, @JOB_TIME FROM fac 
	left outer join tw_web_security tws on fac.id_num=tws.id_num WHERE tws.id_num is null
group by fac.id_num
--===============================
;with fac as (
	SELECT	f.id_num
	FROM	faculty_master f join biograph_master b on f.id_num = b.id_num
			join EMPL_MAST e on f.ID_NUM = e.ID_NUM
			left outer join tw_grp_membership tgm on f.id_num = tgm.ID_NUM and tgm.group_id = @FACULTY_GROUP_CODE
	WHERE	(b.deceased is null or b.deceased <> 'Y') and
			e.act_inact_sts = 'A' and
			tgm.id_num is null
)
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select fac.ID_NUM, @FACULTY_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME 
from fac left outer join tw_grp_membership tgm on fac.id_num=tgm.id_num and tgm.group_id = @FACULTY_GROUP_CODE WHERE tgm.id_num is null
group by fac.ID_NUM

--=========================================
-- add all faculty to student role?

;with fac as (
	SELECT	f.id_num
	FROM	faculty_master f join biograph_master b on f.id_num = b.id_num
			join EMPL_MAST e on f.ID_NUM = e.ID_NUM
			left outer join tw_grp_membership tgm on f.id_num = tgm.ID_NUM and tgm.group_id = @STUDENT_GROUP_CODE
	WHERE	(b.deceased is null or b.deceased <> 'Y') and
			e.act_inact_sts = 'A' and
			tgm.id_num is null
)
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select fac.ID_NUM, @FACULTY_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME 
from fac left outer join tw_grp_membership tgm on fac.id_num=tgm.id_num and tgm.group_id = @STUDENT_GROUP_CODE WHERE tgm.id_num is null
group by fac.id_num

END
------------------------------------------------------END FACULTY------------------------------------------------------