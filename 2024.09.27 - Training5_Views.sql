/** Create a view showing a list of concerts and locations **/

USE Music_01
GO

SELECT 
    A.Artist,
    T.Tour_name AS [Tour name],
    S.Show_date AS [Show date],
    S.Revenue_$ AS [Revenue $US],
    V.Venue AS [Venue name],
    VT.Venue_type AS [Venue type],
    VC.Venue_category AS [Venue category]
FROM Artist AS A 
    JOIN Tour AS T ON A.Artist_ID = T.Artist_ID
    JOIN Show AS S ON T.Tour_ID = S.Tour_ID
    JOIN Venue AS V ON S.Venue_ID = V.Venue_ID
    JOIN Venue_Type AS VT ON V.Venue_type_ID = VT.Venue_type_ID
    JOIN Venue_Category AS VC ON VT.Venue_category_ID = VC.Venue_category_ID

GO
CREATE VIEW Show_Me_The_Money
AS 
    SELECT 
        A.Artist,
        T.Tour_name AS [Tour name],
        S.Show_date AS [Show date],
        S.Revenue_$ AS [Revenue $US],
        V.Venue AS [Venue name],
        VT.Venue_type AS [Venue type],
        VC.Venue_category AS [Venue category]
    FROM Artist AS A 
        JOIN Tour AS T ON A.Artist_ID = T.Artist_ID
        JOIN Show AS S ON T.Tour_ID = S.Tour_ID
        JOIN Venue AS V ON S.Venue_ID = V.Venue_ID
        JOIN Venue_Type AS VT ON V.Venue_type_ID = VT.Venue_type_ID
        JOIN Venue_Category AS VC ON VT.Venue_category_ID = VC.Venue_category_ID
GO

/** Create a new query which selects every column from your view, sorted in descending order of show revenue **/

SELECT * 
FROM Show_Me_The_Money
ORDER BY [Revenue $US] DESC

/** Go back to the design of your view and add the Opening_date column from the Venue table to it. **/

GO
ALTER VIEW Show_Me_The_Money
AS 
    SELECT 
        A.Artist,
        T.Tour_name AS [Tour name],
        S.Show_date AS [Show date],
        S.Revenue_$ AS [Revenue $US],
        V.Venue AS [Venue name],
        VT.Venue_type AS [Venue type],
        VC.Venue_category AS [Venue category],
        V.Opening_date AS [Opening date] 
    FROM Artist AS A 
        JOIN Tour AS T ON A.Artist_ID = T.Artist_ID
        JOIN Show AS S ON T.Tour_ID = S.Tour_ID
        JOIN Venue AS V ON S.Venue_ID = V.Venue_ID
        JOIN Venue_Type AS VT ON V.Venue_type_ID = VT.Venue_type_ID
        JOIN Venue_Category AS VC ON VT.Venue_category_ID = VC.Venue_category_ID
GO

/** Add a filter to the Opening_date to show venues which opened since the 1st of January 2020 **/

GO
ALTER VIEW Show_Me_The_Money
AS 
    SELECT 
        A.Artist,
        T.Tour_name AS [Tour name],
        S.Show_date AS [Show date],
        S.Revenue_$ AS [Revenue $US],
        V.Venue AS [Venue name],
        VT.Venue_type AS [Venue type],
        VC.Venue_category AS [Venue category],
        V.Opening_date AS [Opening date] 
    FROM Artist AS A 
        JOIN Tour AS T ON A.Artist_ID = T.Artist_ID
        JOIN Show AS S ON T.Tour_ID = S.Tour_ID
        JOIN Venue AS V ON S.Venue_ID = V.Venue_ID
        JOIN Venue_Type AS VT ON V.Venue_type_ID = VT.Venue_type_ID
        JOIN Venue_Category AS VC ON VT.Venue_category_ID = VC.Venue_category_ID
    WHERE V.Opening_date > '2020-01-01'
GO

/** return to the query you wrote earlier. Execute the query again to see the new results. **/

SELECT * 
FROM Show_Me_The_Money
ORDER BY [Revenue $US] DESC

-- Done :)



/** Create a view in SQL Server to show a list of number 1 albums and fields from other tables. **/

USE Music_01
GO

-- Write a query to show the following fields for albums which peaked at number 1 in the US Billboard 200 chart:
-- Album_ID, Title, Release_date, Artist, Record_label
SELECT 
    Alb.Album_ID,
    Alb.Title,
    Alb.Release_date,
    Art.Artist,
    RL.Record_label
