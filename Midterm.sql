/*
1. SQL SELECT
You're giving awards to employees based on the year they started working at Northwind.
Write a query to list all employees (FirstName, LastName) along with their start date.
*/
SELECT EmployeeID, FirstName, LastName, HireDate FROM Employees
ORDER BY HireDate ASC;

/*
2. SQL JOIN
Create a simple report showing which employees are handling orders. Write a query that:
1. Lists employee names (FirstName and LastName)
2. Shows the OrderID for each order they've processed
3. Shows the OrderDate
4. Sorts the results by EmployeeID and then OrderDate
This basic report will help us see which employees are actively processing orders in the Northwing system.
*/
SELECT e.EmployeeID, e.FirstName, e.LastName, o.OrderID, o.OrderDate
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
ORDER BY e.EmployeeID, o.OrderDate;

/*
3. Functions and GROUP BY:
Create a simple report showing total sales by product category.
Include the CategoryName and TotalSales (calculated as the sum of UnitPrice * Quantity).
Sort your results by TotalSales in descending order.
*/
SELECT p.CategoryID, c.CategoryName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) as TotalSales
FROM [Order Details] od
JOIN Products p ON p.ProductID = od.ProductID
JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY p.CategoryID, c.CategoryName
ORDER BY TotalSales DESC;

/*
4. SQL Insert Statements:
Complete the following tasks:
a.Insert a new supplier named "Northwind Traders" based in Seattle, USA.
b.Create a new category called "Organic Products".
c.Insert a new product called "Minneapolis Pizza". You can choose the category, supplier, and other values.
*/
INSERT INTO Suppliers
VALUES ('Northwind Traders', 'Hyungna Lim', 'Purchasing Manager', '3210 Boone Crockett Lane', 'Seattle', 'WA', 98161, 'USA', '(555)-555-5555', NULL, NULL);

ALTER TABLE Categories ALTER COLUMN CategoryName NVARCHAR(50);
INSERT INTO Categories
VALUES ('Organic Products', 'non-GMO fresh produce', NULL);

INSERT INTO Products
VALUES ('Minneapolis Pizza', 30, 7, '1 box', 8.99, 10, 0, 5, 0);

/*
5. SQL Update Statement:
Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
*/
UPDATE Products
SET CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Organic Products')
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.CompanyName = 'Exotic Liquids';

/*
6. SQL Delete Statement:
Remove the product "Minneapolis Pizza".
*/
DELETE FROM Products WHERE ProductName = 'Minneapolis Pizza';

/*
7. Creating Tables and Constraints:
Create a new table named "EmployeePerformance" with the following columns:
PerformanceID (int, primary key, auto-increment)
EmployeeID (int, foreign key referencing Employees table)
Year (int)
Quarter (int)
SalesTarget (decimal(15,2))
ActualSales (decimal(15,2))
Hint: Remember to add a foreign key constraint to the EmployeeID column
so that EmployeeID is a foreign key in the Employee Performance table that references the EmployeeID that is the primary key in the employees table.
This will establish a relationship between Employees and EmployeePerformance.
*/
CREATE TABLE EmployeePerformance (
    PerformanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    Year INT,
    Quarter INT,
    SalesTarget DECIMAL(15,2),
    ActualSales DECIMAL(15,2)
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

/*
8. Creating Views:
Create a view named "vw_ProductInventory" that shows ProductName, CategoryName, UnitsInStock, and UnitsOnOrder for all products.
*/
CREATE VIEW vw_ProductInventory
AS
SELECT p.ProductID, p.ProductName, c.CategoryName, p.UnitsInStock, p.UnitsOnOrder
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;
GO;

/*
9. Stored Procedures:
Create a stored procedure called "sp_UpdateProductInventory" that:
1.Takes two inputs: ProductID and NewStockLevel
2.Updates the UnitsInStock value for the product you specify
3.Makes sure the stock level is never less than zero
*/
CREATE PROCEDURE sp_UpdateProductInventory
@ProductID INT,
@NewStockLevel INT
AS
BEGIN
IF @NewStockLevel < 0
    BEGIN
    PRINT 'Stock level cannot be less than zero.'
    END
ELSE
    BEGIN
        UPDATE Products
        SET UnitsInStock = @NewStockLevel
        WHERE ProductID = @ProductID;
    END
END

/*
10. Complex Query:
Write a query to find the top 5 customers by total freight costs.
Include CustomerID, TotalFreightCost, NumberOfOrders, and AverageFreightPerOrder. 
*/
SELECT TOP 5 CustomerID, SUM(Freight) AS TotalFreightCost, COUNT(OrderID) AS NumberOfOrders, AVG(Freight) AS AverageFreightPerOrder
FROM Orders
GROUP BY CustomerID
ORDER BY TotalFreightCost DESC;