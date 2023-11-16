/*----------------------------------------------------------------------------------------Data cleaning using SQL Queries----------------------------------------------------------------------------------------------*/

Select *
From NashvilleHousing

Select SaleDate,Convert(Date,SaleDate)
From NashvilleHousing






update NashvilleHousing
set Saledateconverted=Convert(Date,SaleDate)


Alter table NashvilleHousing
Add Saledateconverted Date;


Select Saledateconverted,Convert(Date,SaleDate)
From NashvilleHousing


/*--------------------------------------------------------------------------------------Populate property address data----------------------------------------------------------------------------------------------------*/

Select PropertyAddress
From NashvilleHousing

Select PropertyAddress
From NashvilleHousing
Where PropertyAddress  is not null

Select PropertyAddress 
From NashvilleHousing
where PropertyAddress is null

Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select *
From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



Update a
Set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


/*----------------------------------------------------------------------------------Breaking out Address into individual columns(Address,city,state)-------------------------------------------------------------------------------------------*/

Select PropertyAddress
From NashvilleHousing

Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,len(PropertyAddress)) as address
From NashvilleHousing  


Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,len(PropertyAddress))

Select *
From NashvilleHousing


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing


Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From NashvilleHousing


/*-------------------------------------------------------------------------Change Y and N to Yes and No in "Sold as Vacant" field----------------------------------------------------------------------------------------*/

Select Distinct(SoldAsVacant),Count(SoldAsVacant) as count1
From NashvilleHousing
group by SoldAsVacant 
Order by count1


Select SoldAsVacant
, CASE when SoldAsVacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
		else SoldAsVacant
		end
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant=CASE when SoldAsVacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
		else SoldAsVacant
		end

/*---------------------------------------------------------------------------Remove Duplicates------------------------------------------------------------------------------------------------------------------------*/

With RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by UniqueID) row_num
From NashvilleHousing
)
Select *
From RownumCTE
where row_num>1
order by PropertyAddress

--Delete 
--From RowNumCTE
--where row_num>1


/*--------------------------------------------------------------------------------------------Delete Unused Columns------------------------------------------------------------------*/

Select *
From NashvilleHousing

Alter table NashvilleHousing
Drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter table NashvilleHousing
Drop column SaleDate