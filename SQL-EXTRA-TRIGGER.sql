--AFTER TRIGGER
CREATE TABLE EMPLOYEEDETAILS(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
	);

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
	EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
	);

--1)Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"
CREATE OR ALTER TRIGGER tr_EmployeeDetails_AfterOperations
ON EMPLOYEEDETAILS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @EmployeeID INT;
    DECLARE @EmployeeName VARCHAR(100);
    DECLARE @Action NVARCHAR(100);
    DECLARE @CurrentDateTime DATETIME;

    SELECT @CurrentDateTime = GETDATE();

    -- Handle INSERT operation
    IF (SELECT COUNT(*) FROM inserted) > 0 AND (SELECT COUNT(*) FROM deleted) = 0
    BEGIN
        SET @Action = 'Employee record inserted';
        SELECT @EmployeeID = EmployeeID, @EmployeeName = EmployeeName FROM inserted;
    END
    -- Handle UPDATE operation
    ELSE IF (SELECT COUNT(*) FROM inserted) > 0 AND (SELECT COUNT(*) FROM deleted) > 0
    BEGIN
        SET @Action = 'Employee record updated';
        SELECT @EmployeeID = EmployeeID, @EmployeeName = EmployeeName FROM inserted;
    END
    -- Handle DELETE operation
    ELSE IF (SELECT COUNT(*) FROM deleted) > 0 AND (SELECT COUNT(*) FROM inserted) = 0
    BEGIN
        SET @Action = 'Employee record deleted';
        SELECT @EmployeeID = EmployeeID, @EmployeeName = EmployeeName FROM deleted;
    END

    -- Log the action in the EmployeeLogs table
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    VALUES (@EmployeeID, @EmployeeName, @Action, @CurrentDateTime);
END;

  

INSERT INTO EMPLOYEEDETAILS (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (201, 'John Doe', '1234567890', 'HR', 50000.00, '2025-02-07');

UPDATE EMPLOYEEDETAILS
SET EmployeeName = 'Jane Doe'
WHERE EmployeeID = 201;

DELETE FROM EMPLOYEEDETAILS
WHERE EmployeeID = 201;


select * from EMPLOYEEDETAILS
select * from EmployeeLogs

drop trigger tr_EmployeeDetails_AfterOperations

--2)Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.
CREATE OR ALTER TRIGGER tr_EmployeeDetails_Insert
ON EMPLOYEEDETAILS
AFTER INSERT
AS 
BEGIN
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    SELECT EmployeeID, EmployeeName, 'INSERT', GETDATE()
    FROM inserted;
END;

INSERT INTO EmployeeDetails 
VALUES (301, 'Nina Dobrew', '9054361323', 'IT', 250000.00, '2024-01-01')

drop trigger tr_EmployeeDetails_Insert

CREATE OR ALTER TRIGGER tr_EmployeeDetails_Update
ON EMPLOYEEDETAILS
AFTER UPDATE
AS 
BEGIN
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    SELECT EmployeeID, EmployeeName, 'UPDATE', GETDATE()
    FROM inserted;
END;

UPDATE EMPLOYEEDETAILS
SET EmployeeName = 'Elena Gilbert'
WHERE EmployeeID = 301;

drop trigger tr_EmployeeDetails_Update

CREATE OR ALTER TRIGGER tr_EmployeeDetails_Delete
ON EMPLOYEEDETAILS
AFTER DELETE
AS 
BEGIN
    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    SELECT EmployeeID, EmployeeName, 'DELETE', GETDATE()
    FROM deleted;
END;

DELETE FROM EMPLOYEEDETAILS
WHERE EmployeeID = 101;

drop trigger tr_EmployeeDetails_Delete

--3)Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
CREATE OR ALTER TRIGGER TR_BONUS
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
    UPDATE EMPLOYEEDETAILS
    SET Salary = Salary + (Salary * 0.1)
    WHERE EmployeeID IN (SELECT EmployeeID FROM inserted);
END;

INSERT INTO EMPLOYEEDETAILS (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (103, 'Rahul Sharma', '9876543210', 'Finance', 55000.00, '2025-06-01');

SELECT * FROM EMPLOYEEDETAILS WHERE EmployeeID = 103;

drop trigger TR_BONUS

--4)Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
CREATE TRIGGER tr_SetDefaultJoiningDate
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
    UPDATE EmployeeDetails
    SET JoiningDate = ISNULL(JoiningDate, GETDATE())
    WHERE EmployeeID IN (SELECT EmployeeID FROM inserted);
END;

INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (105, 'Amit Patel', '9876543210', 'Sales', 60000.00, NULL);

SELECT * FROM EmployeeDetails WHERE EmployeeID = 105;

drop trigger tr_SetDefaultJoiningDate

--5)Create a trigger that ensure that ContactNo is valid during insert and update (Like ContactNo length is 10)
CREATE OR ALTER TRIGGER TR_VALIDCONTACT
ON EMPLOYEEDETAILS
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @EmployeeID INT;
    DECLARE @EmployeeName VARCHAR(100);
    DECLARE @ContactNo VARCHAR(100);
    DECLARE @Message VARCHAR(100);

    SELECT @EmployeeID = EmployeeID, @EmployeeName = EmployeeName, @ContactNo = ContactNo FROM inserted;

    IF LEN(@ContactNo) = 10
    BEGIN
        SET @Message = 'VALID';
    END
    ELSE
    BEGIN
        SET @Message = 'NOT VALID';
    END

    INSERT INTO EmployeeLogs (EmployeeID, EmployeeName, ActionPerformed, ActionDate)
    VALUES (@EmployeeID, @EmployeeName, @Message, GETDATE());
