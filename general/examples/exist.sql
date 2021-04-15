sELECT
    *
FROM
    sales.orders o
WHERE
    EXISTS (
        SELECT
            customerid
        FROM
            sales.customers c
        WHERE
            o.customerid = c.customerid
       
    )
ORDER BY
    o.customerid,
    orderdate;