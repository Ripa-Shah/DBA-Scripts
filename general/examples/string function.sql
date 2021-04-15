WITH cte AS(
    SELECT  
        CHAR(ASCII('A')) [char], 
        1 [count]
    UNION ALL
    SELECT  
        CHAR(ASCII('A') + cte.count) [char], 
        cte.count + 1 [count]
    FROM    
        cte
)
SELECT  
    TOP(26) cte.char
FROM
    cte;
SELECT 
    CHARINDEX('SQL', 'SQL Server CHARINDEX') position;

SELECT 
    CHARINDEX(
        'SERVER', 
        'SQL Server CHARINDEX' 
        COLLATE Latin1_General_CS_AS
    ) position;

DECLARE @haystack VARCHAR(100);  
SELECT @haystack = 'This is a haystack';  
SELECT CHARINDEX('needle', @haystack);  

SELECT 
    CHARINDEX('is','This is a my sister',5) start_at_fifth,
    CHARINDEX('is','This is a my sister',10) start_at_tenth;

SELECT 
    SOUNDEX('Two') soundex_two,
    SOUNDEX('Too') soundex_too,
    DIFFERENCE('Two', 'Too') similarity;

SELECT 
    SOUNDEX('Johny') soundex_johny,
    SOUNDEX('John') soundex_john,
    DIFFERENCE('Johny', 'John') similarity;

SELECT 
    SOUNDEX('Coffee') soundex_coffee,
    SOUNDEX('Laptop') soundex_laptop,
    DIFFERENCE('Coffee', 'Laptop') similarity;

SELECT 
    customer_id,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) full_name
FROM 
    sales.customer
ORDER BY 
    full_name;

SELECT 
    CONCAT(
        CHAR(13),
        CONCAT(first_name,' ',last_name),
        CHAR(13),
        phone,
        CHAR(13),
        CONCAT(city,' ',state1),
        CHAR(13),
        zipcode
    ) customer_address
FROM
    sales.customer
ORDER BY 
    first_name,
    last_name;

SELECT 
    CONCAT_WS(' ', 'John', 'Doe') full_name

SELECT LEFT('SQL Server',3) Result_string;

SELECT 
    product_name,
    LEFT(product_name, 7) first_7_characters
FROM 
    production.product
ORDER BY 
    product_name;