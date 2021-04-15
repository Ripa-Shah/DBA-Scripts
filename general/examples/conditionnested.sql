alter procedure check_price_proc
(@p_productid int)
as
declare 
	@v_unitprice float,
	@v_productname varchar(100)
begin
	select @v_unitprice=UnitPrice,
	@v_productname=ProductName
	from Products
	where ProductID=@p_productid

	print 'Current Product Price is:'+CAST(@v_unitPrice AS VARCHAR)+ ' (' + @v_productName + ')'
	if @v_unitprice > 50
		print 'Greater than 50'
		
	else 
	if @v_unitprice=50
		print 'Equal to 50'
	else
	begin
		print 'less than 50'
		update Products set UnitPrice=UnitPrice * 1.1 where ProductID=@p_productid
		select @v_unitprice=unitPrice, @v_productname=ProductName from Products
		where ProductID=@p_productid
		print 'Current Product Price is:'+ cast(@v_unitPrice as varchar)+ '('+@v_productname+')'
	end
end

exec check_price_proc 75
	 