--Using a Temp Table for New Vaccinations

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

SELECT * FROM #PercentPopVaccinated
--WHERE [location] like 'Ireland'
ORDER BY [location], [date]