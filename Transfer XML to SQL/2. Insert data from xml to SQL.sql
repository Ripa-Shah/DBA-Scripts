use TestDB;

INSERT INTO museum_table(Mname,Mphone,Maddress,Mclosing,Mrates,Mspecials)
SELECT
   MY_XML.museum.query('Mname').value('.', 'nvarchar(max)'),
   MY_XML.museum.query('Mphone').value('.', 'nvarchar(max)'),
   MY_XML.museum.query('Maddress').value('.', 'nvarchar(max)'),
   MY_XML.museum.query('Mclosing').value('.', 'nVARCHAR(max)'),
   MY_XML.museum.query('Mrates').value('.','nvarchar(max)'),
   MY_XML.museum.query('Mspecials').value('.','nvarchar(max)')

FROM (SELECT CAST(MY_XML AS xml)
      FROM OPENROWSET(BULK 'C:\Users\19498\Desktop\SQL\museums.xml', SINGLE_BLOB) AS T(MY_XML)) AS T(MY_XML)
      CROSS APPLY MY_XML.nodes('museums/museum') AS MY_XML(museum);

--delete from museum;