FROM Album AS Alb 
    JOIN Artist AS Art ON Alb.Artist_ID = Art.Artist_ID
    JOIN Record_Label AS RL ON Alb.Record_label_ID = RL.Record_label_ID
WHERE Alb.US_Billboard_200_peak = 1

-- create a view called Number_1_Albums.
GO
CREATE VIEW Number_1_Albums
AS 
    SELECT 
        Alb.Album_ID,
        Alb.Title,
        Alb.Release_date,
        Art.Artist,
        RL.Record_label
    FROM Album AS Alb 
        JOIN Artist AS Art ON Alb.Artist_ID = Art.Artist_ID
        JOIN Record_Label AS RL ON Alb.Record_label_ID = RL.Record_label_ID
    WHERE Alb.US_Billboard_200_peak = 1
GO

-- Create a query which joins your view to the Tour table using the Album_ID fields. 
-- Select the fields shown below: Tour_name, Start_date, Title, Release_date, Artist, Record_label
SELECT T.Tour_name, T.Start_date, No1.Title, No1.Release_date, No1.Artist, No1.Record_label 
FROM Number_1_Albums AS No1
    JOIN Tour AS T ON No1.Album_ID = T.Album_ID

-- add the US_sales_(m) field to the View
GO 
ALTER VIEW Number_1_Albums
AS 
    SELECT 
        Alb.Album_ID,
        Alb.Title,
        Alb.Release_date,
        Art.Artist,
        RL.Record_label,
        Alb.[US_sales_(m)]
    FROM Album AS Alb 
        JOIN Artist AS Art ON Alb.Artist_ID = Art.Artist_ID
        JOIN Record_Label AS RL ON Alb.Record_label_ID = RL.Record_label_ID
    WHERE Alb.US_Billboard_200_peak = 1
GO

-- write a query using a GROUP BY clause to show the following statistics from the view:
-- Count_of_albums, Sum_of_sales (per artist)
SELECT 
    No1.Artist, 
    COUNT(No1.Title) AS Count_of_albums, 
    SUM(No1.[US_sales_(m)]) AS Sum_of_sales
FROM Number_1_Albums AS No1
GROUP BY No1.Artist

-- Done :)



/** Write a view to combine tables, then use this as a basis for a grouping query **/

USE WorldEvents
GO

-- Write the script to generate a view called vwEverything (based on the tblCategory, tblEvent, tblCountry and tblContinent tables) to show this data:
-- Category, Continent, Country, EventName, EventDate
GO
CREATE VIEW vwEverything 
AS 
    SELECT 
        Cat.CategoryName AS Category,
        Con.ContinentName AS Continent,
        Cou.CountryName AS Country,
        E.EventName,
        E.EventDate
    FROM tblEvent AS E 
        JOIN tblCategory AS Cat ON E.CategoryID = Cat.CategoryID
        JOIN tblCountry AS Cou ON E.CountryID = Cou.CountryID
        JOIN tblContinent AS Con ON Cou.ContinentID = Con.ContinentID
GO

SELECT * FROM vwEverything

-- Now write a query which selects data from this view to show the number of events by category within Africa
SELECT 
    Category, 
    COUNT(*) AS NumberEvents
FROM vwEverything
WHERE Continent = 'Africa'
GROUP BY Category
ORDER BY COUNT(*) DESC

-- Done :)



/** Use the view designer to create a view, and change it in SQL **/

USE DoctorWho
GO

-- Including the tables tblAuthor, tblEpisode and tblDoctor, create a view listing the episodes whose titles start with F, 
-- with the following information: AuthorName, DoctorName, Title, EpisodeDate
GO
CREATE VIEW vwEpisodesByFirstLetter 
AS 
    SELECT A.AuthorName, D.DoctorName, E.Title, E.EpisodeDate
    FROM tblEpisode AS E 
        JOIN tblAuthor AS A ON E.AuthorId = A.AuthorId
        JOIN tblDoctor AS D ON E.DoctorId = D.DoctorId
    WHERE E.Title LIKE 'F%'
GO
SELECT * FROM vwEpisodesByFirstLetter

--  change the criteria to show episodes starting with H.
GO
ALTER VIEW vwEpisodesByFirstLetter 
AS 
    SELECT A.AuthorName, D.DoctorName, E.Title, E.EpisodeDate
    FROM tblEpisode AS E 
        JOIN tblAuthor AS A ON E.AuthorId = A.AuthorId
        JOIN tblDoctor AS D ON E.DoctorId = D.DoctorId
    WHERE E.Title LIKE 'H%'
