--select @@VERSION;

-- update ADVISOR_STUD_TABLE
--        set  
--         advisor_stud_table.advisor_id='5678'
--    FROM adv_master LEFT OUTER JOIN student_master ON adv_master.id_num = student_master.id_num LEFT OUTER JOIN class_definition ON student_master.current_class_cde = class_definition.class_cde,   
--         advisor_stud_table,   
--         name_format_suffix_view name_format_suffix_view_a,   
--         name_format_suffix_view name_format_suffix_view_b  
--   WHERE ( advisor_stud_table.id_num = adv_master.id_num ) and  
--         ( advisor_stud_table.advisor_id = name_format_suffix_view_a.id_num ) and  
--         ( advisor_stud_table.id_num = name_format_suffix_view_b.id_num )
		 and ADVISOR_STUD_TABLE.ADVISOR_ID='1234'  
--		 and ADVISOR_STUD_TABLE.ID_NUM='4356051'
delete from ADVISOR_STUD_TABLE where ID_NUM='4356051';
select @@ROWCOUNT;
