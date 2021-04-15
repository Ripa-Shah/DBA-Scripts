--CREATE SCHEMA hr;
--GO
--CREATE TABLE hr.candidates(
--    id INT PRIMARY KEY IDENTITY,
--    fullname VARCHAR(100) NOT NULL
--);

--CREATE TABLE hr.employees(
--    id INT PRIMARY KEY IDENTITY,
--    fullname VARCHAR(100) NOT NULL
--);

--INSERT INTO 
--    hr.candidates(fullname)
--VALUES
--    ('John Doe'),
--    ('Lily Bush'),
--    ('Peter Drucker'),
--    ('Jane Doe');


--INSERT INTO 
--    hr.employees(fullname)
--VALUES
--    ('John Doe'),
--    ('Jane Doe'),
--    ('Michael Scott'),
--    ('Jack Sparrow');

--SELECT  
--    c.id candidate_id,
--    c.fullname candidate_name,
--    e.id employee_id,
--    e.fullname employee_name
--FROM 
--    hr.candidates c
--    INNER JOIN hr.employees e 
--        ON e.fullname = c.fullname;

--SELECT  
--	c.id candidate_id,
--	c.fullname candidate_name,
--	e.id employee_id,
--	e.fullname employee_name
--FROM 
--	hr.candidates c
--	LEFT JOIN hr.employees e 
--		ON e.fullname = c.fullname;
--SELECT  
--    c.id candidate_id,
--    c.fullname candidate_name,
--    e.id employee_id,
--    e.fullname employee_name
--FROM 
--    hr.candidates c
--    LEFT JOIN hr.employees e 
--        ON e.fullname = c.fullname
--WHERE 
    --e.id IS NULL;

--SELECT  
--    c.id candidate_id,
--    c.fullname candidate_name,
--    e.id employee_id,
--    e.fullname employee_name
--FROM 
--    hr.candidates c
--    RIGHT JOIN hr.employees e 
--        ON e.fullname = c.fullname;
--SELECT  
--    c.id candidate_id,
--    c.fullname candidate_name,
--    e.id employee_id,
--    e.fullname employee_name
--FROM 
--    hr.candidates c
--    RIGHT JOIN hr.employees e 
--        ON e.fullname = c.fullname
--WHERE
--    c.id IS NULL;
SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    FULL JOIN hr.employees e 
        ON e.fullname = c.fullname;

