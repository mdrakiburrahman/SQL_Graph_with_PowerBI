USE [SQL_GRAPH_Weasley_Family]
/* ========================
    Create NODE tables
   ======================== */
--  [dbo].[people]
CREATE TABLE [dbo].[people](
    personID Int,
    [name] VARCHAR(100),
    [image] VARCHAR(100)
) AS NODE;

--  [dbo].[address]
CREATE TABLE [dbo].[address](
    addressID Int,
    ADDR VARCHAR(100),
    [image] VARCHAR(100)
) AS NODE;

/* ========================
    Create EDGE tables
   ======================== */
--  [dbo].[homeaddress]
CREATE TABLE [dbo].[homeaddress] (relation VARCHAR(100)) AS EDGE;
--  [dbo].[parents]
CREATE TABLE [dbo].[parents] (relation VARCHAR(100)) AS EDGE;
--  [dbo].[children]
CREATE TABLE [dbo].[children] (relation VARCHAR(100)) AS EDGE;
--  [dbo].[siblings]
CREATE TABLE [dbo].[siblings] (relation VARCHAR(100)) AS EDGE;

/* ========================
    Populate NODE tables
   ======================== */
-- [dbo].people
INSERT INTO [people] (personID, [name], [image] )
    VALUES (0, 'Molly Weasley', 'Molly'),
           (1, 'Arthur Weasley', 'Arthur'),
           (2, 'Bill Weasley', 'Bill'),
           (3, 'Fleur Delacour', 'Fleur'),
           (4, 'George Weasley', 'George'),
           (5, 'Fred Weasley', 'Fred'),
           (6, 'Ron Weasley', 'Ron'),
           (7, 'Hermione Granger', 'Hermione'),
           (8, 'Hugo Weasley', 'Hugo'),
           (9, 'Rose Weasley', 'Rose'),
           (10, 'Percy Weasley', 'Percy'),
           (11, 'Ginny Weasley', 'Ginny'),
           (12, 'Harry Potter', 'Harry'),
           (13, 'James Sirius Potter', 'James'),
           (14, 'Lily Luna Potter', 'Lily'),
           (15, 'Albus Severus Potter', 'Albus')

SELECT *  FROM [dbo].[people]

-- [dbo].[address]
INSERT INTO [address] (addressID, ADDR, [image])
    VALUES (1, 'The Burrow', '_Burrow'),
           (2, 'Godrics Hollow', '_Godric'),
           (3, 'Granger Household', '_Granger'),
           (4, 'Hogwarts', '_Hogwarts')

SELECT *  FROM [dbo].[address]

/* ========================
    Populate EDGE tables
   ======================== */
-- [dbo].[homeaddress]
INSERT INTO [homeaddress] 
    VALUES ( -- Arthur owns the Burrow
                (SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 1), 'Owns' ),
           ( -- Harry owns the Godrics Hollow
                (SELECT $node_ID FROM [address] WHERE addressID = 2), (SELECT $node_ID FROM [people] WHERE personID = 12), 'Owns' ),
           ( -- Hermione owns the Granger Household
                (SELECT $node_ID FROM [address] WHERE addressID = 3), (SELECT $node_ID FROM [people] WHERE personID = 7), 'Owns' ),
             -- The Burrow residents
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 0), 'LivesAt' ), -- Molly
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 2), 'LivesAt' ), -- Bill
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 3), 'LivesAt' ), -- Fleur
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 4), 'LivesAt' ), -- George
           ((SELECT $node_ID FROM [address] WHERE addressID = 4), (SELECT $node_ID FROM [people] WHERE personID = 5), 'Attends' ), -- Fred
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 10), 'LivesAt' ), -- Percy
            -- Granger Household residents
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 6), 'LivesAt' ), -- Ron
           -- Godric's Hollow residents
           ((SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 11), 'LivesAt' ), -- Ginny
          -- Kids all go to Hogwarts
          ((SELECT $node_ID FROM [address] WHERE addressID = 4), (SELECT $node_ID FROM [people] WHERE personID = 8), 'Attends' ), -- Hugo
          ((SELECT $node_ID FROM [address] WHERE addressID = 4), (SELECT $node_ID FROM [people] WHERE personID = 9), 'Attends' ), -- Rose
          ((SELECT $node_ID FROM [address] WHERE addressID = 4), (SELECT $node_ID FROM [people] WHERE personID = 13), 'Attends' ), -- James
          ((SELECT $node_ID FROM [address] WHERE addressID = 4), (SELECT $node_ID FROM [people] WHERE personID = 14), 'Attends' ), -- Lily
          ((SELECT $node_ID FROM [address] WHERE addressID = 4), (SELECT $node_ID FROM [people] WHERE personID = 15), 'Attends' ) -- Albus

SELECT *  FROM [dbo].[homeaddress]

