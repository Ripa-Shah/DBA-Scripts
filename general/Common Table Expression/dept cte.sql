select * from DEPARTMENT;
;WITH deptCTE(dept_cde,dept_desc) AS
(
select dept_cde,dept_desc from DEPARTMENT
)
select d.dept_cde,d.dept_desc from deptCTE d INNER JOIN deptCTE d2
ON d.dept_cde=d2.dept_cde
--select d.DEPT_CDE,d.DEPT_DESC from DEPARTMENT d INNER JOIN DEPARTMENT d2
--ON d.DEPT_CDE=d2.DEPT_CDE

