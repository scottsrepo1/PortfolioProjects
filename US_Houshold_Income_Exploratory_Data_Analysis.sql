# US Household Income Exploratory Data Analysis

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

# Calculating the Sum of area for land and water per state

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY SUM(ALand) DESC;

# Identifying the top 10 largest states by land and by water

# Top 10 States by area of land

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY SUM(ALand) DESC
LIMIT 10;

# Top 10 States by area of water
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY SUM(AWater) DESC
LIMIT 10;


SELECT * 
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id;

# Filtering out data that house a mean of '0'
SELECT * 
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0;

-- -----------------------------------------------
SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0;

# Looking at Average income per Household by state

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 
;

# Looking at 5 lowest states average household income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5
;

# Looking at 5 highest states average household income

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5
;

# Looking at 10 highest states average household income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10
;

# Looking at 10 highest median incomes per household per state

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Looking at 10 lowest median incomes per household per state

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 10
;


# Looking at AVG Mean houshold income by Type

SELECT Type, COUNT(Type),ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 20;

# Looking at AVG Median houshold income by Type

SELECT Type, COUNT(Type),ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 4 DESC
LIMIT 20
;

# Looking at lowest AVG houshold income by `Type` = 'Community'

SELECT COUNT(Type), Type, u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0 AND Type = 'Community'
GROUP BY u.State_Name
;


# Filtering out possible `Type` outliers that are less than 100
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0 
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
;

-- Highest AVG Income per household by City

SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC
;


