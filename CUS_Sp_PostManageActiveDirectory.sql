use db
GO
/****** Object:  StoredProcedure [dbo].[Cus_sp_PostManageActiveDirectory]    Script Date: 11/1/2016 8:46:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[Cus_sp_PostManageActiveDirectory]
AS
-- =============================================
-- Author:		Ripa Shah
-- Create date: 4/3/2016
-- Description:	update CUS_ManageActiveDirectory table to ensure all samAccountNames are maintained
-- =============================================	

BEGIN
	SET NOCOUNT ON;

 /*====================================================================================================*/
 -- add Employee accounts from active directory into reporting table 
/*====================================================================================================*/

insert into CUS_ManageActiveDirectory
  select case when isnumeric(employeeid)=1 then employeeid else null end employeeid,  sAMAccountName,instanceType,objectCategory, mail
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
 
/*====================================================================================================*/ 
 -- add student accounts from active directory into reporting table 
/*====================================================================================================*/
insert into CUS_ManageActiveDirectory
   select    case when isnumeric(employeeid)=1 then employeeid else null end employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon,
   case when userAccountControl in (514, 66050) then 'Disabled' else 'Enabled' end UserAccountControl
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  , userAccountControl
  FROM  ''LDAP://OU=Students,DC=server,DC=edu''  
  WHERE objectClass =  ''User''  and SamAccountName < ''K''
  ')
   where sAMAccountName not in (select samaccountname from CUS_ManageActiveDirectory)


insert into CUS_ManageActiveDirectory
   select   case when isnumeric(employeeid)=1 then employeeid else null end  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  
  ,createTimeStamp,modifyTimeStamp,lastLogonTimestamp, 
  case when isdate((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207)=1 then 
   convert(datetime,((CONVERT(BIGINT,lastLogon)/ 864000000000.0) - 109207))
   else 0 end lastLogon,
   case when userAccountControl in (514, 66050) then 'Disabled' else 'Enabled' end UserAccountControl
             from OpenQuery ( adsi,  
  'SELECT 
  employeeid,  sAMAccountName,instanceType,objectCategory, mail
  ,displayName, DistinguishedName
  ,department,isDeleted,name
  ,logoncount
  ,createTimeStamp,modifyTimeStamp
  ,lastLogonTimestamp, lastlogon
  , userAccountControl
  FROM  ''LDAP://OU=Students,DC=mesalands,DC=edu''  
  WHERE objectClass =  ''User''  and SamAccountName >= ''K''
  ')
   where sAMAccountName not in (select samaccountname from CUS_ManageActiveDirectory)

END



