 SELECT DISTINCT NAME_MASTER.id_num,   
         STUDENT_DIV_MAST.ADVISOR_ID_NUM,   
         class_definition.class_desc
 FROM adv_master LEFT OUTER JOIN student_master ON adv_master.id_num = student_master.id_num 
 LEFT OUTER JOIN class_definition ON student_master.current_class_cde = class_definition.class_cde
 left outer join NAME_MASTER on NAME_MASTER.ID_NUM=STUDENT_MASTER.ID_NUM
 left outer join STUDENT_TERM_SUM on name_MASTER.ID_NUM=STUDENT_TERM_SUM.ID_NUM
and NAME_MASTER.ID_NUM=STUDENT_TERM_SUM.ID_NUM
left outer join STUDENT_DIV_MAST on student_Div_mast.ID_NUM=name_master.id_num
left outer join REG_CONFIG on STUDENT_TERM_SUM.YR_CDE=REG_CONFIG.CUR_YR_DFLT
and STUDENT_TERM_SUM.TRM_CDE=REG_CONFIG.CUR_TRM_DFLT
--, 
--         advisor_stud_table
 WHERE 
 --( advisor_stud_table.id_num = adv_master.id_num ) 
 --and 
  ADVISOR_ID_NUM='5678'