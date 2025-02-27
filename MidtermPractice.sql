-- 1. SQL SELECT Statements: Write a query to list all products (ProductName) with their CategoryName and SupplierName.
SELECT p.ProductName, c.CategoryName, s.CompanyName AS SupplierName 
FROM Products p 
JOIN Categories c ON p.CategoryID = c.CategoryID 
JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- 2. SQL JOINs: Find all customers who have never placed an order. Display the CustomerID and CompanyName.
SELECT c.CustomerID, c.CompanyName 
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE o.CustomerID IS NULL;

-- 3. Functions and GROUP BY: List the top 5 employees by total sales amount. Include EmployeeID, FirstName, LastName, and TotalSales.
SELECT TOP 5 o.EmployeeID, e.FirstName, e.LastName, COUNT(o.OrderID) AS TotalSales 
FROM Orders o 
JOIN Employees e ON o.EmployeeID = e.EmployeeID 
GROUP BY o.EmployeeID, e.FirstName, e.LastName 
ORDER BY TotalSales DESC;

/* 4. SQL Insert Statement: Add a new product to the Products table with the following details:
ProductName: "Northwind Coffee"
SupplierID: 1
CategoryID: 1
QuantityPerUnit: "10 boxes x 20 bags"
UnitPrice: 18.00
UnitsInStock: 39
UnitsOnOrder: 0
ReorderLevel: 10
Discontinued: 0 */
INSERT INTO Products VALUES ('Northwind Coffee', 1, 1, '10 boxes x 20 bags', 18.00, 39, 0, 10, 0);

--5. SQL Update Statement: Increase the UnitPrice of all products in the "Beverages" category by 10%.
UPDATE Products 
SET UnitPrice = UnitPrice * 1.1 
FROM Products p JOIN Categories c ON p.CategoryID = c.CategoryID 
WHERE c.CategoryName = 'Beverages';

-- 6. SQL Insert and Delete Statements:
-- a) Insert a new order for customer VINET with today's date.
INSERT INTO Orders 
SELECT c.CustomerID, 1, CAST(GETDATE() AS DATE), '2025-04-01 00:00:00.000', NULL, 3, 22.2222,
    c.CompanyName, c.Address, c.City, c.Region, c.PostalCode, c.Country 
FROM Customers c 
WHERE c.CustomerID = 'VINET';

-- b) Delete the order you just created.
DELETE FROM Orders WHERE OrderDate = CAST(GETDATE() AS DATE);

-- 7. Creating Tables: Create a new table named "ProductReviews" with the following columns:
/* ReviewID (int, primary key)
ProductID (int, foreign key referencing Products table)
CustomerID (nchar(5), foreign key referencing Customers table)
Rating (int)
ReviewText (nvarchar(max))
ReviewDate (datetime) */
CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY,
    ProductID INT,
    CustomerID NCHAR(5),
    Rating INT,
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

SELECT * FROM ProductReviews;

-- 8. Creating Views: Create a view named "vw_ProductSales" that shows ProductName, CategoryName, and TotalSales (sum of UnitPrice * Quantity) for each product.
CREATE VIEW vw_ProductSales 
AS 
SELECT p.ProductName, c.CategoryName, SUM(od.UnitPrice * od.Quantity) AS TotalSales 
FROM [Order Details] od 
JOIN Products p ON od.ProductID = p.ProductID 
JOIN Categories c ON p.CategoryID = c.CategoryID 
GROUP BY p.ProductName, c.CategoryName;

SELECT * FROM vw_ProductSales;

-- 9. Stored Procedures: Write a stored procedure named "sp_TopCustomersByCountry" that takes a country name as input and returns the top 3 customers by total order amount for that country.
CREATE PROCEDURE sp_TopCustomersByCountry 
@CountryInput NVARCHAR(50)
AS 
SELECT TOP 3 c.CustomerID, c.CompanyName, COUNT(o.OrderID) AS OrderCount 
FROM Orders o 
JOIN Customers c ON c.CustomerID = o.CustomerID 
WHERE c.Country = @CountryInput 
GROUP BY c.CustomerID, o.CustomerID, c.CompanyName 
ORDER BY OrderCount DESC;

EXEC sp_TopCustomersByCountry @CountryInput = 'Germany';

-- 10. Complex Query: Write a query to find the employee who has processed orders for the most unique products. Display the EmployeeID, FirstName, LastName, and the count of unique products they've processed.
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, COUNT(DISTINCT ProductID) AS ProductCount 
FROM [Order Details] od 
JOIN Orders o ON od.OrderID = o.OrderID 
JOIN Employees e ON o.EmployeeID = e.EmployeeID 
GROUP BY e.EmployeeID, e.FirstName, e.LastName 
ORDER BY ProductCount DESC;