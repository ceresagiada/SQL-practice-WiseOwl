/** Create a query to list out the following statistics from the table of events: 
    Number of events; Last date; First date. **/

USE WorldEvents
GO

SELECT 
    COUNT(*) AS [Number of events],
    MAX(EventDate) AS [Last date],
    MIN(EventDate) AS [First date] 
FROM tblEvent
-- Done :)



/** Write a query to return the Artist_type column from the Artist table and how many artists for each artist type. **/

USE Music_01
GO

SELECT Artist_type, COUNT(*)
FROM Artist
GROUP BY Artist_type



/** Create a query which shows two statistics for each category initial:

The number of events for categories beginning with this letter; and
The average length in characters of the event name for categories beginning with this letter. **/

USE WorldEvents
GO

SELECT 
    LEFT(C.CategoryName,1) AS [Category initial], 
    COUNT(*) AS [Number of events], 
    AVG(LEN(E.EventName)) AS [Average event name length]
FROM tblCategory AS C JOIN tblEvent AS E 
    ON C.CategoryID = E.CategoryID
GROUP BY LEFT(C.CategoryName,1)
-- Done :)



/** Create a query which:

groups by the category name from the category table; and
counts the number of events for each. **/

USE WorldEvents
GO

SELECT C.CategoryName, COUNT(*) AS [Number of events]
FROM tblCategory AS C JOIN tblEvent AS E 
    ON C.CategoryID = E.CategoryID
GROUP BY C.CategoryName
ORDER BY C.CategoryName
-- Done :)



/** Write a query to list out for each author and doctor the number of episodes made, 
but restrict your output to show only the author/doctor combinations for which more than 5 episodes have been written. **/

USE DoctorWho
GO

SELECT A.AuthorName, D.DoctorName, COUNT(*) AS [Number of episodes]
FROM tblAuthor AS A 
    JOIN tblEpisode AS E ON A.AuthorId = E.AuthorId
    JOIN tblDoctor AS D ON E.DoctorId = D.DoctorId
GROUP BY A.AuthorName, D.DoctorName
HAVING COUNT(*) > 5
ORDER BY [Number of episodes] DESC
-- Done :)



/** Create a query to show the following information: Cnetury; Number of events **/

USE WorldEvents
GO

SELECT MIN(EventDate), MAX(EventDate)
FROM tblEvent

SELECT 
CASE 
    WHEN YEAR(EventDate) >= 2000 THEN '21st century'
    WHEN YEAR(EventDate) >= 1900 AND YEAR(EventDate) < 2000  THEN '20th century'
    WHEN YEAR(EventDate) >= 1800 AND YEAR(EventDate) < 1900  THEN '19th century'
    ELSE '17th century'
END AS Century, 
COUNT(*) AS [Number of events]
FROM tblEvent
GROUP BY (CASE 
    WHEN YEAR(EventDate) >= 2000 THEN '21st century'
    WHEN YEAR(EventDate) >= 1900 AND YEAR(EventDate) < 2000  THEN '20th century'
    WHEN YEAR(EventDate) >= 1800 AND YEAR(EventDate) < 1900  THEN '19th century'
    ELSE '17th century'
END)
ORDER BY Century
-- Done, but the grand total is missing --> suggestion to use the CUBE function

SELECT 
    CASE 
        WHEN YEAR(EventDate) >= 2000 THEN '21st century'
        WHEN YEAR(EventDate) >= 1900 AND YEAR(EventDate) < 2000  THEN '20th century'
        WHEN YEAR(EventDate) >= 1800 AND YEAR(EventDate) < 1900  THEN '19th century'
        ELSE '17th century'
    END AS Century, 
    COUNT(*) AS [Number of events]
FROM tblEvent
GROUP BY CUBE (CASE 
    WHEN YEAR(EventDate) >= 2000 THEN '21st century'
    WHEN YEAR(EventDate) >= 1900 AND YEAR(EventDate) < 2000  THEN '20th century'
    WHEN YEAR(EventDate) >= 1800 AND YEAR(EventDate) < 1900  THEN '19th century'
    ELSE '17th century'
END)
ORDER BY Century
-- Done :)



/** Use this to show for each author:

the number of episodes they wrote;
their earliest episode date; and
their latest episode date. **/

USE DoctorWho
GO

SELECT 
    A.AuthorName,
    COUNT (*) AS [Number of episodes],
    MIN(E.EpisodeDate) AS [Earliest date],
    MAX(E.EpisodeDate) AS [Latest date]
FROM tblAuthor AS A JOIN tblEpisode AS E
    ON A.AuthorId = E.AuthorId
GROUP BY A.AuthorName
ORDER BY [Number of episodes] DESC
-- Done :)



