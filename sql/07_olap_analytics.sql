-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 9: OLAP Analytics — Data Cube Queries
-- Run AFTER 06_olap_etl.sql
--
-- Uses ROLLUP and CUBE operators for multi-dimensional analysis
-- =============================================================

-- -------------------------------------------------------------
-- 1. Revenue by Category and Month
--    Insight: which product categories are most lucrative
--    and during which months — useful for seasonal marketing
-- -------------------------------------------------------------
SELECT
  t.MONTH,
  cat.NAME  AS CATEGORY_NAME,
  SUM(f.TOTALAMOUNT) AS Revenue
FROM SalesFact    f
JOIN DimProduct   p   ON f.PRODUCTKEY  = p.PRODUCTKEY
JOIN DimCategory  cat ON p.CATEGORYKEY = cat.CATEGORYKEY
JOIN DimTime      t   ON f.TIMEKEY     = t.TIMEKEY
GROUP BY ROLLUP (t.MONTH, cat.NAME)
ORDER BY t.MONTH, cat.NAME;

-- -------------------------------------------------------------
-- 2. Sales by Category and Gender
--    Insight: which product categories appeal to which genders
--    — informs targeted marketing campaigns
-- -------------------------------------------------------------
SELECT
  cat.NAME   AS CATEGORY_NAME,
  cust.GENDER,
  SUM(f.QUANTITYSOLD) AS TotalSales
FROM SalesFact    f
JOIN DimProduct   p    ON f.PRODUCTKEY  = p.PRODUCTKEY
JOIN DimCategory  cat  ON p.CATEGORYKEY = cat.CATEGORYKEY
JOIN DimCustomer  cust ON f.CUSTOMERKEY = cust.CUSTOMERKEY
GROUP BY CUBE (cat.NAME, cust.GENDER)
ORDER BY cat.NAME, cust.GENDER;

-- -------------------------------------------------------------
-- 3. Sales by Customer and Category
--    Insight: per-customer purchase patterns across categories
--    — enables personalised product recommendations
-- -------------------------------------------------------------
SELECT
  cust.NAME || ' (ID = ' || TO_CHAR(cust.CUSTOMERID) || ')' AS Customer,
  cat.NAME  AS CATEGORY_NAME,
  SUM(f.QUANTITYSOLD) AS TotalSales
FROM SalesFact    f
JOIN DimProduct   p    ON f.PRODUCTKEY  = p.PRODUCTKEY
JOIN DimCategory  cat  ON p.CATEGORYKEY = cat.CATEGORYKEY
JOIN DimCustomer  cust ON f.CUSTOMERKEY = cust.CUSTOMERKEY
GROUP BY ROLLUP (cust.NAME || ' (ID = ' || TO_CHAR(cust.CUSTOMERID) || ')', cat.NAME)
ORDER BY Customer, cat.NAME;

-- -------------------------------------------------------------
-- 4a. Sales by Category and Exact Age
--     Insight: age-level purchasing behaviour per category
-- -------------------------------------------------------------
SELECT
  cat.NAME  AS CATEGORY_NAME,
  cust.AGE,
  SUM(f.QUANTITYSOLD) AS TotalSales
FROM SalesFact    f
JOIN DimProduct   p    ON f.PRODUCTKEY  = p.PRODUCTKEY
JOIN DimCategory  cat  ON p.CATEGORYKEY = cat.CATEGORYKEY
JOIN DimCustomer  cust ON f.CUSTOMERKEY = cust.CUSTOMERKEY
GROUP BY CUBE (cat.NAME, cust.AGE)
ORDER BY cat.NAME, cust.AGE;

-- -------------------------------------------------------------
-- 4b. Sales by Category and Age Group (decade buckets)
--     Insight: generational purchasing trends per category
-- -------------------------------------------------------------
SELECT
  cat.NAME  AS CATEGORY_NAME,
  TO_CHAR(FLOOR(cust.AGE / 10) * 10) || ' - ' ||
  TO_CHAR(CEIL(cust.AGE  / 10) * 10 - 1) AS AgeGroup,
  SUM(f.QUANTITYSOLD) AS TotalSales
FROM SalesFact    f
JOIN DimProduct   p    ON f.PRODUCTKEY  = p.PRODUCTKEY
JOIN DimCategory  cat  ON p.CATEGORYKEY = cat.CATEGORYKEY
JOIN DimCustomer  cust ON f.CUSTOMERKEY = cust.CUSTOMERKEY
GROUP BY CUBE (
  cat.NAME,
  TO_CHAR(FLOOR(cust.AGE / 10) * 10) || ' - ' || TO_CHAR(CEIL(cust.AGE / 10) * 10 - 1)
)
ORDER BY cat.NAME, AgeGroup;

-- -------------------------------------------------------------
-- 5. Revenue by Product and Time (Year + Month)
--    Insight: long-term product performance trends
--    — identifies rising or declining products
-- -------------------------------------------------------------
SELECT
  t.YEAR,
  t.MONTH,
  p.DESCRIPTION  AS PRODUCT_NAME,
  SUM(f.TOTALAMOUNT) AS Revenue
FROM SalesFact   f
JOIN DimProduct  p ON f.PRODUCTKEY = p.PRODUCTKEY
JOIN DimTime     t ON f.TIMEKEY    = t.TIMEKEY
GROUP BY ROLLUP (t.YEAR, t.MONTH, p.DESCRIPTION)
ORDER BY t.YEAR, t.MONTH, p.DESCRIPTION;
