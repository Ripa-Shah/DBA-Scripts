create table country
(id int identity primary key,
country_name char(128),
country_name_eng char(128),
country_code char(8));
--drop table country;

drop trigger if exists t_country_insert;
go
CREATE TRIGGER t_country_insert ON country INSTEAD OF INSERT
AS BEGIN
    DECLARE @country_name CHAR(128);
    DECLARE @country_name_eng CHAR(128);
    DECLARE @country_code  CHAR(8);
	select @country_name=country_name, @country_name_eng=country_name_eng, @country_code=country_code from inserted i;
	IF @country_name IS NULL SET @country_name = @country_name_eng;
    IF @country_name_eng IS NULL SET @country_name_eng = @country_name;
    INSERT INTO country (country_name, country_name_eng, country_code) VALUES (@country_name, @country_name_eng, @country_code);
END;

SELECT * FROM country;
INSERT INTO country (country_name_eng, country_code) VALUES ('United Kingdom', 'UK');
insert into country(country_name,country_code) values('United States','USA');
insert into country(country_name_eng,country_code) values('Australia','AUS');

SELECT * FROM country;

DROP TRIGGER IF EXISTS t_country_delete;
GO
CREATE TRIGGER t_country_delete ON country INSTEAD OF DELETE
AS BEGIN
    DECLARE @id INT;
    DECLARE @count INT;
    SELECT @id = id FROM DELETED;
    SELECT @count = COUNT(*) FROM city WHERE country_id = @id;
    IF @count = 0
        DELETE FROM country WHERE id = @id;
    ELSE
        THROW 51000, 'can not delete - country is referenced in other tables', 1;
END;

	
DELETE FROM country WHERE id = 1;
