--Showing the countries with the highest death count:

SELECT [location], MAX(CAST(Total_deaths AS int)) AS Total_Death_Count
FROM dbo.[Covid Deaths]
WHERE continent IS NOT NULL
GROUP BY [location]
ORDER BY Total_Death_Count desc

--I casted as an integer here as MAX(nvarchar) will return the string with the 'highest' values for each position of the string,
--ie. the integers with the most 9's in them and not necessarily the integer of greatest magnitude.