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
,[Job Title] = ISNULL(F.[JobTitle], 'None')
,[Job Category] =
	CASE
	WHEN F.[JobTitle] LIKE '%Manager%' OR F.[JobTitle] LIKE '%President%' OR F.[JobTitle] LIKE '%Executive%' THEN 'Management'
	WHEN F.[JobTitle] LIKE '%Engineer%' THEN 'Engineering'
	WHEN F.[JobTitle] LIKE '%Production%' THEN 'Production'
	WHEN F.[JobTitle] LIKE '%Marketing%' THEN 'Marketing'
	WHEN F.[JobTitle] IS NULL THEN 'NA'
	WHEN F.[JobTitle] IN ('Human Resources Administrative Assistant', 'Benefits Specialist','Recruiter') THEN 'Human Resources'
	ELSE 'Other'
	END


FROM [Person].[Person] A
LEFT JOIN [Person].[BusinessEntityAddress] B 
ON A.[BusinessEntityID] = B.[BusinessEntityID]
LEFT JOIN [Person].[Address] C
ON B.[AddressID] = C.[AddressID]
LEFT JOIN [Person].[StateProvince] D
ON C.[StateProvinceID] = D.[StateProvinceID]
LEFT JOIN [Person].[CountryRegion] E
ON D.[CountryRegionCode] = E.[CountryRegionCode]
LEFT JOIN [HumanResources].[Employee] F
ON A.BusinessEntityID = F.BusinessEntityID

WHERE A.PersonType = 'SP'
OR (C.PostalCode LIKE '9%' AND LEN(C.PostalCode) = 5 AND E.[Name] = 'United States')


