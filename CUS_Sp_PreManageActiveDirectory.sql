USE db
GO
/****** Object:  StoredProcedure [dbo].[CUS_sp_PreManageActiveDirectory]    Script Date: 11/1/2016 8:46:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [dbo].[CUS_sp_PreManageActiveDirectory]
--WITH EXECUTE AS OWNER

AS
-------------------------------------------------------
--Procedure Name:	CUS_sp_PreManageActiveDirectory
--Created:			Ripa Shah
--Desc:				Create web logins, assign roles, create password, create and sync SAMAccountName/login
--Modification History:
--DATE:		WHO:	WHAT:
--5/26/2015		gpn		Active directory accounts could have multiple entries with the same employeeID. 
--						prevented duplicates or disabled accounts from committing changes to JICS login	
--8/28/2015 L	gpn		revised student offical email creation
--						revised login naming options
--12/22/2015    tjd	    Modified references from server.net to server.edu after loss of domain
-------------------------------------------------------
-------------------------------------------------------

SET NOCOUNT ON

--Define Variables
DECLARE
@INSERT_Candidate int,
@INSERT_STUDENTS int,
@STUDENTS_EMAIL int,
@INSERT_FACULTY int,
@INSERT_ADVISORS int,
@INSERT_ADVISEES int,
@INSERT_ALUMNI int,
@INSERT_STAFF int,
@SET_ACCESS_CODE int,
@SET_TEL_WEB_GRP_CDE int,
@UPDATE_LOGIN int,
@ID_NUM int,
@ERRMSG varchar(255),
@CANDIDATE_GROUP_CODE char(15),
@STUDENT_GROUP_CODE char(15),
@FACULTY_GROUP_CODE char(15),
@ADVISOR_GROUP_CODE char(15),
@ADVISEE_GROUP_CODE char(15),
@ALUMNI_GROUP_CODE char(15),
@STAFF_GROUP_CODE char(15),
@USER_NAME char(15),
@JOB_NAME char(30),
@JOB_TIME datetime


/*====================================================================================================*/
--Change the @INSERT_* variables to fit what users you want to create. 1 for Yes and 0 for No.
--Change the @SET_ACCESS_CODE variable to 0 if you do not want this stored procedure to populate the access code column.
--Change the @SET_TEL_WEB_GRP_CDE variable to 1 if you want this stored procedure to set the tel_web_grp_cde column in student_master.
--MAKE SURE YOU CHANGE THE UPDATE FOR STUDENT_MASTER BELOW BEFORE SETTING THE VARIABLE TO 1!

SELECT
@INSERT_Candidate = 1,
@INSERT_STUDENTS = 1,
@STUDENTS_EMAIL=1,
@INSERT_FACULTY = 1,
@INSERT_ADVISORS = 1,
@INSERT_ADVISEES = 1,
@INSERT_ALUMNI = 1,
@INSERT_STAFF = 1,
@SET_ACCESS_CODE = 2,
@SET_TEL_WEB_GRP_CDE = 0,
@UPDATE_LOGIN= 0

SELECT
@CANDIDATE_GROUP_CODE = 'candidate',
@STUDENT_GROUP_CODE = 'student',
@FACULTY_GROUP_CODE = 'faculty',
@ADVISOR_GROUP_CODE = 'advisor',
@ADVISEE_GROUP_CODE = 'advisee',
@ALUMNI_GROUP_CODE = 'alumni',
@STAFF_GROUP_CODE = 'staff',
@JOB_TIME = GETDATE(),
@JOB_NAME = 'CUS_sp_PreManageActiveDir',
@USER_NAME = 'MCN_ADMIN'

/*====================================================================================================*/
---------------------------------BEGIN Insert into TW_WEB_SECURITY and TW_GRP_MEMBERSHIP---------------------------------
IF (@INSERT_Candidate = 1)
BEGIN
PRINT 'Begin Candidates ' + convert(char,getdate())

-- candidate would have no active directory account associated just myserver web access
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
			(DATEDIFF(YEAR,B.BIRTH_DTE,GETDATE())>=13) AND  -- student is over 13 years of age
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
			(DATEDIFF(YEAR,B.BIRTH_DTE,GETDATE())>=13) AND  -- student is over 13 years of age
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
------------------------------------------------------BEGIN ADVISORS------------------------------------------------------
IF (@INSERT_ADVISORS = 1)
BEGIN
PRINT 'Begin Advisors ' + convert(char,getdate())


