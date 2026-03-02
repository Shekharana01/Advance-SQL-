## Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
-- A Common Table Expression (CTE) is a temporary result set defined using the WITH keyword that exists only during the execution of a query.
-- Benefits:
-- Improves query readability
-- Breaks complex queries into smaller logical parts
-- Can be reused within the same query
-- Useful for recursive queries

## Q2. Why are some views updatable while others are read-only? Explain with an example.
-- A view is updatable if it:
-- Is based on a single table
-- Does NOT use DISTINCT
-- Does NOT use aggregate functions
-- A view becomes read-only if it contains joins, GROUP BY, aggregate functions, etc.

## Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
-- Stored Procedures:
-- Improve performance (execution plan cached)
-- Reduce redundancy
-- Improve maintainability
-- Allow parameter usage

## Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
-- Triggers automatically execute in response to database events (INSERT, UPDATE, DELETE).
-- Use Case:
-- Automatically archive deleted records into another table for audit purposes.

## Q5. Explain the need for data modelling and normalization when designing a database.
-- Data Modelling:
-- Defines how data is structured and related.
-- Normalization:
-- Reduces redundancy
-- Improves data integrity
-- Prevents anomalies
-- Example: Separating Products and Categories into different tables avoids repeating category names.

## Dataset creation for Q6 to Q9

CREATE DATABASE AdvancedSQL_Assignment;
USE AdvancedSQL_Assignment;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Quantity INT
);

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 50000, 2),
(2, 'Phone', 'Electronics', 20000, 5),
(3, 'Chair', 'Furniture', 3000, 3),
(4, 'Table', 'Furniture', 7000, 1),
(5, 'Headphones', 'Electronics', 2000, 10);

## Q6. Write a CTE to calculate total revenue for each product (Revenue = Price × Quantity) and return only products where revenue > 3000.
WITH RevenueCTE AS (
    SELECT 
        ProductID,
        ProductName,
        Price * Quantity AS Revenue
    FROM Products
)
SELECT *
FROM RevenueCTE
WHERE Revenue > 3000;

## Q7. Create a view named vw_CategorySummary that shows:
-- Category, TotalProducts, AveragePrice.

CREATE VIEW vw_CategorySummary AS
SELECT 
    Category,
    COUNT(ProductID) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

SELECT * FROM vw_CategorySummary;

## Q8. Create an updatable view containing ProductID, ProductName, and Price. Then update the price of ProductID = 1 using the view.
-- create view
CREATE VIEW vw_ProductDetails AS
SELECT ProductID, ProductName, Price
FROM Products;

-- update using view
UPDATE vw_ProductDetails
SET Price = 55000
WHERE ProductID = 1;

-- verify
SELECT * FROM Products WHERE ProductID = 1;

## Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.
DELIMITER //

CREATE PROCEDURE GetProductsByCategory(IN categoryName VARCHAR(50))
BEGIN
    SELECT *
    FROM Products
    WHERE Category = categoryName;
END //

DELIMITER ;

-- execute procedure
CALL GetProductsByCategory('Electronics');

## Q10. Create an AFTER DELETE trigger on the Products table that archives deleted product rows into a new table ProductArchive. The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp.
-- Step 1: Create Archive Table
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt DATETIME
);

-- Step 2: Create Trigger
DELIMITER //

CREATE TRIGGER trg_AfterDeleteProduct
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive
    VALUES (
        OLD.ProductID,
        OLD.ProductName,
        OLD.Category,
        OLD.Price,
        NOW()
    );
END //

DELIMITER ;

-- Test Trigger
DELETE FROM Products WHERE ProductID = 2;

SELECT * FROM ProductArchive;
