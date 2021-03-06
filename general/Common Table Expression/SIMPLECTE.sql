;WITH SUMPARTSCTE AS
( SELECT 1 AS COUNTNUMBER, 1 AS GRANDTOTAL
	UNION ALL
	SELECT COUNTNUMBER+1,
	GRANDTOTAL+COUNTNUMBER+1
	FROM SUMPARTSCTE
	WHERE COUNTNUMBER < 40000

)
SELECT MAX(GRANDTOTAL) AS SUMPARTS
FROM SUMPARTSCTE
OPTION (MAXRECURSION 0);