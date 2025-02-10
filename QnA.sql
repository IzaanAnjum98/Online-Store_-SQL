--QUERIES

--Query# 1 : Retrieve all order for a Specific Customer
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

--Query# 2 : Find Total Sales of Each Products

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

--Query# 3 : Calculate the average order value

SELECT AVG(TotalAmount) as Average 
FROM Orders

--Query# 4 : List the top 5 customers by total spending

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

--Query# 5 : Most Popular Product Category
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

--Query# 6 : List of Product that are out of stock

SELECT 
	ProductID,
	ProductName,
	Price,
	Stock 

FROM 
	Products
WHERE
	STOCK = 0

--Query# 7 : Customers who placed order in last 30 days

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

-- Query# 8 : Calculate the no of order placed in each month

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

-- Query# 9 : Retrieve the detail of most recent orders

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

-- Query# 10 : List the customer who never placed a order

SELECT C.CustomerID, C.FirstName, C.LastName, C.Email, C.Phone,O.OrderID, O.TotalAmount
FROM Customers C FULL JOIN ORDERS O
ON C.customerid= O.CustomerID
WHERE O.OrderID IS NULL;
