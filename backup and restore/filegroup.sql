-- Script 1: Create DB and add additional file group
-- If DB pre exists then drop it
IF exists (SELECT * FROM sys.databases WHERE NAME = 'MSSQLTip')
USE MASTER
DROP DATABASE MSSQLTip
GO
-- Create new DB
CREATE DATABASE MSSQLTip
GO
-- Add file groups to DB
ALTER DATABASE MSSQLTip ADD FILEGROUP FG1
ALTER DATABASE MSSQLTip ADD FILEGROUP FG2
GO
-- Verify file groups in DB
USE MSSQLTip
GO 
SELECT groupName AS FileGroupName FROM sysfilegroups
GO

-- Script 2: Create tables in file groups
-- tbl1 would be created on primary file group
CREATE Table tbl1 (ID int identity(1,1))
GO
-- tbl2 would be created on FG1
CREATE Table tbl2 (ID int identity(1,1), fname varchar(20))
ON FG1
GO
-- Verify file group of tbl1
sp_help tbl1
GO
-- Verify file group of tbl2
sp_help tbl2
GO

INSERT INTO tbl2 (fname) values ('Atif')
GO

ALTER DATABASE MSSQLTip MODIFY FILEGROUP FG1 DEFAULT
GO

-- Script 3: Add data files to file groups
-- Add data file to FG1
ALTER DATABASE MSSQLTip
ADD FILE (NAME = MSSQLTip_1,FILENAME = 'C:\test\MSSQLTip_1.ndf')
TO FILEGROUP FG1
GO
-- Add data file to FG2
ALTER DATABASE MSSQLTip
ADD FILE (NAME = MSSQLTip_2,FILENAME = 'C:\test\MSSQLTip_2.ndf')
TO FILEGROUP FG2
GO
-- Verify files in file groups
USE MSSQLTip
GO
sp_helpfile
GO
  

--Script 4: Set FG1 as default file group
-- Set FG1 as default file group
ALTER DATABASE MSSQLTip MODIFY FILEGROUP FG1 DEFAULT
GO
-- Create a table without specifying file group
Create table table3 (ID TINYINT)
GO
--Verify the file group of table3 is FG1
sp_help table3
GO
-- insert some data to make sure no errors
insert into table3 values (10)
GO

--Script 5: verify default filegroup
USE MSSQLTip
GO
SELECT groupname AS DefaultFileGroup FROM sysfilegroups
WHERE convert(bit, (status & 0x10)) = 1
GO

BACKUP DATABASE MSSQLTip FILEGROUP = 'FG1' 
TO DISK = 'C:\test\TestBackup_FG1y.FLG'
GO

Backup database MSSQLTip FILEGROUP='FG2'
TO DISK='C:\test\TestBackup_FG2.FLG'
GO

backup database MSSQLTip FILEGROUP='Primary'
TO DISK='C:\test\TestBackup_Primary.flg'
GO