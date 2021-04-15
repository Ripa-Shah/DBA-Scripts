--CREATE TABLE sales.members (
--    member_id INT IDENTITY PRIMARY KEY,
--    customer_id INT NOT NULL,
--    member_level CHAR(10) NOT NULL
--);
--CREATE TRIGGER sales.trg_members_insert
--ON sales.members
--AFTER INSERT
--AS
--BEGIN
--    PRINT 'A new member has been inserted';
--END;
--insert into sales.members values(3,'Gold');
--DISABLE TRIGGER sales.trg_members_insert 
--ON sales.members;
--DISABLE TRIGGER ALL ON sales.members;
CREATE TRIGGER sales.trg_members_delete
ON sales.members
AFTER DELETE
AS
BEGIN
    PRINT 'A new member has been deleted';
END;
