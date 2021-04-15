CREATE TABLE dbo.EmployeePhoto
(EmployeeId      INT NOT NULL PRIMARY KEY, 
 Photo           VARBINARY(MAX) NULL, 
 MyRowGuidColumn UNIQUEIDENTIFIER NOT NULL
                                  ROWGUIDCOL UNIQUE
                                             DEFAULT NEWID()
);

CREATE TABLE Bookstore2
(ISBN_NO    VARCHAR(15) NOT NULL PRIMARY KEY, 
 SHORT_DESC VARCHAR(100), 
 AUTHOR     VARCHAR(40), 
 PUBLISHER  VARCHAR(40), 
 PRICE      FLOAT, 
 INDEX SHORT_DESC_IND(SHORT_DESC, PUBLISHER)
);

--create schema production;

CREATE TABLE production.parts(
    part_id   INT NOT NULL, 
    part_name VARCHAR(100)
);

INSERT INTO 
    production.parts(part_id, part_name)
VALUES
    (1,'Frame'),
    (2,'Head Tube'),
    (3,'Handlebar Grip'),
    (4,'Shock Absorber'),
    (5,'Fork');

	SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5;

CREATE TABLE production.part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) 
);

ALTER TABLE Production.part_prices
DROP CONSTRAINT PK__part_pri__20299A2B7FF8CF73; 

Alter table Production.parts
drop constraint PK__parts__A0E3FAB88A2EF682;

CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id);

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5;