
-- SALES ANALYTICS PROJECT
-- DAY 7 SQL ANALYSIS PROJECT


-- Create tables

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    order_date DATE
);


-- Insert customer data

INSERT INTO customers
(customer_id, customer_name, city, signup_date)
VALUES
(1, 'Aarav', 'Calicut', '2026-01-10'),
(2, 'Diya', 'Wayanad', '2026-01-15'),
(3, 'Kabir', 'Kochi', '2026-02-05'),
(4, 'Meera', 'Kannur', '2026-02-12'),
(5, 'Ishaan', 'Calicut', '2026-03-01'),
(6, 'Tara', 'Thrissur', '2026-03-18'),
(7, 'Vivaan', 'Kochi', '2026-04-02'),
(8, 'Kiara', 'Malappuram', '2026-04-15'),
(9, 'Rohan', 'Wayanad', '2026-05-09'),
(10, 'Myra', 'Kannur', '2026-05-20');


-- Insert product data

INSERT INTO products
(product_id, product_name, category, price)
VALUES
(1, 'Laptop', 'Electronics', 55000.00),
(2, 'Headphones', 'Electronics', 2500.00),
(3, 'T-Shirt', 'Clothing', 800.00),
(4, 'Jeans', 'Clothing', 1800.00),
(5, 'Backpack', 'Accessories', 1200.00),
(6, 'Smartphone', 'Electronics', 30000.00),
(7, 'Watch', 'Accessories', 3500.00),
(8, 'Sneakers', 'Footwear', 2800.00);


-- Insert order data

INSERT INTO orders
(order_id, customer_id, product_id, quantity, order_date)
VALUES
(101, 1, 1, 1, '2026-01-05'),
(102, 2, 3, 2, '2026-01-12'),
(103, 3, 2, 1, '2026-01-20'),
(104, 1, 6, 1, '2026-02-03'),
(105, 4, 4, 2, '2026-02-10'),
(106, 5, 5, 1, '2026-02-18'),
(107, 2, 8, 1, '2026-03-02'),
(108, 6, 7, 2, '2026-03-11'),
(109, 3, 3, 3, '2026-03-20'),
(110, 7, 2, 2, '2026-04-04'),
(111, 8, 6, 1, '2026-04-15'),
(112, 1, 2, 2, '2026-04-22'),
(113, 9, 5, 3, '2026-05-06'),
(114, 4, 1, 1, '2026-05-12'),
(115, 10, 8, 2, '2026-05-25'),
(116, 2, 7, 1, '2026-06-03'),
(117, 5, 4, 1, '2026-06-10'),
(118, 6, 3, 2, '2026-06-18'),
(119, 1, 5, 2, '2026-06-25'),
(120, 3, 6, 1, '2026-06-29');


-- Check table data

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;


-- Total revenue

SELECT SUM(p.price * o.quantity) AS total_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id;


-- Monthly revenue

SELECT
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(p.price * o.quantity) AS monthly_revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY month
ORDER BY month;


-- Find repeat customers

SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1;


-- Top-selling product category by quantity

SELECT
    p.category,
    SUM(o.quantity) AS total_sold
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sold DESC;


-- Revenue by city

SELECT
    c.city,
    SUM(p.price * o.quantity) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- Most expensive product

SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 1;


-- Total number of orders

SELECT COUNT(*) AS total_orders
FROM orders;


-- Total quantity sold

SELECT SUM(quantity) AS total_quantity_sold
FROM orders;


-- Average order quantity

SELECT AVG(quantity) AS average_quantity
FROM orders;


-- Revenue by product

SELECT
    p.product_name,
    SUM(p.price * o.quantity) AS total_revenue
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;


-- Number of orders by city

SELECT
    c.city,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;


-- Products priced above 1000

SELECT product_name, price
FROM products
WHERE price > 1000
ORDER BY price DESC;


-- Revenue by product category

SELECT
    p.category,
    SUM(p.price * o.quantity) AS total_revenue
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Customers who never placed an order

SELECT customer_name
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
);


-- Total spending by customer

SELECT
    c.customer_name,
    SUM(p.price * o.quantity) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;


-- Orders placed during March 2026

SELECT *
FROM orders
WHERE order_date BETWEEN '2026-03-01' AND '2026-03-31'
ORDER BY order_date;


-- Create monthly sales view

CREATE VIEW monthly_sales_view AS
SELECT
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(p.price * o.quantity) AS revenue
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY month;


-- Check monthly sales view

SELECT *
FROM monthly_sales_view
ORDER BY month;


-- Create product sales view

CREATE VIEW product_sales_view AS
SELECT
    p.product_name,
    SUM(o.quantity) AS total_sold,
    SUM(p.price * o.quantity) AS total_revenue
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name;


-- Check product sales view

SELECT *
FROM product_sales_view
ORDER BY total_revenue DESC;
