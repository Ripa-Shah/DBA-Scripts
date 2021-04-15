--create login basicuser with password='password123!';
select * from tempdb.sys.objects where name like '#%';

if not exists (select name from sys.objects where name='table_variable')
declare @table_variable table (spy_id int not null, spyname text not null, realname text null);

insert into @table_variable(spy_id,spyname,realname) values (1,'Black Widow','Scarlet johnson');
insert into @table_variable(spy_id,spyname,realname) values (2,'Ethan Hunt','Tom Cruise');
insert into @table_variable(spy_id,spyname,realname) values (3,'Evelyn Salt','Angelina Jollie');
select * from @table_variable;
select * from sys.objects where name not like '%[]%'
and (select len(name)- len(replace(name,'#','')))=1
 