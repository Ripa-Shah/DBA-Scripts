--create schema sales;
--drop table customer;
--create table sales.customer
--(
--	customer_id int,
--	first_name varchar(50),
--	last_name varchar(50),
--	phone varchar(10),
--	email varchar(50),
--	street varchar(50),
--	city varchar(50),
--	state1 varchar(50),
--	zipcode varchar(50)
--);
--insert into sales.customer(1,'Ripa','Shah','900078967','ripashah89@gmail.com','california','upjohn ave','California','93555');
--insert into sales.customer(2,'John','Oliver','7896756789','kanaiyo1940@gmail.com','bullock blvd','socorro','New Mexico','87801');
--insert into sales.customer(3,'John','William','8989767678','johnwilliam@gmail.com','tucumcari blvd','tucumcari','New Mexico','88401');

--CREATE INDEX ix_customers_city
--ON sales.customer(city);

SELECT 
    customer_id, 
    first_name, 
    last_name
FROM 
    sales.customer
WHERE 
    last_name = 'Berg' AND 
    first_name = 'Monika';

select
    customer_id, 
    city
FROM 
    sales.customer
WHERE 
    city = 'Atwater';