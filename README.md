# SQL-Portfolio-Projects
## Projects that I have completed through SQL Server including Data Exploration and Data Cleaning.

### Data Exploration.
#### After learning the nature of query languages, I sought after the goal of developing data projects through SQL Server as a means of learning more about the intricacies of Data Science.
#### I began by striving to further understand the infection rates, death rates and vaccinations from Covid-19 via the publicly available data from ourworldindata.org, in particular, comparing these variables from country to country. This was achieved by the use of Temp Tables and CTEs in SQL Server. I partitioned the data base into Covid Death information and Covid Vaccination information.
#### I found analysing Ireland's data quite interesting, approximating the probability of any one individual having Covid-19 during any given period. I was also found the average death rate from the virus in Ireland during any given period.
#### As these findings were very much relatable having lived in Ireland throughout the pandemic, I will be developing a new project where I will further analyse the infection rates and death rates in Ireland and hope to better understand the answer to questions such as 'What factors mostly influenced the chance of death from Covid-19 in Ireland in comparison to other countries?'; 'How did factors such as underlying health conditions, national percentage of smokers, age groups, gdp per capita, number of hospital beds per thousand as well as population density affect Ireland's rates throughout Covid-19?' and furthermore, 'How do these factors compare to the data of other developed countries?

### Data Cleaning.
#### Having explored the basics of Data Science through SQL Server via the application of Covid-19 data, I decided to progress onto another vital branch of Data Science and Analytics; Data Cleaning.
#### For this project, I used the Excel spreadsheet Nashville Housing Data for Data Cleaning available at kaggle.com/tmthyjames/nashville-housing-data.
#### I began by first viewing the entire dataset to get understanding of its completeness (ie. occurence of NULL values) as well as to see what data types I am viewing.
#### Noticing that the dates were in data type nvarchar, I converted all dates to date format. I followed this with populating the NULL addresses in the housing data using a dependent field called the 'ParcelID', so that if two addresses had equal corresponding ParcelID, then we will say that their addresses are equal.
#### Continuing on, I saw the addresses were a single field, this made analysing these entries less desirable, so I partitioned all addresses into street name, town and city. I did this using two distinguishable methods; using PARSENAME as well as SUBSTRING.
#### As well as this, on viewing the field entries for 'Sold as Vacant', I saw 'Yes','Y','No','N' were present. A simple CASE statement replaced all cases of 'Yes' with 'Y' and all 'No' with 'N'. Now this data is more straightforward to investigate.
#### Lastly, I displayed a simple method to replace unwanted duplicates of rows. Although in practise removing raw data from a working data set is ill-advised, this may be advantageous to know in case a duplicate error was made to the data previously.
