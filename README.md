## 🛒 EcommerceDB – E-commerce Data Analytics and Management System

### 📘 Overview

**EcommerceDB** is a structured SQL project designed to simulate a real-world e-commerce database system.
It helps analyze, clean, and validate customer, order, and product data to uncover key business insights such as revenue trends, customer behavior, and regional performance.

The project covers every stage of database management — from setup and data validation to advanced analytical queries.

---

### 🧱 Database Structure

The **EcommerceDB** database consists of five main tables:

1. **Customers** – Stores customer details like ID, name, email, signup date, and region.
2. **Orders** – Contains order records with customer references, dates, and total amounts.
3. **Order_Items** – Holds details of each item in an order including product, quantity, and price.
4. **Products** – Includes product information such as name, category, and price.
5. **Returns** – Tracks returned orders and reasons for return.

---

### ⚙️ Project Sections and Functionality

#### **SECTION 1: Database Setup**

* Create the `ecommercedb` database and set up all base tables.
* Preview table data using `SELECT` queries.

#### **SECTION 2: Data Preview & Initial Exploration**

* Display the first few records of each table.
* Count total rows per table to confirm successful data loading.

#### **SECTION 3: Data Quality – Null & Missing Value Checks**

* Identify missing or NULL values across all columns.
* Calculate the percentage of missing data in key fields.
* Ensure data completeness and reliability.

#### **SECTION 4: Basic Statistics & Summary Metrics**

* Compute minimum, maximum, average, and total order amounts.
* Analyze product prices and quantity trends for understanding sales patterns.

#### **SECTION 5: Duplicate Data Handling**

* Detect and remove duplicate customers, orders, or order items using `GROUP BY`, `HAVING`, and window functions (`ROW_NUMBER()`).
* Maintain data integrity by keeping only unique entries.

#### **SECTION 6: Data Validation & Cleaning Patterns**

* Validate email formats using regular expressions.
* Identify blank or invalid names and replace missing regions with `"UNKNOWN"`.
* Exclude incomplete transactions (e.g., NULL total amounts).

#### **SECTION 7: Referential Integrity Checks**

* Detect mismatched relationships between tables such as:

  * Orders without valid customers.
  * Order items missing corresponding products.
  * Returns linked to nonexistent orders.

#### **SECTION 8: Sales & Revenue Analysis**

* Compute revenue by product category.
* Identify top-selling products by total sales.
* Measure order frequency per customer.
* Calculate overall and per-customer revenue performance.

#### **SECTION 9: Time-Based Analysis**

* Generate monthly and daily sales trends.
* Identify seasonal or date-based order fluctuations.

#### **SECTION 10: Product & Category Analysis**

* Evaluate product mix per category and month.
* Find each customer’s first purchase date for retention insights.

#### **SECTION 11: Customer Behavior & Cohort Analysis**

* Track new customer signups by month (cohort analysis).
* Determine early customer engagement by measuring orders placed within 30 days of signup.

#### **SECTION 12: Window Functions & Analytics**

* Rank customers based on total revenue using `DENSE_RANK()`.
* Highlight top-performing buyers and their contribution to overall sales.

#### **SECTION 13: Return & Refund Analysis**

* Calculate total return rate as a percentage of all orders.
* Analyze return reasons and quantify refund value.
* Assess the financial impact of returned products.

#### **SECTION 14: Geographical Insights**

* Determine customer distribution across regions.
* Analyze regional revenue contribution to identify high-performing markets.

---

### 🧠 Learning Outcomes

By completing **EcommerceDB**, you’ll gain practical knowledge of:

* **Database design and normalization**.
* **Data cleaning and integrity validation** using SQL.
* **Statistical and business analysis** with aggregate functions.
* **Window functions and ranking operations**.
* **Cohort and revenue analysis** for e-commerce insights.

---

### 🧩 Technologies Used

* **Database System:** MySQL
* **Core SQL Concepts:**

  * Data definition (`CREATE DATABASE`, `USE`, `SELECT`)
  * Data aggregation (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`)
  * Conditional statements (`CASE`, `COALESCE`)
  * Joins and Subqueries
  * Window Functions (`ROW_NUMBER`, `DENSE_RANK`)
  * Regular Expressions for data validation

---

### 🚀 Future Enhancements

* Automate data cleaning using **stored procedures**.
* Add **triggers** for real-time referential integrity enforcement.
* Integrate **Power BI or Tableau** dashboards for visualization.
* Implement **user roles and access control** for data security.
