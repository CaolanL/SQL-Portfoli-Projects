--Looking at Total Cases vs Population in any individual Country:

SELECT [location], [date], [population], total_cases, (total_cases/[population])*100 AS Population_Infected_Percentage
FROM dbo.[Covid Deaths]
WHERE [location] LIKE 'Ireland'
ORDER BY total_cases,Population_Infected_Percentage 

--Shows what percentage of population got Covid in Ireland up until a given date

--Remarks: It only took until 18th October 2020 for 1% of Ireland's population to have had Covid.
--As of 21st October 2021, 8.494% of Irelands population has had Covid.