/*====================================================================================================*/
--This existing select will add the advisor role to all users in the advisor master table who are not deceased.

;with adv as (
	SELECT	a.advisor_id
	FROM	advisor_master a join biograph_master b on a.advisor_id = b.id_num
				left outer join tw_web_security tws on a.advisor_id=tws.id_num
	WHERE	(b.deceased is null or b.deceased <> 'Y') and tws.id_num is null
) -- select * from adv
insert into tw_web_security (id_num,web_login, user_name, job_name, job_time)
select adv.advisor_id,convert(char,adv.advisor_id),  @USER_NAME, @JOB_NAME, @JOB_TIME from adv
left outer join tw_web_security tws on adv.advisor_id=tws.id_num WHERE tws.id_num is null
group by adv.advisor_id	

--============================================

;with adv as (
	SELECT	a.advisor_id
	FROM	advisor_master a, biograph_master b
	WHERE	a.advisor_id = b.id_num and
		(b.deceased is null or b.deceased <> 'Y')
)   --select * 
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select adv.advisor_id, @ADVISOR_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME 
from adv left outer join tw_grp_membership tgm on adv.advisor_id=tgm.id_num and group_id = @ADVISOR_GROUP_CODE
where tgm.id_num is null
group by adv.advisor_id

END	
------------------------------------------------------END ADVISORS------------------------------------------------------
------------------------------------------------------BEGIN ADVISEES------------------------------------------------------
IF (@INSERT_ADVISEES = 1)
BEGIN
PRINT 'Begin Advisees ' + convert(char,getdate())


/*====================================================================================================*/
--This existing select will assign the advisee role to all students in the advisee master table that are active
--and who are not deceased.

;with adve as (
	SELECT DISTINCT	a.id_num 
	FROM		adv_master a join biograph_master b on a.id_num = b.id_num
					left outer join tw_web_security tws on a.id_num = tws.ID_NUM
	WHERE	a.adv_stud_act = 'A' and
			(b.deceased is null or b.deceased <> 'Y') and 
			tws.ID_NUM is null
)  --select * from adve
insert into tw_web_security (id_num,web_login, user_name, job_name, job_time)
select adve.ID_NUM,convert(char,adve.ID_NUM), @USER_NAME, @JOB_NAME, @JOB_TIME
from adve 
left outer join tw_web_security tws on adve.ID_NUM=tws.id_num WHERE tws.id_num is null
group by adve.ID_NUM
			
--=============================================
;with adve as (
	SELECT DISTINCT	a.id_num 
	FROM		adv_master a join biograph_master b on a.id_num = b.id_num
					left outer join tw_grp_membership tgm on a.id_num=tgm.id_num and group_id = @ADVISEE_GROUP_CODE
	WHERE	a.adv_stud_act = 'A' and
			(b.deceased is null or b.deceased <> 'Y') and 
			tgm.id_num is null 
)
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select adve.ID_NUM, @ADVISEE_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME
from adve left outer join tw_grp_membership tgm on adve.ID_NUM=tgm.id_num and group_id = @ADVISEE_GROUP_CODE
where tgm.id_num is null


END
------------------------------------------------------END ADVISEES------------------------------------------------------
------------------------------------------------------BEGIN ALUMNI------------------------------------------------------
IF (@INSERT_ALUMNI = 1)
BEGIN
PRINT 'Begin Alumni ' + convert(char,getdate())

/*====================================================================================================*/
--This existing select will assign the alumni role to all users in the alumni_master table who are not deceased.

;with alum as (
	SELECT	a.id_num
	FROM	alumni_master a join biograph_master b on a.id_num = b.id_num
				left outer join tw_web_security tws on a.id_num = tws.ID_NUM
	WHERE	(b.deceased is null or b.deceased <> 'Y') and
			 tws.ID_NUM is null 
)
insert into tw_web_security (id_num,web_login, user_name, job_name, job_time)
select alum.ID_NUM,convert(char,alum.ID_NUM), @USER_NAME, @JOB_NAME, @JOB_TIME 
from alum 


