--Using a CTE for new vaccinations:

WITH PopVsVac (Continent, [location], [date], [population], New_Vaccinations, Vaccinations_Augmented)
AS
(
SELECT dea.continent, dea.[location], dea.[date], dea.[population], vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.[location] ORDER BY dea.[location],
dea.[date]) AS Vaccinations_Augmented
FROM dbo.[Covid Deaths] dea
JOIN dbo.[Covid Vaccinations] vac
	ON dea.[location] = vac.[location]
	AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
--ORDER BY [location], [date]
)
SELECT * FROM PopVsVac
ORDER BY [location]

--Note: Either CONVERT or CAST can be used to change data type to integers.
--Issue with SUM function here; "Arithmetic overflow error converting expression to data type int"
--Using BIGINT solves this error.

--Remark: Vaccinations_Augmented shows the total number of vaccinations up to and including the corresponding date. This cannot be interpreted as the total number of people vaccinated
--because for most vaccinations types, 2 vaccinations are required per person.
--This implies that finding the augmented vaccinations percentage will surpass 100% at some point in time.
