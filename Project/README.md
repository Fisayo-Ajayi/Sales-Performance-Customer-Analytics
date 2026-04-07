**E-commerce Sales, Customer Retention & Product Performance Analytics**

**Project Overview**
This project explores how data can be used to understand sales performance, customer behavior, and product impact within an e-commerce environment.

I approached this as an end-to-end analytics workflow—starting with SQL-based data exploration, moving through data cleaning and transformation, and finally building an interactive dashboard to communicate insights clearly.

The goal was not just to analyze the data, but to uncover patterns that could realistically support business decisions around revenue growth, customer retention, and product strategy.



**Tools & Technologies**
MySQL – Initial querying and relational analysis
SQLite – Data cleaning and transformation
Microsoft Power BI – Data modeling, DAX, and visualization
SQL – Joins, aggregations, and analytical queries



**About the Dataset**
The dataset represents a typical e-commerce business and includes:

Customers and their signup details
Orders and transaction values
Products and pricing
Order-level details (quantity and item pricing)
Customer segmentation using RFM (Recency, Frequency, Monetary)

It reflects realistic behavior such as repeat purchases, varying customer value, and differences in product performance.



**How the Analysis Was Done**
1. Data Exploration (MySQL)
I started by working through the relationships between tables—joining customers, orders, and products to understand how transactions flow through the system.

2. Data Cleaning (SQLite)
Next, I prepared the data for analysis by:

Handling missing values (e.g., unknown countries)
Standardizing fields
Filtering out invalid transactions
Creating clean datasets for reporting

3. Dashboard Development (Power BI)
Finally, I built a Power BI dashboard where:

A star schema model was created
Relationships were defined across datasets
Measures (like revenue and customer value) were calculated
Insights were visualized in a clear and interactive way



**Dashboard Overview**
🔹 Sales Performance Overview
Total Revenue
Total Orders
Total Customers
Monthly Revenue Trend
Customer Segmentation (RFM)
🔹 Customer & Product Insights
Top Customers by Lifetime Value
Top Products by Revenue
Customer Retention (Repeat vs One-time)



**Dashboard Preview**

**Full Dashboard Report**
You can view the full dashboard here:
👉 reports/ecommerce_dashboard.pdf



**Key Insights**
The business shows a strong base of repeat customers, suggesting solid retention.
At the same time, a segment of customers appears to be at risk, highlighting potential churn.
Revenue is largely driven by a group of high-value customers, making them critical to overall performance.
A relatively small set of products contributes most of the revenue, pointing to clear product leaders.

📁 Project Structure
ecommerce-sales-analytics/
│
├── data/
├── sql/
├── dashboard/
├── images/
├── reports/
└── README.md



**Why This Project Matters**
This project demonstrates how data can move beyond numbers and into decisions.

It shows how to:

Understand customer behavior
Identify revenue drivers
Highlight risks like churn
Translate data into meaningful insights



**Author**
Fisayo Ajayi
Data Analyst | Business Analytics | Data Visualization
