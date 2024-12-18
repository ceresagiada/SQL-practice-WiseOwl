/** Write a script to create a stored procedure called usp_Number_1_Albums 
which returns the following columns from the Album table where the US_Billboard_200_peak equals 1:
title, release_date, US_sales **/

USE Music_01
GO

CREATE PROC usp_Number_1_Albums AS 
BEGIN 
    SELECT Title, Release_date, [US_sales_(m)]
    FROM Album
    WHERE US_Billboard_200_peak = 1
END
GO 
EXECUTE usp_Number_1_Albums


/** Alter the procedure to sort the albums in descending order of US sales. **/
GO
ALTER PROC usp_Number_1_Albums AS 
BEGIN 
    SELECT Title, Release_date, [US_sales_(m)]
    FROM Album
    WHERE US_Billboard_200_peak = 1
    ORDER BY [US_sales_(m)] DESC
END
GO 
EXECUTE usp_Number_1_Albums
-- Done :)



/** Create a stored procedure called uspCountriesAsia to list out all the countries with ContinentId equal to 1, in alphabetical order **/

USE WorldEvents
GO

GO
CREATE PROCEDURE uspCountriesAsia AS
BEGIN 
    SELECT CountryName
    FROM tblCountry
    WHERE ContinentID = 1
    ORDER BY CountryName 
END
GO
EXECUTE uspCountriesAsia

/** modify the text of your query to create a different procedure called uspCountriesEurope which lists all the countries in continent id number 3, and check that this works **/
GO
CREATE PROCEDURE uspCountriesEurope AS
BEGIN 
    SELECT CountryName
    FROM tblCountry
    WHERE ContinentID = 3
    ORDER BY CountryName 
END
GO
EXECUTE uspCountriesEurope

/** Change the uspCountriesAsia procedure so that it lists out the CountryId too **/
GO
ALTER PROCEDURE uspCountriesAsia AS
BEGIN 
    SELECT CountryID, CountryName
    FROM tblCountry
    WHERE ContinentID = 1
    ORDER BY CountryName 
END
GO
EXECUTE uspCountriesAsia
--Done :)



/** Create a query to return the following columns from the Artist, Tour and Show tables: 
Artist, Tour _name, Tickets_sold, Revenue_$ **/

USE Music_01
GO

SELECT A.Artist, T.Tour_name, S.Tickets_sold, S.Revenue_$
FROM Artist AS A 
    JOIN TOUR AS T ON A.Artist_ID = T.Artist_ID
    JOIN Show AS S ON T.Tour_ID = S.Tour_ID

/** Modify the query to GROUP BY the Artist and Tour_name columns, 
summing the TIckets_sold and Revenue_$ fields and sorting the results in descending order of total revenue. **/
SELECT 
    A.Artist, 
    Tour_name, 
    SUM(Tickets_sold) AS [Total tickets sold], 
    SUM(Revenue_$) AS [Total revenue]
FROM Artist AS A 
    JOIN TOUR AS T ON A.Artist_ID = T.Artist_ID
    JOIN Show AS S ON T.Tour_ID = S.Tour_ID
GROUP BY A.Artist, Tour_name
ORDER BY [Total revenue] DESC 

/** Use the query to create a stored procedure called usp_Tour_Totals.
Execute the script to create the procedure and then test that the procedure works. **/
GO
CREATE PROCEDURE usp_Tour_Totals AS
BEGIN 
    SELECT 
        A.Artist, 
        Tour_name, 
        SUM(Tickets_sold) AS [Total tickets sold], 
        SUM(Revenue_$) AS [Total revenue]
    FROM Artist AS A 
        JOIN TOUR AS T ON A.Artist_ID = T.Artist_ID
        JOIN Show AS S ON T.Tour_ID = S.Tour_ID
    GROUP BY A.Artist, Tour_name
    ORDER BY [Total revenue] DESC 
END
GO
EXEC usp_Tour_Totals

/** Alter the procedure so that it also returns the average of TIckets_sold and Revenue_$ 
and sort the results in descending order of the average revenue. Test that the procedure returns the extra columns when you execute it. **/
GO
ALTER PROCEDURE usp_Tour_Totals AS
BEGIN 
    SELECT 
        A.Artist, 
        Tour_name, 
        SUM(Tickets_sold) AS [Total tickets sold], 
        SUM(Revenue_$) AS [Total revenue],
        AVG(Tickets_sold) AS [Avg tickets sold],
        AVG(Revenue_$) AS [Avg revenue]
    FROM Artist AS A 
        JOIN TOUR AS T ON A.Artist_ID = T.Artist_ID
        JOIN Show AS S ON T.Tour_ID = S.Tour_ID
    GROUP BY A.Artist, Tour_name
    ORDER BY [Avg revenue] DESC
END
GO
EXEC usp_Tour_Totals
-- Done :)



/** Create a stored procedure to list Dr Who episodes featuring Matt Smith
--> WE WANT: Series, Episode, title, date, dcotor **/

USE DoctorWho
GO

GO
CREATE PROC uspMattSmithEpisodes AS
BEGIN 
    SELECT SeriesNumber, EpisodeNumber, Title, EpisodeDate, DoctorName
    FROM tblEpisode AS E 
    JOIN tblDoctor AS D ON E.DoctorId = D.DoctorId
    WHERE DoctorName = 'Matt Smith'
END
GO
EXEC uspMattSmithEpisodes

/** Now change your script so that it alters the stored procedure to list out only those episodes featuring Matt Smith made in 2012 **/
GO
ALTER PROC uspMattSmithEpisodes AS
BEGIN 
    SELECT SeriesNumber, EpisodeNumber, Title, EpisodeDate, DoctorName
    FROM tblEpisode AS E 
    JOIN tblDoctor AS D ON E.DoctorId = D.DoctorId
    WHERE DoctorName = 'Matt Smith' AND EpisodeDate >= '2012-01-01' AND EpisodeDate < '2013-01-01'
