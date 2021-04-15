--crud op

    SELECT * FROM OPENQUERY(LSNorthwind, 'select * from dbo.Categories')  
SELECT * FROM OPENQUERY(LSNorthwind, 'EXEC [dbo].[CustOrdersOrders] VINET') 

    insert OPENQUERY(LSNorthwind, 'select CategoryName, Description from dbo.Categories')   
    select 'Testing', 'Testing'  
