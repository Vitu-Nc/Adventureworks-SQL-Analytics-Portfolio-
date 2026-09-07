USE AdventureWorks2019;
GO
-- Row Number() 1:This numbers every row 1, 2, 3... based on the DESC order . No grouping yet.
SELECT 
SalesOrderID,
CustomerID,
OrderDate,
TotalDue,
ROW_NUMBER() OVER (ORDER BY TotalDue DESC) AS RowNum
FROM Sales.SalesOrderHeader;

--RANK()2:Rank each customer's orders by value, highest first

SELECT 
CustomerID,
SalesOrderID,
OrderDate,
TotalDue,
RANK() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS RankInCustomer
FROM Sales.SalesOrderHeader;
--customer's #1 highest order:get only each customer's #1 highest order:
SELECT * FROM (
SELECT 
CustomerID,
SalesOrderID,
OrderDate,
TotalDue,
RANK() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS RankInCustomer
FROM Sales.SalesOrderHeader
) ranked
WHERE RankInCustomer = 1;

--RANK vs DENSE_RANK vs ROW_NUMBER;
--1.ROW_NUMBER():always gives unique numbers (1,2,3,4) even if values tie
--2.RANK() :gives ties the same number, then skips the next number (1,1,3,4)
--3.DENSE_RANK() gives ties the same number, but doesn't skip (1,1,2,3)
SELECT 
CustomerID,
TotalDue,
ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS RowNum,
RANK() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS Rnk,
DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) AS DenseRnk
FROM Sales.SalesOrderHeader;

--LAG() and LEAD()4: compare a row to the previous/next row
--Total revenue per month, compared to the previous month
SELECT 
OrderMonth,
TotalRevenue,
LAG(TotalRevenue) OVER (ORDER BY OrderMonth) AS PrevMonthRevenue,
TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY OrderMonth) AS ChangeFromPrevMonth
FROM (
SELECT 
FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
) monthly
ORDER BY OrderMonth;
--LAG(TotalRevenue) grabs the value from the previous row (based on the ORDER BY inside the OVER clause) and puts it alongside the current row
--That lets you subtract and get month over month change in a single query
--LEAD() works identically but grabs the next row instead of the previous one.

--Running totals SUM()5:
SELECT 
OrderMonth,
TotalRevenue,
SUM(TotalRevenue) OVER (ORDER BY OrderMonth ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM (
SELECT 
FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
) monthly
ORDER BY OrderMonth;
--SUM(...) OVER (...ROWS UNBOUNDED PRECEDING) means:for each row,sum up this column from the very first row through the current row

--Combine it all6:puts window functions next to GROUP BY
SELECT 
p.Name AS ProductName,
SUM(sod.OrderQty * sod.UnitPrice) AS TotalRevenue,
RANK() OVER (ORDER BY SUM(sod.OrderQty * sod.UnitPrice) DESC) AS RevenueRank
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product p
ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;
--For each sales territory, the highest-value order and its rank position (1st)
SELECT
SalesOrderID,
TerritoryID,
TotalDue,
Rank
FROM (
SELECT
SalesOrderID,
TerritoryID,
TotalDue,
RANK() OVER (PARTITION BY TerritoryID ORDER BY TotalDue DESC) AS RANK
FROM Sales.SalesOrderHeader) AS RankedOrders
WHERE Rank=1
ORDER BY TerritoryID;
