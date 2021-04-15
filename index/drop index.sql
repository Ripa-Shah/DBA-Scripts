--drop index (if exists) index_name
--on table_name;

--drop index index_name on table_name,
--index_name2 on table_name2;

drop index if exists ix_cust_email on sales.customer;