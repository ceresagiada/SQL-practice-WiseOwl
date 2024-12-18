/** Create a stored procedure called spCalculateAge which:

Declares an integer variable called @Age

Sets the value of this variable to be the difference in years between your date of birth and today's date 

Prints out your age **/
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spCalculateAge')
DROP PROCEDURE spCalculateAge
GO
CREATE PROCEDURE spCalculateAge
AS 
BEGIN 
    DECLARE @Age int 
    SET @Age = DATEDIFF(year, '1994-11-04', GETDATE())
    PRINT 'You are ' + CAST(@Age AS varchar(3)) + ' years old.'
END
GO
EXEC spCalculateAge
-- This works but it's not the correct age

GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spCalculateAge')
DROP PROCEDURE spCalculateAge
GO
CREATE PROCEDURE spCalculateAge
AS 
BEGIN 
    DECLARE @Age int 
    DECLARE @DOB date = '1994-11-04'
    SET @Age = DATEDIFF(year, @DOB, GETDATE())
    IF
            MONTH(@DOB) < MONTH(GETDATE()) 
            OR
            (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) <= DAY(GETDATE()))
    BEGIN
        PRINT 'You are ' + CAST(@Age AS varchar(3)) + ' years old.'
    END
    PRINT 'You are ' + CAST(@Age-1 AS varchar(3)) + ' years old.'
END
GO
EXEC spCalculateAge
-- it works

--now let's make it dynamic
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spCalculateAge')
DROP PROCEDURE spCalculateAge 
GO
CREATE PROCEDURE spCalculateAge (@datebirth date)
AS 
BEGIN 
    DECLARE @Age int 
    DECLARE @DOB date = @datebirth
    SET @Age = DATEDIFF(year, @DOB, GETDATE())
    IF
            MONTH(@DOB) < MONTH(GETDATE()) 
            OR
            (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) <= DAY(GETDATE()))
    BEGIN
        PRINT 'You are ' + CAST(@Age AS varchar(3)) + ' years old.'
    END
    PRINT 'You are ' + CAST(@Age-1 AS varchar(3)) + ' years old.'
END
GO
EXEC spCalculateAge '1994-11-04' 

EXEC spCalculateAge '2008-06-25'
-- There is a problem: it shows the result twice

--> I need to change the proc
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spCalculateAge')
DROP PROCEDURE spCalculateAge 
GO
CREATE PROCEDURE spCalculateAge (@datebirth date)
AS 
BEGIN 
    DECLARE @Age int 
    DECLARE @DOB date = @datebirth
    SET @Age = DATEDIFF(year, @DOB, GETDATE())
    IF
            MONTH(@DOB) > MONTH(GETDATE()) 
            OR
            (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
    BEGIN
        SET @Age = @Age -1
    END
    PRINT 'You are ' + CAST(@Age AS varchar(3)) + ' years old.'
END
GO
EXEC spCalculateAge '2008-06-25' 
-- Done :)




/** The aim of this exercise is to summarise events using the MIN, MAX and COUNT functions:

@EarliestDate	The earliest date
@LatestDate	The latest date
@NumberOfEvents	The number of events
@EventInfo	The title Summary of events

The snag?  You're not allowed to use GROUP BY! **/

USE WorldEvents
GO

DECLARE @EarliestDate date
DECLARE @LatestDate date
DECLARE @NumberOfEvents int 
DECLARE @EventInfo varchar(50)

SELECT 
    @EarliestDate = MIN(EventDate),
    @LatestDate = MAX(EventDate),
    @NumberOfEvents = COUNT(*),
    @EventInfo = 'Summary of events'
FROM tblEvent

SELECT 
    @EventInfo AS Title,
    @EarliestDate AS [Earliest Date],
    @LatestDate AS [Latest Date],
    @NumberOfEvents AS [Number Of Events]
-- Done :)
-- The purpose of using variables is in order not to use GROUP BY 
    --> if you have "SELECT MIN(), MAX(), COUNT(*) FROM tbl" you need a GROUP BY



