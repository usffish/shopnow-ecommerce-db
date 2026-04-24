-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 4: OLTP Schema (Oracle SQL)
-- Tables: Categories, Suppliers, Customers, Products,
--         Orders, Order Items, Payments, Shipping Info
-- =============================================================

SET DEFINE OFF;

-- -------------------------------------------------------------
-- 0) CLEAN SLATE: drop tables if they already exist
-- -------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TABLE "Order Items" CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE "Shipping Info" CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Payments CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Orders CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Products CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Customers CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Categories CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Suppliers CASCADE CONSTRAINTS PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- -------------------------------------------------------------
-- 1) CATEGORIES
-- -------------------------------------------------------------
CREATE TABLE Categories (
  CategoryID   NUMBER GENERATED ALWAYS AS IDENTITY,
  Name         VARCHAR2(100) NOT NULL,
  Description  VARCHAR2(300),
  CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
  CONSTRAINT UQ_Categories_Name UNIQUE (Name)
);

-- -------------------------------------------------------------
-- 2) SUPPLIERS
-- -------------------------------------------------------------
CREATE TABLE Suppliers (
  SupplierID      NUMBER GENERATED ALWAYS AS IDENTITY,
  Name            VARCHAR2(100) NOT NULL,
  Email           VARCHAR2(100),
  PhoneNumber     VARCHAR2(100),
  SupplierAddress VARCHAR2(100),
  CONSTRAINT PK_Suppliers PRIMARY KEY (SupplierID)
);

-- -------------------------------------------------------------
-- 3) CUSTOMERS
-- Gender stored as NUMBER: 0=Not Specified, 1=Male, 2=Female
-- -------------------------------------------------------------
CREATE TABLE Customers (
  CustomerID  NUMBER GENERATED ALWAYS AS IDENTITY,
  Name        VARCHAR2(100) NOT NULL,
  Email       VARCHAR2(100) NOT NULL,
  PhoneNumber VARCHAR2(30),
  Age         NUMBER,
  Gender      NUMBER,
  CONSTRAINT PK_Customers      PRIMARY KEY (CustomerID),
  CONSTRAINT UQ_Customers_Email UNIQUE (Email),
  CONSTRAINT CK_Customers_Age  CHECK (Age IS NULL OR Age BETWEEN 0 AND 120)
);

-- -------------------------------------------------------------
-- 4) PRODUCTS
-- -------------------------------------------------------------
CREATE TABLE Products (
  ProductID   NUMBER GENERATED ALWAYS AS IDENTITY,
  Description VARCHAR2(300) NOT NULL,
  CategoryID  NUMBER        NOT NULL,
  UnitPrice   NUMBER(10,2)  NOT NULL,
  Inventory   NUMBER        NOT NULL,
  SupplierID  NUMBER        NOT NULL,
  CONSTRAINT PK_Products           PRIMARY KEY (ProductID),
  CONSTRAINT CK_Products_Price     CHECK (UnitPrice >= 0),
  CONSTRAINT CK_Products_Inventory CHECK (Inventory >= 0),
  CONSTRAINT FK_Products_Category  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
  CONSTRAINT FK_Products_Supplier  FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- -------------------------------------------------------------
-- 5) ORDERS
-- Status: 0=NEW, 1=PAID, 2=SHIPPED, 3=DELIVERED, 4=CANCELLED
-- -------------------------------------------------------------
CREATE TABLE Orders (
  OrderID    NUMBER GENERATED ALWAYS AS IDENTITY,
  CustomerID NUMBER       NOT NULL,
  OrderDate  DATE         NOT NULL,
  Status     NUMBER       NOT NULL,
  TotalPrice NUMBER(12,2) NOT NULL,
  CONSTRAINT PK_Orders          PRIMARY KEY (OrderID),
  CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  CONSTRAINT CK_Orders_TotalNonNeg CHECK (TotalPrice >= 0)
);

-- -------------------------------------------------------------
-- 6) ORDER ITEMS  (quoted identifier due to space in name)
-- -------------------------------------------------------------
CREATE TABLE "Order Items" (
  OrderItemID NUMBER GENERATED ALWAYS AS IDENTITY,
  OrderID     NUMBER NOT NULL,
  ProductID   NUMBER NOT NULL,
  Quantity    NUMBER NOT NULL,
  CONSTRAINT PK_OrderItems         PRIMARY KEY (OrderItemID),
  CONSTRAINT FK_OrderItems_Order   FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
  CONSTRAINT FK_OrderItems_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
  CONSTRAINT CK_OrderItems_Qty     CHECK (Quantity > 0)
);

-- -------------------------------------------------------------
-- 7) PAYMENTS
-- PaymentMethod: 1=Credit Card, 2=Debit Card, 3=PayPal, etc.
-- PaymentStatus: 0=FAILED, 1=PAID
-- -------------------------------------------------------------
CREATE TABLE Payments (
  PaymentID     NUMBER GENERATED ALWAYS AS IDENTITY,
  OrderID       NUMBER       NOT NULL,
  PaymentDate   DATE         NOT NULL,
  PaymentMethod NUMBER       NOT NULL,
  Amount        NUMBER(12,2) NOT NULL,
  PaymentStatus NUMBER       NOT NULL,
  CONSTRAINT PK_Payments       PRIMARY KEY (PaymentID),
  CONSTRAINT FK_Payments_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CONSTRAINT CK_Payments_Amt   CHECK (Amount >= 0)
);

-- -------------------------------------------------------------
-- 8) SHIPPING INFO  (quoted identifier due to space in name)
-- -------------------------------------------------------------
CREATE TABLE "Shipping Info" (
  ShippingID        NUMBER GENERATED ALWAYS AS IDENTITY,
  OrderID           NUMBER       NOT NULL,
  Address           VARCHAR2(100) NOT NULL,
  "Tracking Number" VARCHAR2(100),
  CONSTRAINT PK_ShippingInfo       PRIMARY KEY (ShippingID),
  CONSTRAINT FK_ShippingInfo_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- -------------------------------------------------------------
-- Supporting indexes
-- -------------------------------------------------------------
CREATE INDEX IX_Products_Category  ON Products(CategoryID);
CREATE INDEX IX_Products_Supplier  ON Products(SupplierID);
CREATE INDEX IX_Orders_Customer    ON Orders(CustomerID);
CREATE INDEX IX_OrderItems_Order   ON "Order Items"(OrderID);
CREATE INDEX IX_OrderItems_Product ON "Order Items"(ProductID);
CREATE INDEX IX_Payments_Order     ON Payments(OrderID);
CREATE INDEX IX_Ship_Order         ON "Shipping Info"(OrderID);
