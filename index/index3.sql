--CREATE UNIQUE INDEX ix_cust_email 
--ON sales.customer(email);
--DROP INDEX ix_cust_email 
--ON sales.customer;

--CREATE UNIQUE INDEX ix_cust_email_inc
--ON sales.customer(email)
--INCLUDE(first_name,last_name);

SELECT 
    SUM(CASE
            WHEN phone IS NULL
            THEN 1
            ELSE 0
        END) AS [Has Phone], 
    SUM(CASE
            WHEN phone IS NULL
            THEN 0
            ELSE 1
        END) AS [No Phone]
FROM 
    sales.customer;
--CREATE INDEX ix_cust_phone
--ON sales.customer(phone)
--WHERE phone IS NOT NULL;
--CREATE INDEX ix_cust_phone_1
--ON sales.customer(phone)
--WHERE phone IS NOT NULL;
--ALTER TABLE sales.customer
--ADD 
--    email_local_part AS 
--        SUBSTRING(email, 
--            0, 
--            CHARINDEX('@', email, 0)
--        );
CREATE INDEX ix_cust_email_local_part1
ON sales.customer(email_local_part);