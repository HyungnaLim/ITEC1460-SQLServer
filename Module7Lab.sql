-- Part 1
-- Create a new stored procedure that calculates the total amount for an order
-- Specifying a parameter as OUTPUT means the procedure can modify
-- the parameter's value.

CREATE OR ALTER PROCEDURE CalculateOrderTotal
    @OrderID INT,
    @TotalAmount MONEY OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Calculate the total amount for the given order
    SELECT @TotalAmount = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    -- Check if the order exists
    IF @TotalAmount IS NULL
    BEGIN
        SET @TotalAmount = 0;
        PRINT 'Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' not found.';
        RETURN;
    END

    PRINT 'The total amount for Order ' + CAST(@OrderID AS NVARCHAR(10)) + ' is $' + CAST(@TotalAmount AS NVARCHAR(20));
END
GO

-- Test the stored procedure with a valid order
-- First declare variables
DECLARE @OrderID INT = 10248;
DECLARE @TotalAmount MONEY;

EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total amount: $' + CAST(@TotalAmount AS NVARCHAR(20));

-- Test with an invalid order
SET @OrderID = 99999;
SET @TotalAmount = NULL;

EXEC CalculateOrderTotal 
    @OrderID = @OrderID, 
    @TotalAmount = @TotalAmount OUTPUT;

PRINT 'Returned total amount: $' + CAST(ISNULL(@TotalAmount, 0) AS NVARCHAR(20));
GO


-- Execute the SQL file using the command line:
-- sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -i Module7Lab.sql -o results.txt

/*
The sqlcmd command executes the SQL file:
-S localhost specifies the server (localhost for Codespaces)
-U sa -P <YourPassword> provides login credentials
-d Northwind specifies the database
-i order_total_procedure.sql specifies the input file
-o results.txt directs the output to a file
*/

-- View the results:
-- code results.txt


-- =============================================
-- Part 2: CheckProductStock Procedure
-- =============================================
CREATE OR ALTER PROCEDURE CheckProductStock
    @ProductID INT,
    @NeedsReorder BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UnitsInStock INT
    DECLARE @ReorderLevel INT
    DECLARE @Discontinued INT
    DECLARE @ProductName NVARCHAR(50)

    SELECT @UnitsInStock = UnitsInStock, @ReorderLevel = ReorderLevel, @Discontinued = Discontinued, @ProductName = ProductName
    FROM Products
    WHERE ProductID = @ProductID

    IF @Discontinued = 1
    BEGIN
    SET @NeedsReorder = 0
    PRINT @ProductName + ' has been discontinued. Current stock: '
    + CAST(@UnitsInStock AS NVARCHAR(5));
    END

    ELSE
    BEGIN
        IF @UnitsInStock - @ReorderLevel > 0
        BEGIN
        SET @NeedsReorder = 0
        PRINT @ProductName + ' has not reached the reorder level yet. Current stock: '
        + CAST(@UnitsInStock AS NVARCHAR(5))
        + ' Reorder Level: ' + CAST(@ReorderLevel AS NVARCHAR(5));
        END

        IF @UnitsInStock - @ReorderLevel <= 0
        BEGIN
        SET @NeedsReorder = 1
        PRINT @ProductName + ' needs reorder! Current stock: '
        + CAST(@UnitsInStock AS NVARCHAR(5))
        + ' Reorder Level: ' + CAST(@ReorderLevel AS NVARCHAR(5));
        END
    END    
END
GO

-- Test the new procedure
DECLARE @NeedsReorder BIT;
EXEC CheckProductStock 
    @ProductID = 11,
    @NeedsReorder = @NeedsReorder OUTPUT;

PRINT 'Needs Reorder: ' + CAST(@NeedsReorder AS VARCHAR(1));

-- Execute Both Procedures
-- sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -i Module7Lab.sql -o results.txt
