--3---------

--req 3.10a
--1
INSERT INTO tblMembershipType (MembershipType) SELECT DISTINCT (MembershipType)FROM [dbo].[tblPersonSTAGING];
--3
UPDATE tblPersonSTAGING 
SET MembershipTypeID = mt.MembershipTypeID
FROM tblMembershipType mt           
INNER JOIN tblPersonSTAGING pSTGNG
ON mt.MembershipType = pSTGNG.MembershipType
--4.1
UPDATE tblPersonSTAGING 
SET IsGroup = mt.IsGroup
FROM tblMembershipType mt           
INNER JOIN tblPersonSTAGING pSTGNG
ON mt.MembershipType = pSTGNG.MembershipType
--4.2
UPDATE tblPersonSTAGING 
SET AnnualFee = mt.AnnualFee
FROM tblMembershipType mt           
INNER JOIN tblPersonSTAGING pSTGNG
ON mt.MembershipType = pSTGNG.MembershipType
--5.1
INSERT INTO tblMembershipType (IsGroup) SELECT DISTINCT (IsGroup)FROM [dbo].[tblPersonSTAGING];
--5.2
INSERT INTO tblMembershipType (AnnualFee) SELECT DISTINCT (AnnualFee)FROM [dbo].[tblPersonSTAGING];
--req 3.10b
INSERT INTO tblMembership (MembershipNumber,isCurrentMember,MembershipTypeID) 
SELECT DISTINCT MembershipNumber,isCurrentMember,MembershipTypeIDFROM [dbo].[tblPersonSTAGING];
--req 3.10c
INSERT INTO tblPerson (FirstName,MidName,LastName,isCurrentMember,Address,City,State,Zip,AreaCode,Phone,Email,MembershipID) 
SELECT DISTINCT FirstName,MidName,LastName,isCurrentMember,Address,City,State,Zip,AreaCode,Phone,Email,MembershipID
FROM [dbo].[tblPersonSTAGING];
--req 2.30

UPDATE tblPersonSTAGING 
SET MembershipID = mt.MembershipID
FROM tblMembership mt           
INNER JOIN tblPersonSTAGING pSTGNG
ON mt.MembershipNumber = pSTGNG.MembershipNumber

--4---------

--Step 1
Select * from tblPersonLanguage_IMPORT WHERE L1 IS NULL

DELETE FROM tblPersonLanguage_IMPORT WHERE L1 IS NULL

SELECT * FROM tblPersonLanguage_IMPORT 
Order by PersonID desc;
WHERE PersonID IS NULL

--Step 2
UPDATE tblPersonLanguage_IMPORT 
SET PersonID = P.PersonID 
FROM tblPersonLanguage_IMPORT AS PI INNER JOIN tblPerson AS P 
ON (PI.FirstName=P.FirstName) 
AND (PI.Phone=P.Phone)
WHERE PI.PersonID IS NULL;

Select PersonID, COUNT(*) AS NumOfPers 
from tblPersonLanguage_IMPORT
Group By PersonID
Having COUNT(*) > 1
Order by PersonID desc;

Select * from tblPerson
Order by PersonID desc;

UPDATE tblPersonLanguage_IMPORT
SET PersonID = 69
WHERE FirstName = 'Herman';

--Step 3
Select * From tblFluency

INSERT INTO tblFluency(FluencyRanking,FluencyCode,FluencyDescription)
VALUES (0,'FNK','Fluency level Not Known');

--Step 4
INSERT INTO tblPersonLanguageSTAGING (PersonID, Language, FluencyCode)
(SELECT DISTINCT PersonID, L4, L4Fluency FROM tblPersonLanguage_IMPORT
WHERE L4 <> ''       AND L4Fluency <> '' 
AND L4 IS NOT NULL AND L4Fluency IS NOT NULL)

select * from tblPersonLanguageSTAGING

