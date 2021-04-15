 --CREATE TABLE #cb (        cb_ID INT IDENTITY(1,1),--sequence of entries 1..n 
 --      Et VARCHAR(10), --entryType 
 --      amount money)--quantity 
 --INSERT INTO #cb(et,amount) SELECT 'balance',465.00 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',56.00 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',434.30 
 --   INSERT INTO #cb(et,amount) SELECT 'purchase',20.04 
 --   INSERT INTO #cb(et,amount) SELECT 'purchase',65.00 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',23.22 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',45.80 
 --   INSERT INTO #cb(et,amount) SELECT 'purchase',34.08 
 --   INSERT INTO #cb(et,amount) SELECT 'purchase',78.30 
 --   INSERT INTO #cb(et,amount) SELECT 'purchase',56.00 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',75.22 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',5.80 
 --   INSERT INTO #cb(et,amount) SELECT 'purchase',3.08 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',3.29 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',100.80 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',100.22 
 --   INSERT INTO #cb(et,amount) SELECT 'sale',23.80 

  /* You don't actually need a cursor. You can get a running total using a correlated subquery */ 
    --SELECT [Entry Type]=Et, amount, 
    --[balance after transaction]=( 
    --       SELECT SUM(--the correlated subquery 
    --                      CASE WHEN total.Et='purchase' 
    --                       THEN -total.amount 
    --                       ELSE total.amount 
    --                       END) 
    --FROM #cb total WHERE total.cb_id <= #cb.cb_id ) 
    --FROM #cb ORDER BY #cb.cb_id 

	   --SELECT [Entry Type]=MIN(#cb.Et), [amount]=MIN (#cb.amount), 
    --[balance after transaction]= 
    --SUM(CASE WHEN total.Et='purchase' 
    --                       THEN -total.amount 
    --                       ELSE total.amount 
    --                       END) 

	 DECLARE @cb TABLE(cb_ID INT,--sequence of entries 1..n 
            Et VARCHAR(10), --entryType 
            amount money,--quantity 
            total money) 
    DECLARE @total money 
    SET @total = 0 
    
    INSERT INTO @cb(cb_id,Et,amount,total) 
         SELECT cb_id,Et,CASE WHEN Et='purchase' 
                           THEN -amount 
                           ELSE amount 
                           END,0 FROM #cb order by cb_id
    UPDATE @cb 
              SET @total = total = @total + amount FROM @cb 
    SELECT [Entry Type]=Et, [amount]=amount, 
                    [balance after transaction]=total FROM @cb ORDER BY cb_id 
    
	DECLARE @ii INT, @iiMax INT, @CurrentBalance money 
    DECLARE @Runningtotals TABLE (cb_id INT, Total money) 
    SELECT @ii=MIN(cb_id), @iiMax=MAX(cb_id),@CurrentBalance=0 FROM #cb 
    
    WHILE @ii<=@iiMax 
           BEGIN 
           SELECT  @currentBalance=@currentBalance 
                           +CASE WHEN Et='purchase' 
                           THEN -amount 
                           ELSE amount 
                           END FROM #cb WHERE cb_ID=@ii 
    