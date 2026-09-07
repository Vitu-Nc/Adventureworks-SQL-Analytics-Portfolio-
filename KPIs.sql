USE AdventureWorks2019;
GO
--1. Total Revenue (overall and by year)
-- Overall
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;

-- By year
SELECT 
YEAR(OrderDate) AS OrderYear,
SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--2. Year-over-Year (YoY) Growth %
SELECT 
OrderYear,
TotalRevenue,
LAG(TotalRevenue) OVER (ORDER BY OrderYear) AS PrevYearRevenue,
ROUND(
(TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY OrderYear)) 
* 100.0 / LAG(TotalRevenue) OVER (ORDER BY OrderYear), 2
 ) AS YoYGrowthPct
FROM (
SELECT YEAR(OrderDate) AS OrderYear, SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
) yearly
ORDER BY OrderYear;

--Average Order Value
SELECT 
YEAR(OrderDate) AS OrderYear,
SUM(TotalDue) / COUNT(DISTINCT SalesOrderID) AS AvgOrderValue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--Customer Retention(repeat Vs one time customers)
SELECT 
CASE WHEN OrderCount = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END AS CustomerType,
COUNT(*) AS NumberOfCustomers
FROM (
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
) customer_orders
GROUP BY CASE WHEN OrderCount = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END;

--Top 10% of Customers by Revenue (Pareto-style analysis)
--who drives most of our revenue" KPI
--NTILE(10) splits customers into 10 equal sized buckets ranked by spend decile 1 is your top 10% of spenders.
SELECT 
CustomerID,
TotalSpent,
NTILE(10) OVER (ORDER BY TotalSpent DESC) AS DecileRank
FROM (
SELECT CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
) customer_totals;

--Order Fulfillment Time (Ship Date - Order Date)
--An operations style KPI:
SELECT 
AVG(DATEDIFF(day, OrderDate, ShipDate)) AS AvgDaysToShip
FROM Sales.SalesOrderHeader
WHERE ShipDate IS NOT NULL;

--Monthly Active "Purchasing" Customers
SELECT 
FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM Sales.SalesOrderHeader
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY OrderMonth;

--Revenue Concentration by Territory (% of total)
SELECT 
TerritoryID,
SUM(TotalDue) AS TerritoryRevenue,
ROUND(SUM(TotalDue) * 100.0 / SUM(SUM(TotalDue)) OVER (), 2) AS PctOfTotalRevenue
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TerritoryRevenue DESC;

