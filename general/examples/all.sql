SELECT
    AVG (list_price) avg_list_price
FROM
    production.product
GROUP BY
    brand_id
ORDER BY
    avg_list_price;

SELECT
    product_name,
    list_price
FROM
    production.product
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.product
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;

SELECT
    product_name,
    list_price
FROM
    production.product
WHERE
    list_price < ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.product
        GROUP BY
            brand_id
    )
ORDER BY
    list_price DESC;

