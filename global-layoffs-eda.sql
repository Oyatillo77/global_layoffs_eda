-- Exploratory Data Analysis 

SELECT * FROM layoffs_staging2;


SELECT * FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company,Sum(total_laid_off) 
FROM layoffs_staging2 GROUP by company
ORDER BY 2 DESC;

SELECT MIN(`date`),Max(`date`)
FROM layoffs_staging2;

SELECT country,Sum(total_laid_off) 
FROM layoffs_staging2 GROUP by country
ORDER BY 2 DESC;


SELECT YEAR(`date`),Sum(total_laid_off) 
FROM layoffs_staging2 GROUP by YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage,Sum(total_laid_off) 
FROM layoffs_staging2 GROUP by stage
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`,1,7) As `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) As `MONTH`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,total_off,Sum(total_off) OVER(Order by `MONTH`) AS rolling_total
FROM Rolling_total;


SELECT company,Year(`date`),Sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,Year(`date`);


WITH Company_Year(company,years,total_laid_off) AS
(
    SELECT company,Year(`date`),Sum(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company,Year(`date`)
), Company_Year_Rank As
(SELECT *,
DENSE_RANK() OVER(Partition By years ORDER BY total_laid_off DESC) as Ranking
FROM Company_Year
WHERE years is NOT NULL
)
Select * FROM Company_Year_Rank
WHERE Ranking<=5; 