--  [dbo].[parents]
INSERT INTO [parents] 
    VALUES ( -- Molly
            (SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 2), 'mother' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 10), 'mother' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 4), 'mother' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 5), 'mother' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 11), 'mother' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 6), 'mother' ), -- Ron
           ( -- Arthur
            (SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 2), 'father' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 10), 'father' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 4), 'father' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 5), 'father' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 11), 'father' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 6), 'father' ), -- Ron
           ( -- Ginny
            (SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 13), 'mother' ), -- James
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 14), 'mother' ), -- Lily
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 15), 'mother' ), -- Albus
           ( -- Harry
            (SELECT $node_ID FROM [people] WHERE personID = 12), (SELECT $node_ID FROM [people] WHERE personID = 13), 'father' ), -- James
           ((SELECT $node_ID FROM [people] WHERE personID = 12), (SELECT $node_ID FROM [people] WHERE personID = 14), 'father' ), -- Lily
           ((SELECT $node_ID FROM [people] WHERE personID = 12), (SELECT $node_ID FROM [people] WHERE personID = 15), 'father' ), -- Albus
           ( -- Hermione
            (SELECT $node_ID FROM [people] WHERE personID = 7), (SELECT $node_ID FROM [people] WHERE personID = 8), 'mother' ), -- Hugo
           ((SELECT $node_ID FROM [people] WHERE personID = 7), (SELECT $node_ID FROM [people] WHERE personID = 9), 'mother' ), -- Rose
           ( -- Ron
            (SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 8), 'father' ), -- Hugo
           ((SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 9), 'father' ) -- Rose

SELECT *  FROM [dbo].[parents]

--  [dbo].[children]
INSERT INTO [children] 
    VALUES ( -- Bill
            (SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 0), 'son' ), -- Molly
           ((SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 1), 'son' ), -- Arthur
           ( -- Percy
            (SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 0), 'son' ), -- Molly
           ((SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 1), 'son' ), -- Arthur
           ( -- George
            (SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 0), 'son' ), -- Molly
           ((SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 1), 'son' ), -- Arthur
           ( -- Fred
            (SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 0), 'son' ), -- Molly
           ((SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 1), 'son' ), -- Arthur
           ( -- Ginny
            (SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 0), 'daughter' ), -- Molly
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 1), 'daughter' ), -- Arthur
           ( -- Ron
            (SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 0), 'son' ), -- Molly
           ((SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 1), 'son' ), -- Arthur
           ( -- James
            (SELECT $node_ID FROM [people] WHERE personID = 13), (SELECT $node_ID FROM [people] WHERE personID = 11), 'son' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 13), (SELECT $node_ID FROM [people] WHERE personID = 12), 'son' ), -- Harry
           ( -- Lily
            (SELECT $node_ID FROM [people] WHERE personID = 14), (SELECT $node_ID FROM [people] WHERE personID = 11), 'daughter' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 14), (SELECT $node_ID FROM [people] WHERE personID = 12), 'daughter' ), -- Harry
           ( -- Albus
            (SELECT $node_ID FROM [people] WHERE personID = 15), (SELECT $node_ID FROM [people] WHERE personID = 11), 'son' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 15), (SELECT $node_ID FROM [people] WHERE personID = 12), 'son' ), -- Harry
           ( -- Hugo
            (SELECT $node_ID FROM [people] WHERE personID = 8), (SELECT $node_ID FROM [people] WHERE personID = 7), 'son' ), -- Hermione
           ((SELECT $node_ID FROM [people] WHERE personID = 8), (SELECT $node_ID FROM [people] WHERE personID = 6), 'son' ), -- Ron
           ( -- Rose
            (SELECT $node_ID FROM [people] WHERE personID = 9), (SELECT $node_ID FROM [people] WHERE personID = 7), 'daughter' ), -- Hermione
           ((SELECT $node_ID FROM [people] WHERE personID = 9), (SELECT $node_ID FROM [people] WHERE personID = 6), 'daughter' ) -- Ron

SELECT *  FROM [dbo].[children]

--  [dbo].[siblings]
INSERT INTO [siblings] 
    VALUES ( -- Bill
            (SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 10), 'brother' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 4), 'brother' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 5), 'brother' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 11), 'brother' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 6), 'brother' ), -- Ron
           ( -- Percy
            (SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 2), 'brother' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 4), 'brother' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 5), 'brother' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 11), 'brother' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 10), (SELECT $node_ID FROM [people] WHERE personID = 6), 'brother' ), -- Ron
           ( -- George
            (SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 2), 'brother' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 10), 'brother' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 5), 'brother' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 11), 'brother' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 6), 'brother' ), -- Ron
           ( -- Fred
            (SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 2), 'brother' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 10), 'brother' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 4), 'brother' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 11), 'brother' ), -- Ginny
           ((SELECT $node_ID FROM [people] WHERE personID = 5), (SELECT $node_ID FROM [people] WHERE personID = 6), 'brother' ), -- Ron
           ( -- Ginny
            (SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 2), 'sister' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 10), 'sister' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 4), 'sister' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 5), 'sister' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 11), (SELECT $node_ID FROM [people] WHERE personID = 6), 'sister' ), -- Ron
           ( -- Ron
            (SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 2), 'brother' ), -- Bill
           ((SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 10), 'brother' ), -- Percy
           ((SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 4), 'brother' ), -- George
           ((SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 5), 'brother' ), -- Fred
           ((SELECT $node_ID FROM [people] WHERE personID = 6), (SELECT $node_ID FROM [people] WHERE personID = 11), 'brother' ) -- Ginny