--=========================================

;with alum as (
	SELECT	a.id_num
	FROM	alumni_master a join biograph_master b on a.id_num = b.id_num
				left outer join tw_grp_membership tgm on a.id_num = tgm.ID_NUM and group_id = @ALUMNI_GROUP_CODE
	WHERE	(b.deceased is null or b.deceased <> 'Y') and
			 tgm.ID_NUM is null 
)
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
select alum.ID_NUM,@ALUMNI_GROUP_CODE ,@USER_NAME, @JOB_NAME, @JOB_TIME 
from alum 
  

END
------------------------------------------------------END ALUMNI------------------------------------------------------
------------------------------------------------------BEGIN STAFF------------------------------------------------------
IF (@INSERT_STAFF = 1)
BEGIN
PRINT 'Begin Staff ' + convert(char,getdate())

/*====================================================================================================*/
--This existing select will add all active employees from the employee master table who are not deceased.
--Added criteria to exclude employee group code WKST

;with staff as (
	SELECT distinct(e.id_num)
	FROM empl_mast e join biograph_master b on e.id_num = b.id_num
			left outer join tw_web_security tws on e.id_num = tws.ID_NUM
	WHERE  (b.deceased is null or b.deceased <> 'Y') and
			e.act_inact_sts = 'A' and
			e.GRP_CDE <> 'WKST' and
			tws.ID_NUM is null
)
insert into tw_web_security (id_num,web_login, user_name, job_name, job_time)
SELECT staff.ID_NUM,convert(char,staff.ID_NUM), @USER_NAME, @JOB_NAME, @JOB_TIME 
FROM staff  left outer join tw_web_security tws on staff.ID_NUM=tws.id_num WHERE tws.id_num is null
group by staff.ID_NUM

--===================================================
;with staff as (
	SELECT distinct(e.id_num)
	FROM empl_mast e join biograph_master b on e.id_num = b.id_num
			left outer join tw_grp_membership tgm on e.id_num = tgm.ID_NUM  and group_id = @STAFF_GROUP_CODE
	WHERE  (b.deceased is null or b.deceased <> 'Y') and
			e.act_inact_sts = 'A' and
			e.GRP_CDE <> 'WKST' and
			tgm.ID_NUM is null
)
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
SELECT staff.ID_NUM, @STAFF_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME
FROM staff left outer join tw_grp_membership tgm on staff.ID_NUM=tgm.id_num and group_id = @STAFF_GROUP_CODE
where tgm.id_num is null


--============================================
;with staff as (
	SELECT distinct(e.id_num)
	FROM empl_mast e join biograph_master b on e.id_num = b.id_num
			left outer join tw_grp_membership tgm on e.id_num = tgm.ID_NUM  and group_id = @STUDENT_GROUP_CODE
	WHERE  (b.deceased is null or b.deceased <> 'Y') and
			e.act_inact_sts = 'A' and
			e.GRP_CDE <> 'WKST' and
			tgm.ID_NUM is null
)
insert into tw_grp_membership (id_num, group_id, user_name, job_name, job_time)
SELECT staff.ID_NUM, @STUDENT_GROUP_CODE, @USER_NAME, @JOB_NAME, @JOB_TIME
FROM staff left outer join tw_grp_membership tgm on staff.ID_NUM=tgm.id_num and group_id = @STUDENT_GROUP_CODE
where tgm.id_num is null


END
------------------------------------------------------END STAFF------------------------------------------------------

/* =============  make sure login-id_xref is properly populated ====================*/
--insert into login_id_xref		
--select tws.ID_NUM, tws.ID_NUM,1,tws.USER_NAME, tws.JOB_NAME, tws.job_time 
--from tw_web_security tws left outer join login_id_xref xr on tws.ID_NUM=xr.id_num 
--where xr.ID_NUM is null


/*====================================================================================================*/
---------------------------------END Insert into TW_WEB_SECURITY and TW_GRP_MEMBERSHIP---------------------------------
/*====================================================================================================*/
--------------------------------------BEGIN Populate STUDENT_MASTER.TEL_WEB_GRP_CDE--------------------------------------

