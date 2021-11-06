SELECT * FROM dbo.[Covid Deaths]
WHERE continent IS NOT NULL
ORDER BY [location],[date]

--These tables include locations such as 'World','Africa','Europe','North America' etc.
--The 'IS NOT NULL' statement allows us to only view rows whose location is a nation/sovereign state

--SELECT * FROM dbo.[Covid Vaccinations]
--ORDER BY 3,4

--Looking at Total Cases vs Total Deaths:

--Shows likelihood of dying from Covid in country quoted below; ('WHERE location like')
SELECT [location], [date], total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM dbo.[Covid Deaths]
WHERE [location] LIKE 'Ireland'
ORDER BY [location],[date]
--Remark: The Highest Death Percentage in Ireland from Covid was 6.825% on 4th July 2020.

--Looking at Total Cases vs Population:

SELECT [location], [date], [population], total_cases, (total_cases/[population])*100 AS Population_Infected_Percentage
FROM dbo.[Covid Deaths]
WHERE [location] LIKE 'Ireland'
ORDER BY total_cases,Population_Infected_Percentage
--Shows what percentage of population got Covid
--Remark: It only took until 18th October 2020 for 1% of Ireland's population to have had Covid.

--Looking at countries with highest infection rate compared to population:

SELECT [location], [population], MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/[population]))*100 
AS Population_Infected_Percentage
FROM dbo.[Covid Deaths]
GROUP BY [location], [population]
ORDER BY Population_Infected_Percentage desc
--Remark: Seychelles currently has the highest percentage of infected poulation at 22.31%,
--followed by Montenegro at 22.21% and Andorra at 19.89%

--Showing the countries with the highest death count:

SELECT [location], MAX(CAST(Total_deaths AS int)) AS Total_Death_Count
FROM dbo.[Covid Deaths]
WHERE continent IS NOT NULL
GROUP BY [location]
ORDER BY Total_Death_Count desc
--I casted as an integer here as it seems MAX(nvarchar) was returning the string with the 'highest' values for each position of the string,
--ie. the integers with the most 9's in them and not necessarily the largest integer.

--Let's break things down by continent:

SELECT [location], MAX(CAST(Total_deaths AS int)) AS Total_Death_Count
FROM dbo.[Covid Deaths]
WHERE continent IS NULL
GROUP BY [location]
ORDER BY Total_Death_Count desc
--Remark: Looks at all locations where continent is NULL, so that we are left with only the numbers
--for globals deaths, EU deaths and deaths by continent

--Global Numbers:

SELECT [date], SUM(new_cases) AS Total_Cases_Per_Day, SUM(CAST(new_deaths AS int)) AS Total_Deaths_Per_Day, SUM(CAST(New_deaths AS int))/SUM(New_Cases)*100
AS DeathPercentage
FROM dbo.[Covid Deaths]
WHERE continent IS NOT NULL
GROUP BY [date]
ORDER BY 1,2
--Remark: This shows us the cases and deaths that happened each day from 17/1/2020 until 21/10/2021 globally

SELECT SUM(new_cases) AS Total_Global_Cases, SUM(CAST(new_deaths AS int)) AS Total_Global_Deaths, SUM(CAST(New_deaths AS int))/SUM(New_Cases)*100
AS Death_Percentage
FROM dbo.[Covid Deaths]
WHERE continent IS NOT NULL
--Remark: Current death percentage globally is 2.03%


--Looking at Total Population vs Vaccinations:

SELECT dea.continent, dea.[location], dea.[date], dea.[population], vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.[location] ORDER BY dea.[location],
dea.date) AS PeopleVaccinatedAugmented
FROM dbo.[Covid Deaths] dea
JOIN dbo.[Covid Vaccinations] vac
	ON dea.[location] = vac.[location]
	AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

--USE CTE for the above query:

WITH PopvsVac (Continent, [location], [date], [population], New_Vaccinations, PeopleVaccinatedAugmented)
AS
(
SELECT dea.continent, dea.[location], dea.[date], dea.[population], vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.[location] ORDER BY dea.[location],
dea.[date]) AS PeopleVaccinatedAugmented
FROM dbo.[Covid Deaths] dea
JOIN dbo.[Covid Vaccinations] vac
	ON dea.[location] = vac.[location]
	AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (PeopleVaccinatedAugmented/Population)*100
FROM PopvsVac
--Note: Either CONVERT or CAST can be used to change data type to integers.
--Issue with SUM function here; "Arithmetic overflow error converting expression to data type int"
--Using BIGINT solves this error.

-- Using a Temp Table similar to the above CTE:


DROP TABLE IF EXISTS #PercentPopVaccinated
CREATE TABLE #PercentPopVaccinated
(
Continent nvarchar(255),
[location] nvarchar(255),
[date] datetime,
[population] numeric,
New_Vaccinations numeric,
PeopleVaccinatedAugmented numeric
)

INSERT INTO #PercentPopVaccinated
SELECT dea.continent, dea.[location], dea.[date], dea.[population], vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.[location] ORDER BY dea.[location],
dea.[date]) AS PeopleVaccinatedAugmented
FROM dbo.[Covid Deaths] dea
JOIN dbo.[Covid Vaccinations] vac
	ON dea.[location] = vac.[location]
	AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (PeopleVaccinatedAugmented/[population])*100 AS AugmentedVaccinationPercentage
FROM #PercentPopVaccinated


--Creating view to store data for later visualisations

--CREATE VIEW PercentPopVaccinated AS
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
--dea.date) AS PeopleVaccinatedAugmented
--FROM dbo.[Covid Deaths] dea
--JOIN dbo.[Covid Vaccinations] vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT null
