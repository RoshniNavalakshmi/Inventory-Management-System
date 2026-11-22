CREATE DATABASE Inventory;
USE Inventory;
SHOW DATABASES;
CREATE TABLE Categories(
category_id INT PRIMARY KEY,
category_name VARCHAR(50) NOT NULL
);

CREATE TABLE Suppliers(
supplier_id INT PRIMARY KEY,
supplier_name VARCHAR(50) NOT NULL,
phone_no VARCHAR(15),
email_id VARCHAR(50)
);

CREATE TABLE Products(
product_id INT PRIMARY KEY,
product_name VARCHAR(50) ,
category_id INT,
supplier_id INT,
price DECIMAL(10,2),
stock_qty INT,
FOREIGN KEY (category_id) REFERENCES Categories(category_id),
FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

SHOW TABLES;

INSERT INTO Categories (category_id,category_name)
VALUES
(1 , 'Electronics'),
(2 , 'Stationary'),
(3 , 'Furniture'),
(4 , 'Groceries');

SELECT * FROM Categories;

INSERT INTO Suppliers
(supplier_id , supplier_name , phone_no , email_id)
VALUES
(1 , 'Tech World' , 6754098762 , 'techworld@gmail.cpm'),
(2 , 'Office Mart' , 9876545098 , 'officemart@gmail.com'),
(3 , 'Home Needs' , 9876432098 , 'homeneeds@gmail.com' ),
(4 , 'Fresh Foods' , 9865432333 , 'freshfoods@gmail.com' );

SELECT * FROM Suppliers;

INSERT INTO Products
(product_id , product_name , category_id , supplier_id , price ,stock_qty)
VALUES
(1 , 'lAPTOP' ,1 , 1 ,55000.00 ,10),
(2, 'Keyboard' , 1 , 1 , 1500.00 ,25),
(3, 'Notebook' , 2 ,2 , 80.00 , 100),
(4, 'Office Chair' ,  3, 3 , 2500.00 ,15),
(5, 'Rice Bag' ,4 ,4 ,1200.00,30);

SELECT * FROM Products;

SELECT product_name,price,stock_qty
FROM Products;

SELECT product_name,stock_qty
FROM Products
WHERE stock_qty < 20;

SELECT product_name , price
FROM Products
ORDER BY price DESC;

SELECT COUNT(*) AS total_products
FROM Products;

SELECT SUM(price * stock_qty) AS total_inventory_value
FROM Products;

SELECT AVG(price) AS average_value
FROM Products;

SELECT MAX(price) AS highest_price
FROM Products;

SELECT product_name,price
FROM Products
WHERE price = (SELECT MAX(price) FROM Products);

SELECT MIN(price) AS lowest_price
FROM Products;

SELECT product_name,price
FROM products
WHERE price = (SELECT MIN(price) FROM Products);

SELECT category_id, COUNT(*) AS total_product
FROM Products
GROUP BY category_id;

SELECT
   c.category_name,
   COUNT(p.product_id) AS total_products
FROM Categories c
JOIN Products p
   ON C.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 1;

UPDATE Products
SET stock_qty = stock_qty + 5
WHERE product_id = 1;

SELECT product_name , stock_qty 
FROM Products
WHERE product_id = 1;

UPDATE Products
SET stock_qty = stock_qty - 5
WHERE product_id = 2;

SELECT product_name, stock_qty
FROM Products
WHERE product_id = 2;

SELECT product_name, product_id
FROM Products
WHERE product_name = 'Rice Bag';

DELETE FROM Products
WHERE product_id = 5;

SELECT * FROM Products;

SELECT AVG(price)
FROM Products;

SELECT product_name , price
FROM Products
WHERE price > ( SELECT AVG(price) FROM Products);

CREATE VIEW Low_stock_report AS
SELECT
     product_id,
     product_name,
     price,
     stock_qty
FROM Products
WHERE stock_qty <20;

SELECT * FROM Low_stock_report;

CREATE PROCEDURE Addstock(
  IN p_product_id INT,
  IN p_quantity INT
) 
   UPDATE Products
   SET stock_qty = stock_qty + p_quantity
   WHERE product_id = p_product_id;


SHOW PROCEDURE STATUS
WHERE DB = 'Inventory';

CALL Addstock(1,5);

SELECT product_name, stock_qty
FROM Products
WHERE product_id = 1;

SELECT * FROM Products;

SELECT UPPER(product_name)
FROM PRODUCTS;

SELECT LOWER(product_name)
FROM Products;

SELECT product_name , LENGTH(product_name) AS name_length
FROM Products;

SELECT CONCAT(product_name, ' - Rs', price) AS product_details
FROM Products;

SELECT product_name,ROUND(price,0) AS rounded_price
FROM Products;

SELECT product_name,price * stock_qty AS total_value
FROM Products;

CREATE TABLE stock_log(
   log_id INT AUTO_INCREMENT PRIMARY KEY,
   product_id INT,
   old_stock INT,
   new_stock INT,
   changed_at TIMESTAMP
);

SELECT * FROM stock_log;

CREATE TRIGGER stock_change_log
AFTER UPDATE ON Products
FOR EACH ROW
INSERT INTO stock_log(product_id,old_stock,new_stock,changed_at)
VALUES (OLD.product_id,OLD.stock_qty,NEW.stock_qty, NOW());

DROP TRIGGER stock_change_log;

UPDATE Products
SET stock_qty = stock_qty +10
WHERE product_id = 1;

CREATE TRIGGER stock_change_log
AFTER UPDATE ON Products
FOR EACH ROW
INSERT INTO stock_log(product_id,old_stock,new_stock,changed_at)
VALUES (OLD.product_id,OLD.stock_qty,NEW.stock_qty, NOW());

SELECT * FROM stock_log;

SELECT
    p.product_name,
    p.stock_qty,
    s.old_stock,
    s.new_stock,
    s.changed_at
FROM Products p
JOIN stock_log s
ON P.product_id = s.product_id;

    