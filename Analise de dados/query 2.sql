SELECT TOP 3
    p.Name AS ProductName,
    p.DaysToManufacture,
    SUM(d.OrderQty) AS TotalSold
FROM curated.SalesOrderDetail d
INNER JOIN curated.SpecialOfferProduct sop
    ON d.ProductID = sop.ProductID
INNER JOIN curated.Product p
    ON d.ProductID = p.ProductID
GROUP BY 
    p.Name,
    p.DaysToManufacture
ORDER BY 
    SUM(d.OrderQty) DESC;
