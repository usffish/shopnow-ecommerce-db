-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 6: Analytics Queries, DML Operations & Transaction
-- Run AFTER 02_oltp_seed_data.sql
-- =============================================================

-- -------------------------------------------------------------
-- 6.1  Sales by Category  (JOIN + GROUP BY)
-- -------------------------------------------------------------
SELECT
  cat.Name                              AS Category,
  SUM(oi.Quantity * p.UnitPrice)        AS GrossSales
FROM "Order Items" oi
JOIN Products   p   ON p.ProductID   = oi.ProductID
JOIN Categories cat ON cat.CategoryID = p.CategoryID
JOIN Orders     o   ON o.OrderID     = oi.OrderID
GROUP BY cat.Name
ORDER BY GrossSales DESC;

-- -------------------------------------------------------------
-- 6.2  Top Customers by Spend
-- -------------------------------------------------------------
SELECT
  c.Name            AS Customer,
  SUM(o.TotalPrice) AS TotalSpent,
  COUNT(*)          AS OrdersCount
FROM Orders    o
JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.Name
ORDER BY TotalSpent DESC;

-- -------------------------------------------------------------
-- 6.3  Low Inventory Alert  (products with < 100 units)
-- -------------------------------------------------------------
SELECT
  p.Description,
  c.Name  AS Category,
  p.Inventory
FROM Products   p
JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE p.Inventory < 100
ORDER BY p.Inventory ASC;

-- -------------------------------------------------------------
-- 6.4  UPDATE: auto-advance to SHIPPED (2) when tracking
--      exists and order was already PAID (1)
-- -------------------------------------------------------------
UPDATE Orders o
SET    o.Status = 2
WHERE  o.Status = 1
  AND  EXISTS (
         SELECT 1
         FROM   "Shipping Info" s
         WHERE  s.OrderID = o.OrderID
           AND  s."Tracking Number" IS NOT NULL
       );
COMMIT;

-- -------------------------------------------------------------
-- 6.5  DELETE: remove FAILED payment attempts when a
--      successful payment exists for the same order
-- -------------------------------------------------------------
DELETE FROM Payments p_failed
WHERE  p_failed.PaymentStatus = 0
  AND  EXISTS (
         SELECT 1
         FROM   Payments p_ok
         WHERE  p_ok.OrderID       = p_failed.OrderID
           AND  p_ok.PaymentStatus = 1
       );
COMMIT;

-- -------------------------------------------------------------
-- 6.6  TRANSACTION: new order + items + payment + shipping
--      Uses COMMIT / ROLLBACK to guarantee atomicity
-- -------------------------------------------------------------
DECLARE
  v_order_id NUMBER;
BEGIN
  -- 1) Create order (NEW = 0; temp total 0)
  INSERT INTO Orders (CustomerID, OrderDate, Status, TotalPrice)
    VALUES (
      (SELECT CustomerID FROM Customers WHERE Email = 'ava@example.com'),
      SYSDATE, 0, 0
    )
  RETURNING OrderID INTO v_order_id;

  -- 2) Add line items
  INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
    VALUES (v_order_id, (SELECT ProductID FROM Products WHERE Description = 'Novel: Distant Stars'), 2);
  INSERT INTO "Order Items" (OrderID, ProductID, Quantity)
    VALUES (v_order_id, (SELECT ProductID FROM Products WHERE Description = 'Coffee Maker'), 1);

  -- 3) Compute total and mark PAID (1)
  UPDATE Orders o
  SET    o.TotalPrice = (
           SELECT SUM(oi.Quantity * p.UnitPrice)
           FROM   "Order Items" oi
           JOIN   Products p ON p.ProductID = oi.ProductID
           WHERE  oi.OrderID = v_order_id
         ),
         o.Status = 1
  WHERE  o.OrderID = v_order_id;

  -- 4) Record payment
  INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount, PaymentStatus)
    VALUES (
      v_order_id, SYSDATE, 1,
      (SELECT TotalPrice FROM Orders WHERE OrderID = v_order_id),
      1
    );

  -- 5) Create shipping record
  INSERT INTO "Shipping Info" (OrderID, Address, "Tracking Number")
    VALUES (v_order_id, '12 Oak St, Tampa, FL', 'TRK-NEW-001');

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END;
/

-- Verify the new order (created today)
SELECT o.OrderID, c.Name AS Customer, o.TotalPrice, o.Status, o.OrderDate
FROM   Orders    o
JOIN   Customers c ON c.CustomerID = o.CustomerID
WHERE  TRUNC(o.OrderDate) = TRUNC(SYSDATE)
ORDER  BY o.OrderID DESC;
