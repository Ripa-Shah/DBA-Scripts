if(OBJECT_ID('tempdb..#LocalTempTbl') is null)
create table #LocalTemptbl (spyid int not null, spyname text not null, realname text null); 
insert into #LocalTempTbl(spyid,spyname,realname) values(1,'Black Widow','Scarlet Johnson');
insert into #LocalTemptbl(spyid,spyname,realname) values(2,'Ethan Hunt','Tom Cruise');
insert into #LocalTemptbl(spyid,spyname,realname) values(3,'Evelyn Salt','Angelina Jolie');

select * from tempdb.sys.objects
where name like '%[_]%'
and (select len(name)-len(replace(name,'#','')))=1