--Step 5
Insert Into tblLanguage(Language)
Values ('Chinese')
select * from tblLanguage

--Step 6
UPDATE tblPersonLanguageSTAGING
SET LanguageID = 15
WHERE Language = 'Chinese';

select * from tblPersonLanguageSTAGING

--Step 7(a)
UPDATE tblPersonLanguageSTAGING
SET FluencyID = 6
WHERE FluencyCode = 'FNK';

select * from tblPersonLanguageSTAGING

--Step 7(b)
Select PersonID,LanguageID, COUNT(*) AS NumOfPers 
from tblPersonLanguageSTAGING
Group By PersonID,LanguageID
Having COUNT(*) > 1
Order by PersonID,LanguageID desc;

--Step 8
INSERT INTO tblPersonLangFluency (PersonID, LanguageID, FluencyID)
(SELECT DISTINCT PersonID, LanguageID, FluencyID FROM tblPersonLanguageSTAGING)


Select * From tblPersonLangFluency

--5---------

--5.10a
CREATE TABLE tblCommittee (
CommitteeID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
CommitteeName NVARCHAR(250) NOT NULL UNIQUE,
MeetingTime NVARCHAR(250) NULL,
BudgetedExpenditures MONEY NULL,
ExpendituresToDate MONEY NULL,
CommitteeType NCHAR(1) NOT NULL ,
CONSTRAINT CommitteeAK
UNIQUE(CommitteeID,CommitteeType),
CONSTRAINT CommitteeCheck
CHECK(CommitteeType='C' or CommitteeType='S')
);
--5.10b
CREATE TABLE tblSisterCityCommittee(
SisterCityCommiteeID INT NOT NULL PRIMARY KEY,
SisterCityID INT NOT NULL UNIQUE,
TopProject NVARCHAR(250) NULL,
LastVisitToCity DATETIME NULL,
LastVisitFromCity DATETIME NULL,
NextVisitToCity DATETIME NULL,
NextVisitFromCity DATETIME NULL,
CommitteeType NCHAR(1) NULL DEFAULT 'C',
CONSTRAINT tblSisterCityCommitteeFK1 
FOREIGN KEY(SisterCityCommiteeID,CommitteeType)
REFERENCES tblCommittee(CommitteeID,CommitteeType)
ON UPDATE NO ACTION
ON DELETE NO ACTION,
CONSTRAINT tblSisterCityCommitteeFK2 FOREIGN KEY(SisterCityID)
REFERENCES tblSisterCity(SisterCityID)
ON UPDATE NO ACTION
ON DELETE NO ACTION,
CONSTRAINT SisterCityCommitteeCheck CHECK (CommitteeType='C')
);
--5.10c
CREATE TABLE tblSupportCommittee (
SupportCommitteeID INT NOT NULL PRIMARY KEY,
CityContact NVARCHAR(250) NULL,
MissionStatement NVARCHAR(max) NULL,
CommitteeType NCHAR(1) NULL DEFAULT 'S',
CONSTRAINT tblSupportCommitteeFK1 
FOREIGN KEY(SupportCommitteeID,CommitteeType)
REFERENCES tblCommittee(CommitteeID,CommitteeType)
ON UPDATE NO ACTION
ON DELETE NO ACTION,
CONSTRAINT SupportCommitteeCheck CHECK (CommitteeType='S')
);
--5.15A
INSERT INTO tblCommittee(CommitteeName,CommitteeType, MeetingTime, BudgetedExpenditures, ExpendituresToDate)
(SELECT DISTINCT CommitteeName,CommitteeType, MonthlyMeetingTime, BudgetedExpenditures, ExpendituresToDate   FROM tblCommitteeIMPORT)

--5.15B
UPDATE tblCommitteeIMPORT
SET CommitteeID = P.CommitteeID
FROM tblCommitteeIMPORT AS PI INNER JOIN tblCommittee AS P
ON (PI.CommitteeName=P.CommitteeName)
WHERE PI.CommitteeID IS NULL;

