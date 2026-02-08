# 🚖 Rapido Logistics: Operational Analytics & Revenue Optimization
**Project Status:** Completed | **Role:** Data Analyst | **Domain:** Supply Chain / Last-Mile Logistics

![Rapido Banner](https://img.shields.io/badge/Status-Project_Completed-success?style=for-the-badge) ![SQL](https://img.shields.io/badge/Tech-MySQL_8.0-blue?style=for-the-badge) ![PowerBI](https://img.shields.io/badge/Tech-Power_BI-yellow?style=for-the-badge)

## 📖 Executive Summary
This project analyzes a dataset of **30,000 ride bookings** to identify revenue leakage points, operational bottlenecks, and service reliability issues. By migrating raw flat-file data into a **Normalized Star Schema (3NF)**, I designed a scalable data warehouse that enabled complex SQL analysis.

The analysis revealed **₹251.9K in revenue leakage** due to cancellation spikes and identified that **Night Shifts (10 PM - 6 AM)** suffer from a 20% higher Turnaround Time (TAT) compared to peak hours, indicating a critical supply-side shortage.

---

## 🛠️ Data Architecture
The project moved away from Excel-based analysis to a robust SQL backend. I designed an **8-Table Star Schema** to ensure data integrity and query performance.

### **Entity-Relationship Model (Star Schema)**
The data warehouse consists of **2 Fact Tables** and **6 Dimension Tables**:

* **Fact Tables (Transactional):**
    * `Fact_Bookings`: The primary transactional table (30k rows) capturing ride details, revenue, and time metrics.
    * `Fact_Incomplete_Logs`: An audit table specifically tracking failure reasons for incomplete rides.
* **Dimension Tables (Context):**
    * `Dim_Customers`: Customer demographics and rating history.
    * `Dim_Drivers`: Driver performance scores and unique IDs.
    * `Dim_Vehicles`: Fleet details (Bike vs. Auto).
    * `Dim_Locations`: Pickup/Drop zones and city mapping.
    * `Dim_Payment_Methods`: Payment instrument details (UPI, Cash).
    * `Dim_Date`: A standard date hierarchy for time-intelligence analysis.

> **Technical Highlight:** Used `INSERT IGNORE` and `UPDATE JOIN` logic to handle data quality issues (e.g., missing cancellation flags) during the ETL process.

---

## 🔍 Key Business Problems & SQL Solutions

### 1. Revenue Leakage Analysis
**Problem:** Management suspected high cancellations were draining revenue but lacked quantification.
**SQL Approach:** Aggregated booking values for 'Incomplete' and 'Canceled' statuses.
**Insight:**
* **Total Leakage:** ₹251,905.66 (approx. 15% of potential revenue).
* **Root Cause:** Driver-side cancellations accounted for 60% of failed rides.

### 2. Driver Performance Audit ("The Repeat Offenders")
**Problem:** Are cancellations random, or are specific drivers gaming the system?
**SQL Approach:** Used `HAVING` clauses to filter drivers with >5 cancellations.
**Insight:**
* Identified **15 Drivers** responsible for a disproportionate share of cancellations.
* **Action:** Recommended immediate suspension or retraining for these specific IDs.

### 3. Time-Slot Efficiency (The "Night Shift" Bottleneck)
**Problem:** Customer complaints about wait times were increasing.
**SQL Approach:** Categorized timestamps into bins (`Morning Peak`, `Afternoon Slump`, `Evening Peak`, `Night`) using `CASE WHEN
