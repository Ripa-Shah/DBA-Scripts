select StockItemName,TotalAmount,
 sum(TotalAmount) OVER(ORDER BY StockItemName) AS RunningTotal
from(

select s.StockItemName, s.QuantityPerOuter,
s.TaxRate,
s.Brand,
s.UnitPrice,
sum(s.QuantityPerOuter*s.UnitPrice) [TotalAmount] 
from Warehouse.StockItems s
inner join Purchasing.Suppliers ps
on ps.SupplierID=s.SupplierID
group by s.StockItemName,s.QuantityPerOuter,s.TaxRate,s.Brand,s.UnitPrice
) t

--SELECT productname,
--       TotalAmout,
--       sum([TotalAmout]) OVER(ORDER BY productname) AS RunningTotal
--FROM
--  (SELECT prod.ProductName,
--          sum(ord.Quantity*ord.UnitPrice) [TotalAmout]
--   FROM [Order Details] ord
--   INNER JOIN Products prod ON ord.ProductID=prod.ProductID
--   GROUP BY prod.ProductName) t