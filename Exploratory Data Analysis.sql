-- Data Analysis

Select *
From layoffs_staging2;


Select MAX(total_laid_off), MAX(percentage_laid_off)
From layoffs_staging2;


Select *
From layoffs_staging2
Where percentage_laid_off = 1
Order by funds_raised_millions DESC;


Select company, SUM(total_laid_off)
From layoffs_staging2
Group By company
Order by 2 desc;


Select MIN(`date`), MAX(`date`)
From layoffs_staging2;



Select industry, SUM(total_laid_off)
From layoffs_staging2
Group By industry
Order by 2 desc;


Select location, SUM(total_laid_off)
From layoffs_staging2
Group By location
Order by 2 desc;


Select year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By year(`date`)
Order by 1 desc;


Select company, SUM(percentage_laid_off)
From layoffs_staging2
Group By company
Order by 2 desc;


Select substring(`date`,1,7) AS `Month`, SUM(total_laid_off)
From layoffs_staging2
Where substring(`date`,1,7) IS NOT NULL  
Group By `Month`
Order by 1 asc;


With Rolling_Total AS 
( 
Select substring(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
From layoffs_staging2
Where substring(`date`,1,7) IS NOT NULL  
Group By `Month`
Order by 1 asc
)
Select  `Month`, total_off
, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
From Rolling_Total;


Select company, SUM(percentage_laid_off)
From layoffs_staging2
Group By company
Order by 2 desc;


Select company, YEAR(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, YEAR(`date`)
ORDER BY 3 desc;

With company_year (company, years, total_laid_off) AS
(
Select company, YEAR(`date`), SUM(total_laid_off)
From layoffs_staging2
Group By company, YEAR(`date`)
), Company_Year_Rank AS
(
Select *, DENSE_Rank() OVER (partition by years ORDER BY total_laid_off desc) AS Ranking
From company_year
Where years AND total_laid_off IS NOT NULL
)
Select * 
From Company_Year_Rank
Where Ranking <= 5
