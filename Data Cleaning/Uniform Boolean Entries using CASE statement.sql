--Making the "Sold as Vacant" Column Entries Uniform:
--(Entries include 'Yes', 'No', 'Y' and 'N')

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2
--Let's replace Y and N with Yes and No:

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