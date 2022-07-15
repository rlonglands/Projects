SELECT
 A.[BusinessEntityID]
 ,A.[PersonType]
 ,[Full Name] = 
		CASE
		WHEN A.MiddleName IS NULL THEN A.FirstName + ' ' + A.LastName
		ELSE A.FirstName + ' ' + A.MiddleName + ' ' + A.LastName
		END
 
,[Address] = C.AddressLine1
,C.City
,C.PostalCode
,[State] = D.[Name]
,[Country] = E.[Name]

FROM [Person].[Person] A
LEFT JOIN [Person].[BusinessEntityAddress] B 
ON A.[BusinessEntityID] = B.[BusinessEntityID]
LEFT JOIN [Person].[Address] C
ON B.[AddressID] = C.[AddressID]
LEFT JOIN [Person].[StateProvince] D
ON C.[StateProvinceID] = D.[StateProvinceID]
LEFT JOIN [Person].[CountryRegion] E
ON D.[CountryRegionCode] = E.[CountryRegionCode]

WHERE A.PersonType = 'SP'
OR (C.PostalCode LIKE '9%' AND LEN(C.PostalCode) = 5 AND E.[Name] = 'United States')


