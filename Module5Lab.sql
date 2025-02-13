-- Exercise 1: INSERT Operation
sqlq "INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country)
VALUES ('STUDE', 'Student Company', 'Hyungna Lim', 'USA');"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"

sqlq "INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry)
VALUES ('STUDE', 1, GETDATE(), 'USA');"
sqlq "SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE';"

-- Exercise 2: UPDATE Operation
sqlq "UPDATE Customers SET ContactName = 'Heena Lim' WHERE CustomerID = 'STUDE'"
sqlq "SELECT ContactName FROM Customers WHERE CustomerID = 'STUDE';"

sqlq "UPDATE Orders SET ShipCountry = 'South Korea' WHERE CustomerID = 'STUDE';"
sqlq "SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE';"

-- Exercise 3: DELETE Operation
sqlq "DELETE FROM Orders WHERE CustomerID = 'STUDE';"
sqlq "SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE';"

sqlq "DELETE FROM Customers WHERE CustomerID = 'STUDE';"
sqlq "SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE';"

-- Part2 Exercises
sqlq "INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country)
VALUES ('Pop-up Foods', 'Hyungna Lim', 'Owner', 'USA');"
sqlq "SELECT * FROM Suppliers WHERE CompanyName = 'Pop-up Foods';"

sqlq "INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('House Special Pizza', 30, 2, 15.99, 50);"
sqlq "SELECT * FROM Products WHERE SupplierID = 30;"

sqlq "UPDATE Products SET UnitsInStock = 25, UnitPrice = 17.99 WHERE ProductID = 78;"
sqlq "SELECT * FROM Products WHERE ProductID = 78;"

sqlq "DELETE FROM Products WHERE ProductID = 78;"
sqlq "SELECT * FROM Products WHERE ProductID = 78;"

sqlq "INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('Acai Bowl', 30, 3, 10.95, 10)"
sqlq "SELECT * FROM Products WHERE ProductName = 'Acai Bowl';"

sqlq "UPDATE Products SET UnitPrice = 11.25 WHERE ProductID = 79;"
sqlq "SELECT * FROM Products WHERE ProductID = 79;"

sqlq "DELETE FROM Products WHERE ProductID = 79;"
sqlq "SELECT * FROM Products WHERE ProductID = 79;"
