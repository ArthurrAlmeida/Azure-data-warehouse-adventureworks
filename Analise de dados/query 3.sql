SELECT
    d.ProductID,
    h.OrderDate,
    SUM(d.OrderQty) AS TotalQuantity
FROM curated.SalesOrderDetail d
INNER JOIN curated.SalesOrderHeader h
    ON d.SalesOrderID = h.SalesOrderID
GROUP BY
    d.ProductID,
    h.OrderDate
ORDER BY
    h.OrderDate,
    d.ProductID;
