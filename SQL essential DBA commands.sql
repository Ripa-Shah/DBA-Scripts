select 
SERVERPROPERTY('MachineName') as host,
SERVERPROPERTY('InstanceName') as Instance,
SERVERPROPERTY('Edition') as Edition,
SERVERPROPERTY('ProductLevel') as ProductLevel,
Case SERVERPROPERTY('IsClustered') when 1 then 'Clustered' 
									else 'Standalone'
									end as ServerType,
@@VERSION as version

select * from sys.configurations order by name;

sp_configure 'show advanced options',1
go
RECONFIGURE with OVERRIDE
go
sp_configure
go

select l.name,l.denylogin,l.isntname,l.isntgroup,l.isntuser from master.dbo.syslogins l
where l.sysadmin=1
or l.securityadmin=1

DBCC Tracestatus(-1)
dbcc tracestatus();

select name,compatibility_level,recovery_model_desc,state_desc from sys.databases;

select db_name(database_id) as databasename,name,type_desc,physical_name from sys.master_files

EXEC master.dbo.sp_MSforeachdb @command1 = 'USE [?] SELECT * FROM sys.filegroups'

SELECT Distinct physical_device_name FROM msdb.dbo.backupmediafamily
sp_who
sp_who2

SELECT db.name, 
case when MAX(b.backup_finish_date) is NULL then 'No Backup' else convert(varchar(100), 
	MAX(b.backup_finish_date)) end AS last_backup_finish_date
FROM sys.databases db
LEFT OUTER JOIN msdb.dbo.backupset b ON db.name = b.database_name AND b.type = 'D'
	WHERE db.database_id NOT IN (2) 
GROUP BY db.name
ORDER BY 2 DESC
use TmsEPrd
dbcc show_statistics

select * from sys.dm_os_wait_stats;