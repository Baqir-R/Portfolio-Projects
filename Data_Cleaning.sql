SELECT * 
FROM layoffs;

-- 1. Delete Duplicates
-- 2. Standardize Data
-- 3. Null values or Blank values
-- 4. Remove any Columns or Rows

CREATE TABLE layoffs_staging LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT INTO layoffs_staging SELECT * FROM layoffs;

SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;


SELECT * 
FROM layoffs_staging 
WHERE company = "Yahoo"; -- Cazoo Hibob Wildlife Studios Yahoo


WITH duplicate_cte AS 
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2 
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2 
WHERE row_num > 1;

DELETE
FROM layoffs_staging2 
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company);

SELECT DISTINCT location, TRIM(location)
FROM layoffs_staging2 
ORDER BY location;

UPDATE layoffs_staging2 
SET location = TRIM(location);

SELECT DISTINCT industry, TRIM(industry)
FROM layoffs_staging2 
ORDER BY industry;

SELECT *
FROM layoffs_staging2 
WHERE industry LIKE "Crypto%Currency%";

UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry like "Crypto%";

SELECT * 
FROM layoffs_staging2;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

SELECT DISTINCT TRIM(TRAILING "." FROM country)
FROM layoffs_staging2
WHERE country LIKE "United States%";

UPDATE layoffs_staging2 
SET country = TRIM(TRAILING "." FROM country)
WHERE country LIKE "United States%";

SELECT `date`
FROM layoffs_staging2;

SELECT `date`, STR_TO_DATE(`date`, "%m/%d/%Y")
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y");

-- Change date column from "text" to "Date" Format
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2;

CREATE TABLE layoffs_staging3 
LIKE layoffs_staging2;

INSERT INTO layoffs_staging3
SELECT * 
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging3;

SELECT * 
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT industry 
FROM layoffs_staging3;

SELECT *
FROM layoffs_staging3
WHERE industry IS NULL 
OR industry = "";

SELECT *
FROM layoffs_staging3
WHERE company = "Airbnb";

UPDATE layoffs_staging3 
SET industry = NULL
WHERE industry = "";

SELECT t1.industry, t2.industry
FROM layoffs_staging3 AS t1
JOIN layoffs_staging3 AS t2
	ON t1.company = t2.company 
    WHERE (t1.industry IS NULL OR t1.industry = "")
    AND t2.industry IS NOT NULL;
    

UPDATE layoffs_staging3 AS t1
JOIN layoffs_staging3 AS t2
	ON t1.company = t2.company
    SET t1.industry = t2.industry
    WHERE (t1.industry IS NULL OR t1.industry = "")
    AND t2.industry IS NOT NULL;

CREATE TABLE layoffs_staging4
LIKE layoffs_staging3;

INSERT INTO layoffs_staging4
SELECT * 
FROM layoffs_staging3;

SELECT * 
FROM layoffs_staging4;

SELECT * 
FROM layoffs_staging4
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging4
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging4
DROP COLUMN row_num;







