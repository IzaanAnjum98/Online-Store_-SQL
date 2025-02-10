## 🛒 Online Store 

![Logo](https://github.com/IzaanAnjum98/Online-Store_SQL/blob/main/Logo.jpg)


A well-structured relational database schema for an online store, designed using SQL Server. It includes tables for customers, products, categories, orders, and order items, ensuring efficient data management for e-commerce applications.

📌 Schema Overview
The database consists of the following key tables:

1️⃣ Customers
Stores customer details, including name, email, phone, and address.

2️⃣ Products
Manages product information with categories, pricing, and stock levels.

3️⃣ Categories
Contains product categories with descriptions for better classification.

4️⃣ Orders
Records customer orders with timestamps and total amounts.

5️⃣ OrderItems
Stores individual items within orders, linking products and quantities.

### Tables Creation
```sql
-- Creating Customers Table
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY IDENTITY(1, 1),
  FirstName NVARCHAR(50),
  LastName NVARCHAR(50),
  Email NVARCHAR(50) UNIQUE,
  Phone NVARCHAR(100),
  Address NVARCHAR(100),
  City NVARCHAR(50),
  State NVARCHAR(50),
  ZipCode NVARCHAR(50),
  Country NVARCHAR(50),
  CreatedAt DATETIME DEFAULT GETDATE()
);

-- Creating Categories Table
CREATE TABLE Category (
  CategoryID INT PRIMARY KEY IDENTITY(1, 1),
  CategoryName NVARCHAR(100),
  Description NVARCHAR(100)
);

-- Creating Products Table
CREATE TABLE Products (
  ProductID INT PRIMARY KEY IDENTITY(1, 1),
  ProductName NVARCHAR(100),
  CategoryID INT,
  Price DECIMAL(10, 2),
  Stock INT,
  CreatedAt DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Creating Orders Table
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY IDENTITY(1, 1),
  CustomerID INT,
  OrderDate DATETIME DEFAULT GETDATE(),
  TotalAmount DECIMAL(10, 2),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Creating OrderItems Table
CREATE TABLE OrderItems (
  OrderItemID INT PRIMARY KEY IDENTITY(1, 1),
  OrderID INT,
  ProductID INT,
  Quantity INT,
  Price DECIMAL(10,2),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
```

📥 Sample Data

```sql

-- Insert sample data into Categories Table
INSERT INTO Category (CategoryName, Description) 
VALUES 
('Electronics', 'Devices and Gadgets'),
('Clothing', 'Apparel and Accessories'),
('Books', 'Printed and Electronic Books');

-- Insert sample data into Products Table
INSERT INTO Products (ProductName, CategoryID, Price, Stock)
VALUES 
('Television', 1, 1099.99, 10),
('T-Shirt', 2, 19.99, 50),
('Novel', 3, 14.99, 100);

-- Insert sample data into Customers Table
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St', 'New York', 'NY', '10001', 'USA'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '456 Oak St', 'Madison', 'WI', '53703', 'USA'),
('Harshad', 'Patel', 'harshad.patel@example.com', '345-678-9012', '789 Dalal St', 'Mumbai', 'Maharashtra', '41520', 'INDIA')
('Izaan','Anjum','izaananjum@example.com','923-456-7000','108 DHA St','Weatherfield','WI','62701','USA');

-- Insert sample data into Orders Table
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES 
(1, GETDATE(), 719.98),
(2, GETDATE(), 49.99),
(3, GETDATE(), 44.98);

-- Insert sample data into OrderItems Table
INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 2, 1, 49.99),
(3, 3, 1, 14.99);

```

#### Query# 1 : Retrieve all order for a Specific Customer
```sql
SELECT 
  O.OrderID, 
  O.OrderDate, 
  O.TotalAmount, 
  OI.ProductID, 
  P.ProductName, 
  OI.Quantity, 
  OI.Price 
FROM 
  Orders O 
  JOIN OrderItems OI ON O.OrderID = OI.OrderID 
  JOIN Products P ON P.ProductID = OI.ProductID

WHERE O.CustomerID = 1;
```


#### Query# 2 : Find Total Sales of Each Products
```sql
SELECT 
  OI.ProductID, 
  P.ProductName, 
  SUM(OI.Price * OI.Quantity) as Total_Sales 
FROM 
  OrderItems OI 
  JOIN Products P ON OI.ProductID = P.ProductID 
GROUP BY 
  OI.ProductID, 
  P.ProductName
ORDER BY Total_Sales DESC
;
```
#### Query# 3 : Calculate the average order value
```sql
SELECT AVG(TotalAmount) as Average 
FROM Orders
```
#### Query# 4 : List the top 5 customers by total spending
```sql
SELECT CustomerID, FullName, Total_Spending FROM
(
SELECT 
  C.CustomerID, 
  (C.FirstName + ' ' + C.LastName) AS FullName, 
  SUM(O.TotalAmount) as Total_Spending ,
  ROW_NUMBER() OVER(ORDER BY SUM(O.TotalAmount)DESC) AS Ranked
FROM 
  Customers C 
  JOIN Orders O ON C.customerid = O.CustomerID 
GROUP BY 
  C.customerid, 
  (C.FirstName + ' ' + C.LastName) 
) SUB
WHERE Ranked < 5
```
#### Query# 5 : Most Popular Product Category
```sql
SELECT 
  CategoryID, 
  CategoryName, 
  Quantity_Sold, 
  Ranked 
FROM 
  (
    SELECT 
      C.CategoryID, 
      C.CategoryName, 
      SUM(OI.Quantity) as Quantity_Sold, 
      ROW_NUMBER() OVER(
        ORDER BY 
          SUM(OI.Quantity) DESC
      ) as Ranked 
    FROM 
      OrderItems OI 
      JOIN Products P ON OI.ProductID = P.ProductID 
      JOIN Category C ON P.CategoryID = C.CategoryID 
    GROUP BY 
      C.CategoryID, 
      C.CategoryName
  ) SUB 
WHERE 
  Ranked = 1
```
#### Query# 6 : List of Product that are out of stock
```sql
SELECT 
	ProductID,
	ProductName,
	Price,
	Stock 

FROM 
	Products
WHERE
	STOCK = 0
```
#### Query# 7 : Customers who placed order in last 30 days
```sql
SELECT 
  C.CustomerID, 
  (C.FirstName + ' ' + C.LastName) AS Full_Name, 
  C.Email, 
  C.phone 
FROM 
  Customers C 
  JOIN Orders O ON C.customerid = O.CustomerID 
WHERE 
  O.OrderDate >= DATEADD(
    DAY, 
    -30, 
    GETDATE()
  );
```
#### Query# 8 : Calculate the no of order placed in each month
```sql
SELECT 
  Year(OrderDate) as Years, 
  MONTH(OrderDate) as Months, 
  COUNT(OrderID) AS No_Of_Order 
FROM 
  Orders 
Group by 
  Year(OrderDate), 
  MONTH(OrderDate) 
order by 
  No_Of_Order
```
#### Query# 9 : Retrieve the detail of most recent orders
```sql
SELECT 
  TOP 1 O.OrderID, 
  O.OrderDate, 
  O.TotalAmount, 
  C.FirstName, 
  C.LastName 
FROM 
  Orders O 
  JOIN CUSTOMERS C ON O.CustomerID = C.customerid 
ORDER BY 
  O.OrderDate DESC
```
#### Query# 10 : List the customer who never placed a order
```sql
SELECT 
  C.CustomerID, 
  C.FirstName, 
  C.LastName, 
  C.Email, 
  C.Phone, 
  O.OrderID, 
  O.TotalAmount 
FROM 
  Customers C FULL 
  JOIN ORDERS O ON C.customerid = O.CustomerID 
WHERE 
  O.OrderID IS NULL;
```