END;

INSERT INTO EMPLOYEEDETAILS (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (106, 'Aditi Verma', '9876543210', 'HR', 45000.00, '2025-05-01');
INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, ContactNo, Department, Salary, JoiningDate)
VALUES (107, 'Anjali Kapoor', '876109', 'Finance', 55000.00, '2025-06-01');

SELECT * FROM EMPLOYEEDETAILS
SELECT * FROM EmployeeLogs

UPDATE EMPLOYEEDETAILS
SET ContactNo = '123'
WHERE EmployeeID = 106;

drop trigger TR_VALIDCONTACT


--INSTEAD OF TRIGGER
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);
SELECT * FROM Movies

--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.
CREATE or alter TRIGGER tr_Movie_insted_Insert
ON Movies
Instead of INSERT
AS
BEGIN
	Declare @movieId int;
	Declare @title varchar(100);

	select @movieId = movieId from inserted
	select @title = movietitle from inserted

	Insert into MoviesLog
	values(@movieId, @title, 'Insert', getdate())

END;
INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (101, 'New Movie', 2022, 'Drama', 7.0, 120);

SELECT * FROM MoviesLog;
SELECT * FROM Movies;

drop TRIGGER tr_Movie_insted_Insert

CREATE TRIGGER tr_Movie_instead_update
ON Movies
Instead of update
AS
BEGIN
	Declare @movieId int;
	Declare @title varchar(100);

	select @movieId = movieId from inserted
	select @title = movietitle from inserted

	INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
    SELECT MovieID, MovieTitle, 'Update', GETDATE()
    FROM inserted;

END;

UPDATE Movies
SET MovieTitle = 'Updated Movie'
WHERE MovieID = 1;

drop TRIGGER tr_Movie_instead_update

CREATE TRIGGER tr_Movie_instead_Delete
ON Movies
Instead of Delete
AS
BEGIN
	Declare @movieId int;
	Declare @title varchar(100);

	select @movieId = movieId from deleted
	select @title = movietitle from deleted

	INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
    VALUES (@movieId, @title, 'Delete', GETDATE());

END;

DELETE FROM Movies
WHERE MovieID = 1;

SELECT * FROM MoviesLog;
SELECT * FROM Movies;

drop TRIGGER tr_Movie_instead_Delete

--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
CREATE OR ALTER TRIGGER tr_Movie_instead_Insert_Rating
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
    SELECT MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration
    FROM inserted
    WHERE Rating > 5.5;

    INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
    SELECT MovieID, MovieTitle, 'Insert', GETDATE()
    FROM inserted
    WHERE Rating > 5.5;
END;
INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (1, 'High Rated Movie', 2022, 'Drama', 7.0, 120);
INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (2, 'Low Rated Movie', 2023, 'Comedy', 5.0, 90);

SELECT * FROM Movies;
SELECT * FROM MoviesLog;
 
drop TRIGGER tr_Movie_instead_Insert_Rating

--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.
CREATE OR ALTER TRIGGER tr_Insteadof_insert_Movie_duplicate
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
    SELECT i.MovieID, i.MovieTitle, i.ReleaseYear, i.Genre, i.Rating, i.Duration
    FROM inserted i
    WHERE i.MovieTitle NOT IN (SELECT MovieTitle FROM Movies);

    INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
    SELECT i.MovieID, i.MovieTitle, 'Attempt to Insert', GETDATE()
    FROM inserted i;
END;

INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (3, 'Unique Movie', 2022, 'Drama', 7.0, 120);
INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (4, 'Unique Movie', 2023, 'Comedy', 8.0, 90);

drop TRIGGER tr_Insteadof_insert_Movie_duplicate

--4.	Create trigger that prevents to insert pre-release movies.
CREATE OR ALTER TRIGGER tr_Insteadof_insert_Movie_PreRelease
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
    SELECT MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration
    FROM inserted
    WHERE ReleaseYear <= YEAR(GETDATE());

    INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
    SELECT i.MovieID, i.MovieTitle, 'Attempt to Insert Pre-Release Movie', GETDATE()
    FROM inserted i
    WHERE i.ReleaseYear > YEAR(GETDATE());
END;

INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (5, 'Released Movie', 2022, 'Drama', 7.0, 120);
INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (6, 'Pre-Release Movie', 2026, 'Sci-Fi', 8.0, 130);

SELECT * FROM Movies;
SELECT * FROM MoviesLog;

drop TRIGGER tr_Insteadof_insert_Movie_PreRelease

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.
CREATE OR ALTER TRIGGER tr_Insteadof_insert_Movie_Duration
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
    SELECT MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration
    FROM inserted
    WHERE Duration <= 120;

    INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
    SELECT i.MovieID, i.MovieTitle, 'Attempt to Insert Unrealistic Duration', GETDATE()
    FROM inserted i
    WHERE i.Duration > 120;
END;

INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (7, 'Valid Duration Movie', 2022, 'Drama', 7.0, 120);
INSERT INTO Movies (MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration)
VALUES (8, 'Unrealistic Duration Movie', 2025, 'Sci-Fi', 8.0, 130);

drop TRIGGER tr_Insteadof_insert_Movie_Duration
