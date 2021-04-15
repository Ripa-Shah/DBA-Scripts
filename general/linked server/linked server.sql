EXEC sp_addlinkedserver
   @server = 'ExcelData',
   @srvproduct = 'Microsoft.Jet.OLEDB.4.0',
   @provider = 'Microsoft.Jet.OLEDB.4.0',
   @datasrc = 'C:ex.xls';