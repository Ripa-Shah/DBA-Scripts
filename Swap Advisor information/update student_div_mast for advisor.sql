update   STUDENT_DIV_MAST
set      STUDENT_DIV_MAST.ADVISOR_ID_NUM='5678'
    FROM adv_master LEFT OUTER JOIN student_master ON adv_master.id_num = student_master.id_num LEFT OUTER JOIN class_definition ON student_master.current_class_cde = class_definition.class_cde,   
         STUDENT_DIV_MAST,   
         name_format_suffix_view name_format_suffix_view_a,   
         name_format_suffix_view name_format_suffix_view_b  
   WHERE ( STUDENT_DIV_MAST.id_num = adv_master.id_num ) and  
         ( STUDENT_DIV_MAST.ADVISOR_ID_NUM = name_format_suffix_view_a.id_num ) and  
         ( STUDENT_DIV_MAST.id_num = name_format_suffix_view_b.id_num )
		 and STUDENT_DIV_MAST.ADVISOR_ID_NUM='1234'  
		
