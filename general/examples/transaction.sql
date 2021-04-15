--CREATE Database BookStore;
--GO
--USE BookStore;
--CREATE TABLE Books
--(
--id INT,
--name VARCHAR(50) NOT NULL,
--category VARCHAR(50) NOT NULL,
--price INT NOT NULL
--)

--USE BookStore
 
--INSERT INTO Books
 
--VALUES
--(1, 'Book1', 'Cat1', 1800),
--(2, 'Book2', 'Cat2', 1500),
--(3, 'Book3', 'Cat3', 2000),
--(4, 'Book4', 'Cat4', 1300),
--(5, 'Book5', 'Cat5', 1500),
--(6, 'Book6', 'Cat6', 5000),
--(7, 'Book7', 'Cat7', 8000),
--(8, 'Book8', 'Cat8', 5000),
--(9, 'Book9', 'Cat9', 5400),
--(10, 'Book10', 'Cat10', 3200)

--INSERT INTO Books 
--VALUES (15, 'Book15', 'Cat5', 2000)
--UPDATE Books
--SET price = '25 Hundred' WHERE id = 15
--DELETE from Books
--WHERE id = 15


--BEGIN TRANSACTION
 
--  INSERT INTO Books 
--  VALUES (20, 'Book15', 'Cat5', 2000)
 
--  UPDATE Books
--  SET price = '25 Hundred' WHERE id = 20
 
--  DELETE from Books
--  WHERE id = 20
 
--COMMIT TRANSACTION

--DECLARE @BookCount int
 
--BEGIN TRANSACTION AddBook
 
--  INSERT INTO Books
--  VALUES (20, 'Book15', 'Cat5', 2000)
 
--  SELECT @BookCount = COUNT(*) FROM Books WHERE name = 'Book15'
 
--  IF @BookCount > 1
--    BEGIN 
--      ROLLBACK TRANSACTION AddBook
--      PRINT 'A book with the same name already exists'
--    END
--  ELSE
--    BEGIN
--      COMMIT TRANSACTION AddStudent
--      PRINT 'New book added successfully'
--    END

	begin transaction
	UPDATE HumanResources.Employee
        SET JobTitle = 'DBA'
        WHERE LoginID IN (
        SELECT LoginID FROM HumanResources.Employee)

