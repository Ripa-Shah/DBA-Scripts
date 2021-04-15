


SELECT row_number() over (partition by nm.first_name,nm.last_name order by  sm.short_crs_title_1),
         sm.yr_cde,   
         sm.trm_cde,   
         sm.crs_cde,   
         ss.monday_cde,   
         ss.tuesday_cde,   
         ss.wednesday_cde,   
         ss.thursday_cde,   
         ss.friday_cde,   
         ss.saturday_cde,   
         ss.sunday_cde,   
         ss.begin_tim,   
         ss.end_tim,   
         ss.begin_dte,   
         ss.end_dte,   
         ss.days_tim_ovrid,   
         ss.loc_cde,   
         ss.bldg_cde,   
         ss.room_cde,   
         ss.comment_txt,   
         sm.short_crs_title_1,   
         nm.first_name,   
         nm.last_name,   
         ss.professor_id_num,   
         ss.seq_num_2,   
         sm.x_listed_parnt_crs,
		  (
      SELECT count(*)
      FROM STUDENT_CRS_HIST sch
      WHERE sch.YR_CDE = ss.YR_CDE
         AND sch.TRM_CDE = ss.TRM_CDE
         AND sch.CRS_CDE = ss.CRS_CDE
   ) AS [No of student] 
    FROM section_master sm,   
         section_schedules ss,   
         name_master nm
   WHERE ( ss.yr_cde = sm.yr_cde ) and  
         ( ss.trm_cde = sm.trm_cde ) and  
         ( ss.crs_cde = sm.crs_cde ) and  
         ( ss.professor_id_num = nm.id_num ) and
		 (ss.YR_CDE='2016') and
		 (ss.TRM_CDE='20')  