-- ============================================
-- SQL Stored Procedure Samples
-- Author: Jerry Reeves
-- Description: Demonstrates SQL Server stored procedures
--              for data retrieval, aggregation, and reporting
-- ============================================

-- Procedure 1: Get Customer Orders by Date Range
-- Purpose: Retrieves all orders within a specified date range
CREATE PROCEDURE GetOrdersByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        o.order_id,
        o.order_date,
        c.customer_name,
        c.email,
        o.order_total,
        o.status
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_date BETWEEN @StartDate AND @EndDate
    ORDER BY o.order_date DESC;
END;
GO

-- Procedure 2: Get Customer Order Summary
-- Purpose: Returns aggregated order statistics for a specific customer
CREATE PROCEDURE GetCustomerOrderSummary
    @CustomerID INT
AS
BEGIN
    SELECT 
        c.customer_id,
        c.customer_name,
        c.email,
        c.registration_date,
        COUNT(o.order_id) AS total_orders,
        COALESCE(SUM(o.order_total), 0) AS total_spent,
        COALESCE(AVG(o.order_total), 0) AS average_order_value,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE c.customer_id = @CustomerID
    GROUP BY 
        c.customer_id, 
        c.customer_name, 
        c.email, 
        c.registration_date;
END;
GO

-- Procedure 3: Get Top Customers by Sales
-- Purpose: Returns top N customers ranked by total purchase amount
CREATE PROCEDURE GetTopCustomers
    @TopN INT = 10
AS
BEGIN
    SELECT TOP (@TopN)
        c.customer_id,
        c.customer_name,
        c.email,
        COUNT(o.order_id) AS total_orders,
        SUM(o.order_total) AS total_sales
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.email
    HAVING COUNT(o.order_id) > 0
    ORDER BY total_sales DESC;
END;
GO

-- Procedure 4: Search Products by Keyword
-- Purpose: Searches products with partial name or description matching
CREATE PROCEDURE SearchProducts
    @SearchTerm VARCHAR(100)
AS
BEGIN
    SELECT 
        product_id,
        product_name,
        category,
        price,
        stock_quantity,
        description
    FROM products
    WHERE 
        product_name LIKE '%' + @SearchTerm + '%'
        OR description LIKE '%' + @SearchTerm + '%'
    ORDER BY product_name;
END;
GO

-- Procedure 5: Update Product Stock
-- Purpose: Updates product stock quantity with validation
CREATE PROCEDURE UpdateProductStock
    @ProductID INT,
    @Quantity INT,
    @Operation VARCHAR(10) -- 'ADD' or 'SUBTRACT'
AS
BEGIN
    DECLARE @CurrentStock INT;
    
    -- Get current stock
    SELECT @CurrentStock = stock_quantity
    FROM products
    WHERE product_id = @ProductID;
    
    -- Validate operation
    IF @Operation = 'ADD'
    BEGIN
        UPDATE products
        SET stock_quantity = stock_quantity + @Quantity,
            last_updated = GETDATE()
        WHERE product_id = @ProductID;
    END
    ELSE IF @Operation = 'SUBTRACT'
    BEGIN
        -- Check if sufficient stock
        IF @CurrentStock >= @Quantity
        BEGIN
            UPDATE products
            SET stock_quantity = stock_quantity - @Quantity,
                last_updated = GETDATE()
            WHERE product_id = @ProductID;
        END
        ELSE
        BEGIN
            -- Insufficient stock
            RAISERROR('Insufficient stock available', 16, 1);
        END
    END
    ELSE
    BEGIN
        RAISERROR('Invalid operation. Use ADD or SUBTRACT', 16, 1);
    END
END;
GO

-- Procedure 6: Get Monthly Sales Report
-- Purpose: Generates sales summary for a specific month and year
CREATE PROCEDURE GetMonthlySalesReport
    @Year INT,
    @Month INT
AS
BEGIN
    SELECT 
        DATEPART(DAY, o.order_date) AS day_of_month,
        COUNT(o.order_id) AS total_orders,
        SUM(o.order_total) AS daily_sales,
        AVG(o.order_total) AS average_order_value
    FROM orders o
    WHERE 
        YEAR(o.order_date) = @Year
        AND MONTH(o.order_date) = @Month
    GROUP BY DATEPART(DAY, o.order_date)
    ORDER BY day_of_month;
END;
GO