END
GO
EXEC uspMattSmithEpisodes
-- Done :)



/** Create a SQL stored procedure to return a list of rock and roll music albums
--> WE WANT: Title, artist, subgenre, relase_date, us_billboard_200_peak.
--> Sort the albums alphabetically by Title. **/

USE Music_01
GO

SELECT DISTINCT(Subgenre) FROM Subgenre
WHERE Subgenre LIKE '%Rock%roll%'

GO
CREATE PROC usp_Rock_and_Roll_Albums AS
BEGIN 
    SELECT Title, Artist, Subgenre, Release_date, US_Billboard_200_peak
    FROM Album AS Alb
        JOIN Artist AS Art ON Alb.Artist_ID = Art.Artist_ID
        JOIN Subgenre AS Sub ON Alb.Subgenre_ID = Sub.Subgenre_ID
    WHERE Subgenre = 'Rock and roll'
    ORDER BY Title
END 
GO
EXEC usp_Rock_and_Roll_Albums

/** Alter the procedure to return the extra columns shown below: Artist_type, US_sales **/
GO
ALTER PROC usp_Rock_and_Roll_Albums AS
BEGIN 
    SELECT Title, Artist, Artist_type, Subgenre, Release_date, [US_sales_(m)], US_Billboard_200_peak
    FROM Album AS Alb
        JOIN Artist AS Art ON Alb.Artist_ID = Art.Artist_ID
        JOIN Subgenre AS Sub ON Alb.Subgenre_ID = Sub.Subgenre_ID
    WHERE Subgenre = 'Rock and roll'
    ORDER BY Title
END 
GO
EXEC usp_Rock_and_Roll_Albums
-- Done :)



/** Create a procedure called spSummariseEpisodes to show:

the 3 most frequently-appearing companions; then separately
the 3 most frequently-appearing enemies. **/

USE DoctorWho
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'uspSummariseEpisodes')
DROP PROCEDURE uspSummariseEpisodes
GO
CREATE PROC uspSummariseEpisodes AS
BEGIN
    BEGIN
        SELECT 
            TOP 3 (CompanionName), 
            COUNT(*) AS Episodes
        FROM tblEpisode AS E 
            JOIN tblEpisodeCompanion AS EC ON E.EpisodeId = EC.EpisodeId
            JOIN tblCompanion AS C ON EC.CompanionId = C.CompanionId
        GROUP BY CompanionName
        ORDER BY Episodes DESC
    END
    BEGIN  
        SELECT 
            TOP 3(EnemyName),
            COUNT(*) AS Episodes
        FROM tblEpisode AS EP 
            JOIN tblEpisodeEnemy AS EE ON EP.EpisodeId = EE.EpisodeId
            JOIN tblEnemy AS EN ON EE.EnemyId = EN.EnemyId
        GROUP BY EnemyName
        ORDER BY Episodes DESC
    END
END
GO
EXEC uspSummariseEpisodes

/** Change your script to alter your procedure 
so that it shows the 5 least-frequently appearing companions, and 5 least-frequently appearing enemies. **/
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'uspSummariseEpisodes')
DROP PROCEDURE uspSummariseEpisodes
GO
CREATE PROC uspSummariseEpisodes AS
BEGIN
    BEGIN
        SELECT 
            TOP 5 (CompanionName), 
            COUNT(*) AS Episodes
        FROM tblEpisode AS E 
            JOIN tblEpisodeCompanion AS EC ON E.EpisodeId = EC.EpisodeId
            JOIN tblCompanion AS C ON EC.CompanionId = C.CompanionId
        GROUP BY CompanionName
        ORDER BY Episodes, CompanionName 
    END
    BEGIN  
        SELECT 
            TOP 5 (EnemyName),
            COUNT(*) AS Episodes
        FROM tblEpisode AS EP 
            JOIN tblEpisodeEnemy AS EE ON EP.EpisodeId = EE.EpisodeId
            JOIN tblEnemy AS EN ON EE.EnemyId = EN.EnemyId
        GROUP BY EnemyName
        ORDER BY Episodes, EnemyName 
    END
END
GO
EXEC uspSummariseEpisodes
-- Done :)



/** The aim of this exercise is to create a stored procedure called uspAugustEvents 
which will show all events that occurred in the month of August **/

USE WorldEvents
GO

GO
CREATE PROC uspAugustEvents AS
BEGIN
    SELECT EventID, EventName, EventDetails, EventDate
    FROM tblEvent
    WHERE MONTH(EventDate) = 8
END
GO 
EXEC uspAugustEvents
-- Done :)



/** Create a stored procedure to list Dr Who episodes written by Steven Moffat in order by most recent **/

USE DoctorWho
GO

GO
CREATE PROC uspMoffat AS 
BEGIN
    SELECT Title
    FROM tblEpisode AS E 
        JOIN tblAuthor AS A ON E.AuthorId = A.AuthorId
    WHERE AuthorName = 'Steven Moffat'
    ORDER BY EpisodeDate DESC
END
GO
EXEC uspMoffat

/** Now amend your SQL so that it creates a different stored procedure called spRussell, 
listing out the 30 episodes penned by people called Russell **/
GO
CREATE PROC uspRussell AS 
BEGIN
    SELECT Title
    FROM tblEpisode AS E 
        JOIN tblAuthor AS A ON E.AuthorId = A.AuthorId
    WHERE AuthorName LIKE '%Russell%'
    ORDER BY EpisodeDate DESC
END
GO
EXEC uspRussell
--Done :)

