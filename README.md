# ShopNow E-Commerce Database

End-to-end Oracle SQL database project for a fictional e-commerce platform — covering 3NF OLTP schema design, ETL pipeline, star schema OLAP warehouse, and multi-dimensional analytics with ROLLUP/CUBE.

![Oracle](https://img.shields.io/badge/Oracle_SQL-F80000?style=flat-square&logo=oracle&logoColor=white)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-F80000?style=flat-square&logo=oracle&logoColor=white)
![Data Warehousing](https://img.shields.io/badge/Data_Warehousing-4169E1?style=flat-square&logo=databricks&logoColor=white)
![ETL](https://img.shields.io/badge/ETL_Pipeline-FF6F00?style=flat-square&logo=apacheairflow&logoColor=white)

---

## Overview

ShopNow is a transactional e-commerce system designed to manage customers, products, orders, payments, and shipping — while also supporting analytical queries on sales trends, customer behaviour, and inventory.

The project progresses through two major layers:

| Layer | Purpose |
|---|---|
| **OLTP** | Day-to-day operations — 3NF relational schema, constraints, indexes |
| **OLAP** | Business intelligence — star schema, ETL, data cube analytics |

---

## Project Structure

```
sql/
├── 01_oltp_schema.sql      # DDL: 8-table 3NF schema with constraints & indexes
├── 02_oltp_seed_data.sql   # Sample data: ≥10 rows per table
├── 03_oltp_queries.sql     # Analytics queries, DML updates, and ACID transaction
├── 04_oltp_joins.sql       # INNER / LEFT / RIGHT / FULL OUTER join examples
├── 05_olap_schema.sql      # Star schema DDL: SalesFact + 5 dimension tables
├── 06_olap_etl.sql         # ETL: load dimensions and fact table from OLTP
└── 07_olap_analytics.sql   # Data cube queries using ROLLUP and CUBE
```

---

## OLTP Schema (3NF)

Eight tables covering all core business entities:

```
Categories ──┐
             ├── Products ──┐
Suppliers  ──┘              ├── Order Items ──┐
                            │                 ├── Orders ── Customers
                            └── (inventory)   │
                                              ├── Payments
                                              └── Shipping Info
```

Key design decisions:
- Gender stored as NUMBER in OLTP (0/1/2) and transformed to VARCHAR2 during ETL
- Quoted identifiers ("Order Items", "Shipping Info") preserve original naming
- Check constraints enforce non-negative prices, inventory, and valid age range
- Indexes on all foreign key columns for join performance

---

## OLAP Star Schema

```
              DimTime
                │
DimSupplier ── DimProduct ── SalesFact ── DimCustomer
                │
            DimCategory
```

**SalesFact** grain: one row per order line item  
**Degenerate dimension**: OrderID retained directly in the fact table  
**DimTime**: populated via PL/SQL loop — one row per day from 2020-01-01 to 2030-12-31

---

## Analytics Queries

| Query | Operator | Business Question |
|---|---|---|
| Revenue by Category & Month | ROLLUP | Which categories peak in which months? |
| Sales by Category & Gender | CUBE | Which genders buy which product types? |
| Sales by Customer & Category | ROLLUP | What does each customer tend to buy? |
| Sales by Category & Age Group | CUBE | Which age groups drive which categories? |
| Revenue by Product & Time | ROLLUP | How do individual products trend over time? |

---

## Setup & Usage

**Requirements:** Oracle Database 12c+ (or Oracle Live SQL / Oracle XE)

Run the scripts in order:

```sql
-- 1. Create OLTP schema
@sql/01_oltp_schema.sql

-- 2. Load sample data
@sql/02_oltp_seed_data.sql

-- 3. Run OLTP queries and transaction demo
@sql/03_oltp_queries.sql

-- 4. Explore join operations
@sql/04_oltp_joins.sql

-- 5. Create OLAP star schema
@sql/05_olap_schema.sql

-- 6. Run ETL to populate OLAP tables
@sql/06_olap_etl.sql

-- 7. Run analytics / data cube queries
@sql/07_olap_analytics.sql
```

> All scripts are idempotent — they drop and recreate objects on each run.

---

## Course

**ISM 6218: Advanced Database Management**  
University of South Florida — Fall 2025  
Team: Ismail Jhaveri, Dylan Raab, Izaac Martinez

---

## Author

**Ismail Jhaveri**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ismail-jhaveri-2021/)
[![Email](https://img.shields.io/badge/Email-ismailj@usf.edu-D14836?style=flat-square&logo=gmail&logoColor=white)](mailto:ismailj@usf.edu)
