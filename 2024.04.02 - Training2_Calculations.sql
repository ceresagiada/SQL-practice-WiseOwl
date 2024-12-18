USE WorldEvents
GO



/** Create a query listing out each event with the length of its name, with the "shortest event" first **/

SELECT EventName, LEN(EventName) AS [Lenght of name]
FROM tblEvent
ORDER BY LEN(EventName)
-- Done :)



/** 
Write a query to divide countries into these groups:

Continent id	Belongs to	    Actual continent (for interest)
1 or 3	        Eurasia	        Europe or Asia
5 or 6	        Americas	    North and South America
2 or 4	        Somewhere hot	Africa and Australasia
7	            Somewhere cold	Antarctica
Otherwise	    Somewhere else	International
**/

SELECT CountryName,
CASE
    WHEN ContinentID IN (1,3) THEN 'Eurasia'
    WHEN ContinentID IN (5,6) THEN 'Americas'
    WHEN ContinentID IN (2,4) THEN 'Somewhere hot'
    WHEN ContinentID = 7 THEN 'Somewhere cold'
    ELSE 'Somewhere else'
    END AS CountryLocation
FROM tblCountry
ORDER BY CountryLocation DESC
-- Done :)



/** 
First create the following columns in a query:

Column	        What it should show
AreaLeftOver	The remainder when you divide a country's area by the area of Wales
WalesUnits	    The number of exact times that the area of Wales divides a country's area, once you've subtracted the area left over as calculated above

Wales is 20,761 square kilometres in area
**/

SELECT 
    Country, 
    KmSquared/20761 AS WalesUnit,
    KmSquared-(20761*(KmSquared/20761)) AS AreaLeftOver
FROM CountriesByArea
ORDER BY Country ASC
-- Done :)

/** Now extend your query to show a text description of how many times each country could accommodate Wales **/
SELECT 
    Country, 
    KmSquared/20761 AS WalesUnit,
    KmSquared-(20761*(KmSquared/20761)) AS AreaLeftOver,
    CASE
        WHEN KmSquared/20761 >0 THEN (CONVERT(varchar, KmSquared/20761) + ' x Wales plus ' + CONVERT(varchar,KmSquared-(20761*(KmSquared/20761))) + ' sq. km.') 
        ELSE 'Smaller than Wales'
    END AS WalesComparison
FROM CountriesByArea
ORDER BY Country ASC

/** Finally, change your query's sort order so that it lists countries with the closest in size to Wales first **/

SELECT 
    Country, 
    KmSquared/20761 AS WalesUnit,
    KmSquared-(20761*(KmSquared/20761)) AS AreaLeftOver,
    CASE
        WHEN KmSquared/20761 >0 THEN (CONVERT(varchar, KmSquared/20761) + ' x Wales plus ' + CONVERT(varchar,KmSquared-(20761*(KmSquared/20761))) + ' sq. km.') 
        ELSE 'Smaller than Wales'
    END AS WalesComparison
FROM CountriesByArea
ORDER BY ABS(KmSquared-20761)
-- Done :)

-- I could have used the % modulus for AreaLeftOver
SELECT KmSquared % 20761 AS [AreaLeftOver%], KmSquared-(20761*(KmSquared/20761)) AS AreaLeftOver
FROM CountriesByArea
-- It is the same



/** 
Create a query to list out for each event the category number that it belongs to.

Apply a WHERE criteria to show only those events in country number 1 (Ukraine) **/

SELECT (EventName + ' (category ' + CAST(CategoryID AS char(1)) + ')') AS [Event (category)], EventDate
FROM tblEvent
WHERE CountryID=1
-- Done :)



/** 
Write a query to list out all of the non-boring events
A non-boring event is one which doesn't begin and end with the same letter, and which doesn't begin and end with a vowel 
**/

SELECT 
    EventName, 
    CASE
        WHEN LEFT(EventName,1)=RIGHT(EventName,1) THEN 'Same letter'
        WHEN LEFT(EventName,1) IN ('A','E','I','O','U') AND RIGHT(EventName,1) IN ('A','E','I','O','U') THEN 'Begins and ends with vowel'
    END
FROM tblEvent
WHERE 
    LEFT(EventName,1)=RIGHT(EventName,1)
    OR
    (LEFT(EventName,1) IN ('A','E','I','O','U') AND RIGHT(EventName,1) IN ('A','E','I','O','U'))



/** The aim of this exercise is to find this and that in the EventDetails column (in that order) **/

