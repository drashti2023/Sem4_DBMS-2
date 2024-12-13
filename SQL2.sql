-- Create Department Table
CREATE TABLE Department (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Designation Table
CREATE TABLE Designation (
 DesignationID INT PRIMARY KEY,
 DesignationName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Person Table
CREATE TABLE Person (
 PersonID INT PRIMARY KEY IDENTITY(101,1),
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8, 2) NOT NULL,
 JoiningDate DATETIME NOT NULL,
 DepartmentID INT NULL,
 DesignationID INT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
 FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

--Part – A
--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.

CREATE PROCEDURE PR_DEPARTMENT_INSERT
	@DEPTID INT,
	@DEPTNAME VARCHAR(100)
AS 
BEGIN
	INSERT INTO DEPARTMENT
	(DEPARTMENTID,DEPARTMENTNAME)
	VALUES
	(@DEPTID,@DEPTNAME)
END

EXEC PR_DEPARTMENT_INSERT 1,'ADMIN'
EXEC PR_DEPARTMENT_INSERT 2,'IT'
EXEC PR_DEPARTMENT_INSERT 3,'HR'
EXEC PR_DEPARTMENT_INSERT 4,'ACCOUNT'

CREATE PROCEDURE PR_DESIGNATION_INSERT
	@DEGID INT,
	@DEGNAME VARCHAR(100)
AS 
BEGIN
	INSERT INTO DESIGNATION
	(DESIGNATIONID,DESIGNATIONNAME)
	VALUES
	(@DEGID,@DEGNAME)
END

EXEC PR_DESIGNATION_INSERT 11,'JOBBER'
EXEC PR_DESIGNATION_INSERT 12,'WELDER'
EXEC PR_DESIGNATION_INSERT 13,'CLERK'
EXEC PR_DESIGNATION_INSERT 14,'MANAGER'
EXEC PR_DESIGNATION_INSERT 15,'CEO'

CREATE PROCEDURE PR_PERSON_INSERT
	@PFIRSTNAME VARCHAR(100),
	@PLASTNAME VARCHAR(100),
	@PSALARY DECIMAL(8,2),
	@PJOININGDT DATETIME,
	@PDEPTID INT,
	@PDEGID INT
AS 
BEGIN
	INSERT INTO PERSON
	(FIRSTNAME,LASTNAME,SALARY,JOININGDATE,DEPARTMENTID,DESIGNATIONID)
	VALUES
	(@PFIRSTNAME,@PLASTNAME,@PSALARY,@PJOININGDT,@PDEPTID,@PDEGID)
END

EXEC PR_PERSON_INSERT 'RAHUL','ANSHU',56000,'01-01-1990',1,12
EXEC PR_PERSON_INSERT 'HARDIK','HINSHU',18000,'1990-09-25',2,11
EXEC PR_PERSON_INSERT 'BHAVIN','KAMANI',25000,'1991-05-14',NULL,11
EXEC PR_PERSON_INSERT 'BHOOMI','PATEL',39000,'2014-02-20',1,13
EXEC PR_PERSON_INSERT 'ROHIT','RAJGOR',17000,'1990-07-23',2,15
EXEC PR_PERSON_INSERT 'PRIYA','MEHTA',25000,'1990-10-18',2,NULL
EXEC PR_PERSON_INSERT 'NEHA','TRIVEDI',18000,'2014-02-20',3,15

CREATE PROCEDURE PR_DEPARTMENT_DELETE
	@DEPTID INT
AS
BEGIN
	DELETE FROM DEPARTMENT
	WHERE DEPARTMENTID=@DEPTID
END

CREATE PROCEDURE PR_DESIGNATION_DELETE
	@DEGID INT
AS
BEGIN
	DELETE FROM DESIGNATION
	WHERE DESIGNATIONID=@DEGID
END

CREATE PROCEDURE PR_PERSON_DELETE
	@PID INT
AS
BEGIN
	DELETE FROM PERSON
	WHERE PERSONID=@PID
END

CREATE PROCEDURE PR_DEPARTMENT_UPDATE
	@DEPTID INT,
	@DEPTNAME VARCHAR(100)
AS 
BEGIN
	UPDATE DEPARTMENT
	SET 
	DEPARTMENTNAME=@DEPTNAME
	WHERE 
	DEPARTMENTID = @DEPTID
END

CREATE PROCEDURE PR_DESIGNATION_UPDATE
	@DEGID INT,
	@DEGNAME VARCHAR(100)
AS 
BEGIN
	UPDATE DESIGNATION
	SET 
	DESIGNATIONNAME=@DEGNAME
	WHERE 
	DESIGNATIONID = @DEGID
END

CREATE OR ALTER PROCEDURE PR_PERSON_UPDATE
	@PID INT,
	@PFIRSTNAME VARCHAR(100),
	@PLASTNAME VARCHAR(100),
	@PSALARY DECIMAL(8,2),
	@PJOININGDT DATETIME,
	@PDEPTID INT,
	@PDEGID INT
AS 
BEGIN
	UPDATE PERSON
	SET 
	FIRSTNAME=@PFIRSTNAME ,
	LASTNAME=@PLASTNAME ,
	SALARY=@PSALARY ,
	JOININGDATE=@PJOININGDT,
	DEPARTMENTID=@PDEPTID ,
	DESIGNATIONID=@PDEGID 
	WHERE 
	PERSONID = @PID
END

EXEC PR_PERSON_UPDATE 102,'DRASHTI','RATHOD',85000,'2005-08-23',2,15
SELECT * FROM PERSON

--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY
CREATE PROCEDURE PR_SelectDepartmentByPrimaryKey
    @DepartmentID int
AS
BEGIN
    SELECT *
    FROM Department
    WHERE DepartmentID = @DepartmentID;
END
EXEC PR_SelectDepartmentByPrimaryKey 1

CREATE PROCEDURE PR_SelectDesignationByPrimaryKey
    @DesignationID int
AS
BEGIN
    SELECT *
    FROM Designation
    WHERE DesignationID = @DesignationID;
END
EXEC PR_SelectDesignationByPrimaryKey 12

CREATE PROCEDURE PR_SelectPersonByPrimaryKey
    @PersonID int
AS
BEGIN
    SELECT *
    FROM Person
    WHERE PersonID = @PersonID;
END
EXEC PR_SelectPersonByPrimaryKey 103

--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take
--columns on select list)
CREATE PROCEDURE PR_SelectDepartment
    @DepartmentID int
AS
BEGIN
    SELECT DepartmentID,DepartmentName
    FROM Department
    WHERE DepartmentID = @DepartmentID;
END
EXEC PR_SelectDepartment 2

CREATE PROCEDURE PR_SelectDesignation
    @DesignationID int
AS
BEGIN
    SELECT DesignationID,DesignationName
    FROM Designation
    WHERE DesignationID = @DesignationID;
END
EXEC PR_SelectDesignation 13

CREATE PROCEDURE PR_SelectPerson
    @PersonID int
AS
BEGIN
    SELECT Person.PersonID,Person.FirstName,Person.LastName,
		   Person.Salary,Person.JoiningDate,
		   Department.DepartmentID,Designation.DesignationID
    FROM Person JOIN Department 
	ON Person.DepartmentID = Department.DepartmentID
    JOIN Designation
	ON Person.DesignationID = Designation.DesignationID
    WHERE Person.PersonID = @PersonID;
END
EXEC PR_SelectPerson 101

--4. Create a Procedure that shows details of the first 3 persons.
CREATE PROCEDURE PR_GetFirstThreePersons
AS
BEGIN
    SELECT TOP 3 
        PersonID,FirstName,LastName,Salary,
		JoiningDate,DepartmentID,DesignationID
    FROM Person
    ORDER BY PersonID
END
EXEC PR_GetFirstThreePersons

--Part – B
--5. Create a Procedure that takes the department name as input and returns a table with all workers
--working in that department.
CREATE PROCEDURE PR_Workers
	@DepartmentName VARCHAR(100)
AS 
BEGIN
	SELECT * 
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	WHERE DepartmentName=@DepartmentName
END
EXEC PR_Workers "IT"

--6. Create Procedure that takes department name & designation name as input and returns a table with
--worker’s first name, salary, joining date & department name.
CREATE PROCEDURE PR_WorkerDetails
	@DepartmentName VARCHAR(100),
	@DesignationName VARCHAR(100)
AS 
BEGIN
	SELECT Person.FirstName,Person.Salary,Person.JoiningDate,Department.DepartmentName 
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	WHERE DepartmentName=@DepartmentName AND DesignationName=@DesignationName
END
EXEC PR_WorkerDetails "HR","CEO"

--7. Create a Procedure that takes the first name as an input parameter and display all the details of the
--worker with their department & designation name.
CREATE PROCEDURE PR_WorkersInfo
	@FirstName VARCHAR(100)
AS
BEGIN
	SELECT Person.FirstName,Person.LastName,Person.JoiningDate,Person.Salary,
	       Person.DepartmentID,Person.DesignationID,
		   Department.DepartmentName,Designation.DesignationName
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	WHERE Person.FirstName=@FirstName
END
EXEC PR_WorkersInfo "Neha"

--8. Create Procedure which displays department wise maximum, minimum & total salaries.
CREATE PROCEDURE PR_MaxMinTotal
AS
BEGIN
	SELECT MAX(Person.Salary) AS MaxSalary,
	MIN(Person.Salary) AS MinSalary,
	Sum(Person.Salary) AS TotalSalary,Department.DepartmentName
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	GROUP BY Department.DepartmentName
END
EXEC PR_MaxMinTotal

--9. Create Procedure which displays designation wise average & total salaries.
CREATE PROCEDURE PR_AvgTotal
AS
BEGIN
	SELECT AVG(Person.Salary) AS AvgSalary,
	Sum(Person.Salary) AS TotalSalary,Designation.DesignationName
	FROM Person JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	GROUP BY Designation.DesignationName
END
EXEC PR_AvgTotal

--Part – C
--10. Create Procedure that Accepts Department Name and Returns Person Count.
CREATE PROCEDURE PR_PersonCount
	@DepartmentName VARCHAR(100)
AS
BEGIN
	SELECT Count(Person.Salary) AS PersonCount
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	WHERE Department.DepartmentName=@DepartmentName
END
EXEC PR_PersonCount "Admin"

--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than
--input salary value along with their department and designation details.
CREATE PROCEDURE PR_Salary
	@Salary int
AS
BEGIN
	SELECT *
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	WHERE Person.Salary > @Salary
END
EXEC PR_Salary 20000

--12. Create a procedure to find the department(s) with the highest total salary among all departments.
CREATE PROCEDURE PR_HighestTotalSalary
AS
BEGIN
    SELECT TOP 1 Department.DepartmentName, Department.DepartmentID
    FROM Department
    JOIN Person ON Department.DepartmentID = Person.DepartmentID
    GROUP BY Department.DepartmentName, Department.DepartmentID
    ORDER BY SUM(Person.Salary) DESC;
END

--13. Create a procedure that takes a designation name as input and returns a list of all workers under that
--designation who joined within the last 10 years, along with their department.
CREATE PROCEDURE PR_DesignationName
	@DesignationName VARCHAR(100)
AS
BEGIN
	SELECT *
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	WHERE Designation.DesignationName = @DesignationName 
		  AND Person.JoiningDate >= DATEADD(YEAR, -10,GETDATE())
END
EXEC PR_DesignationName "Manager"

--14. Create a procedure to list the number of workers in each department who do not have a designation
--assigned.
CREATE PROCEDURE PR_NoOfWorkers
AS
BEGIN
	SELECT COUNT(Person.PersonID) AS PeopleList,Department.DepartmentName
	FROM Person JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	Where Designation.DesignationName=NULL
	Group BY DepartmentName
END
EXEC PR_NoOfWorkers

--15. Create a procedure to retrieve the details of workers in departments where the average salary is above
--12000.
CREATE PROCEDURE PR_WorkersWithHighAvgSalary
AS
BEGIN
    SELECT *
    FROM Person
    JOIN Department ON Person.DepartmentID = Department.DepartmentID
    WHERE Person.DepartmentID IN (
        SELECT DepartmentID
        FROM Person
        GROUP BY DepartmentID
        HAVING AVG(Salary) > 12000)
END
EXEC PR_WorkersWithHighAvgSalary;

