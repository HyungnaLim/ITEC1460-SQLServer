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
