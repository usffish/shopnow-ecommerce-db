-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 8: ETL — Load OLAP Dimension & Fact Tables
-- Run AFTER 05_olap_schema.sql and 02_oltp_seed_data.sql
-- =============================================================

-- -------------------------------------------------------------
-- ETL: DimCustomer
-- Transforms numeric Gender codes to descriptive strings
-- -------------------------------------------------------------
INSERT INTO DimCustomer (CustomerID, Name, Email, PhoneNumber, Age, Gender)
SELECT
  CustomerID,
  Name,
  Email,
  PhoneNumber,
  Age,
  CASE
    WHEN Gender = 1 THEN 'Male'
    WHEN Gender = 2 THEN 'Female'
    WHEN Gender = 0 THEN 'Not Specified'
    ELSE 'Unknown'
  END AS Gender
FROM Customers;

-- -------------------------------------------------------------
-- ETL: DimCategory
-- -------------------------------------------------------------
INSERT INTO DimCategory (CategoryID, Name, Description)
SELECT CategoryID, Name, Description
FROM   Categories;

-- -------------------------------------------------------------
-- ETL: DimSupplier
-- -------------------------------------------------------------
INSERT INTO DimSupplier (SupplierID, Name, Email, PhoneNumber, SupplierAddress)
SELECT SupplierID, Name, Email, PhoneNumber, SupplierAddress
FROM   Suppliers;

-- -------------------------------------------------------------
-- ETL: DimProduct
-- Joins OLTP Products with the new dimension tables to resolve
-- surrogate keys (CategoryKey, SupplierKey)
-- -------------------------------------------------------------
INSERT INTO DimProduct (ProductID, Description, UnitPrice, CategoryKey, SupplierKey)
SELECT
  p.ProductID,
  p.Description,
  p.UnitPrice,
  dc.CategoryKey,
  ds.SupplierKey
FROM Products  p
JOIN DimCategory dc ON p.CategoryID = dc.CategoryID
JOIN DimSupplier ds ON p.SupplierID = ds.SupplierID;

-- -------------------------------------------------------------
-- ETL: DimTime
-- Procedural PL/SQL block — generates one row per calendar day
-- from 2020-01-01 through 2030-12-31
-- -------------------------------------------------------------
DECLARE
  v_start_date   DATE := TO_DATE('2020-01-01', 'YYYY-MM-DD');
  v_end_date     DATE := TO_DATE('2030-12-31', 'YYYY-MM-DD');
  v_current_date DATE := v_start_date;
BEGIN
  WHILE v_current_date <= v_end_date LOOP
    INSERT INTO DimTime (FullDate, DayOfWeek, DayOfMonth, Month, MonthName, Quarter, Year)
    VALUES (
      v_current_date,
      TO_CHAR(v_current_date, 'FMDay'),
      TO_NUMBER(TO_CHAR(v_current_date, 'DD')),
      TO_NUMBER(TO_CHAR(v_current_date, 'MM')),
      TO_CHAR(v_current_date, 'FMMonth'),
      TO_NUMBER(TO_CHAR(v_current_date, 'Q')),
      TO_NUMBER(TO_CHAR(v_current_date, 'YYYY'))
    );
    v_current_date := v_current_date + 1;
  END LOOP;
  COMMIT;
END;
/

-- -------------------------------------------------------------
-- ETL: SalesFact
-- Joins OLTP transactional tables with dimension tables to
-- resolve surrogate keys; calculates TotalAmount per line item
-- -------------------------------------------------------------
INSERT INTO SalesFact (CustomerKey, ProductKey, TimeKey, OrderID, QuantitySold, UnitPrice, TotalAmount)
SELECT
  dc.CustomerKey,
  dp.ProductKey,
  dt.TimeKey,
  o.OrderID,
  oi.Quantity,
  p.UnitPrice,
  (oi.Quantity * p.UnitPrice) AS TotalAmount
FROM Orders          o
JOIN "Order Items"   oi ON o.OrderID     = oi.OrderID
JOIN Products        p  ON oi.ProductID  = p.ProductID
JOIN DimCustomer     dc ON o.CustomerID  = dc.CustomerID
JOIN DimProduct      dp ON oi.ProductID  = dp.ProductID
JOIN DimTime         dt ON TRUNC(o.OrderDate) = dt.FullDate;

COMMIT;

-- Quick verification
SELECT COUNT(*) AS dim_customers  FROM DimCustomer;
SELECT COUNT(*) AS dim_categories FROM DimCategory;
SELECT COUNT(*) AS dim_suppliers  FROM DimSupplier;
SELECT COUNT(*) AS dim_products   FROM DimProduct;
SELECT COUNT(*) AS dim_time_rows  FROM DimTime;
SELECT COUNT(*) AS fact_rows      FROM SalesFact;