/** Write a SQL statement which brings back the top 3 events in your year of birth, in event name order. 

What we'd really like to do is to join the events into a single string variable called @EventsInYear **/

USE WorldEvents
GO

SELECT TOP 3 EventName
FROM tblEvent
WHERE EventDate >= '1994-01-01' AND EventDate < '1995-01-01'
ORDER BY EventName 

DECLARE @EventsInYear varchar(MAX) = ''

SELECT @EventsInYear = @EventsInYear +  Eve.EventName + ',' 
FROM 
(
    SELECT TOP 3 EventName 
    FROM tblEvent
    WHERE EventDate >= '1994-01-01' AND EventDate < '1995-01-01'
    ORDER BY EventName 
) AS Eve

SELECT @EventsInYear AS [Eventful Year]
-- It works

-- Let's make it a dynamic procedure
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spEventfulYear')
DROP PROCEDURE spEventfulYear
GO
CREATE PROCEDURE spEventfulYear (@BirthDate date)
AS
BEGIN 
    DECLARE @EventsInYear varchar(MAX) = ''
    SELECT @EventsInYear = @EventsInYear +  Eve.EventName + ', ' 
    FROM 
    (
        SELECT TOP 3 EventName 
        FROM tblEvent
        WHERE YEAR(EventDate) = YEAR(@BirthDate)
        ORDER BY EventName 
    ) AS Eve
    IF LEN(@EventsInYear) = 0
        BEGIN
            SELECT 'No events this year' AS [Eventful Year]
        END
    SELECT @EventsInYear AS [Eventful Year]
END
GO
EXEC spEventfulYear '1994-11-04'
EXECUTE spEventfulYear '2024-01-01'
-- Done :)



/** The aim of this exercise is to use variables to present some information about yourself as a little sentence:
My name is Sam Lowrie, I was born on 26/04/1981 and I have 8 pets **/
USE master
GO

DECLARE @name varchar(50) = 'Giada Ceresa'
DECLARE @DOB date = '1994-11-04'
DECLARE @petcount int = 1

SELECT 'My name is ' + @name + ', I was born on ' + CONVERT(char(10), @DOB) + ' and I have ' + CONVERT(varchar(3),@petcount) + ' pets.' AS [Fun Facts]

-- Let's make it a procedure
GO 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spFunFacts')
DROP PROC spFunFacts 
GO
CREATE PROC spFunFacts (@yourname varchar(50), @yourDOB date, @yourpetcount int) 
AS 
BEGIN
    DECLARE @name varchar(50) = @yourname
    DECLARE @DOB date = @yourDOB
    DECLARE @petcount int = @yourpetcount 
    DECLARE @petword varchar(6) = CASE WHEN @petcount = 1 THEN ' pet.' ELSE ' pets.' END
    SELECT 'My name is ' + @name + ', I was born on ' + CONVERT(char(10), @DOB) + ' and I have ' + CONVERT(varchar(3),@petcount) + @petword AS [Fun Facts]
END
GO
EXEC spFunFacts 'Giada Ceresa', '1994-11-04', 1
-- Done :)



/** The aim of this exercise is to generate a list of events that occurred in the year that you were born:
EventName, EventDate, CountryName

To do this, first create two appropriately named variables to store the first date of your year of birth and the last,  
then use these variables to filter your results to show only events occurring between these two dates. **/
USE WorldEvents
GO

GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spEventsInYear')
DROP PROCEDURE spEventsInYear
GO
CREATE PROCEDURE spEventsInYear AS
BEGIN 
    DECLARE @YearStart date = '1994-01-01'
    DECLARE @YearEnd date = '1994-12-31'
    SELECT EventName, EventDate, CountryName
    FROM tblEvent AS E 
        JOIN tblCountry AS C ON E.CountryID = C.CountryID
    WHERE EventDate BETWEEN @YearStart AND @YearEnd
END
GO
EXEC spEventsInYear

