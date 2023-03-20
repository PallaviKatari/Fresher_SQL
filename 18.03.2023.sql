use Trainees;

--The CAST() function converts a value (of any type) into a specified datatype.
SELECT CAST(25.65 AS int) as Number;

SELECT CAST(25.65 AS varchar) as Character;

SELECT CAST('2017-08-25' AS datetime) as DateTime;


--The CONVERT() function converts a value (of any type) into a specified datatype
SELECT CONVERT(int, 25.65);

SELECT CONVERT(varchar, 25.65);

SELECT CONVERT(datetime, '2017-08-25');

SELECT CONVERT(varchar, '2017-08-25');

--CAST is part of the ANSI-SQL specification; whereas, CONVERT is not.  In fact, CONVERT is SQL implementation-specific.
--CONVERT differences lie in that it accepts an optional style parameter that is used for formatting.
--For example, when converting a DateTime datatype to Varchar, you can specify the resulting date’s format, such as YYYY/MM/DD or MM/DD/YYYY.

SELECT CONVERT(VARCHAR,GETDATE(),101) as MMDDYYYY,
       CONVERT(VARCHAR,GETDATE(),111) as YYYYMMDD --https://learn.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?redirectedfrom=MSDN&view=sql-server-ver15

--The COALESCE() function returns the first non-null value in a list.
SELECT COALESCE(NULL, NULL, NULL, 'Hello', NULL, 'Trainees') as FirstNotNull;
SELECT COALESCE(NULL, 1, 2, 'Welcome') as FirstNotNull;

--The CURRENT_USER function returns the name of the current user in the SQL Server database.
SELECT CURRENT_USER as DefaultSchema;

--The IIF() function returns a value if a condition is TRUE, or another value if a condition is FALSE.
SELECT IIF(500<1000, 'YES', 'NO') as Result;
SELECT IIF(500>1000, 5, 10) as Result;

SELECT empname,salary, IIF(salary>70000, 'Senior Developer', 'Junior Developer') as Details
FROM batch35;

select * from batch35

-------------------------------
--SQL | Numeric Functions

SELECT ABS(-243.5) as abs; --absolute value
SELECT ACOS(0.25) as acos;
SELECT ASIN(0.25) as asin;
SELECT ATAN(2.5) as atan;
SELECT CEILING(25.75) as ceiling;
SELECT CEILING(25.05) as ceiling;
SELECT COS(30) as cos;
SELECT COT(6) as cot;
SELECT DEGREES(1.5) as degrees;--It converts a radian value into degrees.
SELECT DEGREES(PI()) as pidegree;
SELECT EXP(10) as exp;
SELECT FLOOR(25.99) as floor;
SELECT ROUND(235.414, 2) AS RoundValue;
SELECT SIGN(255.5) as PositiveNegativeSign;
SELECT SQUARE(4) as Square;
SELECT POWER(4, 2) as Power;
--RAND(seed)
--seed	Optional. If seed is specified, it returns a repeatable sequence of random numbers. 
--If no seed is specified, it returns a completely random number
SELECT RAND();--no seed value - so it returns a completely random number >= 0 and <1
SELECT RAND(6);
SELECT RAND()*(10-5+1)+5;--Return a random number >= 5 and <=10:
SELECT RAND()*(10-5)+5;--Return a random decimal number >= 5 and <10:

--String Functions
select * from batch35;
SELECT empname,ASCII(empname) AS NumCodeOfFirstChar FROM batch35;

select ASCII('A') as Uppercase;
select ASCII('a') as Lowercase;

SELECT CHAR(FLOOR(RAND()*97)) AS CodeToCharacter;

SELECT CHARINDEX('t', 'Trainee') AS MatchPosition;--CHARINDEX(substring, string, start)
SELECT CHARINDEX('in', 'Trainee') AS MatchPosition;
SELECT CHARINDEX('rain', 'Trainee') AS MatchPosition;

select empname,charindex('a',empname) from batch35;

SELECT CONCAT('Hello',' ','Trainees') as Concatenation;
SELECT 'Welcome'+' '+'to'+' '+'CG VAK' as StringConcatenation;

