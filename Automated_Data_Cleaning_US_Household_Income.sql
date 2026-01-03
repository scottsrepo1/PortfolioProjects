-- Automated Data Cleaning

-- Created stored procedure that is going to clean all the data automatically
-- Within stored procedure created a duplicate table of 'us_household_income' 
-- Then inserted into new table 'us_household_income_Cleaned' some data modifications
-- Checked to see if stored procedure worked as expected
-- Created an event that runs the stored procedure

SELECT *
FROM us_project.us_household_income;

SELECT * FROM us_project.us_household_income_cleaned;

-- CREATING STORED PROCEDURE
-- Creating table `us_household_income_cleaned` and adding `TimeStamp` column

DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_and_Clean_Data;
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN
	CREATE TABLE IF NOT EXISTS `us_household_income_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `TimeStamp` TIMESTAMP DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- COPY DATA TO NEW TABLE
	INSERT INTO us_household_income_cleaned
    SELECT *, CURRENT_TIMESTAMP
    FROM us_project.us_household_income;

-- Data Cleaning Steps

	-- 1. Remove Duplicates
	DELETE FROM us_household_income_cleaned
	WHERE row_id IN (
		SELECT row_id
		FROM (
			SELECT row_id, id,
			ROW_NUMBER() OVER (
            PARTITION BY id, `TimeStamp`
            ORDER BY id, `TimeStamp`) row_num
			FROM us_household_income_cleaned
			) duplicates
	WHERE row_num > 1)
    ;

	-- 2. Standardization
	UPDATE us_household_income_cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE us_household_income_cleaned
	SET State_Name = 'Alabama'
	WHERE State_Name = 'alabama';

	UPDATE us_household_income_cleaned
	SET County = UPPER(County);

	UPDATE us_household_income_cleaned
	SET City = UPPER(City);

	UPDATE us_household_income_cleaned
	SET Place = UPPER(Place);

	UPDATE us_household_income_cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE us_household_income_cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_household_income_cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';

END $$
DELIMITER ;

CALL Copy_and_Clean_Data();

-- CREATE EVENT
CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 2 minute
    DO CALL Copy_and_Clean_Data();
    
-- Verifying 2 Min interval

SELECT * FROM us_project.us_household_income_cleaned;

SELECT DISTINCT timestamp
FROM us_household_income_cleaned;

-- CHANGING/DROPPING EVENT
DROP EVENT run_data_cleaning;

CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_Data();




-- DEBUGGING OR CHECKING IF STORED PROCEDURE WORKS

		SELECT row_id, id, row_num
		FROM (
			SELECT row_id, id,
			ROW_NUMBER() OVER (
            PARTITION BY id 
            ORDER BY id) AS row_num
			FROM us_household_income_cleaned
			) duplicates
	WHERE row_num > 1;
    
SELECT COUNT(row_id)
FROM us_household_income_cleaned;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned
GROUP BY State_Name;





