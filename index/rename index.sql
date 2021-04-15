--EXEC sp_rename 
--    index_name, 
--    new_index_name, 
--    N'INDEX';  

--EXEC sp_rename 
--    @objname = N'index_name', 
--    @newname = N'new_index_name',   
--    @objtype = N'INDEX';

EXEC sp_rename 
        @objname = N'sales.customer.ix_customers_city',
        @newname = N'ix_cust_city' ,
        @objtype = N'INDEX';