GO
SELECT * FROM vwEpisodesByFirstLetter



/** Create a view in the view designer, tidy up its SQL and use it to select data **/

USE WorldEvents
GO

-- create this new view: CATGEORYNAME, EVENTNAME + Count the number of events by category
GO
IF EXISTS (SELECT * FROM sys.views WHERE name = 'EventsByCategory')
DROP VIEW EventsByCategory
GO 
CREATE VIEW EventsByCategory
AS
    SELECT TOP 100 PERCENT 
        C.CategoryName AS Category,
        COUNT(E.EventName) AS What
    FROM tblEvent AS E 
        JOIN tblCategory AS C ON E.CategoryID = C.CategoryID
    GROUP BY C.CategoryName
    ORDER BY What DESC
GO
SELECT * FROM EventsByCategory
-- I don't get the results in order !!!
    --> according to chatgpt: not possible

-- change the view so that it returns the results in ascending rather than descending order
GO
ALTER VIEW EventsByCategory
AS
    SELECT TOP 100 PERCENT 
        C.CategoryName AS Category,
        COUNT(E.EventName) AS What
    FROM tblEvent AS E 
        JOIN tblCategory AS C ON E.CategoryID = C.CategoryID
    GROUP BY C.CategoryName
    ORDER BY What ASC
GO
SELECT * FROM EventsByCategory
-- Order doesn't change :(

-- show the results of this view where the nuber of events is more than 50
SELECT * 
FROM EventsByCategory 
WHERE What > 50

-- Done but order doesn't change



/** Use views based on views to show Doctor Who episodes with only 1 enemy and 1 companion **/

USE DoctorWho
GO

-- Create a series of views which will ultimately list out all of the episodes which had both multiple enemies and multiple companions.
-- To achieve this, create (in this order) the following views:
-- vwEpisodeCompanion	List all of the episodes which had only a single companion.
-- vwEpisodeEnemy	    List all of the episodes which had only a single enemy.
-- vwEpisodeSummary	    List all of the episodes which have no corresponding rows in either the vwEpisodeCompanion or vwEpisodeEnemy tables.

SELECT * FROM tblEpisodeCompanion
SELECT * FROM tblCompanion
SELECT * FROM tblEpisodeEnemy
SELECT * FROM tblEnemy

GO
CREATE VIEW vwEpisodeCompanion
AS 
    SELECT 
        E.Title, 
        COUNT(*) AS CompanionCount
    FROM tblEpisode AS E 
        JOIN tblEpisodeCompanion AS EC ON E.EpisodeId = EC.EpisodeId
    GROUP BY E.Title
    HAVING COUNT(*) = 1
GO
SELECT * FROM vwEpisodeCompanion

GO
CREATE VIEW vwEpisodeEnemy
AS
    SELECT 
        E.Title,
        COUNT(*) AS EnemyCount
    FROM tblEpisode AS E 
        JOIN tblEpisodeEnemy AS EE ON E.EpisodeId = EE.EpisodeId
    GROUP BY E.Title
    HAVING COUNT(*) = 1
GO
SELECT * FROM vwEpisodeEnemy

GO 
CREATE VIEW vwEpisodeSummary
AS
    SELECT E.EpisodeId, E.Title
    FROM tblEpisode AS E 
        LEFT OUTER JOIN vwEpisodeCompanion AS vwEC ON E.Title = vwEC.Title
        LEFT OUTER JOIN vwEpisodeEnemy AS vwEE ON E.Title = vwEE.Title
    WHERE 
        vwEC.Title IS NULL 
        AND
        vwEE.Title IS NULL
GO
SELECT * FROM vwEpisodeSummary

-- Done with som ehelp :|



/** Script a view in a query, then use the view designer to edit it **/

USE DoctorWho
GO

-- create a view to show series 1 episodes
GO
CREATE VIEW vwSeriesOne
AS 
    SELECT Title, SeriesNumber, EpisodeNumber 
    FROM tblEpisode
    WHERE SeriesNumber = 1
GO
SELECT * FROM vwSeriesOne

-- Amend the criteria to show all of the episodes in series 2, not 1, then save and close your view
GO
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vwSeriesOne')
DROP VIEW vwSeriesOne
GO
CREATE VIEW vwSeriesOne
AS 
    SELECT Title, SeriesNumber, EpisodeNumber 
    FROM tblEpisode
    WHERE SeriesNumber = 2
GO
SELECT * FROM vwSeriesOne