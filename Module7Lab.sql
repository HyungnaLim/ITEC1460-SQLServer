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

