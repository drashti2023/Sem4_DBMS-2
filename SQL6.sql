-- Create the Products table
CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
-- Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000)


SELECT * FROM Products;
DROP TABLE Products


--Part - A

--1. Create a cursor Product_Cursor to fetch all the rows from a products table.

DECLARE
@Product_id INT,
@Product_Name VARCHAR(50),
@Price DECIMAL(8,2);
DECLARE Product_Cursor CURSOR 
FOR SELECT 
Product_id,
Product_Name,
Price
FROM
Products;

OPEN Product_Cursor;

FETCH NEXT FROM Product_Cursor INTO
@Product_id,
@Product_Name,
@Price;

WHILE @@FETCH_STATUS=0
BEGIN
	PRINT CAST(@Product_id AS VARCHAR) +'-'+@Product_Name+'-'+CAST(@Price AS VARCHAR);
	FETCH NEXT FROM Product_Cursor INTO
	@Product_id,
	@Product_Name,
	@Price;

	END;

CLOSE Product_Cursor;
DEALLOCATE Product_Cursor;

--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName.
--(Example: 1_Smartphone)

DECLARE
@id INT,
@Name VARCHAR(50);

DECLARE Product_Cursor_Fetch CURSOR 
FOR SELECT 
Product_id,
Product_Name
FROM
Products;

OPEN Product_Cursor_Fetch;

FETCH NEXT FROM Product_Cursor_Fetch INTO
@id,
@Name;


WHILE @@FETCH_STATUS=0
BEGIN
	PRINT CAST(@id AS VARCHAR) +'_'+@Name;
	FETCH NEXT FROM Product_Cursor_Fetch INTO
	@id,
	@Name;
	

	END;

CLOSE Product_Cursor_Fetch;
DEALLOCATE Product_Cursor_Fetch;

--3. Create a Cursor to Find and Display Products Above Price 30,000.
DECLARE
@PR_ID INT,
@PR_NAME VARCHAR(50),
@PR DECIMAL(8,2);
DECLARE Product_Cursor_Price CURSOR 
FOR
SELECT
Product_id,
Product_Name,
Price
FROM 
Products WHERE Price > 30000;

OPEN Product_Cursor_Price;

FETCH NEXT FROM Product_Cursor_Price INTO
@PR_ID,
@PR_NAME,
@PR;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CAST(@PR_ID AS VARCHAR) +'-'+@PR_NAME+'-'+CAST(@PR AS VARCHAR );
    FETCH NEXT FROM Product_Cursor_Price INTO
	@PR_ID,
	@PR_NAME,
	@PR;
END

CLOSE Product_Cursor_Price;
DEALLOCATE Product_Cursor_Price;

--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
DECLARE @P_id INT;

DECLARE Product_CursorDelete CURSOR 
FOR SELECT Product_id 
FROM 
Products;

OPEN Product_CursorDelete;

FETCH NEXT FROM Product_CursorDelete INTO @P_id;
WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM Products WHERE CURRENT OF Product_CursorDelete;
    PRINT CAST(@P_id as varchar);
    FETCH NEXT FROM Product_CursorDelete INTO 
	@P_id;
END

CLOSE Product_CursorDelete;
DEALLOCATE Product_CursorDelete;

--Part – B

--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases
--the price by 10%.
DECLARE
@_id INT ,
@P_Name VARCHAR(250),
@P DECIMAL(10,2)

DECLARE Product_CursorUpdate CURSOR
FOR SELECT Product_id,Product_Name,Price 
FROM Products

OPEN  Product_CursorUpdate

FETCH NEXT FROM  Product_CursorUpdate INTO @_id,@P_Name,@P

WHILE @@FETCH_STATUS=0
	BEGIN
	UPDATE Products
	SET @P=@P+(@P*10)/100
	WHERE  Product_id=@_id
	SELECT @_id AS Product_id,@P_Name AS Product_Name,@P AS Price
	FETCH NEXT FROM  Product_CursorUpdate INTO @_id,@P_Name,@P
	END
 
CLOSE Product_CursorUpdate

DEALLOCATE Product_CursorUpdate

SELECT * FROM Products

--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
DECLARE @Pro_id INT, @Pri DECIMAL(10,2)

DECLARE product_cursor CURSOR FOR
SELECT Product_id, Price FROM Products

OPEN product_cursor

FETCH NEXT FROM product_cursor INTO @Pro_id, @Pri

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products
    SET Price = ROUND(@Pri, 0) 
    WHERE Product_id = @Pro_id

    FETCH NEXT FROM product_cursor INTO @Pro_id, @Pri
END

CLOSE product_cursor
DEALLOCATE product_cursor

SELECT* FROM Products

--Part – C

--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” 
--(Note: Create NewProducts table first with same fields as Products table)
CREATE TABLE  NewProducts( 
Product_id INT PRIMARY KEY, 
Product_Name VARCHAR(250) NOT NULL, 
Price DECIMAL(10, 2) NOT NULL 
); 

DECLARE @Products_id INT,@Products_Name VARCHAR(250),@Prices decimal(10,2)
DECLARE Product_CursorInsert CURSOR
FOR SELECT Product_id,Product_Name,Price FROM Products

OPEN Product_CursorInsert

FETCH NEXT FROM Product_CursorInsert
INTO @Products_id,@Products_Name,@Prices

WHILE @@FETCH_STATUS=0
	BEGIN 
	IF @Products_Name='Laptop'
	Insert into NewProducts values(@Products_id,@Products_Name,@Prices)
	FETCH NEXT FROM Product_CursorInsert INTO @Products_id,@Products_Name,@Prices
	END

CLOSE Product_CursorInsert

DEALLOCATE Product_CursorInsert

SELECT* FROM NewProducts

--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products 
--with a price above 50000 to an archive table, removing them from the original Products table.
CREATE TABLE ArchivedProducts
(Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
 );

DECLARE @PRODUCTID INT,@PEODUCTNAME VARCHAR(250),@PRIC INT
DECLARE ArchivedProducts_CURSOR CURSOR
FOR
SELECT Product_id, Product_Name, Price FROM Products
OPEN ArchivedProducts_CURSOR
FETCH NEXT FROM ArchivedProducts_CURSOR INTO @PRODUCTID,@PEODUCTNAME,@PRIC
WHILE @@FETCH_STATUS=0
BEGIN 
   IF(@PRIC>50000)
    INSERT INTO ArchivedProducts VALUES ( @PRODUCTID,@PEODUCTNAME,@PRIC)

	DELETE FROM Products
	WHERE Product_id=@PRODUCTID

   FETCH NEXT FROM ArchivedProducts_CURSOR INTO @PRODUCTID,@PEODUCTNAME,@PRIC
END
CLOSE ArchivedProducts_CURSOR
DEALLOCATE ArchivedProducts_CURSOR

SELECT * FROM Products
SELECT * FROM ArchivedProducts