/** Change the value of your variables to a different year's start/end, and rerun your query to check that it gives the correct events **/
GO 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spEventsInYear')
DROP PROCEDURE spEventsInYear
GO
CREATE PROCEDURE spEventsInYear AS
BEGIN 
    DECLARE @YearStart date = '1969-01-01'
    DECLARE @YearEnd date = '1969-12-31'
    SELECT EventName, EventDate, CountryName
    FROM tblEvent AS E 
        JOIN tblCountry AS C ON E.CountryID = C.CountryID
    WHERE EventDate BETWEEN @YearStart AND @YearEnd
END
GO
EXEC spEventsInYear

/** wouldn't it be nice if you could make a stored procedure pick up on different dates each time that you ran it? **/
GO 
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spEventsInYear')
DROP PROCEDURE spEventsInYear
GO
CREATE PROCEDURE spEventsInYear (@yourYearStart date, @yourYearEnd date) AS
BEGIN 
    DECLARE @YearStart date = @yourYearStart
    DECLARE @YearEnd date = @yourYearEnd
    SELECT EventName, EventDate, CountryName
    FROM tblEvent AS E 
        JOIN tblCountry AS C ON E.CountryID = C.CountryID
    WHERE EventDate BETWEEN @YearStart AND @YearEnd
END
GO
EXEC spEventsInYear '1994-01-01', '1994-12-31'
-- Done :)



/** Create a variable to hold a given doctor's number (choose between 9, 10, 11 and 12!). 
The aim of this exercise is to use the SQL PRINT statement to show the following information about the doctor you've chosen:
"Doctor name:", "Episodes appeared in:" **/
USE DoctorWho
GO

SELECT DISTINCT(DoctorId) FROM tblDoctor

DECLARE @DocNumber int = 1

DECLARE @DocName varchar(50) = (SELECT DoctorName FROM tblDoctor WHERE DoctorId = @DocNumber)
SELECT @DocName

DECLARE @DocEpisodes int = (SELECT COUNT(*) FROM tblEpisode WHERE DoctorId = @DocNumber)
SELECT @DocEpisodes 

PRINT 'Results for doctor number 1:'
PRINT '---------------------------'
PRINT ''
PRINT 'Doctor name: ' + @DocName
PRINT ''
PRINT 'Episodes appeared in: ' + CAST(@DocEpisodes AS varchar(3))

/** Let's make it a procedure **/
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spDocDetails')
DROP PROCEDURE spDocDetails
GO
CREATE PROCEDURE spDocDetails (@yourDocNumber int)
AS
BEGIN
    IF EXISTS (SELECT DISTINCT(DoctorId) FROM tblDoctor WHERE DoctorId = @yourDocNumber)
        BEGIN
            DECLARE @DocNumber int = @yourDocNumber
            DECLARE @DocName varchar(50) = (SELECT DoctorName FROM tblDoctor WHERE DoctorId = @DocNumber)
            DECLARE @DocEpisodes int = (SELECT COUNT(*) FROM tblEpisode WHERE DoctorId = @DocNumber)
            PRINT 'Results for doctor number 1:'
            PRINT '---------------------------'
            PRINT ''
            PRINT 'Doctor name: ' + @DocName
            PRINT ''
            PRINT 'Episodes appeared in: ' + CAST(@DocEpisodes AS varchar(3)) 
        END
    ELSE 
        BEGIN
            PRINT 'No doctor for this ID'
        END 
END
GO
EXEC spDocDetails 1
EXEC spDocDetails 20
-- Done :)



/** The aim of this exercise is to show a list of all of the Doctor's enemies for a given episode: **/
USE DoctorWho
GO

SELECT 
    Ep.EpisodeId AS [Episode id],  
    En.EnemyName AS [Enemies]
FROM tblEpisode AS Ep 
    JOIN tblEpisodeEnemy AS EE ON Ep.EpisodeId = EE.EpisodeId
    JOIN tblEnemy AS En ON EE.EnemyId = En.EnemyId

begin tran 
DECLARE @EpisodeId int = 15
DECLARE @EnemyList varchar(max) = ''

SELECT @EnemyList = @EnemyList + Enemies.EnemyName  + ', '
FROM (SELECT  
    En.EnemyName 
FROM tblEpisode AS Ep 
    JOIN tblEpisodeEnemy AS EE ON Ep.EpisodeId = EE.EpisodeId
    JOIN tblEnemy AS En ON EE.EnemyId = En.EnemyId
WHERE Ep.EpisodeId = @EpisodeId) AS Enemies 

