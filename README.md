# 🚖 Rapido Logistics: Operational Analytics & Data Warehousing
**Domain:** Supply Chain / Last-Mile Logistics | **Tools:** SQL (MySQL), ETL, Star Schema

### 🚀 Project Overview
Analyzed a dataset of **30,000 ride bookings** to identify revenue leakage points and operational bottlenecks. Designed a **Star Schema (3NF)** data warehouse to transform raw flat files into a structured analytical database, reducing query redundancy and improving integrity.

### 💼 Business Impact
* **Revenue Protection:** Identified **₹251.9K** in potential revenue loss due to cancellation spikes and incomplete rides (Script `03`).
* **Driver Optimization:** Flagged **15 "Repeat Offender" drivers** responsible for disproportionate cancellations, recommending targeted training.
* **Efficiency Gains:** Discovered that **Night Shifts (10 PM - 6 AM)** had the highest Turnaround Time (TAT) of **17.02 mins**, highlighting a supply-side shortage rather than a traffic issue.

### 🛠️ Technical Architecture
* **01_Schema_Architecture.sql:** Defines the 8-table Star Schema (Fact_Bookings, Dim_Customers, etc.) with Primary/Foreign Keys.
* **02_ETL_Pipeline.sql:** Handles data cleaning, `INSERT IGNORE` logic for duplicates, and `UPDATE JOIN` patterns to fix missing flags.
* **03_Business_Analysis.sql:** Contains the complex SQL queries (Window Functions, CTEs, CASE logic) used to derive insights.

### 📊 Key Insights
1.  **Network Analysis:** The **Pune -> Mumbai** lane has the highest volume but suffers from a **12% higher cancellation rate** than average.
2.  **Customer Segmentation:** Customers with ratings **< 3.5** face a **3x higher rejection rate**, indicating potential driver bias.
