--ensure database integrity
--informational statement
--dbcc opentran
--validation statement
--dbcc checkdb
--maintenance statement
--dbcc freeproccache
--misceallaneous statement
--dbcc traceoff/traceon

dbcc opentran
dbcc checkdb('TmsEPrd') with no_infomsgs, all_errormsgs
dbcc freeproccache
dbcc traceon
dbcc traceoff
dbcc checkalloc
use TmsEPrd
GO
dbcc checktable(N'TmsEPrd.dbo.Name_Master',NOINDEX) with all_errormsgs;

USE AdventureWorks2014DW
GO
ALTER DATABASE AdventureWorks2014DW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DBCC CHECKTABLE (N'FactFinance',REPAIR_REBUILD) WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO
ALTER DATABASE Test SET MULTI_USER;