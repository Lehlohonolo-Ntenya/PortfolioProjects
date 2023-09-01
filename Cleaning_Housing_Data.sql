Select * 
From
PortfolioProject.dbo.NashvilleHousing

--------------------------STANDARDISE THE SALEDATE---------------------------


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


Select SaleDateConverted, CONVERT(Date,SaleDate)
From
PortfolioProject.dbo.NashvilleHousing


-------------------------------POPULATE THE PROPERTY ADDRESS------------------------------
Select *
From
PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select d1.ParcelID, d1.PropertyAddress, d2.ParcelID, d2.PropertyAddress,ISNULL(d1.PropertyAddress, d2.PropertyAddress)
From
PortfolioProject.dbo.NashvilleHousing d1
Join PortfolioProject.dbo.NashvilleHousing d2
On d1.ParcelID = d2.ParcelID
And d1.[UniqueID ] <> d2.[UniqueID ]
Where d1.PropertyAddress is null

Update d1
Set PropertyAddress = ISNULL(d1.PropertyAddress, d2.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing d1
Join PortfolioProject.dbo.NashvilleHousing d2
On d1.ParcelID = d2.ParcelID
And d1.[UniqueID ] <> d2.[UniqueID ]


--------------------------BREAKING THE ADDRESS INTO DIFFERENT COLUMNS--------------------------------

--Breaking the PropertyAddress into different Columns ( Address, City)

Select PropertyAddress
From
PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertyAddressSplitAddress NVARCHAR(255)

Update NashvilleHousing
SET PropertyAddressSplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertyAddressSplitCity NVARCHAR(255)

Update NashvilleHousing
SET PropertyAddressSplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))



--Breaking the OwnerAddress into different Columns ( Address, City, State)

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From
PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerAddressSplitAddress NVARCHAR(255)

Update NashvilleHousing
SET OwnerAddressSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add OwnerAddressSplitCity NVARCHAR(255)

Update NashvilleHousing
SET OwnerAddressSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerAddressSplitState NVARCHAR(255)

Update NashvilleHousing
SET OwnerAddressSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-------------------------------------CHANGE Y AND N TO YES AND NO------------------------------------------------


Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End



-----------------------------------REMOVE DUPLICATES-------------------------------------
WITH RowNumCTE as(
Select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order by UniqueID) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

DELETE 
From RowNumCTE
Where row_num > 1


---------------------DELETE UNUSED COLUMNS---------------------------------
Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,OnwerAddressSplitCity, OwerAddressSplitCity, SaleDate