/** Create a query listing out for each continent and country the number of events taking place therein **/

USE WorldEvents
GO

SELECT Con.ContinentName, Cou.CountryName, COUNT(*) AS [Number of events]
FROM tblContinent AS Con 
    JOIN tblCountry AS Cou ON Con.ContinentID = Cou.ContinentID
    JOIN tblEvent AS Eve ON Cou.CountryID = Eve.CountryID
GROUP BY Con.ContinentName, Cou.CountryName
ORDER BY Con.ContinentName, Cou.CountryName

/** Now change your query so that it omits events taking place in the continent of Europe **/

SELECT Con.ContinentName, Cou.CountryName, COUNT(*) AS [Number of events]
FROM tblContinent AS Con 
    JOIN tblCountry AS Cou ON Con.ContinentID = Cou.ContinentID
    JOIN tblEvent AS Eve ON Cou.CountryID = Eve.CountryID
WHERE Con.ContinentName <> 'Europe'
GROUP BY Con.ContinentName, Cou.CountryName
ORDER BY Con.ContinentName, Cou.CountryName

/** Finally, change your query so that it only shows countries having 5 or more events **/

SELECT Con.ContinentName, Cou.CountryName, COUNT(*) AS [Number of events]
FROM tblContinent AS Con 
    JOIN tblCountry AS Cou ON Con.ContinentID = Cou.ContinentID
    JOIN tblEvent AS Eve ON Cou.CountryID = Eve.CountryID
WHERE Con.ContinentName <> 'Europe'
GROUP BY Con.ContinentName, Cou.CountryName
HAVING COUNT(*) > 5
ORDER BY Con.ContinentName, Cou.CountryName
-- Done :)



/** Write a query to list out for each episode year and enemy the number of episodes made, but in addition:

Only show episodes made by doctors born before 1970; and
Omit rows where an enemy appeared in only one episode in a particular year. **/

USE DoctorWho
GO

SELECT 
    YEAR(EpisodeDate) AS [Episode year], 
    EnemyName, 
    COUNT(*) AS [Number of episodes]
FROM tblEnemy AS En 
    JOIN tblEpisodeEnemy AS EpEn ON En.EnemyId = EpEn.EnemyId
    JOIN tblEpisode AS Ep ON EpEn.EpisodeId = Ep.EpisodeId
GROUP BY YEAR(EpisodeDate), EnemyName
ORDER BY COUNT(*) DESC
-- First step done

SELECT 
    YEAR(EpisodeDate) AS [Episode year], 
    EnemyName, 
    COUNT(*) AS [Number of episodes]
FROM tblEnemy AS En 
    JOIN tblEpisodeEnemy AS EpEn ON En.EnemyId = EpEn.EnemyId
    JOIN tblEpisode AS Ep ON EpEn.EpisodeId = Ep.EpisodeId
    JOIN tblDoctor AS D ON Ep.DoctorId = D.DoctorId
WHERE D.BirthDate < '1970-01-01'
GROUP BY YEAR(EpisodeDate), EnemyName
ORDER BY COUNT(*) DESC
-- First limitation done

SELECT 
    YEAR(EpisodeDate) AS [Episode year], 
    EnemyName, 
    COUNT(*) AS [Number of episodes]
FROM tblEnemy AS En 
    JOIN tblEpisodeEnemy AS EpEn ON En.EnemyId = EpEn.EnemyId
    JOIN tblEpisode AS Ep ON EpEn.EpisodeId = Ep.EpisodeId
    JOIN tblDoctor AS D ON Ep.DoctorId = D.DoctorId
WHERE D.BirthDate < '1970-01-01'
GROUP BY YEAR(EpisodeDate), EnemyName
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC



/** Use SQL queries to group a list of music artists and create statistics related to their albums.

Calculate:
The count of albums;
The sum of US sales;
The average of US sales **/

USE Music_01
GO

SELECT 
    Artist, 
    COUNT(*) AS Count_of_albums, 
    ROUND(SUM([US_sales_(m)]),2) AS [Sum_of_sales_(m)], 
    ROUND(AVG([US_sales_(m)]),2) AS [Avg_of_sales_(m)]
FROM Artist AS Art JOIN Album AS Alb
    ON Art.Artist_ID = Alb.Artist_ID
GROUP BY Artist

/** Modify your query so that it only includes albums which reached number 1 in the US Billboard 200 chart. **/
SELECT 
    Art.Artist, 
    COUNT(*) AS Count_of_albums, 
    ROUND(SUM([US_sales_(m)]),2) AS [Sum_of_sales_(m)], 
    ROUND(AVG([US_sales_(m)]),2) AS [Avg_of_sales_(m)]
FROM Artist AS Art JOIN Album AS Alb
    ON Art.Artist_ID = Alb.Artist_ID
