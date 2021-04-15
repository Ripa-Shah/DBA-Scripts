

use WideWorldImporters
SELECT dense_rank() over(ORDER BY o.orderId ) orderwiserownum,
 cat.CustomerCategoryName ,
 o.OrderID,
 c.CustomerName,
 c.AccountOpenedDate,
 c.DeliveryAddressLine1,
 ROW_NUMBER() over (partition by cat.customerCategoryName order by o.orderId)
FROM sales.CustomerCategories cat
INNER JOIN Sales.Customers c ON cat.CustomerCategoryID=c.CustomerCategoryID
Inner Join Sales.Orders o on o.CustomerID=c.CustomerID