SELECT *  FROM [dbo].[siblings]

/* ========================
    Query Relationships
   ======================== */
-- Show child's relation to parent
SELECT child.[name] as 'Child', children.relation, parent.[name] as 'Parent'
FROM people parent, children, people child
WHERE MATCH (child -(children) -> parent);

-- Show parent's relation to child
SELECT parent.[name] as 'Parent', parents.relation, child.[name] as 'Child'
FROM people child, parents, people parent
WHERE MATCH (parent -(parents) -> child);

-- Show sibling relationships
SELECT person1.[name], relation, person2.[name]
FROM people person1, siblings, people person2
WHERE MATCH (person1 -(siblings) -> person2);

-- Show address relationships
SELECT FamilyMember.[name] as 'Family Member', homeaddress.[relation] as 'Status', [address].[ADDR] as 'Address'
	FROM people FamilyMember, homeaddress, [address]
	WHERE MATCH(FamilyMember <- (homeaddress) - [address])

-- Show full family relationship down to address
SELECT FamilyMember.[name] as 'Family Member', parents.[relation] as 'Family Relation', people.[name] as 'Child', siblings.[relation] as 'SiblingRelation', Sibling.[name] as 'Sibling', homeaddress.[relation], [address].[ADDR] as 'Address'
	FROM people FamilyMember, parents, people, siblings, people Sibling, homeaddress, [address]
	WHERE MATCH(FamilyMember - (parents) -> people - (siblings) -> Sibling <- (homeaddress) - [address])

/* ========================
    Views for Power BI
   ======================== */
-- Union all relationships in family
DROP VIEW IF EXISTS [vw_FamilyGraph_UNION];

CREATE VIEW [vw_FamilyGraph_UNION] AS
	SELECT FamilyMember.[name] as 'Family Member 1', children.[relation] as ' has a ', people.[name] as 'Family Member 2'
		FROM people FamilyMember, children, people
		WHERE MATCH (FamilyMember <- (children) - people)
	UNION ALL
	SELECT FamilyMember.[name], siblings.[relation], people.[name]
		FROM people FamilyMember, siblings, people
		WHERE MATCH (FamilyMember <- (siblings) - people);

SELECT * FROM [dbo].[vw_FamilyGraph_UNION];

-- Join parental and sibling relationship
DROP VIEW IF EXISTS [vw_FamilyGraph_JOIN];

CREATE VIEW [vw_FamilyGraph_JOIN] AS
	SELECT FamilyMember.[$node_id_03107F99F090448FA423C5CBD6F05308] as FamilyId, FamilyMember.[name] as 'Family Member', 
		   parents.[relation] as 'Family Relation', 
		   FamilyMember.[image] as 'Family Image',
		   people.[$node_id_03107F99F090448FA423C5CBD6F05308] as PeopleID, people.[name] as 'Child',
		   people.[image] as 'Child Image',
		   siblings.[relation] as 'Sibling Relation', 
		   Sibling.[$node_id_03107F99F090448FA423C5CBD6F05308] as SiblingID, Sibling.[name] as 'Sibling',
		   Sibling.[image] as 'Sibling Image'
		FROM people FamilyMember, parents, people, siblings, people Sibling
		WHERE MATCH(FamilyMember - (parents) -> people - (siblings) -> Sibling);

SELECT * FROM [dbo].[vw_FamilyGraph_JOIN];

-- NODE: People view
DROP VIEW IF EXISTS [vw_people];

CREATE OR ALTER VIEW [vw_people] AS WITH Q AS (
	SELECT people.[$node_id_03107F99F090448FA423C5CBD6F05308], [name], personID, [image] FROM people
) SELECT * FROM Q

-- NODE: Address view
DROP VIEW IF EXISTS [vw_address]

CREATE OR ALTER VIEW [vw_address] AS WITH Q AS (
	SELECT address.[$node_id_ACE9B85C374B41C081C45D7A75449FA5], addressID, ADDR, [image] FROM [address]
) SELECT * FROM Q

-- EDGE: homeaddress view
DROP VIEW IF EXISTS [vw_homeaddress]

CREATE OR ALTER VIEW [vw_homeaddress] AS WITH Q AS (
	SELECT homeaddress.[$edge_id_095D2324DC7E4C8EB916BE6D4CF788F5], homeaddress.[$from_id_99533FCE943D45ADB0DE6EEB05BCAE77], homeaddress.[$to_id_5DF03C9F05464731BC79BE32605BFDBC], relation FROM [homeaddress]
) SELECT * FROM Q

-- SELECT
SELECT * FROM [vw_address];
SELECT * FROM [vw_homeaddress];
SELECT * FROM [vw_people];
SELECT * FROM [dbo].[vw_FamilyGraph_JOIN];