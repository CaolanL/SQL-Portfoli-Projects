--Looking at Total Population vs Vaccinations:

SELECT dea.continent, dea.[location], dea.[date], dea.[population], vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.[location] 
ORDER BY dea.[location], dea.date) AS PeopleVaccinatedAugmented
FROM dbo.[Covid Deaths] dea
JOIN dbo.[Covid Vaccinations] vac
	ON dea.[location] = vac.[location]
	AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
ORDER BY [location], [date]

--Note: Either CONVERT or CAST can be used to change data type to integers.
--Issue with SUM function here; "Arithmetic overflow error converting expression to data type int"
--Using 'bigint' solves this error.