--Looking at Countries with highest infection rate relative to population:

SELECT [location], [population], MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/[population]))*100 
AS Population_Infected_Percentage
FROM dbo.[Covid Deaths]
GROUP BY [location], [population]
ORDER BY Population_Infected_Percentage desc

--Remark: As of 21st October 2021, Seychelles currently has the highest percentage of infected poulation at 22.31%, followed by Montenegro at 22.21% and Andorra at 19.89%