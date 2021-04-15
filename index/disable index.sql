--ALTER INDEX index_name
--ON table_name
--DISABLE;

--ALTER INDEX ALL ON table_name
--DISABLE;

ALTER INDEX ix_cust_city 
ON sales.customer 
DISABLE;

SELECT    
    first_name, 
    last_name, 
    city
FROM    
    sales.customer
WHERE 
    city = 'San Jose';

ALTER INDEX ALL ON sales.customer
DISABLE;