WHERE US_Billboard_200_peak = 1
GROUP BY Artist
ORDER BY COUNT(*) DESC

/** Filter the results to show only artists with average sales of 10 million or more **/
SELECT 
    Art.Artist, 
    COUNT(*) AS Count_of_albums, 
    ROUND(SUM([US_sales_(m)]),2) AS [Sum_of_sales_(m)], 
    ROUND(AVG([US_sales_(m)]),2) AS [Avg_of_sales_(m)]
FROM Artist AS Art JOIN Album AS Alb
    ON Art.Artist_ID = Alb.Artist_ID
WHERE US_Billboard_200_peak = 1
GROUP BY Artist
HAVING  ROUND(AVG([US_sales_(m)]),2) >= 10.00
ORDER BY COUNT(*) DESC
-- Done :)



/** Write a query using the Venue and Show tables to display the aggregations shown below for each venue:

Count _of_shows
Sum _tickets_sold
Avg_revenue_S **/

USE Music_01
GO

SELECT 
    Venue, 
    COUNT(*) AS Count_of_shows,
    SUM(Tickets_sold) AS Sum_tickets_sold,
    AVG(Revenue_$) AS Avg_revenue_S
FROM Venue AS V JOIN Show AS S
    ON V.Venue_ID = s.Venue_ID
GROUP BY Venue
ORDER BY COUNT(*) DESC

/** Make another version of the same query which shows the same statistics for different cities. **/
SELECT 
    City, 
    COUNT(*) AS Count_of_shows,
    SUM(Tickets_sold) AS Sum_tickets_sold,
    AVG(Revenue_$) AS Avg_revenue_S
FROM Venue AS V 
    JOIN Show AS S ON V.Venue_ID = s.Venue_ID
    JOIN City AS C ON V.City_ID = C.City_ID
GROUP BY City
ORDER BY COUNT(*) DESC

/** Make another version of the same query which groups the data by Country **/
SELECT 
    Country, 
    COUNT(*) AS Count_of_shows,
    SUM(Tickets_sold) AS Sum_tickets_sold,
    AVG(Revenue_$) AS Avg_revenue_S
FROM Venue AS V 
    JOIN Show AS S ON V.Venue_ID = s.Venue_ID
    JOIN City AS Ci ON V.City_ID = Ci.City_ID
    JOIN Country AS Co ON Ci.Country_ID = Co.Country_ID
GROUP BY Country
ORDER BY COUNT(*) DESC

/** Make another version of the same query which groups the data by Continent **/
SELECT 
    Continent, Country, City, Venue,
    COUNT(*) AS Count_of_shows,
    SUM(Tickets_sold) AS Sum_tickets_sold,
    AVG(Revenue_$) AS Avg_revenue_S
FROM Venue AS V 
    JOIN Show AS S ON V.Venue_ID = s.Venue_ID
    JOIN City AS Cit ON V.City_ID = Cit.City_ID
    JOIN Country AS Cou ON Cit.Country_ID = Cou.Country_ID
    JOIN Continent AS Con ON Cou.Continent_ID = Con.Continent_ID
GROUP BY Continent, Country, City, Venue
ORDER BY COUNT(*) DESC
-- Done :)



/** Write a query to group albums by their record label, creating the aggregate values shown below:

Count _of _albums
Avg_sales_(m) **/

USE Music_01
GO

SELECT 
    L.Record_label, 
    COUNT(*) AS Count_of_albums,
    ROUND(AVG(A.[US_sales_(m)]),2) AS [Avg_sales_(m)]
FROM Album AS A JOIN Record_Label AS L 
    ON A.Record_label_ID = L.Record_label_ID
GROUP BY L.Record_label

/** create a total row **/
SELECT 
    L.Record_label, 
    COUNT(*) AS Count_of_albums,
    ROUND(AVG(A.[US_sales_(m)]),2) AS [Avg_sales_(m)]
FROM Album AS A JOIN Record_Label AS L 
    ON A.Record_label_ID = L.Record_label_ID
GROUP BY L.Record_label WITH ROLLUP

/** Modify the query to include the Parent_company table and add an extra grouping column. **/
SELECT 
    ISNULL(P.Parent_company, 'GRAND'),
    ISNULL(L.Record_label,'TOTAL'), 
    COUNT(*) AS Count_of_albums,
    ROUND(AVG(A.[US_sales_(m)]),2) AS [Avg_sales_(m)]
FROM Album AS A 
    JOIN Record_Label AS L ON A.Record_label_ID = L.Record_label_ID
    JOIN Parent_Company AS P ON L.Parent_company_ID = P.Parent_company_ID
GROUP BY P.Parent_company, L.Record_label WITH ROLLUP 
-- Done :)