--This script assigns students to their appropriate time control groups.
--This script assumes that you want to set the web registration group code in
--student master to the division code for the current degree.
--You must verify that the tel web group codes match the division codes.
--You will definately need to modify this script to reflect the TEL_WEB_GRP_CDE
--values you have configured through your Tel/Web Admin module.

/*====================================================================================================*/
--not in effect for server
IF (@SET_TEL_WEB_GRP_CDE = 1)
BEGIN
PRINT 'Begin TEL_WEB_GRP_CDE update ' + convert(char,getdate())

--UPDATE student_master SET student_master.tel_web_grp_cde = d.div_cde
--FROM student_master join degree_history d ON
--student_master.id_num = d.id_num AND
--(student_master.tel_web_grp_cde IS NULL OR student_master.tel_web_grp_cde <> d.div_cde) AND
--d.cur_degree = 'Y' AND
--d.div_cde IN (SELECT tel_web_grp_cde FROM tw_group_def)

END
		
--------------------------------------END Populate STUDENT_MASTER.TEL_WEB_GRP_CDE--------------------------------------
/*====================================================================================================*/
----------------------------------------BEGN Populate TW_WEB_SECURITY.ACCESS_CDE----------------------------------------
--CREATED BY: Paul Edinger, Moravian College  8/15/2001
--DESC: This script will create a random 8 character access code where no 2 consecutive
--	characters are the same.  As written, it will also assign access codes to anyone
--	in the web module with a NULL access code.  This prevents people who have encrypted
--	access codes and have had the plain text version deleted from getting new codes.


--Create a string to contain all 36 alpha-numeric characters
IF (@SET_ACCESS_CODE = 1)
BEGIN
PRINT 'Begin Set Web Access Codes ' + convert(char,getdate())
DECLARE
@src_string CHAR(36),
@pwd_char1 CHAR(1),
@pwd_char2 CHAR(1),
@pwd_char3 CHAR(1),
@pwd_char4 CHAR(1),
@pwd_char5 CHAR(1),
@pwd_char6 CHAR(1),
@pwd_char7 CHAR(1),
@pwd_char8 CHAR(1),
@pwd CHAR(8),
@pos INTEGER,
@pass_id NUMERIC

SELECT @src_string = 'abcdefghijklmnopqrstuvwxyz0123456789'

--Declare a cursor to select all records in the tw_web_security table with a NULL access code.
--This can be changed to select differently, or omitted to simply generate a password.

DECLARE blank_cde CURSOR FOR
	SELECT	id_num 
	FROM	tw_web_security
	WHERE	access_cde IS NULL AND
		access_cde_encrypt IS NULL

OPEN blank_cde

FETCH NEXT FROM blank_cde INTO @pass_id

WHILE (@@FETCH_STATUS <> -1)	--While we haven't reached the end of the cursor result set
BEGIN

	--Create a random number, multiply by 10^7 to get a number > 0.  This number is then converted
	--to an integer so the decimal part gets dropped.  Then take the resulting integer MOD 36
	--to get a random position in the source string above.  You must add 1 for cases where the
	--resulting integer is divisible by 36.  Then take the character from the source string
	--at that random position.

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char1 = SUBSTRING(@src_string, @pos, 1)

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char2 = SUBSTRING(@src_string, @pos, 1)

	--Now that we have 2 consecutive characters, make sure that they are not the same.  If they
	--are, regenerate the second one and re-check.  When they are different, move on and repeat
	--this process for the remaining characters

	WHILE (@pwd_char1 = @pwd_char2)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char2 = SUBSTRING(@src_string, @pos, 1)
	END

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char3 = SUBSTRING(@src_string, @pos, 1)

	WHILE (@pwd_char2 = @pwd_char3)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char3 = SUBSTRING(@src_string, @pos, 1)
	END

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char4 = SUBSTRING(@src_string, @pos, 1)

	WHILE (@pwd_char3 = @pwd_char4)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char4 = SUBSTRING(@src_string, @pos, 1)
	END

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char5 = SUBSTRING(@src_string, @pos, 1)

	WHILE (@pwd_char4 = @pwd_char5)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char5 = SUBSTRING(@src_string, @pos, 1)
	END

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char6 = SUBSTRING(@src_string, @pos, 1)

	WHILE (@pwd_char5 = @pwd_char6)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char6 = SUBSTRING(@src_string, @pos, 1)
	END

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char7 = SUBSTRING(@src_string, @pos, 1)

	WHILE (@pwd_char6 = @pwd_char7)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char7 = SUBSTRING(@src_string, @pos, 1)
	END

	SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
	SELECT @pwd_char8 = SUBSTRING(@src_string, @pos, 1)

	WHILE (@pwd_char7 = @pwd_char8)
	BEGIN
		SELECT @pos = (CONVERT(INTEGER, (RAND()*10000000)) % 36) + 1
		SELECT @pwd_char8 = SUBSTRING(@src_string, @pos, 1)
	END

	--Once all 8 positions are set, concatenate them into one string.  The ISNULL function is
	--added as a precaution against ending up with a null password due to one null character

	SELECT @pwd = ISNULL(@pwd_char1,'') + ISNULL(@pwd_char2,'') + ISNULL(@pwd_char3,'') + 
		ISNULL(@pwd_char4,'') + ISNULL(@pwd_char5,'') + ISNULL(@pwd_char6,'') + 
		ISNULL(@pwd_char7,'') + ISNULL(@pwd_char8,'')

	--Update the current record in the cursor with the random password.

	UPDATE tw_web_security SET access_cde = @pwd WHERE CURRENT OF blank_cde

	FETCH NEXT FROM blank_cde INTO @pass_id

