SELECT
    customerid,
    YEAR (orderdate) order_year
FROM
    sales.orders
WHERE
    customerid IN (1, 2)
ORDER BY
    customerid;

SELECT
    customerid,
    YEAR (orderdate) order_year,
    COUNT (orderid) order_placed
FROM
    sales.orders
WHERE
    customerid IN (1, 2)
GROUP BY
    customerid,
    YEAR (orderdate)
ORDER BY
    customerid;
	
SELECT
    customerid,
    YEAR (orderdate) order_year
	
FROM
    sales.orders
WHERE
    customerid IN (1, 2)
GROUP BY
    customerid,
    YEAR (orderdate)
ORDER BY
    customerid; 

SELECT
    cityName,
    COUNT (customerid) customer_count
FROM
    dbo.customers
GROUP BY
    cityName
ORDER BY
    cityName;

SELECT
    city,
    Region,
    COUNT (customerid) customer_count
FROM
    dbo.customers
GROUP BY
    Region,
    city
ORDER BY
    city,
    Region;

use AdventureWorks
SELECT
    brand_name,
    MIN (list_price) min_price,
    MAX (list_price) max_price
FROM
    production.product p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;
