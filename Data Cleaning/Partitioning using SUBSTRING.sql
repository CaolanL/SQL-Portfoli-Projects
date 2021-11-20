--Breaking up the Address into Individual Comlumns (Street, City, State):

SELECT PropertyAddress
FROM dbo.NashvilleHousing

--Note: the delimiter here will be the comma between street name and city

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM dbo.NashvilleHousing

--Note: The '-1' in the SUBSTRING's 3rd parameter removes the comma from the street name
--by starting at the first entry of the string in 'PropertyAddress' and continuing until there is
--a comma in the substring, then subtracting 1 from that index of the substring.

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