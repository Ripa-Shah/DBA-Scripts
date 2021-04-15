
select * from DEPARTMENT;
;WITH departnmentCTE(dept_cde,department) AS
(
select dept_cde, dept_desc from department
)

select * from departnmentCTE