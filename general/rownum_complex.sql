use WideWorldImporters
SELECT row_number() over(ORDER BY o.orderId ) rownum, cat.CustomerCategoryName ,
                                                          o.OrderID,c.CustomerName,c.AccountOpenedDate,c.DeliveryAddressLine1
FROM sales.CustomerCategories cat
INNER JOIN Sales.Customers c ON cat.CustomerCategoryID=c.CustomerCategoryID
Inner Join Sales.Orders o on o.CustomerID=c.CustomerID