-- Part 1
-- Create the Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE
);

-- Create the Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    PublicationYear INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Insert data into Authors table
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate)
VALUES 
(1, 'Jane', 'Austen', '1775-12-16'),
(2, 'George', 'Orwell', '1903-06-25'),
(3, 'J.K.', 'Rowling', '1965-07-31'),
(4, 'Ernest', 'Hemingway', '1899-07-21'),
(5, 'Virginia', 'Woolf', '1882-01-25');

-- Insert data into Books table
INSERT INTO Books (BookID, Title, AuthorID, PublicationYear, Price)
VALUES 
(1, 'Pride and Prejudice', 1, 1813, 12.99),
(2, '1984', 2, 1949, 10.99),
(3, 'Harry Potter and the Philosopher''s Stone', 3, 1997, 15.99),
(4, 'The Old Man and the Sea', 4, 1952, 11.99),
(5, 'To the Lighthouse', 5, 1927, 13.99);

-- Create a view named BookDetails that combines information from both tables
CREATE VIEW BookDetails AS 
SELECT b.BookID, b.Title, a.FirstName + ' ' + a.LastName AS AuthorName, b.PublicationYear, b.Price 
FROM Books b JOIN Authors a ON b.AuthorID = a.AuthorID;

-- Create a view that pulls data from the Authors and the Books tables
CREATE VIEW RecentBooks AS 
SELECT 
    BookID,
    Title,
    PublicationYear,
    Price
FROM 
    Books 
WHERE 
    PublicationYear > 1990;

-- Create a view that shows the number of books and the average price of books
CREATE VIEW AuthorStats AS 
SELECT a.AuthorID, a.FirstName + ' ' + a.LastName AS AuthorName,
COUNT(b.BookID) AS BookCount,
AVG(b.Price) AS AverageBookPrice 
FROM Authors a LEFT JOIN Books b ON a.AuthorID = b.AuthorID 
GROUP BY a.AuthorID, a.FirstName, a.LastName;

-- a) Retrieve all the records from the Bookdetails view
SELECT Title, Price FROM BookDetails;
-- b) List all the books from the RecentBooks view
SELECT * FROM RecentBooks;
-- c) Show statistics for authors
SELECT * FROM AuthorStats;

-- Create an updateable view for author's firstname and lastname
CREATE VIEW AuthorContactInfo AS 
SELECT AuthorID, FirstName, LastName 
FROM Authors;

-- Try updating an author's name through this view:
UPDATE AuthorContactInfo 
SET FirstName = 'Joanne'
WHERE AuthorID = 3;

SELECT * FROM AuthorContactInfo;

-- Create the audit table
CREATE TABLE BookPriceAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

-- Create an Audit Trigger
CREATE TRIGGER trg_BookPriceChange 
ON Books 
AFTER UPDATE 
AS 
BEGIN 
    IF UPDATE(Price) 
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice) 
        SELECT i.BookID, d.Price, i.Price 
        FROM inserted i 
        JOIN deleted d ON i.BookID = d.BookID 
    END 
END;

-- Update a book's price to test the trigger
UPDATE Books SET Price = 14.99 WHERE BookID = 1;

-- Check the audit table
SELECT * FROM BookPriceAudit;




-- Part 2
-- Create BookReviews Table
CREATE TABLE BookReviews(
    ReviewID INT PRIMARY KEY,
    BookID INT,
    CustomerID NCHAR(5),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID), 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create a View
CREATE VIEW vw_BookReviewStats AS 
SELECT b.Title AS BookTitle, COUNT(r.ReviewID) AS TotalReviews, AVG(r.Rating) AS AverageRating, MAX(r.ReviewDate) AS MostRecentReviewDate  
FROM Books b JOIN BookReviews r ON b.BookID = r.BookID 
GROUP BY b.BookID, b.Title;

-- Create a trigger that prevents reviews from being added with future dates
CREATE TRIGGER tr_ValidateReviewDate ON BookReviews FOR INSERT 
AS 
BEGIN 
    IF EXISTS (SELECT * FROM inserted WHERE ReviewDate > GETDATE()) 
    BEGIN 
        RAISERROR('ReviewDate cannot be in the future', 16, 1) 
        ROLLBACK TRANSACTION;
    END 
END;

-- add an AverageRating column (DECIMAL(3,2)) to the Books table
ALTER TABLE Books ADD AverageRating DECIMAL(3,2);

-- Create a trigger that automatically updates the Books.AverageRating whenever reviews are added, updated, or deleted
CREATE TRIGGER tr_UpdateBookRating ON BookReviews AFTER INSERT, UPDATE, DELETE 
AS 
BEGIN 
    IF EXISTS (SELECT * FROM inserted) 
    BEGIN 
        SELECT AVG(CAST(Rating AS DECIMAL(3,2))) AS Average FROM BookReviews GROUP BY BookID
        UPDATE Books SET AverageRating = 
-- WIP... Do I have to set a variable for this trigger? what will be the best way?

-- Test
-- Insert at least 3 reviews for different books
INSERT INTO BookReviews(ReviewID, BookID, CustomerID, ReviewText, Rating, ReviewDate) 
VALUES (1, 1, 'ALFKI', 'Good', 3, '2025-02-06'), 
(2, 2, 'ANTON', 'Legendary', 5, '2025-01-29'), 
(3, 2, 'BLAUS', 'Great', 4, '2024-11-19'), 
(4, 3, 'BOLID', 'Fun', 4, '2024-04-01'), 
(5, 4, 'FOLIG', 'Boring', 2, '2025-02-25');

-- Try to insert a review with a future date (should fail)
INSERT INTO BookReviews(ReviewID, BookID, CustomerID, ReviewText, Rating, ReviewDate) 
VALUES (7, 5, 'WOLZA', 'This is a review from future', 3, '2025-12-12');

-- Query your view to see the statistics
SELECT * FROM vw_BookReviewStats;

-- Update a review's rating and verify the book's average rating updates automatically
UPDATE BookReviews SET Rating = 3 WHERE ReviewID = 5;
