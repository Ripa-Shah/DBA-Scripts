

select s.StockItemName, s.QuantityPerOuter,
s.TaxRate,
s.Brand,
s.UnitPrice,
sum(s.QuantityPerOuter*s.UnitPrice) [TotalAmount] 
from Warehouse.StockItems s
inner join Purchasing.Suppliers ps
on ps.SupplierID=s.SupplierID
group by s.StockItemName,s.QuantityPerOuter,s.TaxRate,s.Brand,s.UnitPrice