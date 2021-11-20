--Let's start by viewing all of our data
SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing

--Standardising the Date Format from a String Format:

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