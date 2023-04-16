
--cleaning data using queries--

Select *
From Portfolio1.dbo.housing

--Standardize SaleDate



Select saleDateConverted, CONVERT(Date,SaleDate)
From Portfolio1.dbo.housing


Update housing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE housing
Add SaleDateConverted Date;

Update housing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--populating proprtyaddress--

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio1.dbo.housing a
JOIN Portfolio1.dbo.housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio1.dbo.housing a
JOIN Portfolio1.dbo.housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--Breaking down the address--
Select PropertyAddress
From Portfolio1.dbo.housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Portfolio1.dbo.housing


ALTER TABLE housing
Add PropertySplitAddress Nvarchar(255);

Update housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing
Add PropertySplitCity Nvarchar(255);

Update housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Portfolio1.dbo.housing



--Splitting ownerAddress--

Select OwnerAddress
From Portfolio1.dbo.housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolio1.dbo.housing



ALTER TABLE housing
Add OwnerSplitAddress Nvarchar(255);

Update housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housing
Add OwnerSplitCity Nvarchar(255);

Update housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housing
Add OwnerSplitState Nvarchar(255);

Update housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio1.dbo.housing

--Changing Y into Yes and N into No in SoldASVacant--


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio1.dbo.housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio1.dbo.housing


Update housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


Select *
From Portfolio1.dbo.housing

--Removing Duplicates--

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio1.dbo.housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Portfolio1.dbo.housing

--Deleting unused columns--

Select *
From Portfolio1.dbo.housing


ALTER TABLE Portfolio1.dbo.housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,

ALTER TABLE Portfolio1.dbo.housing
DROP COLUMN SaleDate






