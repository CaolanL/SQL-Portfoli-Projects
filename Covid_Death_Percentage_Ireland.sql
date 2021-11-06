--SELECT * FROM dbo.[Covid Deaths]
--WHERE continent IS NOT NULL
--ORDER BY [location],[date]

--These tables include locations such as 'World','Africa','Europe','North America' etc.
--The 'IS NOT NULL' statement allows us to only view rows whose location is a nation/sovereign state

--Looking at Total Cases vs Total Deaths in any individual Country:

SELECT [location], [date], total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM dbo.[Covid Deaths]
WHERE [location] LIKE 'Ireland'
--ORDER BY Death_Percentage desc

--Shows likelihood of dying from Covid in country quoted below ('WHERE location LIKE') : 

--Remark: Using the 'ORDER BY Death_Percentage desc', we can see that the highest death percentage in Ireland from Covid was 6.8265% on 23rd July 2020.
--This data is recorded from 29/02/2021 to 21/10/2021

