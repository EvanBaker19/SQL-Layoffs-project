-- Data Cleaning

Select *
From layoffs;

-- Remove Duplicates
-- Standardize Data
-- Null Values or Blank Values
-- Remove uneccasary row/columns



CREATE TABLE layoffs_staging
Like layoffs;

Select *
From layoffs_staging;


Insert layoffs_staging
Select *
From layoffs;


Select *,
row_number() Over(
Partition By company, industry, total_laid_off, percentage_laid_off, `date` ) AS row_num
From layoffs_staging;

With duplicate_cte AS
(
Select *,
row_number() Over(
Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
From layoffs_staging
)
Select *
From duplicate_cte
Where row_num >1;


With duplicate_cte AS
(
Select *,
row_number() Over(
Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
From layoffs_staging
)
Delete
From duplicate_cte
Where row_num >1;




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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
From layoffs_staging2
Where row_num > 1;

Insert Into layoffs_staging2
Select *,
row_number() Over(
Partition By company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
From layoffs_staging;



Delete
From layoffs_staging2
Where row_num > 1;


Select *
From layoffs_staging2;


-- Standardizing data

Select company, trim(company)
From layoffs_staging2;

Update layoffs_staging2
Set company = trim(company);

Select *
From layoffs_staging2
where industry Like 'Crypto%';

Update  layoffs_staging2
Set industry = 'Crypto'
Where industry like 'Crypto%';


Select distinct country
From layoffs_staging2
Order by 1;

Update layoffs_staging2
Set country = 'United States'
Where country Like 'United States%';


Select `date`,
str_to_date(`date`, '%m/%d/%Y')
From layoffs_staging2;


Update layoffs_staging2
Set `date` = str_to_date(`date`, '%m/%d/%Y');


Select `date`
From layoffs_staging2;


Alter Table layoffs_staging2
Modify Column `date` date;


Select *
From layoffs_staging2
Where total_laid_off is Null
And percentage_laid_off is Null;

UPDATE layoffs_staging2
SET industry = null
Where industry = '';

Select *
From layoffs_staging2
Where industry is null
OR industry = '';

Select *
From layoffs_staging2
Where company = 'Airbnb';

Select * 
From layoffs_staging2 t1
Join  layoffs_staging2 t2
	On t1.company = t2.company
    AND t1.location = t2.location
Where (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
Join  layoffs_staging2 t2
	On t1.company = t2.company
SET t1.industry = t2.industry
Where t1.industry IS NULL
AND t2.industry IS NOT NULL;


Select *
From layoffs_staging2
Where industry is null
OR industry = '';

Delete
From layoffs_staging2
Where total_laid_off IS NULL
AND percentage_laid_off IS NULL;	


Select * 
From layoffs_staging2;

ALTER TABLE layoffs_staging2
Drop column row_num;



