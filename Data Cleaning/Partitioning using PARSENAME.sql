--Partitioning OwnerAddress into Street Name and City

--Let's do the same for OwnerAddress as we did for PropertyAddress, but with a new method:

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM dbo.NashvilleHousing

--Remark: PARSENAME is an efficient alternative to SUBSTRING, but requires periods to partition the string, therefore we replaced 
--the commas with periods. 
--Note: PARSENAME uses a descending index.

--Altering our table using this result:

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

SELECT * FROM dbo.NashvilleHousing

--Note: Some Owner Addresses at the beginning have NULL entries