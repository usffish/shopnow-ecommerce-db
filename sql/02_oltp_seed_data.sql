-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 5: Sample Data (>=10 rows per table)
-- Run AFTER 01_oltp_schema.sql
-- =============================================================

SET DEFINE OFF;

-- -------------------------------------------------------------
-- CATEGORIES (10)
-- -------------------------------------------------------------
INSERT INTO Categories (Name, Description) VALUES ('Electronics', 'Phones, laptops, accessories');
INSERT INTO Categories (Name, Description) VALUES ('Clothing',    'Apparel for men and women');
INSERT INTO Categories (Name, Description) VALUES ('Home',        'Home goods and decor');
INSERT INTO Categories (Name, Description) VALUES ('Books',       'Physical and digital books');
INSERT INTO Categories (Name, Description) VALUES ('Toys',        'Kids toys and games');
INSERT INTO Categories (Name, Description) VALUES ('Beauty',      'Cosmetics and skincare');
INSERT INTO Categories (Name, Description) VALUES ('Sports',      'Sports gear and apparel');
INSERT INTO Categories (Name, Description) VALUES ('Outdoors',    'Camping and hiking');
INSERT INTO Categories (Name, Description) VALUES ('Office',      'Office supplies');
INSERT INTO Categories (Name, Description) VALUES ('Pets',        'Pet supplies');

-- -------------------------------------------------------------
-- SUPPLIERS (10)
-- -------------------------------------------------------------
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Acme Supply',    'contact@acme.com',    '555-1000', '101 Supply Way');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Zenith Traders', 'sales@zenith.com',    '555-1001', '202 Market St');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('BlueRiver Co',   'hello@blueriver.com', '555-1002', '303 River Rd');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Nova Wholesale', 'team@nova.com',       '555-1003', '404 Galaxy Ave');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Praxis Goods',   'support@praxis.com',  '555-1004', '505 Praxis Blvd');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Marlin Imports', 'info@marlin.com',     '555-1005', '606 Harbor Ln');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Pioneer Group',  'contact@pioneer.com', '555-1006', '707 Trail Rd');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Atlas Partners', 'ops@atlas.com',       '555-1007', '808 Summit Dr');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Nimbus Ltd',     'admin@nimbus.com',    '555-1008', '909 Cloud Ct');
INSERT INTO Suppliers (Name, Email, PhoneNumber, SupplierAddress) VALUES ('Cedar Corp',     'hello@cedar.com',     '555-1009', '111 Forest Ave');

-- -------------------------------------------------------------
-- CUSTOMERS (10)
-- Gender: 1=Male, 2=Female
-- -------------------------------------------------------------
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Ava Johnson',  'ava@example.com',   '555-2000', 28, 1);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Ben Carter',   'ben@example.com',   '555-2001', 35, 1);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Chloe Nguyen', 'chloe@example.com', '555-2002', 31, 2);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Diego Perez',  'diego@example.com', '555-2003', 42, 1);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Ella Smith',   'ella@example.com',  '555-2004', 26, 2);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Felix Kim',    'felix@example.com', '555-2005', 39, 1);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Grace Lee',    'grace@example.com', '555-2006', 33, 2);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Henry Patel',  'henry@example.com', '555-2007', 29, 1);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Isla Brown',   'isla@example.com',  '555-2008', 24, 2);
INSERT INTO Customers (Name, Email, PhoneNumber, Age, Gender) VALUES ('Jack Wilson',  'jack@example.com',  '555-2009', 45, 1);

-- -------------------------------------------------------------
-- PRODUCTS (10)
-- CategoryID and SupplierID resolved via subquery
-- -------------------------------------------------------------
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Smartphone A',        (SELECT CategoryID FROM Categories WHERE Name='Electronics'),  699.99,  100, (SELECT SupplierID FROM Suppliers WHERE Name='Acme Supply'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Laptop B',            (SELECT CategoryID FROM Categories WHERE Name='Electronics'), 1199.00,   50, (SELECT SupplierID FROM Suppliers WHERE Name='Zenith Traders'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Wireless Earbuds',    (SELECT CategoryID FROM Categories WHERE Name='Electronics'),  129.00,  200, (SELECT SupplierID FROM Suppliers WHERE Name='Nova Wholesale'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Coffee Maker',        (SELECT CategoryID FROM Categories WHERE Name='Home'),          89.99,  150, (SELECT SupplierID FROM Suppliers WHERE Name='BlueRiver Co'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Desk Chair',          (SELECT CategoryID FROM Categories WHERE Name='Office'),       179.99,   80, (SELECT SupplierID FROM Suppliers WHERE Name='Praxis Goods'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Running Shoes',       (SELECT CategoryID FROM Categories WHERE Name='Sports'),        99.99,  120, (SELECT SupplierID FROM Suppliers WHERE Name='Pioneer Group'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Hiking Backpack',     (SELECT CategoryID FROM Categories WHERE Name='Outdoors'),     129.99,   70, (SELECT SupplierID FROM Suppliers WHERE Name='Atlas Partners'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Novel: Distant Stars',(SELECT CategoryID FROM Categories WHERE Name='Books'),         19.99,  300, (SELECT SupplierID FROM Suppliers WHERE Name='Nimbus Ltd'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('Cat Litter 20lb',     (SELECT CategoryID FROM Categories WHERE Name='Pets'),          16.49,  180, (SELECT SupplierID FROM Suppliers WHERE Name='Cedar Corp'));
INSERT INTO Products (Description, CategoryID, UnitPrice, Inventory, SupplierID)
  VALUES ('T-Shirt (Unisex)',    (SELECT CategoryID FROM Categories WHERE Name='Clothing'),      14.99,  400, (SELECT SupplierID FROM Suppliers WHERE Name='Marlin Imports'));

-- -------------------------------------------------------------
-- ORDERS (10)
-- Status: 0=NEW, 1=PAID, 2=SHIPPED, 3=DELIVERED, 4=CANCELLED
-- -------------------------------------------------------------
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='ava@example.com'),   DATE '2025-10-01', 1,  829.98);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='ben@example.com'),   DATE '2025-10-02', 1,  129.00);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='chloe@example.com'), DATE '2025-10-03', 2,  209.98);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='diego@example.com'), DATE '2025-10-04', 3,   99.99);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='ella@example.com'),  DATE '2025-10-05', 1, 1199.00);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='felix@example.com'), DATE '2025-10-06', 1,  149.98);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='grace@example.com'), DATE '2025-10-07', 0,   19.99);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='henry@example.com'), DATE '2025-10-08', 2,  146.48);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='isla@example.com'),  DATE '2025-10-09', 1,  179.99);
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
  VALUES ((SELECT CustomerID FROM Customers WHERE Email='jack@example.com'),  DATE '2025-10-10', 4,   14.99);

