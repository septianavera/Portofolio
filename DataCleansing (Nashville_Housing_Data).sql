/*

Topic : Data Cleansing using Nashville Housing Dataset

*/

--Creat table 
create table housing_data 
	(	UniqueID varchar,
		ParcelID varchar,
		LandUse varchar,
		PropertyAddress varchar,
		SaleDate timestamp,
		SalePrice money,
		LegalReference varchar(16),
		SoldAsVacant varchar(3),
		OwnerName varchar,
		OwnerAddress varchar,
		Acreage decimal,
		TaxDistrict varchar,
		LandValue money,
		BuildingValue money,
		TotalValue money,
		YearBuilt varchar(4),
		Bedrooms int,
		FullBath int,
		HalfBath int
	);
-- Have problem when import data because type of data is wrong, and then we can change the type of data
-- variabel with type of data are money change in varchar because there are mark "$" in variable salesprice
alter table housing_data alter column SalePrice type varchar using SalePrice::varchar;
alter table housing_data alter column LandValue type varchar using LandValue::varchar;
alter table housing_data alter column BuildingValue type varchar using BuildingValue::varchar;
alter table housing_data alter column TotalValue type varchar using TotalValue::varchar;
--variable LegalReference, there are length character more than 16 character
alter table housing_data alter column LegalReference type varchar using LegalReference::varchar;

--Next, doing import data 


--Select all column from table housing_data
select * from housing_data;


--Change standardize format saledate become date
select 
	saledate,
	date(saledate) as sale_date
from housing_data;

-- for add new column sale_date
alter table housing_data
add sale_date date;

-- and fill new column with sale_date
update housing_data
set sale_date = date(saledate);

--Fill property address is null (sumber penggunaan COALESCE FUNGTION : https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-coalesce/)
SELECT h.uniqueid, h.parcelid, COALESCE(h.propertyaddress, d.propertyaddress)
from housing_data h 
join housing_data d
on h.parcelid = d.parcelid
and h.uniqueid <> d.uniqueid
where h.propertyaddress is null;


--create a table view from the data shown above then download the table in csv format
create view propertyaddress_null as 
SELECT h.uniqueid, h.parcelid, COALESCE(h.propertyaddress, d.propertyaddress)
from housing_data h 
join housing_data d
on h.parcelid = d.parcelid
and h.uniqueid <> d.uniqueid
where h.propertyaddress is null;

-- create table from file csv format property addres_null and import table create a csv table with the name propertyaddress_null, then import the csv fileate table propertyadrress_null
		(
			uniqueid varchar,
			parcelid varchar,
			coalesce varchar
		);
		
		
--make commit and rollback transactions so that if something goes wrong, a rollback can be done
begin; 
update housing_data
set propertyaddress = propertyaddress_null.coalesce
from propertyaddress_null
where housing_data.uniqueid = propertyaddress_null.uniqueid and 
housing_data.parcelid = propertyaddress_null.parcelid;


--check for variable propertyadrres have null again or not?
select * from housing_data
-- where propertyaddress is null
-- order by salesdate;


--Breaking out address into individual column (address, city, state)
select 
	propertyaddress, 
	split_part(propertyaddress,', ',1) as PropertySplitAddress, 
	split_part(propertyaddress,', ',2) as PropertySplitCity
from housing_data
order by ParcelID;

-- for add new column
alter table housing_data
add propertysplitaddress varchar;

alter table housing_data
add	propertysplitcity varchar;
	
update housing_data
set propertysplitaddress = split_part(propertyaddress,', ',1);

update housing_data
set propertysplitcity = split_part(propertyaddress,', ',2);

select 
	propertyaddress, 
	propertysplitaddress, 
	propertysplitcity
from housing_data;



--Breaking out owneraddress into individual column (address, city, state)
select 
	owneraddress, 
	split_part(owneraddress,', ',1) as OwnerSplitAddress, 
	split_part(owneraddress,', ',2) as OwnerSplitCity
from housing_data
order by ParcelID;

-- for add new column
alter table housing_data
add ownersplitaddress varchar;

alter table housing_data
add	ownersplitcity varchar;
	
-- and fill new column
update housing_data
set ownersplitaddress = split_part(owneraddress,', ',1);

update housing_data
set propertysplitcity = split_part(owneraddress,', ',2);

select 
	owneraddress, 
	ownersplitaddress, 
	ownersplitcity
from housing_data;


--change Y and N in variable SoldAsVacant to Yes to No 
--First, check the categories from soldasvacant
select soldasvacant
from housing_data
group by soldasvacant;

--select Y and N in variable SoldAsVacant to Yes to No with case when function
select 
	soldasvacant,
	case when soldasvacant ='Y' then 'Yes'
	when soldasvacant ='N' then 'No'
	else soldasvacant
	end 
from housing_data;

-- change Y and N in variable SoldAsVacant to Yes to No with case when function
update housing_data
set soldasvacant= case when soldasvacant ='Y' then 'Yes'
	when soldasvacant ='N' then 'No'
	else soldasvacant
	end;
commit;


--Delete Character $ in variable saleprice
select saleprice, replace(saleprice,'$','')
from housing_data
where saleprice like '$%' ;

begin;
update housing_data
set saleprice = replace(saleprice,'$','');
commit;


--Remove Duplicates
with cte as (
			select * 
			from(
					select *,
											row_number() over(
											partition by parcelid,
														 propertyaddress, 
														 saleprice,
														 saledate,
														 legalreference
														 order by 
																uniqueid
															  ) as row_num
										from housing_data) s
					where row_num > 1
				 )
delete from housing_data
where uniqueid in (select uniqueid from cte);			 				 

select * from housing_data;

--delete unused column 
begin;
select 
	uniqueid,
	parcelid,
	landuse,
	propertysplitaddress,
	propertysplitcity,
	sale_date,
	saleprice,
	legalreference,
	soldasvacant,
	ownername,
	ownersplitaddress,
	ownersplitcity,
	acreage,
	taxdistrict,
	landvalue,
	buildingvalue, 
	totalvalue,
	yearbuilt,
	bedrooms,
	fullbath,
    halfbath
from housing_data
-- where ownername is null;


alter table housing_data
drop column propertysplitaddress;

alter table housing_data
drop column ownersplitaddress;

alter table housing_data
drop column taxdistrict;

alter table housing_data
drop column propertyaddress;

alter table housing_data
drop column owneraddress;

select *
from housing_data
where ownersplitcity is null;


				 