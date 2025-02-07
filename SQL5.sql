CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);

CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL,
);

--Part – A
--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display
--a message “Record is Affected.”
CREATE TRIGGER tr_PersonInfo_RecordAffected
ON PersonInfo
AFTER INSERT,UPDATE,DELETE 
AS 
BEGIN
	PRINT 'RECORD IS AFFECTED'
END;

INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (101, 'Rahul Sharma', 50000.00, '2025-06-01', 'Delhi', 30, '1995-01-01');

UPDATE PersonInfo
SET Salary = 55000.00
WHERE PersonID = 101;

DELETE FROM PersonInfo
WHERE PersonID = 101;

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_PersonInfo_RecordAffected

--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,
--log all operations performed on the person table into PersonLog.
CREATE TRIGGER tr_Insertdata
ON PersonInfo
AFTER INSERT
AS 
BEGIN	
	DECLARE @PERSONID INT
	DECLARE @PERSONNAME VARCHAR(50)
	SELECT @PERSONID=PersonID from INSERTED
	SELECT @PERSONNAME=PersonName FROM INSERTED

	INSERT INTO PersonLog
	VALUES(@PERSONID,@PERSONNAME,'INSERT',GETDATE())
END;

INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (102, 'Anjali Mehta', 45000.00, '2025-05-15', 'Mumbai', 28, '1997-03-10');

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_Insertdata

CREATE OR ALTER TRIGGER tr_Updatedata
ON PersonInfo
AFTER UPDATE
AS 
BEGIN    
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);
    
    SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;

    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE());
END;
 
UPDATE PersonInfo
SET PersonName='Tarun Singh'
WHERE PersonID='102'

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_Updatedata

CREATE TRIGGER tr_Deletedata
ON PersonInfo
AFTER DELETE
AS 
BEGIN	
	DECLARE @PERSONID INT
	DECLARE @PERSONNAME VARCHAR(50)
	SELECT @PERSONID=PersonID from DELETED
	SELECT @PERSONNAME=PersonName FROM DELETED

	INSERT INTO PersonLog
	VALUES(@PERSONID,@PERSONNAME,'DELETE',GETDATE())
END;	

DELETE PersonInfo 
WHERE PersonID = '102'

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_Deletedata

--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo
--table. For that, log all operations performed on the person table into PersonLog.
CREATE TRIGGER tr_Insertdata_instedof
ON PersonInfo
INSTEAD OF INSERT
AS 
BEGIN	
	DECLARE @PERSONID INT
	DECLARE @PERSONNAME VARCHAR(50)
	SELECT @PERSONID=PersonID from INSERTED
	SELECT @PERSONNAME=PersonName FROM INSERTED

	INSERT INTO PersonLog
	VALUES(@PERSONID,@PERSONNAME,'INSERT',GETDATE())
END;

INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (103, 'Sneha Reddy', 60000.00, '2025-08-05', 'Hyderabad', 27, '1998-07-18');

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_Insertdata_instedof

CREATE OR ALTER TRIGGER tr_Updatedata_insteadof
ON PersonInfo
INSTEAD OF UPDATE
AS 
BEGIN    
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);
    
    SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;

    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE());
END;
INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (201, 'Rahul Sharma', 50000.00, '2025-06-01', 'Delhi', 30, '1995-01-01');

UPDATE PersonInfo
SET Salary = 55000.00
WHERE PersonID = 201;

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_Updatedata_insteadof

CREATE TRIGGER tr_Deletedata_insteadof
ON PersonInfo
INSTEAD OF DELETE
AS 
BEGIN	
	DECLARE @PERSONID INT
	DECLARE @PERSONNAME VARCHAR(50)
	SELECT @PERSONID=PersonID from DELETED
	SELECT @PERSONNAME=PersonName FROM DELETED


	INSERT INTO PersonLog
	VALUES(@PERSONID,@PERSONNAME,'DELETE',GETDATE())
END;

DELETE PersonInfo 
WHERE PersonID = 201;

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_Deletedata_insteadof

--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into
--uppercase whenever the record is inserted.
CREATE TRIGGER tr_personinfo_nameupper_insert
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @NAME VARCHAR(50)
	DECLARE @ID INT
	SELECT @NAME=PersonName from INSERTED
	SELECT @ID=PersonId FROM INSERTED


	UPDATE PersonInfo
	SET PersonName=UPPER(@NAME)
	WHERE PersonId=@ID
END;

INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (104, 'Avish Desai', 55000.00, '2025-06-10', 'Pune', 35, '1990-11-15');

SELECT * FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_personinfo_nameupper_insert

--5. Create trigger that prevent duplicate entries of person name on PersonInfo table.
CREATE OR ALTER TRIGGER trg_PreventDuplicateNames
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);

    SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;

    IF (SELECT COUNT(*) FROM PersonInfo WHERE PersonName = @PersonName) = 0
    BEGIN
        INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
        SELECT PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate FROM inserted;
    END
END;

INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (108, 'Kriti Singh', 50000.00, '2025-06-01', 'Delhi', 30, '1995-01-01');
INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (109, 'Kriti Singh', 45000.00, '2025-05-15', 'Mumbai', 28, '1997-03-10');

SELECT * FROM PersonInfo;
SELECT * FROM PersonLog;

drop TRIGGER trg_PreventDuplicateNames

--6. Create trigger that prevent Age below 18 years.
CREATE OR ALTER TRIGGER tr_PreventUnderageInsertion
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
    SELECT PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
    FROM inserted
    WHERE Age >= 18;
END;

drop TRIGGER tr_PreventUnderageInsertion

--Part – B
--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update
--that age in Person table.
CREATE OR ALTER TRIGGER trg_CalculateAge
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET Age = DATEDIFF(YEAR, BirthDate, GETDATE())
    WHERE PersonID IN (SELECT PersonID FROM inserted);
END;

SELECT* FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER trg_CalculateAge

--8. Create a Trigger to Limit Salary Decrease by a 10%.
CREATE OR ALTER TRIGGER trg_LimitSalaryDecrease
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    DECLARE @OldSalary DECIMAL(8, 2);
    DECLARE @NewSalary DECIMAL(8, 2);
    DECLARE @PersonID INT;

    SELECT @OldSalary = Salary, @PersonID = PersonID FROM deleted;
    SELECT @NewSalary = Salary FROM inserted;

    IF @NewSalary < 0.9 * @OldSalary
    BEGIN
        UPDATE PersonInfo
        SET Salary = 0.9 * @OldSalary
        WHERE PersonID = @PersonID;
    END
END;

INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
VALUES (113, 'Pooja Sharma', 50000.00, '2025-06-01', 'Goa', 30, '1995-01-01');

UPDATE PersonInfo
SET Salary = 40000.00
WHERE PersonID = 113;

SELECT * FROM PersonInfo WHERE PersonID = 113;

drop TRIGGER trg_LimitSalaryDecrease

--Part – C
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL
--during an INSERT.
CREATE TRIGGER tr_DefaultJoiningDate
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET JoiningDate = ISNULL(JoiningDate, GETDATE())
    WHERE PersonID IN (SELECT PersonID FROM inserted);
END;

Insert into personinfo 
values(107,'Kunal Kapoor',62400,NULL,'Delhi',22,'2004-08-23');

SELECT* FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_DefaultJoiningDate

--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints
--‘Record deleted successfully from PersonLog’.
CREATE or ALTER TRIGGER tr_MessageOnDelete
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog';
END;

DELETE FROM PersonLog 
WHERE PLogID = 2;

SELECT* FROM PersonInfo
SELECT * FROM PersonLog

drop TRIGGER tr_MessageOnDelete
