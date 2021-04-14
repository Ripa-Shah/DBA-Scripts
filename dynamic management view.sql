select * from sys.dm_os_waiting_tasks as t
inner join
sys.dm_exec_sessions as s
on s.session_id=t.session_id	
where s.is_user_process=1
and t.wait_duration_ms>3000;