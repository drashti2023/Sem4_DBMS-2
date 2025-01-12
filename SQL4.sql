--Part – A
--1. Write a function to print "hello world".
CREATE OR ALTER FUNCTION FN_HELLOWORLD()
RETURNS VARCHAR(20)
AS
BEGIN
	RETURN 'HELLO WORLD'
END
select dbo.FN_HELLOWORLD()

--2. Write a function which returns addition of two numbers.
CREATE OR ALTER FUNCTION FN_ADDNUM(
	@N1 INT,
	@N2 INT)
RETURNS INT
AS 
BEGIN
	DECLARE @SUM INT
	SET @SUM = @N1 + @N2
	RETURN @SUM
END
select dbo.FN_ADDNUM(17,6) as ADDITION

--3. Write a function to check whether the given number is ODD or EVEN.
CREATE OR ALTER FUNCTION FN_ODDEVEN(@N1 INT)
RETURNS VARCHAR(20)
AS 
BEGIN   
    DECLARE @MSG VARCHAR(20)
    IF @N1 % 2 = 0 
        SET @MSG = 'EVEN NUMBER'
    ELSE 
        SET @MSG = 'ODD NUMBER'
    RETURN @MSG
END;

select dbo.FN_ODDEVEN(5)

--4. Write a function which returns a table with details of a person whose first name starts with B.
CREATE OR ALTER FUNCTION FN_PERSON()
RETURNS TABLE 
AS 
RETURN (SELECT * FROM PERSON 
		WHERE FIRSTNAME LIKE 'B%')
select * from dbo.FN_PERSON()

--5. Write a function which returns a table with unique first names from the person table.
CREATE OR ALTER FUNCTION FN_UNIQUE()
RETURNS TABLE
AS 
RETURN 
    (SELECT DISTINCT FIRSTNAME FROM PERSON)
select * from dbo.FN_UNIQUE()

--6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FN_PRINTNUM(@N1 INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @MSG VARCHAR(MAX), @COUNT INT
    SET @MSG = ''
    SET @COUNT = 1
    WHILE @COUNT <= @N1
    BEGIN
        SET @MSG = @MSG + CAST(@COUNT AS VARCHAR) + ' '
        SET @COUNT = @COUNT + 1
    END
    RETURN @MSG
END
select dbo.FN_PRINTNUM(7)

--7. Write a function to find the factorial of a given integer.
CREATE OR ALTER FUNCTION FN_FACT(@N INT)
RETURNS INT
AS
BEGIN
	DECLARE @NUM INT
	SET @NUM = 1
	WHILE @N > 1
		BEGIN
			SET @NUM = @NUM * @N;
			SET @N = @N - 1;
		END
RETURN @NUM
END
select dbo.FN_FACT(5) AS Factorial;

--Part – B
--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
CREATE OR ALTER FUNCTION FN_COMPARE(@N1 INT, @N2 INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @MSG VARCHAR(MAX)
    SET @MSG = CASE 
                   WHEN @N1 > @N2 THEN 'Number a is greater than b'
                   WHEN @N1 < @N2 THEN 'Number b is greater than a'
                   ELSE 'Both numbers are equal'
               END
    RETURN @MSG
END
select dbo.FN_COMPARE(10, 20)

--9. Write a function to print the sum of even numbers between 1 to 20.
CREATE OR ALTER FUNCTION FN_1TO20()
RETURNS INT
AS
BEGIN
    DECLARE @sum INT, @Count INT
    SET @sum = 0
    SET @Count = 2
    WHILE @Count <= 20
    BEGIN 
        SET @sum = @sum + @Count
        SET @Count = @Count + 2
    END
    RETURN @sum
END
select dbo.FN_1TO20() as SumOfEvenNumbers

--10. Write a function that checks if a given string is a palindrome.
CREATE OR ALTER FUNCTION FN_PALINDROME(@S1 VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @rev VARCHAR(MAX)
    SET @rev = REVERSE(@S1)
    IF @S1 = @rev
        RETURN 'Palindrome'
    ELSE 
        RETURN 'Not Palindrome'
    RETURN 'Invalid Input'
END
select dbo.FN_PALINDROME('12321')

--Part – C
--11. Write a function to check whether a given number is prime or not.
CREATE OR ALTER FUNCTION FN_PRIME(@N INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @NUM INT;
    SET @NUM = 2;
    WHILE @NUM * @NUM <= @N
    BEGIN
        IF @N % @NUM = 0
            RETURN 'NOT PRIME'
        SET @NUM = @NUM + 1;
    END
    RETURN 'PRIME'
END
SELECT dbo.FN_PRIME(2) AS Result;


--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
CREATE OR ALTER FUNCTION FN_RETURNDAYS(@SDATE DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @SDATE, GETDATE());
END
SELECT dbo.FN_RETURNDAYS('2024-01-10') AS DaysDifference

--13. Write a function which accepts two parameters year & month in integer and returns total days each
--year.
CREATE OR ALTER FUNCTION fn_TotalDaysInMonth(@Year INT, @Month INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalDays INT;
    SET @TotalDays = DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)));
    RETURN @TotalDays;
END
SELECT dbo.fn_TotalDaysInMonth(2024, 8) AS TotalDays

--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
CREATE OR ALTER FUNCTION FN_GETEMPLOYEESBYDEPARTMENT(@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        FirstName,
        LastName,
        DepartmentID,
        Salary
    FROM Person
    WHERE DepartmentID = @DepartmentID
)
SELECT * FROM dbo.FN_GETEMPLOYEESBYDEPARTMENT(2)

--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
CREATE OR ALTER FUNCTION FN_PERSONSJOINEDAFTER(@JoinDate DATE)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        FirstName,
        LastName,
        JoiningDate
    FROM Person
    WHERE JoiningDate > @JoinDate
)
select * from dbo.FN_PERSONSJOINEDAFTER('1991-01-01')
