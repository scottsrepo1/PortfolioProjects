# US Household Income Data Cleaning

SELECT *
FROM us_project.us_household_income_statistics;

SELECT *
FROM us_project.us_household_income;

# Altering table column from us_project.us_household_income_statistics to correct column name "id" after import
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

# Identifying duplicates from table us_project.us_household_income_statistics 

SELECT id, Count(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) >1;

SELECT Count(id)
FROM us_project.us_household_income_statistics;

# Identifying duplicates from table us_project.us_household_income

SELECT id, Count(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) >1;

SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
FROM us_household_income
) duplicates
WHERE row_num > 1
;

# Removing duplicate ids from non staging table us_project.us_household_income
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
		FROM us_household_income
		) duplicates
WHERE row_num > 1)
;

SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY 1
;

# Standardizing data for table us_project.us_household_income

SELECT DISTINCT State_Name
FROM us_household_income
WHERE State_Name LIKE 'G%'
ORDER BY 1
;

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';


SELECT DISTINCT State_ab
FROM us_household_income
ORDER BY 1
;

SELECT *
FROM us_household_income
WHERE Place = ''
ORDER BY 1
;

SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

# NULL OR BLANK VALUES

SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
;

SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
;

SELECT DISTINCT AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
;

SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL
;
