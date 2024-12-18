

USE WorldEvents
GO

/** 
Create a query to list out the following columns from the tblEvent table, 
with the most recent first (for which you'll need to use an ORDER BY clause):

The event name
The event date

**/

SELECT EventName, EventDate
FROM tblEvent
ORDER BY EventDate DESC
-- Done :)



/** Create a query to list out the id number and name of the last 3 categories from the tblCategory table in alphabetical order **/

SELECT TOP(3) CategoryID, CategoryName
FROM tblCategory
ORDER BY CategoryName DESC
-- Done :)



/** Create a query which uses two separate SELECT statements to show the first and last 2 events in date order from the tblEvent table **/

SELECT TOP(2) EventName AS What, EventDate AS [When] 
FROM tblEvent
ORDER BY EventDate ASC

SELECT TOP(2) EventName AS What, EventDate AS[When]
FROM tblEvent
ORDER BY EventDate DESC 
-- Done BUT can't redirect to text



/** Write a query to show the first 5 events (in date order) from the tblEvent table **/

SELECT TOP(5) EventName AS What, EventDetails AS Details
FROM tblEvent
ORDER BY EventDate
-- Done :)



/** Write a query to list out all of the events from the tblEvent table in category number 11 
(which corresponds to Love and Relationships, as it happens)**/

SELECT EventName, EventDate
FROM tblEvent
WHERE CategoryID = 11
-- Done :)



/** Create a query which lists out all of the events which took place in February 2005 **/
SELECT EventName AS What, EventDate AS [When]
FROM tblEvent
WHERE month(EventDate) = 02 AND year(EventDate) = 2005

SELECT EventName AS What, EventDate AS [When]
FROM tblEvent
WHERE EventDate BETWEEN '2005-02-01' AND '2005-02-28'
-- Suggested way to do it

SELECT EventName AS What, EventDate AS [When]
FROM tblEvent
WHERE EventDate LIKE '2005-02-%'
-- All work



/** First show a list of all events which might have something to do water.  

The Wise Owl interpretation of this is that one or more of the following is true:
They take place in one of the island countries (8, 22, 30 and 35)
Their EventDetails column contains the word Water 
Their category is number 4 (Natural World)
This should return 11 rows.  

Now add a criterion to show only those events which happened since 1970 **/

SELECT EventName, EventDetails, EventDate
FROM tblEvent
WHERE 
    (CountryID IN (8, 22, 30, 35) OR
    EventDetails LIKE '% water %' OR
    CategoryID = 4)
    AND EventDate >= '1970-01-01'
-- Done :)



/** Create a query which lists out all of the tblEvent events which include the word Teletubbies 

Now add an OR condition to your query so that it lists out all events whose:
Name includes Teletubbies; or
Name includes Pandy **/

SELECT EventName, EventDate
FROM tblEvent
WHERE EventName LIKE '%Teletubbies%'

SELECT EventName, EventDate
FROM tblEvent
WHERE EventName LIKE '%Teletubbies%' OR EventName LIKE '%Pandy%'
-- Done :)



/** 
Events which aren't in the Transport category (number 14), but which nevertheless include the text Train in the EventDetails column.	4 rows

Events which are in the Space country (number 13), but which don't mention Space in either the event name or the event details columns.	6 rows

Events which are in categories 5 or 6 (War/conflict and Death/disaster), but which don't mention either War or Death in the EventDetails column.	91 rows
**/

SELECT EventName, EventDetails, CategoryID
FROM tblEvent
WHERE CategoryID <> 14 AND EventDetails LIKE '%Train%'

SELECT EventName, EventDetails, CountryID
FROM tblEvent
WHERE CountryID = 13 AND EventName NOT LIKE '%Space%' AND EventDetails NOT LIKE '%Space%'

SELECT EventName, EventDetails, CategoryID
FROM tblEvent
WHERE CategoryID IN (5,6) AND EventDetails NOT LIKE '%War%' AND EventDetails NOT LIKE '%Death%'
-- Done :)