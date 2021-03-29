INSERT INTO museum_table(Mname,Mphone,Maddress,Mclosing,Mrates,Mspecials)
SELECT
MY_XML.museum.query('name').value('.', 'nvarchar(max)'),
MY_XML.museum.query('phone').value('.', 'nvarchar(max)'),
MY_XML.museum.query('address').value('.', 'nvarchar(max)'),
MY_XML.museum.query('closing').value('.', 'nVARCHAR(max)'),
MY_XML.museum.query('rates').value('.','nvarchar(max)'),
MY_XML.museum.query('specials').value('.','nvarchar(max)')
FROM
  (
  SELECT CAST(MY_XML AS xml)
  FROM OPENROWSET(BULK 'C:\Users\19498\Desktop\SQL\museums.xml', SINGLE_BLOB) AS T(MY_XML)
  )
 
AS T(MY_XML)
CROSS APPLY MY_XML.nodes('museums/museum') AS MY_XML(museum);