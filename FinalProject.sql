-- Create Tables

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50)
);

CREATE TABLE Supplier (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    ContactName NVARCHAR(50),
    ContactTitle NVARCHAR(50),
    Email NVARCHAR(50),
    Phone VARCHAR(30)
);

CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT,
    ProductName NVARCHAR(50),
    Brand NVARCHAR(50),
    Price DECIMAL(15,2),
    Size DECIMAL(10,2),
    SizeUnit NVARCHAR(30),
    SupplierID INT
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE ProductColor (
    ProductColorID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ColorName NVARCHAR(50),
    ColorDesc NVARCHAR(50)
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Location (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    LocationName NVARCHAR(50),
    Aisle INT,
    Shelf INT
);

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductColorID INT,
    LocationID INT,
    QuantityInStock INT,
    ReorderLevel INT,
    LastRestockedDate DATE,
    ExpirationDate DATE
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
    FOREIGN KEY (ProductColorID) REFERENCES ProductColor(ProductColorID)
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);

CREATE TABLE PurchaseOrder (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT,
    OrderDate DATE,
    ArrivalDate DATE,
    Status NVARCHAR(50)
);

CREATE TABLE PurchaseOrderDetail (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    QuantityOrdered INT,
    UnitPrice Decimal(15,2)
    FOREIGN KEY (OrderID) REFERENCES PurchaseOrder(OrderID)
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
VALUES (1, NULL, 1, 12, 10, 2025-01-17, 2026-01-31),
(2, 1, 3, 5, 5, 2025-01-13, 2027-01-31),
(2, 2, 3, 7, 5, 2025-01-13, 2027-01-31),
(3, 3, 2, 3, 8, 2025-02-11, 2026-10-15),
(3, 4, 2, 10, 8, 2025-02-11, 2026-10-18);

INSERT INTO PurchaseOrder
VALUES (3, 2025-02-06, 2025-02-11, 'Arrived'),
(2, 2025-02-21, NULL, 'Shipped'),
(1, 2025-04-18, NULL, 'Order Placed');

INSERT INTO PurchaseOrderDetail
VALUES (1, 3, 20, 10.00),
(2, 1, 30, 3.25),
(3, 2, 15, 5.99);

-- create 3 stored procedures:
-- One for inserting or updating data
-- One for retrieving data in a meaningful way
-- One for deleting data

-- create 2 views:
-- Summarize important business metrics
-- Join multiple tables to provide useful information