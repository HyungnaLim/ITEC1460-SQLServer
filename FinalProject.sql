-- Create Tables
CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL
);

CREATE TABLE Supplier (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50),
    City NVARCHAR(50),
    ContactName NVARCHAR(50),
    ContactTitle NVARCHAR(50),
    Email NVARCHAR(50),
    Phone VARCHAR(30)
);

CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    ProductName NVARCHAR(50) NOT NULL,
    Brand NVARCHAR(50) NOT NULL,
    Price DECIMAL(15,2) NOT NULL,
    Size DECIMAL(10,2),
    SizeUnit NVARCHAR(30),
    SupplierID INT NOT NULL
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE ProductColor (
    ProductColorID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ColorName NVARCHAR(50) NOT NULL,
    ColorDesc NVARCHAR(50)
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Location (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    LocationName NVARCHAR(50) NOT NULL,
    Aisle INT,
    Shelf INT
);

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductColorID INT NOT NULL,
    LocationID INT NOT NULL,
    QuantityInStock INT NOT NULL,
    ReorderLevel INT,
    LastRestockedDate DATE,
    ExpirationDate DATE
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (ProductColorID) REFERENCES ProductColor(ProductColorID),
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);

CREATE TABLE PurchaseOrder (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    OrderDate DATE NOT NULL,
    ArrivalDate DATE,
    Status NVARCHAR(50)
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE PurchaseOrderDetail (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT,
    QuantityOrdered INT NOT NULL,
    UnitPrice Decimal(15,2) NOT NULL
    FOREIGN KEY (OrderID) REFERENCES PurchaseOrder(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Insert sample data into tables
INSERT INTO Category (CategoryName) VALUES ('Skincare'), ('Makeup'), ('Body'), ('Fragrance');

INSERT INTO Supplier
VALUES ('Cosmax', 'Korea', 'Seoul', 'Mina Kim', 'Sales Representative', 'mina@cosmax.kr', '623-132-6536'),
('BeautyPlanet', 'Fance', 'Paris', 'Julian Dubois', 'Purchasing Manager', 'jdubois@beautyplanet.fr', '362-136-1246'),
('Ulta', 'USA', 'Los Angeles', 'Hailey Johns', 'Account Manager', 'haileyj@ulta.com', '721-625-7441');

INSERT INTO Product
VALUES (1, 'Niacinamide 10% + Zinc 1% Oil Control Serum', 'The Ordinary', 6.00, 1.00, 'oz', 2),
(1, 'Lip Butter Balm for Hydration & Shine', 'Summer Fridays', 24.00, 0.50, 'oz', 1),
(3, 'Dew Blush Liquid Cream Blush', 'Saie', 25.00, 0.40, 'oz', 3);

INSERT INTO ProductColor
VALUES (2, 'Vanilla Beige', 'sheer beige'),
(2, 'Birthday Cake', NULL),
(3, 'Rosy', 'soft rose'),
(3, 'Lady', 'nude mauve');

INSERT INTO Location
VALUES ('Counter', 1, 1), ('Counter', 1, 2), ('Counter', 1, 3),
('Center', 1, 1), ('Center', 1, 2), ('Center', 1, 3),
('Center', 2, 1), ('Center', 2, 2), ('Center', 2, 3),
('Center', 3, 1), ('Center', 3, 2), ('Center', 3, 3),
('Left Corner', 1, 1), ('Left Corner', 1, 2), ('Left Corner', 1, 3),
('Left Corner', 2, 1), ('Left Corner', 2, 2), ('Left Corner', 2, 3),
('Left Corner', 3, 1), ('Left Corner', 3, 2), ('Left Corner', 3, 3);

INSERT INTO Inventory
VALUES (1, NULL, 1, 12, 10, '2025-01-17', '2026-01-31'),
(2, 1, 3, 5, 5, '2025-01-13', '2027-01-31'),
(2, 2, 3, 7, 5, '2025-01-13', '2027-01-31'),
(3, 3, 2, 3, 8, '2025-02-11', '2025-04-18'),
(3, 4, 2, 10, 8, '2025-02-11', '2026-10-18');

INSERT INTO PurchaseOrder
VALUES (3, '2025-02-06', '2025-02-11', 'Arrived'),
(2, '2025-02-21', NULL, 'Shipped'),
(1, '2025-04-18', NULL, 'Order Placed');

INSERT INTO PurchaseOrderDetail
VALUES (1, 3, 20, 10.00),
(2, 1, 30, 3.25),
(3, 2, 15, 5.99);

-- Create 3 stored procedures:
-- stored procedure for inserting data
CREATE PROCEDURE AddLocation
@LocationName NVARCHAR(50),
@Aisle INT,
@Shelf INT
AS
BEGIN
    IF @LocationName IS NULL
    BEGIN
        PRINT 'Location Name cannot be NULL. Please try again.';
    END

    ELSE
    BEGIN
        INSERT INTO Location (LocationName, Aisle, Shelf)
        VALUES (@LocationName, @Aisle, @Shelf);
        PRINT 'Location has been added successfully.';
    END
END

-- Test
EXEC AddLocation @LocationName='Right Corner', @Aisle=1, @Shelf=1
EXEC AddLocation @LocationName='Front Display', @Aisle=NULL, @Shelf=NULL
EXEC AddLocation @LocationName=NULL, @Aisle=1, @Shelf=1

-- stored procedure for retrieving data in a meaningful way
CREATE PROCEDURE CheckExpiredProduct
AS
BEGIN
DECLARE @CurrentDate DATE;
SET @CurrentDate = GETDATE();

PRINT 'Expired products:';
SELECT * FROM Inventory WHERE ExpirationDate < @CurrentDate;

IF @@ROWCOUNT = 0
    PRINT 'No expired products found.';
END

-- Test
EXEC CheckExpiredProduct

-- stored procedure for deleting data
CREATE PROCEDURE RemoveProduct
@ProductID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Product WHERE ProductID = @ProductID)
    BEGIN
    DELETE FROM Inventory WHERE ProductID = @ProductID
    PRINT 'Product has been successfully removed from inventory table.';
    END

    ELSE
    BEGIN
    PRINT 'No product found with provided product ID.';
    END
END

-- Test
EXEC RemoveProduct @ProductID = 2
EXEC RemoveProduct @ProductID = 99

-- create 2 views:
-- Summarize important business metrics
CREATE VIEW ProductMargin
AS
SELECT p.ProductID, p.ProductName, p.Price - pod.UnitPrice AS ProductMargin
FROM Product p
JOIN PurchaseOrderDetail pod ON p.ProductID = pod.ProductID;

-- Test
SELECT * FROM [ProductMargin]

-- Join multiple tables to provide useful information
CREATE VIEW InventoryWithNames
AS
SELECT i.InventoryID, i.ProductID, p.ProductName, p.Brand, c.CategoryName, p.Price, i.QuantityInStock
FROM Inventory i
JOIN Product p ON p.ProductID = i.ProductID
JOIN Category c ON p.CategoryID = c.CategoryID

-- Test
SELECT * FROM [InventoryWithNames]