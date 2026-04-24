-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 8: OLAP Star Schema (Oracle SQL)
--
-- Star Schema layout:
--   Fact table  : SalesFact
--   Dimensions  : DimCustomer, DimProduct, DimCategory,
--                 DimSupplier, DimTime
-- =============================================================

-- -------------------------------------------------------------
-- 0) Drop OLAP tables if they already exist
-- -------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TABLE SalesFact   CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DimProduct  CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DimCustomer CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DimCategory CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DimSupplier CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DimTime     CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- -------------------------------------------------------------
-- DIMENSION: DimCustomer
-- Gender transformed from numeric (OLTP) to descriptive string
-- -------------------------------------------------------------
CREATE TABLE DimCustomer (
  CustomerKey NUMBER GENERATED ALWAYS AS IDENTITY,
  CustomerID  NUMBER        NOT NULL,  -- FK back to OLTP
  Name        VARCHAR2(100) NOT NULL,
  Email       VARCHAR2(100) NOT NULL,
  PhoneNumber VARCHAR2(30),
  Age         NUMBER,
  Gender      VARCHAR2(20),            -- 'Male' | 'Female' | 'Not Specified'
  CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerKey)
);

-- -------------------------------------------------------------
-- DIMENSION: DimTime
-- One row per calendar day; covers 2020-01-01 to 2030-12-31
-- -------------------------------------------------------------
CREATE TABLE DimTime (
  TimeKey    NUMBER GENERATED ALWAYS AS IDENTITY,
  FullDate   DATE         NOT NULL,
  DayOfWeek  VARCHAR2(9)  NOT NULL,
  DayOfMonth NUMBER       NOT NULL,
  Month      NUMBER       NOT NULL,
  MonthName  VARCHAR2(9)  NOT NULL,
  Quarter    NUMBER       NOT NULL,
  Year       NUMBER       NOT NULL,
  CONSTRAINT PK_DimTime          PRIMARY KEY (TimeKey),
  CONSTRAINT UQ_DimTime_FullDate UNIQUE (FullDate)
);

-- -------------------------------------------------------------
-- DIMENSION: DimCategory
-- -------------------------------------------------------------
CREATE TABLE DimCategory (
  CategoryKey NUMBER GENERATED ALWAYS AS IDENTITY,
  CategoryID  NUMBER        NOT NULL,  -- FK back to OLTP
  Name        VARCHAR2(100) NOT NULL,
  Description VARCHAR2(300),
  CONSTRAINT PK_DimCategory PRIMARY KEY (CategoryKey)
);

-- -------------------------------------------------------------
-- DIMENSION: DimSupplier
-- -------------------------------------------------------------
CREATE TABLE DimSupplier (
  SupplierKey     NUMBER GENERATED ALWAYS AS IDENTITY,
  SupplierID      NUMBER        NOT NULL,  -- FK back to OLTP
  Name            VARCHAR2(100) NOT NULL,
  Email           VARCHAR2(100),
  PhoneNumber     VARCHAR2(100),
  SupplierAddress VARCHAR2(100),
  CONSTRAINT PK_DimSupplier PRIMARY KEY (SupplierKey)
);

-- -------------------------------------------------------------
-- DIMENSION: DimProduct
-- Denormalized: includes CategoryKey and SupplierKey
-- -------------------------------------------------------------
CREATE TABLE DimProduct (
  ProductKey  NUMBER GENERATED ALWAYS AS IDENTITY,
  ProductID   NUMBER        NOT NULL,  -- FK back to OLTP
  Description VARCHAR2(300) NOT NULL,
  UnitPrice   NUMBER(10,2)  NOT NULL,
  CategoryKey NUMBER,
  SupplierKey NUMBER,
  CONSTRAINT PK_DimProduct          PRIMARY KEY (ProductKey),
  CONSTRAINT FK_DimProduct_Category FOREIGN KEY (CategoryKey) REFERENCES DimCategory(CategoryKey),
  CONSTRAINT FK_DimProduct_Supplier FOREIGN KEY (SupplierKey) REFERENCES DimSupplier(SupplierKey)
);

-- -------------------------------------------------------------
-- FACT TABLE: SalesFact
-- Grain: one row per order line item
-- -------------------------------------------------------------
CREATE TABLE SalesFact (
  SalesFactKey NUMBER GENERATED ALWAYS AS IDENTITY,
  CustomerKey  NUMBER       NOT NULL,
  ProductKey   NUMBER       NOT NULL,
  TimeKey      NUMBER       NOT NULL,
  OrderID      NUMBER       NOT NULL,  -- degenerate dimension
  QuantitySold NUMBER       NOT NULL,
  UnitPrice    NUMBER(10,2) NOT NULL,  -- price at time of sale
  TotalAmount  NUMBER(12,2) NOT NULL,
  CONSTRAINT PK_SalesFact          PRIMARY KEY (SalesFactKey),
  CONSTRAINT FK_SalesFact_Customer FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
  CONSTRAINT FK_SalesFact_Product  FOREIGN KEY (ProductKey)  REFERENCES DimProduct(ProductKey),
  CONSTRAINT FK_SalesFact_Time     FOREIGN KEY (TimeKey)     REFERENCES DimTime(TimeKey)
);