-- CHARINDEX: shows the position of a character or combination of characters in the string
    --> needs 3 arguments: 
        --1. characters to test for
        --2. string to test for
        --3. number of the character where it should start counting

SELECT 
    EventName,
    EventDate,
    --EventDetails,
    CHARINDEX('this',EventDetails,1) AS thisPosition,
    CHARINDEX('that',EventDetails,1) AS thatPosition,
    CHARINDEX('that',EventDetails,1)-CHARINDEX('this',EventName,1) AS Offset 
FROM tblEvent
WHERE 
    EventDetails LIKE '%this%' AND
    EventDetails LIKE '%that%' AND
    CHARINDEX('that',EventDetails,1)>CHARINDEX('this',EventDetails,1)
-- Done :)



/**
The tblContinent table lists out the world's continents, but there are gaps
--> fill in the gaps with the words "No summary",
--> add up to 3 columns: using ISNULL / COALESCE / CASE
**/

SELECT 
    ContinentName,
    Summary,
    ISNULL(Summary,'No summary') AS [Using ISNULL],
    COALESCE(Summary,'No summary') AS [Using COALESCE],
    CASE 
        WHEN Summary IS NOT NULL THEN Summary
        ELSE 'No summary'
    END AS [Using CASE]
FROM tblContinent
-- Done :)



/** Create a query showing events which took place in your year of birth, neatly formatted **/

SELECT EventName, EventDate
FROM tblEvent
WHERE DATEPART(year,EventDate)=1994



/** The idea behind this exercise is to see what was happening in the world around the time when you were born**/

/**First create a query to show the number of days which have elapsed for any event since your birthday **/
SELECT 
    EventName,
    EventDate,
    DATEDIFF(day,'1994-11-04',EventDate) AS [Days offset]
FROM tblEvent
ORDER BY EventDate DESC

/** Now list the events in order of closeness to your birthday **/
SELECT 
    EventName,
    EventDate,
    DATEDIFF(day,'1994-11-04',EventDate) AS [Days offset],
    ABS(DATEDIFF(day,'1994-11-04',EventDate)) AS [Days difference]
FROM tblEvent
ORDER BY [Days difference]



/** Create a query to show the day of the week and also the day number on which each event occurred **/

SELECT 
    EventName,
    EventDate,
    DATENAME(WEEKDAY,EventDate) AS [Day of week],
    DATEPART(DAY,EventDate) AS [Day number]
FROM tblEvent
-- Done :)

/** Use this to show:

That mercifully there weren't any events on Friday the 13th;
That there was one event on Thursday 12th (the day before); and
That there were two events on Saturday the 14th (the day after). **/

SELECT 
    EventName,
    EventDate,
    DATENAME(WEEKDAY,EventDate) AS [Day of week],
    DATEPART(DAY,EventDate) AS [Day number]
FROM tblEvent
WHERE 
    DATENAME(WEEKDAY,EventDate) = 'Friday' AND
    DATEPART(DAY,EventDate) = 13
-- No events

SELECT 
    EventName,
    EventDate,
    DATENAME(WEEKDAY,EventDate) AS [Day of week],
    DATEPART(DAY,EventDate) AS [Day number]
FROM tblEvent
WHERE 
    DATENAME(WEEKDAY,EventDate) = 'Thursday' AND 
    DATEPART(DAY,EventDate) = 12
-- 1 event

SELECT 
    EventName,
    EventDate,
    DATENAME(WEEKDAY,EventDate) AS [Day of week],
    DATEPART(DAY,EventDate) AS [Day number]
FROM tblEvent
WHERE 
    DATENAME(WEEKDAY,EventDate) = 'Saturday' AND 
    DATEPART(DAY,EventDate) = 14
-- 2 events
-- Done :)



/** Create a query to show the full dates for any event **/

SELECT 
    EventName,
    (DATENAME(WEEKDAY,EventDate) + ' ' + CAST(DAY(EventDate) AS varchar(10)) + 
    CASE 
        WHEN DAY(EventDate) = 1 THEN 'st'
        WHEN DAY(EventDate) = 2 THEN 'nd'
        WHEN DAY(EventDate) = 3 THEN 'rd'
        ELSE 'th'
    END + ' ' +
    DATENAME(MONTH,EventDate) + ' ' + CAST(YEAR(EventDate) AS varchar(10))) AS [Full date]
FROM tblEvent
ORDER BY EventDate ASC
-- Done :)