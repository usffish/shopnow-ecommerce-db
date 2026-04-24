-- =============================================================
-- ShopNow E-Commerce Database
-- Phase 7: Join Operations
-- Demonstrates INNER, LEFT, RIGHT, and FULL OUTER joins
-- =============================================================

-- -------------------------------------------------------------
-- INNER JOIN
-- Lists all products that have a supplier, with supplier email
-- -------------------------------------------------------------
SELECT
  p.ProductID,
  p.Description,
  s.Name  AS SupplierName,
  s.Email AS SupplierEmail
FROM Products  p
JOIN Suppliers s ON s.SupplierID = p.SupplierID
ORDER BY p.ProductID;

-- -------------------------------------------------------------
-- LEFT JOIN
-- All products and any orders associated with them
-- (includes products that have never been ordered)
-- -------------------------------------------------------------
SELECT
  p.ProductID,
  p.Description,
  o.OrderID,
  o.OrderDate
FROM Products p
LEFT JOIN "Order Items" oi ON oi.ProductID = p.ProductID
LEFT JOIN Orders        o  ON o.OrderID    = oi.OrderID
ORDER BY p.ProductID, o.OrderDate;

-- -------------------------------------------------------------
-- RIGHT JOIN
-- All customers and their orders
-- (includes customers who have placed no orders)
-- -------------------------------------------------------------
SELECT
  c.CustomerID,
  c.Name    AS CustomerName,
  o.OrderID,
  o.OrderDate
FROM Orders    o
RIGHT JOIN Customers c ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID, o.OrderDate;

-- -------------------------------------------------------------
-- FULL OUTER JOIN
-- All suppliers and all products regardless of relationship
-- (surfaces unmatched rows on both sides)
-- -------------------------------------------------------------
SELECT
  p.ProductID,
  p.Description,
  s.SupplierID,
  s.Name AS SupplierName
FROM Products  p
FULL OUTER JOIN Suppliers s ON s.SupplierID = p.SupplierID
ORDER BY p.ProductID NULLS LAST, s.SupplierID NULLS LAST;