--5.15C
INSERT INTO tblSupportCommittee(SupportCommitteeID,CommitteeType, CityContact, MissionStatement)
(SELECT DISTINCT CommitteeID, CommitteeType, CityGovernmentContact, MissionStatement  FROM tblCommitteeIMPORT
Where CityGovernmentContact is not null)

select * from tblCommitteeIMPORT

--5.15D
UPDATE tblCommitteeIMPORT
SET CommitteeType = 'S' 
Where CityGovernmentContact is not null

UPDATE tblCommitteeIMPORT
SET CommitteeType = 'C' 
Where CityGovernmentContact is null

UPDATE tblCommitteeIMPORT
SET SisterCityID = P.SisterCityID
FROM tblCommitteeIMPORT AS PI INNER JOIN tblSisterCity AS P
ON (PI.AffiliatedCity=P.CityName)
WHERE PI.SisterCityID IS NULL;

INSERT INTO tblSisterCityCommittee(SisterCityCommiteeID,SisterCityID,CommitteeType,TopProject,LastVisitToCity,LastVisitFromCity,NextVisitToCity,NextVisitFromCity)
(SELECT DISTINCT CommitteeID,SisterCityID,CommitteeType,TopProject,MostRecentVisitToCity,MostRecentVisitFromCity,NextVisitToCity,NextVisitFromCity  FROM tblCommitteeIMPORT
Where CityGovernmentContact is null)

select * from tblSisterCityCommittee

--5.20
GO
CREATE VIEW 
vueCommittee_5_20 AS
SELECT 
CommitteeName,MeetingTime,BudgetedExpenditures,ExpendituresToDate,
C.CityName,
P.TopProject,P.LastVisitToCity,P.LastVisitFromCity,P.NextVisitToCity,P.NextVisitFromCity, 
L.CityContact, L.MissionStatement
FROM 
tblCommittee 
LEFT OUTER JOIN tblSupportCommittee AS L 
ON CommitteeID=SupportCommitteeID
LEFT OUTER JOIN tblSisterCityCommittee AS P
ON CommitteeID=SisterCityCommiteeID
LEFT OUTER JOIN tblSisterCity AS C
ON P.SisterCityID=C.SisterCityID;
GO

--5.22
GO
CREATE VIEW vueCityCommittee_5_22 AS 
SELECT CommitteeID,CommitteeName,MeetingTime,BudgetedExpenditures,ExpendituresToDate,
D.CommitteeType,
C.CityName,C.Country,C.Population,C.Description,C.Mayor,C.Website
FROM tblCommittee AS D
INNER JOIN tblSisterCityCommittee AS P
ON CommitteeID=SisterCityCommiteeID
INNER JOIN tblSisterCity AS C
ON P.SisterCityID=C.SisterCityID;
GO

--5.24

CREATE VIEW vueCommitteeSpend_5_24 AS
SELECT CommitteeName,
BudgetedExpenditures,
ExpendituresToDate,
(BudgetedExpenditures - ExpendituresToDate) AS [Amount Available to Spend]
FROM tblCommittee

--6---------
--Inserting new data for the committee req 6.05-a + -b

--1 set identity on to insert the value of committeeID
SET IDENTITY_INSERT tblCommittee  ON

--2 insert new value from instructions
INSERT INTO tblCommittee(CommitteeID,CommitteeName,MeetingTime,BudgetedExpenditures,ExpendituresToDate,CommitteeType)
VALUES (14,'Programs','3rd Friday 7PM',500,50,'S')

--3 checking the result
SELECT * FROM tblCommittee

--a, do not try do this 
UPDATE tblCommittee
SET CommitteeID = 14
Where CommitteeName = 'Programs'

--b instead do this if you make a mistake
DELETE FROM tblCommittee
WHERE CommitteeID = 1002

