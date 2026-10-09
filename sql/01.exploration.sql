USE AdventureWorks2019
GO
-- Query 1 :previewing sales order Header
SELECT TOP 10 * FROM Sales.SalesOrderHeader;
-- Query 2:preview sales order detail
SELECT TOP 20 * FROM Sales.SalesOrderDetail;

--Query 3: checking for nulls in TerritoryID
SELECT 
COUNT(*) AS TotalRows,
SUM(CASE WHEN TerritoryID IS NULL THEN 1 ELSE 0 END) AS NULLTerritorycount
FROM Sales.SalesOrderHeader;

-- QUERY 4: understanding Table relationships
SELECT 
fk.name AS ForeignKeyName,
tp.name AS ParentTable,
cp.name AS ParentColumn,
tr.name AS ReferencedTable,
cr.name AS ReferencedColumn
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE tp.name = 'SalesOrderHeader';

-- Query 5: checking for dinstict values in categorical column
SELECT DISTINCT Status FROM Sales.SalesOrderHeader;
SELECT DISTINCT OnlineOrderFlag FROM Sales.SalesOrderHeader;
SELECT DISTINCT CountryRegionCode FROM Sales.SalesTerritory;

--Query 6:Looking for duplicates
SELECT SalesOrderID,COUNT(*) AS DupeCount
FROM sales.SalesOrderHeader
GROUP BY SalesOrderID
HAVING COUNT(*)>1; 
--Query 7: Checking for  column data types and structure of a table
SELECT 
COLUMN_NAME, 
DATA_TYPE, 
IS_NULLABLE, 
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Product';

--Query 8:checking for zero or suspicious values
SELECT * FROM Production.Product WHERE ListPrice = 0;
SELECT * FROM Sales.SalesOrderDetail WHERE OrderQty <= 0;

--Query 9:Checking for discontinued/inactive products
SELECT ProductID, Name, SellStartDate, SellEndDate, DiscontinuedDate
FROM Production.Product
WHERE DiscontinuedDate IS NOT NULL;

--Query 10:Basic stats on a numeric column
SELECT 
MIN(ListPrice) AS MinPrice,
MAX(ListPrice) AS MaxPrice,
AVG(ListPrice) AS AvgPrice,
COUNT(*) AS TotalProducts
FROM Production.Product;

--Query 11:Row counts across related tables to check relationships
SELECT 'SalesOrderHeader' AS TableName, COUNT(*) AS Rows FROM Sales.SalesOrderHeader
UNION ALL
SELECT 'SalesOrderDetail', COUNT(*) FROM Sales.SalesOrderDetail
UNION ALL
SELECT 'Product', COUNT(*) FROM Production.Product
UNION ALL
SELECT 'Customer', COUNT(*) FROM Sales.Customer;
