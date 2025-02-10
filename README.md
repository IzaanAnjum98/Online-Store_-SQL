## 🛒 Online Store Database Schema
A well-structured relational database schema for an online store, designed using SQL Server. It includes tables for customers, products, categories, orders, and order items, ensuring efficient data management for e-commerce applications.

##📌 Schema Overview
The database consists of the following key tables:

##1️⃣ Customers
Stores customer details, including name, email, phone, and address.

##2️⃣ Products
Manages product information with categories, pricing, and stock levels.

##3️⃣ Categories
Contains product categories with descriptions for better classification.

##4️⃣ Orders
Records customer orders with timestamps and total amounts.

##5️⃣ OrderItems
Stores individual items within orders, linking products and quantities.

## Dataset
Dataset file for the analysis

Link: [Netflix_Dataset](https://github.com/IzaanAnjum98/NetflixProject_SQL/blob/main/netflix_titles.csv)
## Business Problems with Solutions

#### Q#1: Count the number of Movies VS TV shows
```sql
SELECT TYPE,
       COUNT(TYPE) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY TYPE
ORDER BY TOTAL_CONTENT DESC
```
