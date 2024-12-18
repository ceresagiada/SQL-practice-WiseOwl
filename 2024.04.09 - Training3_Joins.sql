/** Create a query containing a join to list out those films whose source is NA **/
USE Movies_02
GO

SELECT F.Title AS Film, S.Source
FROM 
    Source AS S JOIN Film AS F 
    ON S.SourceID = F.SourceID
WHERE Source = 'NA'



/** Create an inner join in a query, then change it to an outer join to show categories having no events **/ 

--1. Create a query which uses an inner join to link the categories table to the events table

USE WorldEvents
GO

SELECT E.EventName, E.EventDate, C.CategoryName
FROM 
    tblCategory AS C 
    JOIN tblEvent AS E 
    ON C.CategoryID = E.CategoryID
ORDER BY E.EventDate DESC

--2. Change the inner join to an outer join, so that you show for each category its events - even when there aren't any
SELECT E.EventName, E.EventDate, C.CategoryName
FROM 
    tblCategory AS C 
    LEFT JOIN tblEvent AS E 
    ON C.CategoryID = E.CategoryID
ORDER BY E.EventDate DESC
-- Done :)



/** Use inner joins to link four tables to show Dr Who enemies by author **/

USE DoctorWho
GO

SELECT En.EnemyName, Au.AuthorName FROM 
    tblEnemy AS En 
    JOIN tblEpisodeEnemy AS EpEn ON EN.EnemyId = EpEn.EnemyId
    JOIN tblEpisode AS Ep ON EpEn.EpisodeId = Ep.EpisodeId
    JOIN tblAuthor AS Au ON Ep.AuthorId = au.AuthorId

-- Show all of the authors who have written episodes featuring the Daleks
SELECT En.EnemyName, Au.AuthorName 
FROM 
    tblEnemy AS En 
    JOIN tblEpisodeEnemy AS EpEn ON EN.EnemyId = EpEn.EnemyId
    JOIN tblEpisode AS Ep ON EpEn.EpisodeId = Ep.EpisodeId
    JOIN tblAuthor AS Au ON Ep.AuthorId = au.AuthorId
WHERE En.EnemyName LIKE '%Daleks%'
-- Done :)



/** Create a query using the designer, joining 2 tables, then tidy it up and comment its SQL **/

USE WorldEvents
GO

SELECT 
    C.CountryName AS Country, 
    E.EventName AS [What happened], 
    E.EventDate AS [When happened]
FROM tblCountry AS C JOIN tblEvent AS E 
    ON C.CountryID = E.CountryID
ORDER BY E.EventDate ASC



/** Create a join to list out all of the doctors who appeared in episodes made in 2010 **/

USE DoctorWho
GO

SELECT D.DoctorName, E.Title
FROM tblDoctor AS D JOIN tblEpisode AS E 
    ON D.DoctorId = E.DoctorId
WHERE E.EpisodeDate BETWEEN '2010-01-01' AND '2010-12-31'
-- Done :)



/** Create a query using an outer join to list out those countries which have no corresponding events **/
USE WorldEvents 
GO

SELECT C.CountryName, E.EventName
FROM tblCountry AS C LEFT JOIN tblEvent AS E 
    ON C.CountryID = E.CountryID
WHERE E.EventName IS NULL
-- Done :)



/** Create a query that shows who wrote the "special" episodes in alphabetical order **/

USE DoctorWho
GO

SELECT A.AuthorName, E.Title, E.EpisodeType 
FROM tblAuthor AS A JOIN tblEpisode AS E 
    ON A.AuthorId = E.AuthorId
WHERE E.EpisodeType LIKE '%special%'
ORDER BY E.Title



/** Create a query to link together the following 3 tables:

tblContinent
tblCountry
tblEvent
Your query should list out those events which took place in either:

the continent called Antarctic; or
the country called Russia. **/

USE WorldEvents
GO

SELECT E.EventName, E.EventDate, Coun.CountryName, ContinentName 
FROM tblContinent AS Cont 
    JOIN tblCountry AS Coun ON Cont.ContinentID = Coun.ContinentID
    JOIN tblEvent AS E ON Coun.CountryID = E.CountryID
WHERE Coun.CountryName = 'Russia' OR Cont.ContinentName = 'Antarctic'
-- Done :)



/** Create a query to list out the appearances of enemies in episodes which have length under 40 characters, where the length is defined as the sum of:

the number of characters in the author's name;
the number of characters in the episode's title;
the number of characters in the doctor's name; and
the number of characters in the enemy's name. **/

USE DoctorWho
GO 

SELECT Au.AuthorName, Ep.Title, Dc.DoctorName, En.EnemyName,
    LEN(Au.AuthorName) + LEN(Ep.Title) + LEN(Dc.DoctorName) + LEN(En.EnemyName) AS [Total length]
FROM 
   tblAuthor AS Au 
   JOIN tblEpisode AS Ep ON Au.AuthorId = Ep.AuthorId
   JOIN tblDoctor AS Dc ON Ep.DoctorId = Dc.DoctorId
   JOIN tblEpisodeEnemy AS EpEn ON Ep.EpisodeId = EpEn.EpisodeId
   JOIN tblEnemy AS En ON EpEn.EnemyId = En.EnemyId
WHERE LEN(Au.AuthorName) + LEN(Ep.Title) + LEN(Dc.DoctorName) + LEN(En.EnemyName) < 40
-- Done :)



/** The database contains details of companions, and the episodes each appeared in.
Use this to list the names of the companions who haven't featured in any episodes **/

USE DoctorWho
GO

SELECT C.CompanionName
FROM tblCompanion AS C LEFT JOIN tblEpisodeCompanion AS EC
    ON C.CompanionId = EC.CompanionId 
WHERE EC.EpisodeId IS NULL
-- Done :)



/** Each row in the Family table contains a column called ParentFamilyId, which tells you which parent family any family belongs to 
(the All categories family - number 25 - has no parent, and so sits at the top of the hierarchy).

Create a query which links 3 tables  using outer joins **/
USE WorldEvents
GO

SELECT Family.FamilyName,
CASE 
    WHEN TopFamily.FamilyName IS NULL THEN '' 
    ELSE TopFamily.FamilyName + ' > '
END +
CASE 
    WHEN ParentFamily.FamilyName IS NULL THEN''
    ELSE ParentFamily.FamilyName + ' > '
END +
CASE 
    WHEN Family.FamilyName IS NULL THEN ''
    ELSE Family.FamilyName
END AS 'Family Path'
FROM tblFamily AS Family
    LEFT JOIN tblFamily AS ParentFamily ON Family.ParentFamilyId = ParentFamily.FamilyId
    LEFT JOIN tblFamily AS TopFamily ON ParentFamily.ParentFamilyId = TopFamily.FamilyId
ORDER BY Family.FamilyName
-- Done with help :|



