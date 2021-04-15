--CREATE TABLE demo(id INT IDENTITY(1, 1),EmpName varchar(50));

--SELECT IDENT_CURRENT('demo') as [IdentityBeforeInsert]; 
--BEGIN TRANSACTION 
--INSERT INTO dbo.demo ( EmpName ) VALUES('Raj'); 
--INSERT INTO dbo.demo ( EmpName ) VALUES('Sonu'); 
--INSERT INTO dbo.demo ( EmpName ) VALUES('Hari'); 
--INSERT INTO dbo.demo ( EmpName ) VALUES('Cheena'); 
--SELECT IDENT_CURRENT('demo') as [IdentityAfterInsert];
--INSERT INTO dbo.demo ( EmpName ) VALUES('sheena'); 
--INSERT INTO dbo.demo ( EmpName ) VALUES('teena'); 
--INSERT INTO dbo.demo ( EmpName ) VALUES('heena'); 
--rollback tran
--select IDENT_CURRENT('demo') as [IdentityAfterRollbackInsert];

--declare @demo table (id int);
--	insert @demo(id) values(11);
--	SELECT id AS 'Before BEGIN TRAN statement' FROM @Demo; 
--		BEGIN TRANSACTION 
--			UPDATE @Demo SET id = 20; 
--                  SELECT id AS 'After BEGIN TRAN statement' FROM @Demo;
--			ROLLBACK TRAN 
--                  SELECT id AS 'After explicit ROLLBACK TRAN' FROM @Demo;

--SELECT @@TRANCOUNT AS [First trancount];
--BEGIN TRANSACTION;
--SELECT @@TRANCOUNT AS [Second trancount]; 
    
--INSERT INTO dbo.demo(EmpName) VALUES('Hari'); 
--INSERT INTO dbo.demo(EmpName) VALUES('Cheena'); 
-- SELECT @@TRANCOUNT AS [Middle trancount];    
--COMMIT TRANSACTION;
    
--SELECT @@TRANCOUNT AS [Third trancount];

SELECT @@TRANCOUNT AS [First trancount];
BEGIN TRANSACTION;
SELECT @@TRANCOUNT AS [Second trancount];
INSERT INTO demo(EmpName) VALUES('Hari'); 
BEGIN TRANSACTION;
SELECT @@TRANCOUNT AS [Third trancount];
INSERT INTO demo(EmpName) VALUES('MOHAN'); 
COMMIT TRANSACTION;
SELECT @@TRANCOUNT AS [Fourth trancount];
ROLLBACK TRANSACTION;
SELECT @@TRANCOUNT AS [Fifth trancount];