USE [SQL_GRAPH_AdventureWorks_Family]
/* ========================
    Create NODE tables
   ======================== */
--  [dbo].[people]
CREATE TABLE [dbo].[people](
    personID Int,
    [name] VARCHAR(100),
    email VARCHAR(100)
) AS NODE;

--  [dbo].[address]
CREATE TABLE [dbo].[address](
    addressID Int,
    ADDR VARCHAR(100),
    PostCode VARCHAR(10)
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
INSERT INTO [people] (personID, [name], email )
    VALUES (0, 'Debbie Williams', 'd.Williams@adventure-works.com'),
           (1, 'Bert Williams', 'b.Williams@adventure-works.com'),
           (2, 'Rob Williams', 'r.Williams@adventure-works.com'),
           (3, 'Tina Williams', 't.Williams@adventure-works.com'),
           (4, 'Jane Williams', 'j.Williams@adventure-works.com')

SELECT *  FROM [dbo].[people]

-- [dbo].[address]
INSERT INTO [address] (addressID, ADDR, PostCode)
    VALUES (1, 'MyHouse', 'RG1 2TT'),
           (2, 'MyFlat', 'RG11 4TT')

SELECT *  FROM [dbo].[address]

/* ========================
    Populate EDGE tables
   ======================== */
-- [dbo].[homeaddress]
INSERT INTO [homeaddress] 
    VALUES ( -- Jane owns the flat
                (SELECT $node_ID FROM [address] WHERE addressID = 2), (SELECT $node_ID FROM [people] WHERE personID = 4), 'OwnsFlat' ),
           ( -- Bert owns the house
                (SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 1), 'OwnsHouse' ),
           ( -- Debbie lives in the house
                (SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 0), 'LivesAt' ),
           ( -- Rob lives in the house
                (SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 2), 'LivesAt' ),
           ( -- Tina lives in the house
                (SELECT $node_ID FROM [address] WHERE addressID = 1), (SELECT $node_ID FROM [people] WHERE personID = 3), 'LivesAt' )

SELECT *  FROM [dbo].[homeaddress]

--  [dbo].[parents]
INSERT INTO [parents] 
    VALUES ( -- Debbie is Rob's mother
                (SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 2), 'mother' ),
           ( -- Debbie is Tina's mother
                (SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 3), 'mother' ),
           ( -- Debbie is Jane's mother
                (SELECT $node_ID FROM [people] WHERE personID = 0), (SELECT $node_ID FROM [people] WHERE personID = 4), 'mother' ),
           ( -- Bert is Rob's father
                (SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 2), 'father' ),
           ( -- Bert is Tina's father
                (SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 3), 'father' ),
            ( -- Bert is Jane's father
                (SELECT $node_ID FROM [people] WHERE personID = 1), (SELECT $node_ID FROM [people] WHERE personID = 4), 'father' )

SELECT *  FROM [dbo].[parents]

--  [dbo].[children]
INSERT INTO [children] 
    VALUES ( -- Rob is Debbie's son
                (SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 0), 'son' ),
           ( -- Tina is Debbie's daughter
                (SELECT $node_ID FROM [people] WHERE personID = 3), (SELECT $node_ID FROM [people] WHERE personID = 0), 'daughter' ),
           ( -- Jane is Debbie's daughter
                (SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 0), 'daughter' ),
           ( -- Rob is Bert's son
                (SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 1), 'son' ),
           ( -- Tina is Bert's daughter
                (SELECT $node_ID FROM [people] WHERE personID = 3), (SELECT $node_ID FROM [people] WHERE personID = 1), 'daughter' ),
            ( -- Jane is Bert's daughter
                (SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 1), 'daughter' )

SELECT *  FROM [dbo].[children]

--  [dbo].[siblings]
INSERT INTO [siblings] 
    VALUES ( -- Rob is Tina and Jane's Brother
                (SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 3), 'brother' ),
           (    (SELECT $node_ID FROM [people] WHERE personID = 2), (SELECT $node_ID FROM [people] WHERE personID = 4), 'brother' ),
           ( -- Jane is Rob and Tina's Sister
                (SELECT $node_ID FROM [people] WHERE personID = 3), (SELECT $node_ID FROM [people] WHERE personID = 2), 'sister' ),
           (    (SELECT $node_ID FROM [people] WHERE personID = 3), (SELECT $node_ID FROM [people] WHERE personID = 4), 'sister' ),
           ( -- Tina is Rob and Jane's Sister
                (SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 2), 'sister' ),
           (    (SELECT $node_ID FROM [people] WHERE personID = 4), (SELECT $node_ID FROM [people] WHERE personID = 3), 'sister' )

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
SELECT FamilyMember.[name] as 'Family Member', homeaddress.[relation] as 'Status', [address].[ADDR] as 'Address', [address].[POSTCODE]
	FROM people FamilyMember, homeaddress, [address]
	WHERE MATCH(FamilyMember <- (homeaddress) - [address])

-- Show full family relationship down to address
SELECT FamilyMember.[name] as 'Family Member', parents.[relation] as 'Family Relation', people.[name] as 'Child', siblings.[relation] as 'SiblingRelation', Sibling.[name] as 'Sibling', homeaddress.[relation], [address].[POSTCODE] as 'Postal Code'
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
	SELECT FamilyMember.[$node_id_9A6927B4DA7A4AC98243311EB28EEB05] as FamilyId, FamilyMember.[name] as 'Family Member', 
		   parents.[relation] as 'Family Relation', 
		   people.[$node_id_9A6927B4DA7A4AC98243311EB28EEB05] as PeopleID, people.[name] as 'Child', siblings.[relation] as 'Sibling Relation', 
		   Sibling.[$node_id_9A6927B4DA7A4AC98243311EB28EEB05] as SiblingID, Sibling.[name] as 'Sibling'
		FROM people FamilyMember, parents, people, siblings, people Sibling
		WHERE MATCH(FamilyMember - (parents) -> people - (siblings) -> Sibling);

SELECT * FROM [dbo].[vw_FamilyGraph_JOIN];

-- NODE: People view
DROP VIEW IF EXISTS [vw_people];

CREATE OR ALTER VIEW [vw_people] AS WITH Q AS (
	SELECT people.[$node_id_9A6927B4DA7A4AC98243311EB28EEB05], email, [name], personID FROM people
) SELECT * FROM Q

-- NODE: Address view
DROP VIEW IF EXISTS [vw_address]

CREATE OR ALTER VIEW [vw_address] AS WITH Q AS (
	SELECT address.[$node_id_A07BD1CED4C94BD394CB2AF9B88B2690], addressID, ADDR, PostCode FROM [address]
) SELECT * FROM Q

-- EDGE: homeaddress view
DROP VIEW IF EXISTS [vw_homeaddress]

CREATE OR ALTER VIEW [vw_homeaddress] AS WITH Q AS (
	SELECT homeaddress.[$edge_id_5200B68F1532440F8D6CF3D19BAA429E], homeaddress.[$from_id_A8D0126F781C4676AB9725AF17CA35A5], homeaddress.[$to_id_0E264F76633D40F398377A8B97D45DFB], relation FROM [homeaddress]
) SELECT * FROM Q

-- SELECT
SELECT * FROM [vw_address];
SELECT * FROM [vw_homeaddress];
SELECT * FROM [vw_people];
SELECT * FROM [dbo].[vw_FamilyGraph_JOIN];