SELECT @EpisodeId AS [Episode id], @EnemyList
commit tran

/* Let's make it into a procedure */
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'spDocEnemies')
DROP PROCEDURE spDocEnemies
GO
CREATE PROCEDURE spDocEnemies (@yourEpisodeId int)
AS
BEGIN
    DECLARE @EpisodeId int = @yourEpisodeId
    IF EXISTS (SELECT EpisodeId FROM tblEpisode WHERE EpisodeId = @yourEpisodeId )
        BEGIN
            DECLARE @EnemyList varchar(max) = ''
            SELECT @EnemyList = @EnemyList + Ene.EnemyName  + ', '
            FROM (SELECT En.EnemyName 
                FROM tblEpisode AS Ep 
                    JOIN tblEpisodeEnemy AS EE ON Ep.EpisodeId = EE.EpisodeId
                    JOIN tblEnemy AS En ON EE.EnemyId = En.EnemyId
                WHERE Ep.EpisodeId = @EpisodeId) AS Ene 
            SELECT @EpisodeId AS [Episode id], @EnemyList AS [Enemies]
        END
    ELSE 
        BEGIN
            SELECT @EpisodeId AS [Episode id], 'No episodes' AS [Enemies]
        END
END
GO
EXEC spDocEnemies 15
EXEC spDocEnemies 3000



/** Use variables in SQL to capture statistics about venues in a database of music. **/
USE Music_01
GO

-- Write a SELECT statement to return the averages of the Capacity and Construction_cost_$m fields from the Venue table. 
-- Include a WHERE clause to exclude rows where either field is NULL.
SELECT 
    AVG(CONVERT(float,Capacity)) AS AVG_Capacity, 
    AVG(Construction_cost_$m) AS AVG_Cost
FROM Venue
WHERE Capacity IS NOT NULL AND Construction_cost_$m IS NOT NULL

-- Declare two variables called @AvgCapacity and @AvgCost and use them to capture the results of your query.
DECLARE @AvgCapacity float
DECLARE @AvgCost float 

SELECT @AvgCapacity = AVG(CONVERT(float,Capacity)) 
    FROM Venue
    WHERE Capacity IS NOT NULL AND Construction_cost_$m IS NOT NULL

SELECT @AvgCost = AVG(Construction_cost_$m)
    FROM Venue
    WHERE Capacity IS NOT NULL AND Construction_cost_$m IS NOT NULL

-- Write a new SELECT statement which uses the values of the variables 
-- to return a list of venues with a higher than average capacity and construction cost.
SELECT Venue, Opening_date, Capacity, Construction_cost_$m
FROM Venue
WHERE Capacity > @AvgCapacity AND Construction_cost_$m > @AvgCost
ORDER BY Capacity, Construction_cost_$m
-- Done :)



/** Use variables to store the values used in the WHERE clause of SQL queries. **/
USE Music_01
GO

-- Write two queries to return a list of albums and songs whose titles contain the word love.
SELECT Title, Release_date, US_Billboard_200_peak
FROM Album
WHERE Title LIKE '%love%'

SELECT Track_name, Single_release_date, US_Billboard_Hot_100_peak
FROM Track
WHERE Track_name LIKE '%love%'

-- Above the first SELECT statement in the script, declare a variable called @NameContains with a data type of NVARCHAR(255). 
-- Set the value of this variable to '%love%'.
-- Modify the WHERE clause of each query to refer to the value of the @NameContains variable instead of the text '%love%'.
--Execute the script to make sure you see the same results.
begin tran
DECLARE @NameContains nvarchar(255) = '%love%'

SELECT Title, Release_date, US_Billboard_200_peak
FROM Album
WHERE Title LIKE @NameContains

SELECT Track_name, Single_release_date, US_Billboard_Hot_100_peak
FROM Track
WHERE Track_name LIKE @NameContains
commit tran