SELECT DATALENGTH('CG VAK') as Company;
SELECT DATALENGTH('G2') as Company;
SELECT empname,DATALENGTH(empname) as NameLength from batch35;

/*The DIFFERENCE() function compares two SOUNDEX values, and returns an integer.
The integer value indicates the match for the two SOUNDEX values, from 0 to 4.
0 indicates weak or no similarity between the SOUNDEX values.
4 indicates strong similarity or identically SOUNDEX values.*/

SELECT DIFFERENCE('Trainee', 'Trainees') as Difference;

--Return a string with 1 space:
SELECT concat(empname,'''s salary is ',space(1),salary) as Details from batch35;

SELECT STR(185.476, 6, 2);--STR(number, length, decimals)
SELECT STR(185.5);

--The STUFF() function deletes a part of a string and then inserts another part into the string, starting at a specified position.
SELECT STUFF('Hello Trainees', 1, 5, 'Hi');--STUFF(string, start, length, new_string)
SELECT STUFF('Hi Trainees!', 12, 1, ' Welcome!!!');

--The SUBSTRING() function extracts some characters from a string.
SELECT SUBSTRING('Hello Trainees', 1, 5) AS ExtractString;--SUBSTRING(string, start, length)
SELECT empname,SUBSTRING(empname, 1, 3) AS ExtractString from batch35;

SELECT empname,UNICODE(empname) AS UnicodeOfFirstChar from batch35;
SELECT empname,UPPER(empname) AS UnicodeOfFirstChar from batch35;
SELECT empname,LOWER(empname) AS UnicodeOfFirstChar from batch35;

-----------------------------------------
--DATE FUNCTIONS
/*
SQL Server SYSDATETIME, SYSDATETIMEOFFSET and SYSUTCDATETIME Functions
SQL Server High Precision Date and Time Functions have a scale of 7 and are:

SYSDATETIME - returns the date and time of the machine the SQL Server is running on
SYSDATETIMEOFFSET - returns the date and time of the machine the SQL Server is running on plus the offset from UTC
SYSUTCDATETIME - returns the date and time of the machine the SQL Server is running on as UTC*/

-- higher precision functions 
SELECT SYSDATETIME()       AS 'DateAndTime';        -- return datetime2(7)       
SELECT SYSDATETIMEOFFSET() AS 'DateAndTime+Offset'; -- datetimeoffset(7)
SELECT SYSUTCDATETIME()    AS 'DateAndTimeInUtc';   -- returns datetime2(7)

/*SQL Server CURRENT_TIMESTAMP, GETDATE() and GETUTCDATE() Functions
SQL Server Lesser Precision Data and Time Functions have a scale of 3 and are:

CURRENT_TIMESTAMP - returns the date and time of the machine the SQL Server is running on
GETDATE() - returns the date and time of the machine the SQL Server is running on
GETUTCDATE() - returns the date and time of the machine the SQL Server is running on as UTC*/

-- lesser precision functions - returns datetime
SELECT CURRENT_TIMESTAMP AS 'DateAndTime'; -- note: no parentheses   
SELECT GETDATE()         AS 'DateAndTime';    
SELECT GETUTCDATE()      AS 'DateAndTimeUtc'; 

/*SQL Server DATENAME Function
DATENAME - Returns a string corresponding to the datepart specified for the given date*/
-- date and time parts - returns nvarchar 
SELECT GETDATE() AS CURRENTDATE;
SELECT DATENAME(YEAR, GETDATE())        AS 'Year';        
SELECT DATENAME(QUARTER, GETDATE())     AS 'Quarter';     
SELECT DATENAME(MONTH, GETDATE())       AS 'Month Name';       
SELECT DATENAME(DAYOFYEAR, GETDATE())   AS 'DayOfYear';   
SELECT DATENAME(DAY, GETDATE())         AS 'Day';         
SELECT DATENAME(WEEK, GETDATE())        AS 'Week';        
SELECT DATENAME(WEEKDAY, GETDATE())     AS 'Day of the Week';     
SELECT DATENAME(HOUR, GETDATE())        AS 'Hour';        
SELECT DATENAME(MINUTE, GETDATE())      AS 'Minute';      
SELECT DATENAME(SECOND, GETDATE())      AS 'Second';      
SELECT DATENAME(MILLISECOND, GETDATE()) AS 'MilliSecond'; 
SELECT DATENAME(MICROSECOND, GETDATE()) AS 'MicroSecond'; 
SELECT DATENAME(NANOSECOND, GETDATE())  AS 'NanoSecond';  
SELECT DATENAME(ISO_WEEK, GETDATE())    AS 'Week';    

/*SQL Server DATEPART Function
DATEPART - returns an integer corresponding to the datepart specified*/

-- date and time parts - returns int
SELECT DATEPART(YEAR, GETDATE())        AS 'Year';        
SELECT DATEPART(QUARTER, GETDATE())     AS 'Quarter';     
SELECT DATEPART(MONTH, GETDATE())       AS 'Month';       
SELECT DATEPART(DAYOFYEAR, GETDATE())   AS 'DayOfYear';   
SELECT DATEPART(DAY, GETDATE())         AS 'Day';         
SELECT DATEPART(WEEK, GETDATE())        AS 'Week';        
SELECT DATEPART(WEEKDAY, GETDATE())     AS 'WeekDay';     
SELECT DATEPART(HOUR, GETDATE())        AS 'Hour';        
SELECT DATEPART(MINUTE, GETDATE())      AS 'Minute';      
SELECT DATEPART(SECOND, GETDATE())      AS 'Second';      
SELECT DATEPART(MILLISECOND, GETDATE()) AS 'MilliSecond'; 
SELECT DATEPART(MICROSECOND, GETDATE()) AS 'MicroSecond'; 
SELECT DATEPART(NANOSECOND, GETDATE())  AS 'NanoSecond';  
SELECT DATEPART(ISO_WEEK, GETDATE())    AS 'Week'; 

/*SQL Server DAY, MONTH and YEAR Functions
DAY - returns an integer corresponding to the day specified
MONTH - returns an integer corresponding to the month specified
YEAR - returns an integer corresponding to the year specified*/

SELECT DAY(GETDATE())   AS 'Day';                            
SELECT MONTH(GETDATE()) AS 'Month';                       
SELECT YEAR(GETDATE())  AS 'Year';  

/*SQL Server DATEFROMPARTS, DATETIME2FROMPARTS, DATETIMEFROMPARTS, DATETIMEOFFSETFROMPARTS, SMALLDATETIMEFROMPARTS and  TIMEFROMPARTS Functions
DATEFROMPARTS - returns a date from the date specified
DATETIME2FROMPARTS - returns a datetime2 from part specified
DATETIMEFROMPARTS - returns a datetime from part specified
DATETIMEOFFSETFROMPARTS - returns a datetimeoffset from part specified
SMALLDATETIMEFROMPARTS - returns a smalldatetime from part specified
TIMEFROMPARTS - returns a time from part specified*/

-- date and time from parts
SELECT DATEFROMPARTS(2019,1,1)                         AS 'Date';          -- returns date, 3 arguments
SELECT DATETIME2FROMPARTS(2019,1,1,6,7,8,123,3)          AS 'DateTime2';     -- returns datetime2, 8 arguments
SELECT DATETIMEFROMPARTS(2019,1,1,6,7,8,123)             AS 'DateTime';      -- returns datetime , 7 arguments
SELECT DATETIMEOFFSETFROMPARTS(2019,1,1,6,2,3,4,5,30,7) AS 'Offset';        -- returns datetimeoffset
SELECT SMALLDATETIMEFROMPARTS(2019,1,1,6,0)            AS 'SmallDateTime'; -- returns smalldatetime
SELECT TIMEFROMPARTS(6,7,8,123,3)                        AS 'Time';          -- returns time

/*SQL Server DATEDIFF and DATEDIFF_BIG Functions
DATEDIFF - returns the number of date or time datepart boundaries crossed between specified dates as an int
DATEDIFF_BIG - returns the number of date or time datepart boundaries crossed between specified dates as a bigint*/

--Date and Time Difference
SELECT DATEDIFF(DAY, 2021-10-09, 2021-01-08)      AS 'DateDif'    -- returns int
SELECT DATEDIFF_BIG(DAY, 2021-10-09, 2021-03-08)  AS 'DateDifBig' -- returns bigint

/*SQL Server DATEADD, EOMONTH, SWITCHOFFSET and TODATETIMEOFFSET Functions
DATEADD - returns datepart with added interval as a datetime
EOMONTH - returns last day of month of offset as type of start_date
SWITCHOFFSET - returns date and time offset and time zone offset
TODATETIMEOFFSET - returns date and time with time zone offset*/

-- modify date and time
SELECT DATEADD(DAY,1,GETDATE())        AS 'DatePlus1';          -- returns data type of the date argument
SELECT DATEADD(YEAR,1,GETDATE())        AS 'YearPlus1';  
SELECT EOMONTH(GETDATE(),1)            AS 'LastDayOfNextMonth'; -- returns start_date argument or date
SELECT EOMONTH(GETDATE(),5)            AS 'LastDayOfAugustMonth';

--The following example uses SWITCHOFFSET to display a different time zone offset than the value stored in the database.
CREATE TABLE dbo.test   
    (  
    ColDatetimeoffset datetimeoffset  
    );  
INSERT INTO dbo.test   
VALUES ('1998-09-20 7:45:50.71345 -5:00');  
INSERT INTO dbo.test   
VALUES ('1998-09-20 7:45:50.71345 -5:30');  
INSERT INTO dbo.test   
VALUES ('1998-09-20 7:45:50.71345 +5:30');  
 
SELECT SWITCHOFFSET (ColDatetimeoffset, '-08:00')   
FROM dbo.test;  --temporary retrieval

--Returns: 1998-09-20 04:45:50.7134500 -08:00  
SELECT ColDatetimeoffset  
FROM dbo.test;  
--Returns: 1998-09-20 07:45:50.7134500 -05:00  
 
SELECT
    TODATETIMEOFFSET (
        '2019-03-06 07:43:58',
        '-08:00'
    ) result;

SELECT SYSDATETIME() AS [SYSDATETIME()]  ,SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET()]  

--CONVERT
SELECT CONVERT (date, SYSDATETIME())  
    ,CONVERT (date, SYSDATETIMEOFFSET())  
    ,CONVERT (date, SYSUTCDATETIME())  
    ,CONVERT (date, CURRENT_TIMESTAMP)  
    ,CONVERT (date, GETDATE())  
    ,CONVERT (date, GETUTCDATE());  

SELECT CONVERT (time, SYSDATETIME()) AS [SYSDATETIME()]  
    ,CONVERT (time, SYSDATETIMEOFFSET()) AS [SYSDATETIMEOFFSET()]  
    ,CONVERT (time, SYSUTCDATETIME()) AS [SYSUTCDATETIME()]  
    ,CONVERT (time, CURRENT_TIMESTAMP) AS [CURRENT_TIMESTAMP]  
    ,CONVERT (time, GETDATE()) AS [GETDATE()]  
    ,CONVERT (time, GETUTCDATE()) AS [GETUTCDATE()]; 

	/*SQL Server ISDATE Function to Validate Date and Time Values
ISDATE - returns int - Returns 1 if a valid datetime type and 0 if not*/

-- validate date and time - returns int
SELECT ISDATE(GETDATE()) AS 'IsDate'; 
SELECT ISDATE(NULL) AS 'IsDate';

--DATEADD (date_part , value , input_date ) 
SELECT DATEADD(second, 1, '2018-12-31 23:59:59') result;
SELECT DATEADD(day, 1, '2018-12-31 23:59:59') result;

create table orders
(
orderid int,
orderdate datetime
)

insert into orders values(1,'2022-10-10'),(2,'2022-10-15'),(3,'2022-10-21')
select * from orders;

SELECT 
    orderid, 
    orderdate,
    DATEADD(day, 2, orderdate) estimated_shipped_date
FROM 
    orders;

SELECT DATEADD(month, 4, '2019-05-31') AS result;




