SELECT
A.PurchaseOrderID,
A.PurchaseOrderDetailID,
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
[Category] = ISNULL(E.[Name], 'None')


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