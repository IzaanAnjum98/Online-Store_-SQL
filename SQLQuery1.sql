-- Creating a Customer Table
CREATE TABLE Customers
  (
     customerid INT PRIMARY KEY IDENTITY(1, 1),
     firstname  NVARCHAR(50),
     lastname   NVARCHAR(50),
     email      NVARCHAR(50) UNIQUE,
     phone      NVARCHAR(100),
     address    NVARCHAR(100),
     city       NVARCHAR(50),
     state      NVARCHAR(50),
     zipcode    NVARCHAR(50),
     country    NVARCHAR(50),
     createdat  DATETIME DEFAULT Getdate()
  ); 

 -- Create A Product Table
CREATE TABLE Products(
  ProductID INT PRIMARY KEY IDENTITY(1, 1), 
  ProductName NVARCHAR(100), 
  CategoryID INT, 
  Price decimal(10, 2), 
  Stock INT, 
  CreatedAt datetime default getdate()
);


--Create A Categories Table
CREATE TABLE Catergory(
  CatergoryID INT PRIMARY KEY IDENTITY(1, 1), 
  CategoryName NVARCHAR(100), 
  Descriptions NVARCHAR(100)
);


--Create A Orders Table
CREATE TABLE Orders(
  OrderID INT PRIMARY KEY IDENTITY(1, 1), 
  CustomerID INT, 
  OrderDate DATETIME DEFAULT GETDATE(), 
  TotalAmount DECIMAL(10, 2), 
  FOREIGN KEY (CustomerID) references Customers(CustomerID)
);

--Create A OrderItems Table
CREATE TABLE OrderItems(
  OrderItemID INT PRIMARY KEY IDENTITY(1, 1), 
  OrderID INT, 
  ProductID INT, 
  Quantity INT, 
  Price DECIMAL(10,2),
  FOREIGN KEY (ProductID) REFERENCES Products(ProductID), 
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert sample data into Categories table
INSERT INTO Catergory(CategoryName, Descriptions) 
VALUES 
('Electronics', 'Devices and Gadgets'),
('Clothing', 'Apparel and Accessories'),
('Books', 'Printed and Electronic Books');

-- Insert sample data into Products table
INSERT INTO Products(ProductName, CategoryID, Price, Stock)
VALUES 
('Televison', 7, 1099.99, 0);

-- Insert sample data into Customers table
INSERT INTO Customers(FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES 
('Sameer', 'Khanna', 'sameer.khanna@example.com', '123-456-7890', '123 Elm St.', 'Springfield', 
'IL', '62701', 'USA'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '456 Oak St.', 'Madison', 
'WI', '53703', 'USA'),
('harshad', 'patel', 'harshad.patel@example.com', '345-678-9012', '789 Dalal St.', 'Mumbai', 
'Maharashtra', '41520', 'INDIA');

-- Insert sample data into Orders table
INSERT INTO Orders(CustomerId, OrderDate, TotalAmount)
VALUES 
(1, GETDATE(), 719.98),
(2, GETDATE(), 49.99),
(3, GETDATE(), 44.98);

-- Insert sample data into OrderItems table
INSERT INTO OrderItems(OrderID, ProductID, Quantity, Price)
VALUES 
(1, 1, 1, 699.99),
(1, 3, 1, 19.99),
(2, 4, 1,  49.99),
(3, 5, 1, 14.99),
(3, 6, 1, 29.99);