--4 insert next values
INSERT INTO tblSupportCommittee(SupportCommitteeID,CityContact,MissionStatement,CommitteeType)
VALUES (14,'Parks and Rec. Dir.','Coordinate the programs offered by the various city committees','S')

--5 checking the results in tblSupportCityCommittee
select * from tblSupportCommittee

--6 creating tables

--tblPosition
CREATE TABLE tblPosition(
PositionID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
Title NVARCHAR(250) NOT NULL UNIQUE
);

--tblAuthorizedCommitteePosition
CREATE TABLE tblAuthorizedCommitteePosition(
PositionID INT NOT NULL, 
CommitteeID INT NOT NULL,
ApprovedDate DATE NULL
PRIMARY KEY (PositionID,CommitteeID)
CONSTRAINT tblAuthorizedCommitteePositionFK1 FOREIGN KEY (PositionID)
REFERENCES tblPosition (PositionID)
ON UPDATE NO ACTION
ON DELETE NO ACTION,
CONSTRAINT tblAuthorizedCommitteePositionFK2 FOREIGN KEY (CommitteeID)
REFERENCES tblCommittee (CommitteeID)
ON UPDATE NO ACTION
ON DELETE NO ACTION
);

--tblServiceHistory
CREATE TABLE tblServiceHistory(
PositionID INT NOT NULL,
CommitteeID INT NOT NULL,
PersonID INT NOT NULL,
ServiceStartDate DATE NOT NULL,
ServiceEndDate DATE NULL,
PRIMARY KEY (PositionID,CommitteeID,PersonID,ServiceStartDate),
CONSTRAINT tblServiceHistoryFK1 FOREIGN KEY (PersonID)
REFERENCES tblPerson (PersonID)
ON UPDATE NO ACTION
ON DELETE NO ACTION,
CONSTRAINT tblServiceHistoryFK2 FOREIGN KEY (PositionID,CommitteeID)
REFERENCES tblAuthorizedCommitteePosition (PositionID,CommitteeID)
ON UPDATE NO ACTION
ON DELETE NO ACTION
);

--Import part
--req 6.10-1
--Clear some null
DELETE FROM tblCommitteeOfficers_IMPORT
WHERE Committee IS NULL

--update part
UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = P.PersonID
FROM tblCommitteeOfficers_IMPORT AS PI INNER JOIN tblPerson AS P
ON (PI.FirstName=P.FirstName) 
AND (PI.LastName=P.LastName)
WHERE PI.PersonID IS NULL;

UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = 95
Where FirstName = 'Hernán' AND LastName = 'Cortés'

UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = 61
Where FirstName = 'Vasco' AND LastName = 'Núñez de Balboa'

UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = 118
Where FirstName = 'George' AND LastName = 'Vancouver (384-5171)'

UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = 78
Where FirstName = 'Francisco' AND LastName = 'Vásquez de Coronado'

UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = 103
Where FirstName = 'Juan' AND LastName = 'Ponce de León'

UPDATE tblCommitteeOfficers_IMPORT
SET PersonID = 100
Where FirstName = 'George' AND LastName = 'Vancouver (371-2131)'

--req 6.10-4a
INSERT INTO tblPosition (Title) (SELECT DISTINCT (Position) FROM tblCommitteeOfficers_IMPORT)

select * from tblPosition

--req 6.10-4b
UPDATE tblCommitteeOfficers_IMPORT
SET PositionID = P.PositionID
FROM tblCommitteeOfficers_IMPORT AS PI INNER JOIN tblPosition AS P
ON (PI.Position=P.Title)
WHERE PI.PositionID IS NULL;

--req 6.10-4c
UPDATE tblCommitteeOfficers_IMPORT
SET AuthorizedPositionID = P.PositionID
FROM tblCommitteeOfficers_IMPORT AS PI INNER JOIN tblPosition AS P
ON (PI.AuthorizedPosition=P.Title)
WHERE PI.AuthorizedPositionID IS NULL;

