--DECLARE @eid integer -- database name  
--DECLARE @ename VARCHAR(50) -- path for backup files  
DECLARE @email VARCHAR(50) -- filename for backup  
--DECLARE @eid1 integer -- used for file name 

DECLARE db_cursor CURSOR FOR  
--SELECT EMP.dbo.EmpBasic.EmpId,EMP.dbo.EmpBasic.Name,Emp.dbo.EmpDetail.EmailId 
--FROM EMP.dbo.EmpBasic ,emp.dbo.EmpDetail where EMP.dbo.EmpBasic.EmpId=EMP.dbo.EmpDetail.EmpId;
 
SELECT --DISTINCT name_master.id_num,   
         --name_master.first_name,   
         --name_master.last_name,   
         --distinct 
		 
		 name_master.EMAIL_ADDRESS --,   
         --STUDENT_CRS_HIST.yr_cde,   
         --STUDENT_CRS_HIST.trm_cde--,
		 --STUDENT_CRS_HIST.STUD_DIV
    FROM name_master,   
         STUDENT_CRS_HIST  
   WHERE ( name_master.id_num = STUDENT_CRS_HIST.id_num ) and  
         ( ( STUDENT_CRS_HIST.yr_cde = '2016') AND  
         ( STUDENT_CRS_HIST.trm_cde = '20' ) ) AND
		 (STUDENT_CRS_HIST.STUD_DIV like 'UG') AND EMAIL_ADDRESS is not null
		-- NAME_MASTER.IS_FERPA_RESTRICTED in ('Y','y')
	--order by NAME_MASTER.ID_NUM
	order by NAME_MASTER.EMAIL_ADDRESS
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @email   



WHILE @@FETCH_STATUS = 0   
BEGIN   
       
	   --PRINT cast(@eid as VARCHAR (50)) +'|'+ @ename + ' | '+@email
	   PRINT @email + ','
	   FETCH NEXT FROM db_cursor INTO @email
       --FETCH NEXT FROM db_cursor INTO @eid,@ename,@email   
	   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor