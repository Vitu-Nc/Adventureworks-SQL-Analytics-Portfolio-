USE AdventureWorks2019;
GO
--Query1:Inner Joins for Order and Order details
--Soh=Sales order Hearder ,SOD = Sale Order Detail
SELECT 
soh.SalesOrderID,
soh.OrderDate,
sod.ProductID,
sod.OrderQty,
 sod.UnitPrice
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
 ON soh.SalesOrderID = sod.SalesOrderID

 -- Adding am a third table
SELECT 
soh.SalesOrderID,
p.Name AS ProductName,
sod.OrderQty
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
  ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product p
ON sod.ProductID = p.ProductID;

--Left Join 2: keep everything left even without a match
-- Inner Join: only customers who HAVE orders
SELECT c.CustomerID, soh.SalesOrderID
FROM Sales.Customer c
INNER JOIN Sales.SalesOrderHeader soh
ON c.CustomerID = soh.CustomerID;

-- Left join: ALL customers, whether they have orders or not
SELECT c.CustomerID, soh.SalesOrderID
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh
ON c.CustomerID = soh.CustomerID; 
--result null hence find customers with zero order
SELECT c.CustomerID, soh.SalesOrderID
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh
ON c.CustomerID = soh.CustomerID
WHERE soh.SalesOrderID IS NULL;

--INNER JOIN (header-details)
SELECT TOP 20*
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderDetailID;

-- INNER JOIN(heade-details but for one order)
SELECT TOP 20*
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderDetailID
WHERE soh.SalesOrderID = 43659;

