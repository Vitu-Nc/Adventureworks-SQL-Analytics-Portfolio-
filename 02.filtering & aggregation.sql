USE AdventureWorks2019;
GO
--Query 1:Orders placed in 2013 only(filtering)
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01' AND OrderDate < '2014-01-01';


--Query2: Orders over $10,000
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 10000
ORDER BY TotalDue DESC;

-- Query3:Online orders that are of high value
SELECT SalesOrderID, OrderDate, TotalDue, OnlineOrderFlag
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 1 AND TotalDue > 5000;

-- Query4: Orders with specific statuses
SELECT SalesOrderID, Status, TotalDue
FROM Sales.SalesOrderHeader
WHERE Status IN (1, 2, 3);

--Group BY & Aggregate functions 

-- Query5:Total revenue by year
SELECT 
YEAR(OrderDate) AS OrderYear,
SUM(TotalDue) AS TotalRevenue,
COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--Query6:Average order value by year
SELECT 
YEAR(OrderDate) AS OrderYear,
AVG(TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--GROUP BY on a categorical column

-- Query7: Revenue by online vs. offline orders
SELECT 
OnlineOrderFlag,
COUNT(*) AS OrderCount,
SUM(TotalDue) AS TotalRevenue,
AVG(TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader
GROUP BY OnlineOrderFlag;

-- Using HAVING for filtering on aggregated results

-- QUery8:Years where total revenue exceeded $50 million
SELECT 
YEAR(OrderDate) AS OrderYear,
SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
HAVING SUM(TotalDue) > 50000000
ORDER BY OrderYear;

-- Query9:(Product Level Agreggation) Product count and average price by subcategory ID
SELECT 
ProductSubcategoryID,
COUNT(*) AS ProductCount,
AVG(ListPrice) AS AvgListPrice,
MAX(ListPrice) AS MaxListPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID
ORDER BY AvgListPrice DESC;

--Combining WHERE,GROUP BY,HAVING,ORDER BY
--Query10:Months in 2013 with more than 400 orders, sorted by revenue
SELECT 
MONTH(OrderDate) AS OrderMonth,
COUNT(*) AS OrderCount,
SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY MONTH(OrderDate)
HAVING COUNT(*) > 400
ORDER BY TotalRevenue DESC;
--QUERY#11:Which sales terrritory(by TerritoryID) generated the most total revenue and how many ordesrs came from it
SELECT
TerritoryID,
COUNT(*) AS TotalOrders,
SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TotalRevenue DESC;