-- -------------------------------------------------------------
-- ORDER ITEMS (~18 rows)
-- -------------------------------------------------------------
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ava@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Smartphone A'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ava@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Wireless Earbuds'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ben@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Wireless Earbuds'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='chloe@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Coffee Maker'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='chloe@example.com'),
          (SELECT ProductID FROM Products WHERE Description='T-Shirt (Unisex)'), 2);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='diego@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Running Shoes'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ella@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Laptop B'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='felix@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Desk Chair'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='felix@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Cat Litter 20lb'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='grace@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Novel: Distant Stars'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='henry@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Hiking Backpack'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='henry@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Coffee Maker'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='isla@example.com'),
          (SELECT ProductID FROM Products WHERE Description='Desk Chair'), 1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity) VALUES (2, (SELECT ProductID FROM Products WHERE Description='Coffee Maker'),      1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity) VALUES (3, (SELECT ProductID FROM Products WHERE Description='Cat Litter 20lb'),   1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity) VALUES (5, (SELECT ProductID FROM Products WHERE Description='Wireless Earbuds'),  1);
INSERT INTO "Order Items" (OrderID, ProductID, Quantity) VALUES (8, (SELECT ProductID FROM Products WHERE Description='Running Shoes'),     1);

-- -------------------------------------------------------------
-- PAYMENTS (Felix has one FAILED + one PAID)
-- PaymentMethod: 1=Credit Card, 2=Debit Card
-- PaymentStatus: 0=FAILED, 1=PAID
-- -------------------------------------------------------------
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ava@example.com'),   DATE '2025-10-01', 1,  829.98, 1);
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ben@example.com'),   DATE '2025-10-02', 2,  129.00, 1);
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='chloe@example.com'), DATE '2025-10-03', 1,  209.98, 1);
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='diego@example.com'), DATE '2025-10-04', 1,   99.99, 1);
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ella@example.com'),  DATE '2025-10-05', 1, 1199.00, 1);
-- Felix: FAILED attempt then successful retry
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='felix@example.com'), DATE '2025-10-06', 1,  149.98, 0);
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='felix@example.com'), DATE '2025-10-06', 1,  149.98, 1);
-- Grace: no payment (order status = NEW)
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='henry@example.com'), DATE '2025-10-08', 2,  146.48, 1);
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='isla@example.com'),  DATE '2025-10-09', 1,  179.99, 1);

-- -------------------------------------------------------------
-- SHIPPING INFO (10)
-- -------------------------------------------------------------
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ava@example.com'),   '12 Oak St, Tampa, FL',    'TRK-0001');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ben@example.com'),   '55 Pine Ave, Tampa, FL',  'TRK-0002');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='chloe@example.com'), '91 Lake Rd, Tampa, FL',   'TRK-0003');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='diego@example.com'), '23 River St, Tampa, FL',  'TRK-0004');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='ella@example.com'),  '7 Harbor Dr, Tampa, FL',  'TRK-0005');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='felix@example.com'), '44 Crest Ln, Tampa, FL',  'TRK-0006');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='grace@example.com'), '3 Willow Ct, Tampa, FL',  'TRK-0007');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='henry@example.com'), '81 Summit Rd, Tampa, FL', 'TRK-0008');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='isla@example.com'),  '16 Beach Ave, Tampa, FL', 'TRK-0009');
INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
  VALUES ((SELECT o.OrderID FROM Orders o JOIN Customers c ON c.CustomerID=o.CustomerID WHERE c.Email='jack@example.com'),  '9 Bay St, Tampa, FL',     'TRK-0010');

COMMIT;

-- Quick row-count verification
SELECT COUNT(*) AS num_categories FROM Categories;
SELECT COUNT(*) AS num_suppliers   FROM Suppliers;
SELECT COUNT(*) AS num_customers   FROM Customers;
SELECT COUNT(*) AS num_products    FROM Products;
SELECT COUNT(*) AS num_orders      FROM Orders;
SELECT COUNT(*) AS num_items       FROM "Order Items";
SELECT COUNT(*) AS num_payments    FROM Payments;
SELECT COUNT(*) AS num_ship        FROM "Shipping Info";