END

--More cursor management

CLOSE blank_cde

DEALLOCATE blank_cde
END


-- option 2 for setting password code
IF (@SET_ACCESS_CODE = 2)  --This process follows the server student original password specification
BEGIN
PRINT 'Begin Set Web Access Codes Alternate' + convert(char,getdate())

update s 
set access_cde= UPPER(SUBSTRING(coalesce(first_name,space(0)),1,1))+LOWER(SUBSTRING(coalesce(LAST_NAME,space(0)),1,1))+'-'+CONVERT(char,s.id_num)
from tw_web_security s join NAME_MASTER nm on s.ID_NUM=nm.id_num
where access_cde is null

end

----------------------------------------END Populate TW_WEB_SECURITY.ACCESS_CDE----------------------------------------
-- Populate login name with proper convention
/*====================================================================================================*/
-- keep ex active directory record up to date to ensure uniqueness in the 
-- samaccountnames for active directory 
/*====================================================================================================*/
 -- add Employee accounts from active directory into reporting table 
/*====================================================================================================*/
PRINT 'CUS_ManageActiveDirectory with latest Active Directory ' + convert(char,getdate())

delete from CUS_ManageActiveDirectory   -- refresh table from active directory each run

insert into CUS_ManageActiveDirectory
  select  case when isnumeric(employeeid)=1 then employeeid else null end employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon,
      case when userAccountControl in (514, 66050) then 'Disabled' else 'Enabled' end UserAccountControl
-- nTSecurityDescriptor,extensionName,comment,objectSid,info,manager, company
-- personalTitle,profilePath,sAMAccountType,userAccountControl,,preferredOU,primaryGroupID
            -- into CUS_ManageActiveDirectory
             --select * 
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  ,UserAccountControl
  FROM  ''LDAP://OU=Employees,DC=server,DC=edu''  
  WHERE objectClass =  ''User''  
  ')
 where sAMAccountName not in (select samaccountname from CUS_ManageActiveDirectory)
 ;
/*====================================================================================================*/ 
 -- add student accounts from active directory into reporting table 
/*====================================================================================================*/
--based on the volumn of rows from active directory cannot extract more than 4000 rows at a time < L
--===========================================================================================
insert into CUS_ManageActiveDirectory
  select  case when isnumeric(employeeid)=1 then employeeid else null end employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon,
      case when userAccountControl in (514, 66050) then 'Disabled' else 'Enabled' end UserAccountControl
      --select  * 
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  ,UserAccountControl
  FROM  ''LDAP://OU=Students,DC=server,DC=edu'' 
  WHERE objectClass =  ''User''  and sAMAccountName <''L''
  ')