--req 6.10-5
UPDATE tblCommitteeOfficers_IMPORT
SET CommitteeID = P.CommitteeID
FROM tblCommitteeOfficers_IMPORT AS PI INNER JOIN tblCommittee AS P
ON (PI.Committee=P.CommitteeName)
WHERE PI.CommitteeID IS NULL;

UPDATE tblCommitteeOfficers_IMPORT
SET CommitteeID = 7
Where Committee = 'PacRim'

--req 6.10-6a
INSERT INTO tblAuthorizedCommitteePosition (CommitteeID,PositionID,ApprovedDate) 
(SELECT CommitteeID,AuthorizedPositionID,ApprovedOn FROM tblCommitteeOfficers_IMPORT
WHERE AuthorizedPositionID IS NOT NULL AND CommitteeID IS NOT NULL)

--req 6.10-6b
INSERT INTO tblServiceHistory(PositionID,CommitteeID,PersonID,ServiceStartDate,ServiceEndDate) 
(SELECT PositionID,CommitteeID,PersonID,StartDate,EndDate 
FROM tblCommitteeOfficers_IMPORT
WHERE 
PositionID IS NOT NULL AND 
CommitteeID IS NOT NULL AND 
PersonID IS NOT NULL AND 
StartDate IS NOT NULL
)

--If insert wrong value
Truncate Table tblServiceHistory

--6.30
GO
CREATE VIEW vueAuthorizedPositionCount_6_30
AS
SELECT
COUNT(ApprovedDate) AS [Number of authorized positions],
('authorized position(s) for ' + CommitteeName) AS 'Committee Positions'
FROM 
tblAuthorizedCommitteePosition
INNER JOIN tblCommittee 
ON tblAuthorizedCommitteePosition.CommitteeID=tblCommittee.CommitteeID
GROUP BY CommitteeName

--look for changes
select * from tblCommitteeOfficers_IMPORT
select * from tblCommittee
select * from tblAuthorizedCommitteePosition
select * from tblServiceHistory
select * from vueAuthorizedPositionCount_6_30

--7---------

--4
--a
Insert Into tblSisterCity (CityName,Country,Population,Description,Mayor,Website)
Values('Sidney BC','Canada',11483,'Sidney is located at the southeast end of Vancouver Island, 
just north of Victoria and adjacent to the world famous Butchart Gardens.','Steve Price','http://www.sidney.ca/')
--b
Insert Into tblCommittee (CommitteeName,MeetingTime,BudgetedExpenditures,ExpendituresToDate,CommitteeType)
Values('Summer Music Festival at the Bay','1st Monday 3 PM', 5000, 1000, 'S')
--c
Insert Into tblCommittee (CommitteeName,MeetingTime,BudgetedExpenditures,ExpendituresToDate,CommitteeType)
Values('Sidney','3rd Tuesday 2 PM', 1000, 500, 'C')
--d
Insert Into tblSupportCommittee (SupportCommitteeID,CityContact,MissionStatement)
Values(1003,'Parks and Rec. Dir.','Promote Bellingham through music events')

Insert Into tblSisterCityCommittee(SisterCityCommiteeID,SisterCityID,TopProject,LastVisitToCity,LastVisitFromCity,NextVisitToCity,NextVisitFromCity)
Values(1004,7,'Establish relationship','2015-5-10','2015-4-24','2015-6-16','2015-7-17')

--f
DELETE FROM tblSisterCity
WHERE CityName = 'Sidney BC'
--g
DELETE FROM tblCommittee
WHERE CommitteeName = 'Sidney'
--h
DELETE FROM tblSupportCommittee
WHERE SupportCommitteeID = 1003
--i
DELETE FROM tblCommittee
WHERE CommitteeName = 'Sidney'
--j
DELETE FROM tblSisterCity
WHERE CityName = 'Sidney BC'