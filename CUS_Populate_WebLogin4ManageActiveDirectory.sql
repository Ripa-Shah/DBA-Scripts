USE db
GO
/****** Object:  StoredProcedure [dbo].[CUS_Populate_WebLogin4ManageActiveDirectory]    Script Date: 11/1/2016 8:45:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[CUS_Populate_WebLogin4ManageActiveDirectory]
-- =============================================
-- Author:		Ripa Shah
-- Create date: 3/11/2016
-- Description:	This process is to update the local reporting data from active directory
--				and to create the web login name for JICS and active directory to use
--				this is populated in login_id_xref for version 4 of ex

-- =============================================
AS
BEGIN
	SET NOCOUNT ON;
--=============================================================================================
-- keep ex active directory record up to date to ensure uniqueness in the 
-- samaccountnames for active directory 
--=============================================================================================
--=============================================================================================  
 -- add Employee accounts from active directory into reporting table 
 --=============================================================================================

insert into CUS_ManageActiveDirectory
  select   employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon
-- nTSecurityDescriptor,extensionName,comment,objectSid,info,manager, company
-- personalTitle,profilePath,sAMAccountType,userAccountControl,,preferredOU,primaryGroupID
            -- into CUS_ManageActiveDirectory
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  FROM  ''LDAP://OU=Employees,DC=server,DC=edu''  
  WHERE objectClass =  ''User''  
  ')
 where sAMAccountName not in (select samaccountname from CUS_ManageActiveDirectory)
 
--=============================================================================================  
 -- add student accounts from active directory into reporting table 
 --=============================================================================================
insert into CUS_ManageActiveDirectory
   select   employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  FROM  ''LDAP://OU=Students,DC=server,DC=edu''  
  WHERE objectClass =  ''User''  
  ')
   where sAMAccountName not in (select samaccountname from CUS_ManageActiveDirectory) 

--=============================================================================================   
-- update login_id_ref login to samaccountname if already in active directory
--=============================================================================================

update xr set xr.login=samaccountname 
from LOGIN_ID_XREF xr 
	join CUS_ManageActiveDirectory mad 
		on employeeID=convert(char,xr.id_num) and LOGIN<>samaccountname
   
--=============================================================================================
--=============================================================================================
-- make the login format to follow rules to be applied for active directory account naming 
--=============================================================================================

;with step1 as (
select xr.ID_NUM,  xr.LOGIN, 
replace(replace(replace(rtrim(coalesce(first_name,''))+rtrim(coalesce(last_name,'')),SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)) web1
,replace(replace(replace(rtrim(coalesce(first_name,''))+substring(coalesce(middle_name,''),1,1)+rtrim(coalesce(last_name,'')),SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)) web2
,replace(replace(replace(rtrim(coalesce(first_name,''))+substring(coalesce(middle_name,''),1,1)+rtrim(coalesce(last_name,''))+right(rtrim(convert(char,xr.id_num)),3)
		,SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)) web3
,replace(replace(replace(rtrim(coalesce(first_name,''))+substring(coalesce(middle_name,''),1,1)+rtrim(coalesce(last_name,''))+right(rtrim(convert(char,xr.id_num)),4)
		,SPACE(1),space(0)),'''',SPACE(0)),'-',SPACE(0)) web4

from LOGIN_ID_XREF xr join NAME_MASTER nm on nm.ID_NUM=xr.id_num
left outer join TmsEPrd..CUS_ManageActiveDirectory mad on convert(char,xr.ID_NUM)=Employeeid
where xr.LOGIN=convert(char,xr.id_num) and EmployeeID is null
),
step2 as (
select ID_NUM, 'web1' type, web1 login  from step1
),
step3 as (
select ID_NUM, 'web2' type, web2 login  from step1
),
step4 as (
select ID_NUM, 'web3' type, web3 login  from step1
),
step5 as (
select ID_NUM, 'web4' type, web4 login  from step1
),
step6 as (
select id_num, 'exist' type, LOGIN from LOGIN_ID_XREF where LOGIN<>convert(char,id_num)
),
step7 as (
select * from step6
union all 
select * from step5
union all 
select * from step4
union all 
select * from step3
union all 
select * from step2
),
step8 as (
select LOGIN, COUNT(*) cnt from step7 group by LOGIN
), step9 as (
select step7.*, cnt, Row_Number() over (partition by step7.id_num order by type) seq from step7 join step8 on step7.LOGIN=step8.login
	left outer join LOGIN_ID_XREF xr on xr.ID_NUM=step7.ID_NUM  and xr.LOGIN=step7.LOGIN
	left outer join TmsEPrd..CUS_ManageActiveDirectory mad on convert(char,xr.ID_NUM)=Employeeid
where xr.ID_NUM is null and cnt=1 and EmployeeID is null
)
update x
set x.LOGIN= step9.LOGIN 
--select *
from login_id_xref x join step9 on x.id_num=step9.id_num 
where seq=1

end