;
--===========================================================================================
--based on the volumn of rows from active directory cannot extract more than 4000 rows at a time >= L
--===========================================================================================
insert into CUS_ManageActiveDirectory
  select   case when isnumeric(employeeid)=1 then employeeid else null end employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon,
      case when userAccountControl in (514, 66050) then 'Disabled' else 'Enabled' end UserAccountControl
      --select  * 
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  ,UserAccountControl
  FROM  ''LDAP://OU=Students,DC=server,DC=edu'' 
  WHERE objectClass =  ''User''  and sAMAccountName >=''L''
  ')


/*====================================================================================================*/ 
-- update login_id_ref login to samaccountname if already in active directory
/*====================================================================================================*/
/* found several cases where employeeID was in the active directory with multiple SamAccountNames
current solution is if the login matches any samaccountname in the active directory to leave it alone */
IF (@UPDATE_LOGIN = 1)  --take this portion out of service 8/28/2015 
BEGIN


update xr set xr.web_login=samaccountname ,
 JOB_TIME=@JOB_TIME ,		--GETDATE() ,
 [user_name]=@USER_NAME ,	-- 'ManageAD' ,
  job_name=@JOB_NAME		--'UPDT_pre_manageAD'
  --select * 
from TW_WEB_SECURITY xr 
	join CUS_ManageActiveDirectory mad 
		on case when isnumeric(employeeid)=1 then employeeid else null end =convert(char,xr.id_num) and web_LOGIN<>samaccountname
		--and employeeid not in (select employeeid from CUS_ManageActiveDirectory group by employeeid having COUNT(*)>1) 
		and web_login not in ( select sAMAccountName from CUS_ManageActiveDirectory )
		and mad.UserAccountControl <>'Disabled'

end

/*====================================================================================================*/
-- make the login format to follow rules to be applied for active directory account naming 
-- this will rename those in students candidate role only 
/*====================================================================================================*/
PRINT 'Assign Login Name for JICS and Active Directory ' + convert(char,getdate())

