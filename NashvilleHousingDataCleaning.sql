SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

--Standardised Date Format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM [Portfolio Project]..NashvilleHousing

UPDATE [Portfolio Project]..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

SELECT SaleDate
FROM [Portfolio Project]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDate,SaleDateConverted
FROM dbo.NashvilleHousing

--Populate Property Address Date

SELECT *
FROM dbo.NashvilleHousing
--WHERE PropertyAddress IS null
ORDER BY ParcelID
-- We will look at populating null addresses by using the parcelID as our dependent
--column to the unspecified address, ie. if 2 ParcelIDs are equal, then we will make 
--their addresses equal

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS null
--Using the UniqueID to find ParcelIDs that are the same

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS null

-- We now have no Property addresses that are unpopulated

--Remark: ISNULL takes 2 parameters: 1. What column will the query look for NULL values?
--	2. What should the query replace the NULL values with?
--Here, those NULL values were replaced with non-NULL entries from Property Addresses from the same table
--via the self-join, using the ParcelID as the primary and relational key.


--Breaking up the Address into Individual Comlumns (Street, City, State)

SELECT PropertyAddress
FROM dbo.NashvilleHousing
--Note: the delimiter here is the comma between street name and city

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address


FROM dbo.NashvilleHousing
--Note: The '-1' in the SUBSTRING's 3rd parameter removes the comma from the street name
--by starting at the first entry of the string in 'PropertyAddress' and continueing until there is
--a comma in the substring, then subtracting 1 from that index of the substring

ALTER TABLE NashvilleHousing
ADD PropertyStreetNameSplit nvarchar(255)

UPDATE dbo.NashvilleHousing
SET PropertyStreetNameSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertyCitySplit nvarchar(255)

UPDATE dbo.NashvilleHousing
SET PropertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

--Result: 2 new columns are added to the table with entries being street name and city name,
--rather than both entries being in one column separated by a comma.
--This makes the data far more investigative and explorable.

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerStreetNameSplit nvarchar(255)

ALTER TABLE NashvilleHousing
ADD OwnerCitySplit nvarchar(255)

ALTER TABLE NashvilleHousing
ADD OwnerStateSplit nvarchar(255)

UPDATE dbo.NashvilleHousing
SET OwnerStreetNameSplit = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

UPDATE dbo.NashvilleHousing
SET OwnerCitySplit = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

UPDATE dbo.NashvilleHousing
SET OwnerStateSplit = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--Making the "Sold as Vacant" Column Entries Uniform

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2
--Let's replace Y and N with Yes and No

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END


-- Removing Duplicates

WITH RowNumCTE AS(
SELECT * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 Saledate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM dbo.NashvilleHousing
--ORDER BY ParcelID
)
--SELECT *
--FROM RowNumCTE
--WHERE row_num > 1
--ORDER BY PropertyAddress

DELETE
FROM RowNumCTE
WHERE row_num > 1

--In Practice, deleting raw data isn't reasonable as once deleted, it cannot be returned
--However here is a simple method of removing duplicates in case the duplication was
--done unintentionally


--Deleting Unused Columns

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN TaxDistrict, SaleDate
