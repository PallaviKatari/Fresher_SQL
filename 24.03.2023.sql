--Table variable is a type of local variable that used to store data temporarily, similar to the temp table in SQL Server. 
--Tempdb database is used to store table variables.

--Table variables are kinds of variables that allow you to hold rows of data, 
--which are similar to temporary tables.

/*The scope of table variables
Similar to local variables, table variables are out of scope at the end of the batch.
If you define a table variable in a stored procedure or user-defined function, 
the table variable will no longer exist after the stored procedure or user-defined function exits.*/

--To declare a table variable, you use the DECLARE statement as follows:
--Note that you need to execute the whole batch or you will get an error:
use trainees;

DECLARE @department TABLE (
    empname VARCHAR(25),
    salary int,
	designation VARCHAR(25)
);
INSERT INTO @department
select empname,salary,designation from batch35;
select * from @department;

/*you have to define the structure of the table variable during the declaration. 
Unlike a regular or temporary table, 
you cannot alter the structure of the table variables after they are declared.*/

/*Performance of table variables
Using table variables in a stored procedure results in fewer recompilations than using a temporary table.
In addition, a table variable use fewer resources than a temporary table with less locking and logging overhead.
Similar to the temporary table, the table variables do live in the tempdb database, not in the memory.*/

DECLARE @WeekDays TABLE (Number INT, Day VARCHAR(40), Name VARCHAR(40));
INSERT INTO @WeekDays
VALUES
(1, 'Mon', 'Monday'),
(2, 'Tue', 'Tuesday'),
(3, 'Wed', 'Wednesday'),
(4, 'Thu', 'Thursday'),
(5, 'Fri', 'Friday'),
(6, 'Sat', 'Saturday'),
(7, 'Sun', 'Sunday');
SELECT * FROM @WeekDays;

DELETE @WeekDays WHERE Number=7;

UPDATE @WeekDays SET Name='Saturday is a holiday' WHERE Number=6 ;
SELECT * FROM @WeekDays;

---------------------------------------------------------------------
/*Temporary tables are tables that exist temporarily on the SQL Server.
SQL Server provided two ways to create temporary tables via SELECT INTO and CREATE TABLE statements.

Create temporary tables using SELECT INTO statement*/

SELECT
   empname,salary,designation
INTO #Salary --- local temporary table
FROM
    batch35
WHERE
    salary>=200000;

--Create temporary tables using CREATE TABLE statement
select * from trainees35;
CREATE TABLE #departmentReact (
    empid int primary key,
	empname varchar(25),
	department varchar(25)
	);

	INSERT INTO #departmentReact
	select empid,empname,designation from trainees35 where designation='React Development';

	select * from #departmentReact

--However, if you open another connection and try the query above query, you will get the an error.
--This is because the temporary tables are only accessible within the session that created them.

/*Global temporary tables
Sometimes, you may want to create a temporary table that is accessible across connections. 
In this case, you can use global temporary tables.*/

CREATE TABLE ##departmentAngular (
    empid int primary key,
	empname varchar(25),
	department varchar(25)
	);

	INSERT INTO ##departmentAngular
	select empid,empname,designation from trainees35 where designation='Angular Development';

	select * from ##departmentAngular;

/*Dropping temporary tables
Automatic removal
SQL Server drops a temporary table automatically when you close the connection that created it.

SQL Server drops a global temporary table once the connection that created it closed and the queries against this table from other connections completes.

Manual Deletion
From the connection in which the temporary table created, you can manually remove the temporary table by using the DROP TABLE statement.*/

DROP TABLE #departmentReact;
DROP TABLE ##departmentAngular;


