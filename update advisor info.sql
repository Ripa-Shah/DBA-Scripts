update ADVISOR_STUD_TABLE set advisor_stud_table.ADVISOR_ID=STUDENT_DIV_MAST.ADVISOR_ID_NUM from STUDENT_DIV_MAST
where STUDENT_DIV_MAST.ADVISOR_ID_NUM=ADVISOR_STUD_TABLE.ADVISOR_ID and 
STUDENT_DIV_MAST.ADVISOR_ID_NUM is not null 
and student_div_mast.DIV_CDE=ADVISOR_STUD_TABLE.DIV_CDE;
  --and
--not exists(select * from ADVISOR_STUD_TABLE where ADVISOR_STUD_TABLE.ADVISOR_ID =STUDENT_DIV_MAST.ADVISOR_ID_NUM and 
--ADVISOR_STUD_TABLE.ID_NUM=STUDENT_DIV_MAST.ID_NUM);