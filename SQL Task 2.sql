SELECT
OrderID = A.SalesOrderID,
OrderDetailID = A.SalesOrderDetailID,
A.OrderQty,
A.UnitPrice,
A.LineTotal,
B.OrderDate,
[OrderSizeCategory] = 
	CASE
	WHEN A.OrderQty > 500 THEN 'Large'
	WHEN A.OrderQty BETWEEN 50 AND 500 THEN 'Medium'
	ELSE 'Small'
	END,

C.[Name] AS [ProductName],
[Subcategory] = ISNULL(D.[Name], 'None'),
[Category] = ISNULL(E.[Name], 'None'),
[Order Type] = 'Sale'


FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Sales].[SalesOrderHeader] B
ON A.SalesOrderID = B.SalesOrderID
LEFT JOIN [Production].[Product] C
ON A.[ProductID] = C.[ProductID]
LEFT JOIN [Production].[Product] F
On A.[ProductID] = F.[ProductID]
LEFT JOIN [Production].[ProductSubcategory] D
ON F.[ProductSubcategoryID] = D.[ProductSubcategoryID]
LEFT JOIN [Production].[ProductCategory] E
ON D.[ProductCategoryID] = E.[ProductCategoryID]

WHERE MONTH(B.OrderDate) = 12

UNION

SELECT
OrderID = A.PurchaseOrderID,
OrderDetailID = A.PurchaseOrderDetailID,
A.OrderQty,
A.UnitPrice,
A.LineTotal,
B.OrderDate,
[OrderSizeCategory] = 
	CASE
	WHEN A.OrderQty > 500 THEN 'Large'
	WHEN A.OrderQty BETWEEN 50 AND 500 THEN 'Medium'
	ELSE 'Small'
	END,

C.[Name] AS [ProductName],
[Subcategory] = ISNULL(D.[Name], 'None'),
[Category] = ISNULL(E.[Name], 'None'),
[Order Type] = 'Purchase'


FROM [Purchasing].[PurchaseOrderDetail] A
LEFT JOIN [Purchasing].[PurchaseOrderHeader] B
ON A.PurchaseOrderID = B.PurchaseOrderID
LEFT JOIN [Production].[Product] C
ON A.[ProductID] = C.[ProductID]
LEFT JOIN [Production].[Product] F
On A.[ProductID] = F.[ProductID]
LEFT JOIN [Production].[ProductSubcategory] D
ON F.[ProductSubcategoryID] = D.[ProductSubcategoryID]
LEFT JOIN [Production].[ProductCategory] E
ON D.[ProductCategoryID] = E.[ProductCategoryID]

WHERE MONTH(B.OrderDate) = 12

ORDER BY 6 DESC
