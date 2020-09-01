--server_Students_Not_In_Active_Directory.sql    
--Ripa Shah  3/3/2016

--==================================================================================
-- creates working extract of active directory students
IF OBJECT_ID('tempdb..##ADSI') IS NOT NULL
drop table ##ADSI ;
  
  
  select   employeeid,  sAMAccountName,instanceType,nTSecurityDescriptor,objectCategory,objectSid, mail
  ,displayName,extensionName,comment,company, DistinguishedName
  ,department,info,isDeleted,name,manager
  ,logoncount,personalTitle,profilePath,sAMAccountType,userAccountControl
  ,preferredOU,primaryGroupID
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon
  --CAST((convert(numeric,lastLogon) / 864000000000.0 - 109207) AS DATETIME)logon

             into ##ADSI
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,nTSecurityDescriptor,objectCategory,objectSid, mail
  ,displayName,extensionName,comment,company, DistinguishedName
  ,department,info,isDeleted,name,manager
  ,logoncount,personalTitle,profilePath,sAMAccountType,userAccountControl
  ,preferredOU,primaryGroupID
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  FROM  ''LDAP://OU=Students,DC=server,DC=edu''  
  WHERE objectClass =  ''User''  
  ')
  
--===========================================================================================
-- defines what current students are not in active directory

with std as (  -- students in current term
select ID_NUM, SUM(PT_FT_HRS) pt_ft_hrs from STUD_TERM_SUM_DIV sd
where YR_CDE='2014' and TRM_CDE='30' and PT_FT_HRS<>0
group by id_num  
), 
xad as ( -- stds in current term not in active directory based on employeeid
select * from std left outer join ##ADSI ad on std.ID_NUM=ad.employeeID
where  ad.samaccountname is null
)
select xr.*, ad.samaccountname --not duplicates in AD but 169 current students that are not in AD
from LOGIN_ID_XREF xr join xad on xad.ID_NUM=xr.id_num
left outer join ##ADSI ad on xr.login=ad.samaccountname
where CONVERT(char,xr.id_num)=login
--and ad.samaccountname is not null

