-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, TRUNCATE(SUM(total_laid_off /2), 0)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, TRUNCATE(SUM(total_laid_off),0)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- TRUNCATE (number, length) - Returns the the number truncated to the precision specified by length. /i.e length = 0, decimal places are omitted
SELECT `date`, TRUNCATE(SUM(total_laid_off /2), 0)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

-- GROUP BY Year Function
SELECT YEAR(`date`), TRUNCATE(SUM(total_laid_off /2), 0)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage, TRUNCATE(SUM(total_laid_off /2), 0)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- rolling total layoffs by month - to see overall progression
-- SUBSTRING(str,startposition,lengthToReturn)

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, TRUNCATE(SUM(total_laid_off /2), 0)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY 1 ASC;


-- CTE rolling total option

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, TRUNCATE(SUM(total_laid_off /2), 0) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` , total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- looking at SUM of layoffs per year by company

SELECT company, TRUNCATE(SUM(total_laid_off /2), 0) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), TRUNCATE(SUM(total_laid_off /2), 0)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Ranking top 5 companies by total lay offs per year

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), TRUNCATE(SUM(total_laid_off /2), 0) 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;
