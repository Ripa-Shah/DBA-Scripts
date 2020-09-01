select distinct(sch.ID_NUM),tw.group_id,nm.FIRST_NAME,nm.LAST_NAME from TW_GRP_MEMBERSHIP tw
left outer join STUDENT_CRS_HIST sch on sch.ID_NUM=tw.ID_NUM
left outer join NAME_MASTER nm on nm.ID_NUM=sch.ID_NUM
where sch.ID_NUM not in (select t.id_num from TW_GRP_MEMBERSHIP t left outer join STUDENT_CRS_HIST s on s.ID_NUM=t.ID_NUM where t.group_id 
in('advisee','admiss_admin','admiss_coun','admiss_officer','advisor','advisor_admin',
'alumni','dev_officer','employ_applcnt','faculty','finaid_admin','general_ledger',
'guest','staff','staff_admin','student_admin'))