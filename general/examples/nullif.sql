--CREATE TABLE sales.leads
--(
--    lead_id    INT	PRIMARY KEY IDENTITY, 
--    first_name VARCHAR(100) NOT NULL, 
--    last_name  VARCHAR(100) NOT NULL, 
--    phone      VARCHAR(20), 
--    email      VARCHAR(255) NOT NULL
--);

--INSERT INTO sales.leads
--(
--    first_name, 
--    last_name, 
--    phone, 
--    email
--)
--VALUES
--(
--    'John', 
--    'Doe', 
--    '(408)-987-2345', 
--    'john.doe@example.com'
--),
--(
--    'Jane', 
--    'Doe', 
--    '', 
--    'jane.doe@example.com'
--),
--(
--    'David', 
--    'Doe', 
--    NULL, 
--    'david.doe@example.com'
--);
SELECT 
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM 
    sales.leads
ORDER BY
    lead_id;

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM    
    sales.leads
WHERE 
    phone IS NULL;

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM    
    sales.leads
WHERE 
    NULLIF(phone,'') IS NULL;