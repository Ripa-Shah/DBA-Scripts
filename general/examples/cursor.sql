--CREATE TABLE #ITEMS (ITEM_ID uniqueidentifier NOT NULL, ITEM_DESCRIPTION VARCHAR(250) NOT NULL)
--INSERT INTO #ITEMS
--VALUES
--(NEWID(), 'This is a wonderful car'),
--(NEWID(), 'This is a fast bike'),
--(NEWID(), 'This is a expensive aeroplane'),
--(NEWID(), 'This is a cheap bicycle'),
--(NEWID(), 'This is a dream holiday')

DECLARE @ITEM_ID uniqueidentifier  -- Here we create a variable that will contain the ID of each row.
 
DECLARE ITEM_CURSOR CURSOR  -- Here we prepare the cursor and give the select statement to iterate through
FOR
SELECT ITEM_ID
FROM #ITEMS
 
OPEN ITEM_CURSOR -- This charges the results to memory
 
FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID -- We fetch the first result
 
WHILE @@FETCH_STATUS = 0 --If the fetch went well then we go for it
BEGIN
 
SELECT ITEM_DESCRIPTION -- Our select statement (here you can do whatever work you wish)
FROM #ITEMS
WHERE ITEM_ID = @ITEM_ID -- In regards to our latest fetched ID
 
FETCH NEXT FROM ITEM_CURSOR INTO @ITEM_ID -- Once the work is done we fetch the next result
 
END
-- We arrive here when @@FETCH_STATUS shows there are no more results to treat
CLOSE ITEM_CURSOR  
DEALLOCATE ITEM_CURSOR -- CLOSE and DEALLOCATE remove the data from memory and clean up the process