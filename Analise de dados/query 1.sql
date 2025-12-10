SELECT 
    SalesOrderID,
    COUNT(*) AS DetailLines
FROM curated.SalesOrderDetail
GROUP BY SalesOrderID
HAVING COUNT(*) >= 3;