-- Declare another variable according to the following table:
-- Variable name = @ReleasedAfter;  Data type = DATE;  Initial value = '1964-01-01'
-- Modify each query to refer to the value of the new variable then execute the script to check the results are the same
GO
begin tran
DECLARE @NameContains nvarchar(255) = '%love%'
DECLARE @ReleasedAfter date = '1964-01-01'

SELECT Title, Release_date, US_Billboard_200_peak
FROM Album
WHERE Title LIKE @NameContains AND Release_date >= @ReleasedAfter

SELECT Track_name, Single_release_date, US_Billboard_Hot_100_peak
FROM Track
WHERE Track_name LIKE @NameContains AND Single_release_date >= @ReleasedAfter
commit tran

-- In between the two SELECT statements, add a SET statement to change the value of the @NameContains variable to '%hate%'.
GO
begin tran
DECLARE @NameContains nvarchar(255) = '%love%'
DECLARE @ReleasedAfter date = '1964-01-01'

SELECT Title, Release_date, US_Billboard_200_peak
FROM Album
WHERE Title LIKE @NameContains AND Release_date >= @ReleasedAfter

SET @NameContains = '%hate%'

SELECT Track_name, Single_release_date, US_Billboard_Hot_100_peak
FROM Track
WHERE Track_name LIKE @NameContains AND Single_release_date >= @ReleasedAfter
commit tran

-- Try changing the values of the variables to return different results.
GO
begin tran
DECLARE @NameContains nvarchar(255) = '%love%'
DECLARE @ReleasedAfter date = '1964-01-01'

SELECT Title, Release_date, US_Billboard_200_peak
FROM Album
WHERE Title LIKE @NameContains AND Release_date >= @ReleasedAfter

SET @NameContains = '%war%'

SELECT Track_name, Single_release_date, US_Billboard_Hot_100_peak
FROM Track
WHERE Track_name LIKE @NameContains AND Single_release_date >= @ReleasedAfter
commit tran
-- Done :)


   
/** Use variables in SQL to capture the results of aggregation functions in queries of a Music database. **/
USE Music_01
GO

-- Create a script to see the count of albums and tracks in the database.
SELECT COUNT(*) AS Count_Album
FROM [dbo].[Album]

SELECT COUNT(*) AS Count_Tracks
FROM [dbo].[Track]

-- Declare two FLOAT variables called @CountAlbums and @CountTracks and use them to capture the results of the two queries.
DECLARE @CountAlbums float = (SELECT COUNT(*) AS Count_Album
                              FROM [dbo].[Album])

DECLARE @CountTracks float = (SELECT COUNT(*) AS Count_Tracks
                              FROM [dbo].[Track])

-- Declare another variable called @AvgTracksPerAlbum and use it to store the result of dividing the count of tracks by the count of albums.
-- Write a SELECT statement to display the values of the three variables, using appropriate aliases as shown below:
-- Count Albums, Count Tracks, Avg Tracks per Album
GO
begin tran 
DECLARE @CountAlbums float = (SELECT COUNT(*) AS Count_Album
                              FROM [dbo].[Album])

DECLARE @CountTracks float = (SELECT COUNT(*) AS Count_Tracks
                              FROM [dbo].[Track])

DECLARE @AvgTracksPerAlbum float = @CountTracks / @CountAlbums

SELECT 
    @CountAlbums AS [Count Albums],
    @CountTracks AS [Count Tracks],
    @AvgTracksPerAlbum AS [Avg tracks per Album]
commit tran 

-- Use three new variables to calculate the average number of shows per venue. Present the results as shown below:
-- Count Venues, Count Shows, Avg Shows per Venue
GO
begin tran 
DECLARE @CountVenues float = (SELECT COUNT(*)
                              FROM [dbo].[Venue])

DECLARE @CountShows float = (SELECT COUNT(*)
                              FROM [dbo].[Show])

DECLARE @AvgShowsperVenue float = @CountShows / @CountVenues

SELECT 
    @CountVenues AS [Count Venues],
    @CountShows AS [Count Shows],
    @AvgShowsperVenue AS [Avg Shows per Venue]
commit tran 
-- Done :)