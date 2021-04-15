USE Master;
GO
 
CREATE DATABASE [QueryTraining];
GO
 
USE [QueryTraining];
GO
 
CREATE TABLE [dbo].[Inventory](
    [InventoryID] [INTEGER] IDENTITY(-2147483647,1) PRIMARY KEY,
    [Category] [VARCHAR](200),
    [ItemSKU] [VARCHAR](200),
    [Description] [VARCHAR](4000),
    [QuantityOnHand] [INT],
    [UnitCost] DECIMAL(10,2),
    [UnitRetail] DECIMAL(10,2),
    [Archived] BIT
); 
 
INSERT INTO dbo.Inventory (Category, ItemSKU, Description, QuantityOnHand,
                           UnitCost, UnitRetail, Archived)
VALUES
('SLEEPINGBAG', 'SB001-LG-RED', 'Sleeping Bag - Large - RED', 5, 5.75, 19.99, 0),
('SLEEPINGBAG', 'SB001-LG-GRN', 'Sleeping Bag - Large - GREEN', 13, 5.75, 14.99, 1),
('SLEEPINGBAG', 'SB001-LG-BLK', 'Sleeping Bag - Large - BLACK', 1, 5.75, 19.99, 0),
('TENT', 'TT001-10-CMO', 'Tent - 10 Man - CAMO', 5, 10.00, 99.95, 0),
('AXE', 'AX013-HT-BLK', 'Axe - Hatchet - Black', 35, 4.99, 24.95, 0),
('FOOD', 'MR005-1S-SPG', 'MRE - 1 Serve - Spaghetti', 5, 0.50, 7.99, 0),
('FOOD', 'MR006-1A-PIZ', 'Pizza', 1, NULL, 9.95, 0),
('FOOD', 'MR009-212-ICE', 'MRE - Ice Cream - Cookies and Cream', 1, NULL, 11.95, 0),
('FOOD', 'MR009-213-ICE', 'MRE - Ice Cream - Chocolate Chip', 1, NULL, 11.95, 0);

UPDATE dbo.Inventory
SET [Description] = 'MRE - Ice Cream - Double Chocolate Chip'
WHERE [ItemSKU] = 'MR009-213-ICE';

UPDATE dbo.Inventory
SET [Description] = 'MRE - Ice Cream - Triple Chocolate Chip'
OUTPUT [deleted].*, [inserted].*
WHERE [ItemSKU] = 'MR009-213-ICE';

UPDATE dbo.Inventory
SET [Description] = 'MRE - Ice Cream - Triple Chocolate Chip'
OUTPUT [deleted].Description, [inserted].Description
WHERE [ItemSKU] = 'MR009-213-ICE';

UPDATE dbo.Inventory
SET [UnitRetail] = [UnitRetail] * 1.10
OUTPUT [deleted].InventoryID,
[deleted].UnitRetail AS PriceBefore,
[inserted].UnitRetail AS PriceAfter;

SELECT
    customerid,
    YEAR (orderdate),
    COUNT (orderid) order_count
FROM
    dbo.orders
GROUP BY
    customerid,
    YEAR (orderdate)
HAVING
    COUNT (orderid) >= 2
ORDER BY
    customerid;