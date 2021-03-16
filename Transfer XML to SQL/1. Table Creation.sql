create table museum
(
Mid int identity(1,1) primary key,
Mname varchar(500),
Mphone varchar(15),
Maddress nvarchar(500),
Mclosing varchar(25),
Mrates nvarchar(200),
Mspecials nvarchar(max));
