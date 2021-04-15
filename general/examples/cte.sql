WITH cte_sales AS (
    SELECT 
        CustomerID, 
        COUNT(*) order_count  
    FROM
        sales.orders
    WHERE 
        YEAR(orderdate) = 2018
    GROUP BY
        CustomerID

)
SELECT
    AVG(order_count) average_orders_by_staff
FROM 
    cte_sales;