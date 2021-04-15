select t1.name as 'Table_Name',
		t2.name as 'Column_name',
		t3.name as 'Column_type',
		t1.create_date,
		t1.modify_date,
		t2.system_type_id,
		t1.parent_object_id
from tempdb.sys.objects as t1
join tempdb.sys.columns as t2
on t1.object_id=t2.object_id
join sys.types t3 on t2.system_type_id=t3.system_type_id
where (select LEN(t1.name)-LEN(replace(t1.name,'#','')))>1