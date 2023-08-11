-- Data Cleaing using SQL

select *
from PortfolioProject.dbo.[Nashville Housing]


-- Standardize to Date Format
select SaleDate
from PortfolioProject.dbo.[Nashville Housing]

select SaleDate, convert(date, SaleDate) as SaleDateConverted
from PortfolioProject.dbo.[Nashville Housing]

--update method
Update [Nashville Housing]
set SaleDate = CONVERT(date, SaleDate)

-- to check if it worked
select SaleDateConverted, convert(date, saledate)
from PortfolioProject.dbo.[Nashville Housing]

-- If it doesn't work
-- alter table
alter table [nashville housing]
add SaleDateConverted Date

Update [Nashville Housing]
set SaleDateConverted = CONVERT(date, SaleDate)


--populate property Adress data
select *
from PortfolioProject.dbo.[Nashville Housing]
--where PropertyAddress is null
order by ParcelID


select a.parcelid, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..[Nashville Housing] a
join PortfolioProject..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a 
set propertyAddress = ISNULL(a.propertyaddress, b.propertyaddress)
from PortfolioProject..[Nashville Housing] a
join PortfolioProject..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




-- Breaking out Address into individual columns (address, city, state)
-- unsing substring
-- charindex  --> searching for specific value
-- -1 to get rid of integer values
-- +1 removed ,

select 
Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
--CHARINDEX(',',PropertyAddress) 
from PortfolioProject.dbo.[Nashville Housing]


select 
Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
Substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, 
LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.[Nashville Housing]


alter table [Nashville Housing]
add propertyNewAdd nvarchar(255);

update [Nashville Housing]
set propertyNewAdd = Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table [Nashville Housing]
add propertyNewCity nvarchar(255)

update [Nashville Housing]
set propertyNewCity = substring(propertyAddress, charindex(',',propertyaddress) +1, len(propertyaddress))



-- separating Owner's Address
select * 
from PortfolioProject..[Nashville Housing]


select OwnerAddress
from PortfolioProject..[Nashville Housing]

-- parsename used for periods
select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.[Nashville Housing]



-- change Y and N to Yes and No in "sold as Vacant" field
select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..[Nashville Housing]
group by SoldAsVacant
order by 2

select soldasvacant, 
case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else SoldasVacant
END
from PortfolioProject..[Nashville Housing]


update [Nashville Housing]
set SoldAsVacant = case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else SoldasVacant
END

select *
from PortfolioProject..[Nashville Housing]

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..[Nashville Housing]
group by SoldAsVacant
order by 2



-- Remove Duplicates
-- cte
with RowNumCTE as(
select *, 
	row_number() over
	(
	partition by parcelid, 
				 propertyAddress, 
				 saleprice,
				 saledate,
				 legalReference
		order by uniqueid
	)row_num
from PortfolioProject.dbo.[Nashville Housing]
--order by ParcelID
)
--select *
delete
--from PortfolioProject.dbo.[Nashville Housing]
from RowNumCTE
where row_num > 1
--order by PropertyAddress

----------------------------------

--Delete United Columns 
---- DON'T USE IT BEFORE ASKING
select *
from PortfolioProject.dbo.[Nashville Housing]

Alter table PortfolioProject.dbo.[Nashville Housing]
drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table PortfolioProject.dbo.[Nashville Housing]
drop column SaleDate













