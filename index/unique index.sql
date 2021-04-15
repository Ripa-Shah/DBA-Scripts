--This statement uses the ALTER INDEX statement to “enable” or rebuild an index on a table:
--ALTER INDEX index_name 
--ON table_name  
--REBUILD;
--This statement uses the CREATE INDEX statement to enable the disabled index and recreate it:
--CREATE INDEX index_name 
--ON table_name(column_list)
--WITH(DROP_EXISTING=ON)
--The following statement uses the ALTER INDEX statement to enable all disabled indexes on a table:
--ALTER INDEX ALL ON table_name
--REBUILD;
--This statement uses the DBCC DBREINDEX to enable an index on a table:
--DBCC DBREINDEX (table_name, index_name);
--DBCC DBREINDEX (table_name, " ");  
--ALTER INDEX ALL ON sales.customer
--REBUILD;

----CREATE UNIQUE INDEX index_name
----ON table_name(column_list);

--SELECT
--    customer_id, 
--    email 
--FROM
--    sales.customer
--WHERE 
--    email = 'caren.stephens@msn.com';

--sELECT 
--    email, 
--    COUNT(email)
--FROM 
--    sales.customer
--GROUP BY 
--    email
--HAVING 
--    COUNT(email) > 1;

--CREATE UNIQUE INDEX ix_cust_email 
--ON sales.customer(email);

--CREATE TABLE t1 (
--    a INT, 
--    b INT
--);

--CREATE UNIQUE INDEX ix_uniq_ab 
--ON t1(a, b);
--INSERT INTO t1(a,b) VALUES(1,1);
--INSERT INTO t1(a,b) VALUES(1,2);
--INSERT INTO t1(a,b) VALUES(1,2);
--CREATE TABLE t2(
--    a INT
--);

--CREATE UNIQUE INDEX a_uniq_t2
--ON t2(a);
INSERT INTO t2(a) VALUES(NULL);
INSERT INTO t2(a) VALUES(NULL);