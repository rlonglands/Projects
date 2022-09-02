--Data Cleaning in SQL server using Nashville Housing Data--

--view data--

SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [dbo].[NashvilleHousing];

  -----------------------------------------------------------------------------------------------------------------------------------

  --change date format--


  ALTER TABLE [dbo].[NashvilleHousing]
  ADD SaleDateConv date;

UPDATE NashvilleHousing
  SET [SaleDateConv] = CONVERT (Date,[SaleDate])

  SELECT [SaleDateConv], CONVERT (Date,[SaleDate]) 
  FROM [dbo].[NashvilleHousing]

---------------------------------------------------------------------------------------------------------------------------------------
 
 -- replace null values in property address column--

  SELECT *
  FROM [dbo].[NashvilleHousing]
  WHERE [PropertyAddress] is NULL


  
  SELECT a.[ParcelID]
		,b.[ParcelID]
		,a.[PropertyAddress]
		,b.[PropertyAddress]
		,ISNULL(a.[PropertyAddress], b.[PropertyAddress])
  FROM [NashvilleHousing] a
  JOIN [NashvilleHousing]b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  WHERE a.[PropertyAddress] is NULL

  

  UPDATE a
  SET PropertyAddress = ISNULL(a.[PropertyAddress], b.[PropertyAddress])
  FROM [NashvilleHousing] a
  JOIN [NashvilleHousing]b
  ON a.ParcelID = b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  WHERE a.[PropertyAddress] is NULL;

-------------------------------------------------------------------------------------------------------------------
  -- split PropertyAddress into separate columns for Address and City --

  SELECT 
  Address = SUBSTRING ([PropertyAddress], 1, CHARINDEX(',',[PropertyAddress])-1),
  City = SUBSTRING ([PropertyAddress], CHARINDEX(',',[PropertyAddress]) +1, LEN([PropertyAddress]))

  FROM [dbo].[NashvilleHousing];


 ALTER TABLE[NashvilleHousing]
 ADD PropertyAddressLine1 NVARCHAR(255);

 UPDATE [NashvilleHousing]
 SET PropertyAddressLine1 = SUBSTRING ([PropertyAddress], 1, CHARINDEX(',',[PropertyAddress])-1);


 ALTER TABLE[NashvilleHousing]
 ADD PropertyCity NVARCHAR(255);

 UPDATE [NashvilleHousing]
 SET PropertyCity = SUBSTRING ([PropertyAddress], CHARINDEX(',',[PropertyAddress]) +1, LEN([PropertyAddress]));


 -------------------------------------------------------------------------------------------------------------------------

 -- split OwnerAddress into separate columns for Address, City and State --

 SELECT
 OwnerAddress1 = PARSENAME (REPLACE([OwnerAddress], ',', '.'), 3)
 ,OwnerCity = PARSENAME (REPLACE([OwnerAddress], ',', '.'), 2)
 ,OwnerState = PARSENAME (REPLACE([OwnerAddress], ',', '.'), 1)
 FROM [dbo].[NashvilleHousing];


 ALTER TABLE[NashvilleHousing]
 ADD OwnerAddress1 NVARCHAR(255);

 UPDATE [NashvilleHousing]
 SET OwnerAddress1 = PARSENAME (REPLACE([OwnerAddress], ',', '.'), 3);


 ALTER TABLE[NashvilleHousing]
 ADD OwnerCity NVARCHAR(255);

 UPDATE [NashvilleHousing]
 SET OwnerCity = PARSENAME (REPLACE([OwnerAddress], ',', '.'), 2);

 
 ALTER TABLE[NashvilleHousing]
 ADD OwnerState NVARCHAR(255);

 UPDATE [NashvilleHousing]
 SET OwnerState = PARSENAME (REPLACE([OwnerAddress], ',', '.'), 1);

 --------------------------------------------------------------------------------------------------------------------------------

 --Change Y and N to Yes and No in SoldAsVacant column --

 SELECT DISTINCT [SoldAsVacant]
 ,COUNT([SoldAsVacant])
 FROM [dbo].[NashvilleHousing]
 Group by [SoldAsVacant]
 Order by 2;


 SELECT [SoldAsVacant]
 ,CASE WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
      WHEN [SoldAsVacant] = 'N' THEN 'No'
	  ELSE [SoldAsVacant]
	  END
 
 FROM [dbo].[NashvilleHousing];

 UPDATE NashvilleHousing
 SET [SoldAsVacant] =  CASE WHEN [SoldAsVacant] = 'Y' THEN 'Yes'
                            WHEN [SoldAsVacant] = 'N' THEN 'No'
	                        ELSE [SoldAsVacant]
	                        END
FROM [dbo].[NashvilleHousing];

------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates --

WITH RowNumCTE AS(
SELECT *,
		ROW_NUMBER () OVER(
		PARTITION BY [ParcelID]
		             ,[PropertyAddress]
					 ,[SalePrice]
					 ,[SaleDate]
					 ,[LegalReference]
					 ORDER BY [UniqueID ] ) row_num

FROM [dbo].[NashvilleHousing])

DELETE
FROM RowNumCTE
WHERE row_num > 1

-----------------------------------------------------------------------------------------------------------------------------

--delete unused columns --

ALTER TABLE [NashvilleHousing]
DROP COLUMN [PropertyAddress]
            ,[OwnerAddress]
			,[SaleDate]


SELECT * FROM [NashvilleHousing]