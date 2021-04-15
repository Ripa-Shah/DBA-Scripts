--Lead and Lag
SELECT cust.CustomerID,
       cust.CustomerName,
       ord.OrderDate,
       LEAD(ord.OrderDate) over(PARTITION BY cust.customername
                                ORDER BY ord.orderdate) [NextOrderDate],
       LAG(ord.OrderDate) over(PARTITION BY cust.customername
                                ORDER BY ord.orderdate) [PreviousOrderDate]
FROM Sales.Orders ord
INNER JOIN Sales.Customers cust ON ord.CustomerID=cust.CustomerID 
