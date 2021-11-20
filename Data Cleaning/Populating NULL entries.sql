--Populate Property Address Date:

-- We will look at populating null addresses by using the parcelID as our dependent
--field to the unspecified address, ie. if 2 ParcelIDs are equal, then we will make 
--their addresses equal

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS null
--Using the UniqueID to find ParcelIDs that are the same

--Note: Using a self-join, where a and b both refer to dbo.NashvilleHousing

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS null

-- We now have no Property addresses that are unpopulated

--Remark: ISNULL takes 2 parameters: 
--	1. In what column will the query look for NULL values?
--	2. What should the query replace the NULL values with?
--Here, those NULL values were replaced with non-NULL entries from Property Addresses from the same table
--via the self-join, using the ParcelID as the primary and relational key.