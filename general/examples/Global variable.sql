if (OBJECT_ID('tempdb..##GlobalTemptbl') is null)
create table ##GlobalTemptbl(spyid int not null, spyname varchar(50) not null, realname varchar(50) null);
insert into ##GlobalTemptbl(spyid,spyname,realname) values(1,'Black Widow','Scarlett Johnson');
insert into ##GlobalTemptbl(spyid,spyname,realname) values(2,'Ethan Hunt','Tom Cruise');
insert into ##GlobalTemptbl(spyid,spyname,realname) values(3,'Evelyn Salt','Angelina Jolie');
go
select * from ##GlobalTemptbl;
go

select * from tempdb.sys.objects
where (select len(name)- len(replace(name,'#',''))) > 1