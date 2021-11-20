-- Removing Duplicates:

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

--Deleting Unused Columns:

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN TaxDistrict, SaleDate

--Remark: In Practice, deleting raw data isn't reasonable as once deleted, it cannot be returned.
--However here is a simple method of removing duplicates and discarding columns in case the action was
--done so unintentionally
