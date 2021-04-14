/*recovery phases
--data copy
--redo
--undo

Recovery process
-don't make it worse calm yourself
-tail log backup (remember the demo)
--restore full backup
--restore most recent differential backup
--restore all logs from most recent differential
--restore the tail of the log and recover the database


*/


RESTORE DATABASE AdventureworksDW2014 FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak' WITH NORECOVERY
GO
RESTORE DATABASE AdventureworksDW2014 FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_diff1.bak' WITH NORECOVERY
GO
restore log AdventureWorksDW2014 
from disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_tail.trn'

RESTORE LOG AdventureworksDW2014 FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_tail.trn' WITH NORECOVERY
GO
RESTORE LOG AdventureworksDW2014 FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW20145.trn' WITH RECOVERY
GO

restore database AdventureWorksDW2014_main
from disk='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'
 

 RESTORE DATABASE AdventureWorksDW2014
   FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\Backup\AdventureWorksDW2014_bak.bak'
   WITH REPLACE,RECOVERY

   use master
   ALTER DATABASE AdventureWorks2014DW
SET MULTI_USER;
GO