;with who2get as (  -- who should get a new login name
select xr.id_num, xr.web_login
,replace(replace(replace(replace(rtrim(coalesce(nm.FIRST_NAME,space(0))),SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)),'.',SPACE(0)) FIRST_NAME
,replace(replace(replace(replace(rtrim(coalesce(nm.MIDDLE_NAME,space(0))),SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)),'.',SPACE(0)) MIDDLE_NAME
,replace(replace(replace(replace(rtrim(coalesce(nm.LAST_NAME,space(0))),SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)),'.',SPACE(0)) LAST_NAME
from TW_WEB_SECURITY xr join NAME_MASTER nm on nm.ID_NUM=xr.id_num 
		join tw_grp_membership gm on xr.id_num=gm.id_num
where CONVERT(char,xr.id_num)=xr.web_login and gm.group_id in ('candidate','student')
group by xr.id_num, xr.web_login,nm.FIRST_NAME, nm.MIDDLE_NAME,nm.LAST_NAME
), x1 as (   -- create and order the options for a person login name
select * from (

select ID_NUM,  WEB_LOGIN, 1 SEQ,   -- first_name + last_name
substring((first_name+last_name),1,18) AD_login
from who2get

union all
select ID_NUM,  WEB_LOGIN, 2 SEQ,   -- first_name + middle initial + last_name
substring((first_name+SUBSTRING(middle_NAME,1,1)+last_name),1,18) AD_login
from who2get 
where len(MIDDLE_NAME)>0

union all
select ID_NUM,  WEB_LOGIN, 3 SEQ,    -- first_name + middle_name + last_name
substring((first_name+middle_NAME+last_name),1,18) AD_login
from who2get 
where len(MIDDLE_NAME)>1

union all
select ID_NUM,  WEB_LOGIN, 4 SEQ,     -- first_name + middle_name + last_name + last 3 numbers of ID_NUM
substring((first_name+middle_NAME+last_name),1,16)+right(rtrim(convert(char,id_num)),3) AD_login
from who2get 
	
) lgin		
), ADWebchk as (   -- who needs a login name the name is not in active directory or tw_web_security/login_id_xref
select x1.* from x1	left outer join CUS_ManageActiveDirectory cus on x1.AD_login=cus.samaccountname
			left outer join TW_WEB_SECURITY xr on x1.AD_login=xr.WEB_LOGIN
where cus.samaccountname is null and xr.web_login is null				
--order by LOGIN, seq
), MSQ AS (
select ID_NUM, MIN(SEQ) MSEQ from ADWebchk GROUP BY ID_NUM
),nwlog as (
select oc.* from ADWebchk oc join MSQ on oc.ID_NUM=msq.id_num and oc.SEQ=msq.mseq
)
update x set x.web_LOGIN= nwlog.ad_login, x.[User_Name]='ManageAD',  x.JOB_TIME=GETDATE(), x.JOB_NAME='UpdateWebName'
--select x.LOGIN, nwlog.ad_login,  x.JOB_TIME,GETDATE(), x.JOB_NAME,'UpdateWebName'
from tw_web_security x join nwlog on x.id_num=nwlog.id_num 

/*====================================================================================================*/
  --  adjust students email to the server email address.
IF (@STUDENTS_EMAIL = 1)
BEGIN
PRINT 'Correct Students Email ' + convert(char,getdate())

--save personal email  --insert *PML record
insert into ADDRESS_MASTER ([ID_NUM],[ADDR_CDE],[ADDR_STS],[CASS_STS],[DTE_CONFIRMED],[START_DTE],[STOP_ADDR_MAIL],
		[ADDR_PRIVATE],[ADDR_LINE_1],[PHONE_PRIVATE],[EMAIL_ADDR],[NOTIFICATION_ENABLED],--[INSTITUTION_EMAIL],
		[user_name], [job_name], [job_time])
SELECT am.[ID_NUM]
      ,'*PML'[ADDR_CDE]
      ,am.[ADDR_STS]
      ,am.[CASS_STS]
      ,getdate() [DTE_CONFIRMED]
      ,getdate()[START_DTE]
      ,'N'[STOP_ADDR_MAIL]
      ,'N'[ADDR_PRIVATE]
      ,am.[ADDR_LINE_1]
      ,'N'[PHONE_PRIVATE]
      ,'Y'[EMAIL_ADDR]
      ,'N'[NOTIFICATION_ENABLED]
      --,'N'[INSTITUTION_EMAIL]
      ,'ManageAD', 'Save_Personal_Email',GETDATE()
 from ADDRESS_MASTER am join TW_GRP_MEMBERSHIP grp on am.ID_NUM=grp.id_num and grp.GROUP_ID='Student'
		join TW_WEB_SECURITY x on am.ID_NUM=x.id_num
		left outer join ADDRESS_MASTER am2 on am2.ID_NUM=am.id_num and am2.ADDR_CDE='*PML'
where am.ADDR_CDE='*EML' and am.ADDR_LINE_1 not like '%@server%'  and am2.id_num is null

--update personal email

update am 
SET [DTE_CONFIRMED]=getdate() 
      ,[ADDR_LINE_1]= rtrim(web_login)+'@server.edu'
      ,[user_name]= 'ManageAD', [job_name]='Save_Personal_Email',[job_time]=GETDATE()
      --select * 
 from ADDRESS_MASTER am  join TW_GRP_MEMBERSHIP grp on am.ID_NUM=grp.id_num and grp.GROUP_ID='Student'
		join TW_WEB_SECURITY tmp on am.ID_NUM=tmp.id_num
		left outer join ADDRESS_MASTER am2 on am2.ID_NUM=tmp.id_num and am2.ADDR_CDE='*PML'
where am.ADDR_CDE='*EML' and am.ADDR_LINE_1 not like '%@server%'  and am2.id_num is not null and am.ADDR_LINE_1 <>am2.ADDR_LINE_1

--create server.edu mail out of new login 
update nm
set EMAIL_ADDRESS = rtrim(web_login)+'@server.edu'
-- select EMAIL_ADDRESS , rtrim(login)+'@server.edu'
from NAME_MASTER nm join TW_GRP_MEMBERSHIP gm on nm.ID_NUM=gm.ID_NUM and gm.GROUP_ID='student'
join TW_WEB_SECURITY xr on nm.ID_NUM=xr.ID_NUM
where coalesce(EMAIL_ADDRESS,'X') not like '%@server%'

END

/*====================================================================================================*/

PRINT 'Completed ' + convert(char,getdate())






