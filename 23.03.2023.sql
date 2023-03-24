use Trainees;

/*Introduction SQL Server MERGE Statement
Suppose, you have two table called source and target tables, and you need to update the 
target table based on the values matched from the source table. There are three cases:

The source table has some rows that do not exist in the target table.
In this case, you need to insert rows that are in the source table into the target table.

The target table has some rows that do not exist in the source table. 
In this case, you need to delete rows from the target table.

The source table has some rows with the same keys as the rows in the target table. 
However, these rows have different values in the non-key columns. 
In this case, you need to update the rows in the target table with the values coming from the source table.*/

/*If you use the INSERT, UPDATE, and DELETE statement individually, you have to construct three separate statements to update the data to the target table with the matching rows from the source table.

However, SQL Server provides the MERGE statement that allows you to perform three actions at the same time. 

The following shows the syntax of the MERGE statement:*/

/*
MERGE target_table USING source_table
ON merge_condition
WHEN MATCHED
    THEN update_statement
WHEN NOT MATCHED
    THEN insert_statement
WHEN NOT MATCHED BY SOURCE
    THEN DELETE;
	*/

select * from onlinecustomers;
select * into onlinecustomersbackup from onlinecustomers where customerid<3;
select * from onlinecustomersbackup;
select * from onlinecustomers;
DROP TABLE onlinecustomersbackup;

UPDATE onlinecustomers set customername='Sam' where customerid=1

MERGE onlinecustomersbackup t 
    USING onlinecustomers s
ON (s.customerid = t.customerid)
WHEN MATCHED
    THEN UPDATE SET 
        t.customername = s.customername,
        t.customercity = s.customercity,
		t.customermail = s.customermail
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (customername,customercity,customermail)
         VALUES (s.customername,s.customercity,s.customermail)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

------------------------------------------------
/*What is a function in SQL Server?
A function in SQL Server is a subprogram that is used to perform an action such as complex calculation and returns the result of the action as a value. 
There are two types of functions in SQL Server, such as

System Defined Function
User-Defined Function*/

/*Types of User-Defined Function:
In SQL Server, we can create three types of User-Defined Functions, such as

Scalar Valued Functions
Inline Table-Valued Functions
Multi-Statement Table-Valued Functions*/

-- 1) Scalar Valued Functions
/*The user-defined function which returns only a single value 
(scalar value) is known as the Scalar Valued Function. 
Scalar Value Functions in SQL Server may or may not have parameters 
that are optional but always return a single (scalar) value which is mandatory. 
The returned value which is return by the SQL Server Scalar Function can be 
of any data type, except text, ntext, image, cursor, and timestamp. */

use trainees;
--Example
ALTER FUNCTION FN_SVF1(@X INT)
RETURNS INT
AS
BEGIN
  RETURN @X * @X
END

--call the function
SELECT dbo.FN_SVF1(3) as 'Result'
drop function dbo.FN_SVF1

--DATE DIFFERENCE
CREATE FUNCTION FN_CalculateAge
(
  @DOB DATE
)
RETURNS INT
AS
BEGIN
  DECLARE @AGE INT
  SET @AGE = DATEDIFF(YEAR, @DOB, GETDATE())
  RETURN @AGE
END

SELECT dbo.FN_CalculateAge ('01/07/2018')AS AGE

--Scalar Valued Function in Select Clause
select * from Worker;
SELECT worker_id,first_name + ' ' + last_name,salary,joining_date, dbo.FN_CalculateAge(joining_date) AS 'No of years in current company'
FROM Worker;

--SQL Server Scalar Valued Function in Where Clause
SELECT worker_id,first_name + ' ' + last_name,salary,joining_date, dbo.FN_CalculateAge(joining_date) AS 'No of years in current company'
FROM Worker
WHERE dbo.FN_calculateAge(joining_date) > 10

--Table Creation
create table mcninvoices  
(  
    invoiceid int not null identity primary key,  
    vendorid int not null,  
    invoiceno varchar(15),  
    invoicetotal money,  
    paymenttotal money,  
    creadittotal money  
)  ;
insert into mcninvoices values (20,'e001',100,100,0.00) ; 
insert into mcninvoices values (21,'e002',200,200,0.00);  
insert into mcninvoices values (22,'e003',500,0.00,100) ; 
insert into mcninvoices values (23,'e004',1000,100,100) ; 
insert into mcninvoices values (24,'e005',1200,200,500) ; 
insert into mcninvoices values (20,'e007',150,100,0.00) ; 
insert into mcninvoices values (21,'e008',800,200,0.00) ; 
insert into mcninvoices values (22,'e009',900,0.00,100) ; 
insert into mcninvoices values (23,'e010',6000,100,100) ; 
insert into mcninvoices values (24,'e011',8200,200,500);
  
create table mcnvendors  
(  
    vendorid int,  
    vendorname varchar(15),  
    vendorcity varchar(15),  
    vendorstate varchar(15)  
) ;

insert into mcnvendors values (20,'vipendra','noida','up')  ;
insert into mcnvendors values (21,'deepak','lucknow','up') ; 
insert into mcnvendors values (22,'rahul','kanpur','up')  ;
insert into mcnvendors values (23,'malay','delhi','delhi') ; 
insert into mcnvendors values (24,'mayank','noida','up') ; 

select * from mcninvoices;
select * from mcnvendors;

--Scalar valued function for dbo.mcninvoices  table
ALTER FUNCTION fnbal_invoice()  
RETURNS MONEY  
BEGIN  
RETURN(SELECT SUM(invoicetotal-paymenttotal-creadittotal)  
        FROM dbo.mcninvoices)  
END

SELECT SUM(invoicetotal-paymenttotal-creadittotal) as 'Result' ,invoicetotal-paymenttotal-creadittotal as 'Main'
        FROM dbo.mcninvoices  group  by ROLLUP(invoicetotal-paymenttotal-creadittotal)

Print 'Balance amount is '+ 'Rs '+ convert(varchar,dbo.fnbal_invoice())
--SUM(invoicetotal-paymenttotal-creadittotal) = 19050-1200-1400 = 16450

CREATE FUNCTION fun_totalsalary()    
RETURNS int  
BEGIN  
RETURN(SELECT sum(salary)  
        FROM batch35 
       )  
END

print 'Total salary is '+ convert(varchar,dbo.fun_totalsalary())

--Scalar valued function for dbo.mcnvendors  table
CREATE FUNCTION fnven_info  
(@vendorid int )  
RETURNS varchar(15)  
BEGIN  
    RETURN (SELECT vendorname FROM dbo.mcnvendors  
        WHERE vendorid=@vendorid)  
END

CREATE FUNCTION fn_custid() 
RETURNS int
BEGIN  
    RETURN (SELECT customerid FROM onlinecustomers  
        WHERE customercity='new york')  
END

select * from dbo.mcnvendors where vendorname=dbo.fnven_info(20);

select * from orders1 where customerid=dbo.fn_custid();

select * from onlinecustomers;
select * from orders1;

-----------------------------------------------------------------
--Inline Table-Valued functions

/*What are Inline Table-Valued functions in SQL Server?

In the case of an Inline Table-Valued Function, 
the body of the function will have only a Single Select Statement 
prepared with the �RETURN� statement. 
And here, we need to specify the Return Type as TABLE by using 
the RETURNS TABLE statement. */

/*We specify TABLE as the Return Type instead of any scalar data type.
The function body is not closed between BEGIN and END blocks. 
This is because the function is going to return a single select statement.
The structure of the Table that is going to be returned is determined by the select statement used in the function.
*/

select * from onlinecustomers;
--Create a function that accepts student id as input and returns that student details from the table.
CREATE FUNCTION FN_GetonlinecustomersByID
(
  @ID INT
)
RETURNS TABLE
AS
RETURN (SELECT * FROM onlinecustomers WHERE customerid = @ID)

SELECT * FROM FN_GetonlinecustomersByID(2)

--Create a function to accept branch name as input and returns the list of students who belongs to that branch.

CREATE FUNCTION FN_GetonlinecustomersByCity
(
  @city VARCHAR(50)
)
RETURNS TABLE
AS
RETURN (SELECT * FROM onlinecustomers WHERE CustomerCity = @city)

SELECT * FROM FN_GetonlinecustomersByCity('New York')


/*The Inline Table-Valued function in SQL Server can be used to 
achieve the functionalities of parameterized views, 
and the table returned by the inline table-valued function in SQL 
Server can also be used in joins with other tables.*/

--Inline Table-Valued Function with JOINs in SQL Server

--Let�s first create an Inline Table-Valued Function that returns the Employees by Gender from the Employees table.

select * from Employees;

CREATE FUNCTION FN_GetEmployeessByGender
(
  @Gender VARCHAR(50)
)
RETURNS TABLE
AS
RETURN (SELECT ID, Name, Gender FROM Employee1 WHERE Gender = @Gender)

SELECT ID, Name, Gender FROM Employees WHERE Gender ='Male';

--Example: Table-valued Function Returning data From two Tables using Join in SQL Server
select * from departments;
select * from  employee;

CREATE FUNCTION FN_EmployeessByDesignation
(
  @Designation VARCHAR(50)
)
RETURNS TABLE
AS
RETURN (
    SELECT emp.EID, emp.EName, dept.Dept_Name 
    FROM employee emp
    JOIN departments dept on emp.EDID = dept.Dept_id
    WHERE Dept_name = 'Angular Development')

SELECT * FROM dbo.FN_EmployeessByDesignation('Angular Development');
select * from Employee;
select * from Departments;

select * from onlinecustomers;
select * from orders1;

ALTER FUNCTION FN_orderdetails
(
  @city varchar(25)
)
RETURNS TABLE
AS
RETURN (
		select oc.customerid,oc.customername,oc.customercity,oc.customermail,o.orderid,o.ordertotal,o.discountrate,o.orderdate
		from onlinecustomers oc
		inner join
		orders1 o
		on oc.customerid=o.customerid where oc.customercity=@city
		)

select * from FN_orderdetails('Chicago')

select * from onlinecustomers;



-----------------------------------------------------------
/*Multi-Statement Table-Valued Function in SQL Server

The Multi-Statement Table Valued Function in SQL Server is the same as the Inline Table-Valued Function means it is also going to returns a table as an output but with the following differences.

The Multi-Statement Table-Valued Function body can contain more than one statement. In Inline Table-Valued Function, it contains only a single Select statement prepared by the return statement.
In Multi-Statement Table-Valued Function, the structure of the table returned from the function is defined by us. But, in Inline Table-Valued Function, the structure of the table is defined by 
the Select statement that is going to return from the function body.*/

--Let�s write both Inline and Multi-Statement Table-Valued functions in SQL Server that return the following output.

--Using Inline Table-Valued function
CREATE FUNCTION ILTVF_GetWorker()
RETURNS TABLE
AS
RETURN (SELECT WORKER_ID,FIRST_NAME, Cast(JOINING_DATE AS Date) AS DOJ
        FROM Worker)

--Calling the Inline Table-Valued Function: 
SELECT * FROM ILTVF_GetWorker()

select * from worker;
-- Multi-statement Table Valued function:
CREATE FUNCTION MLTVF_GetWorker()
RETURNS @Table Table (ID int, NAME nvarchar(20), DOJ Date)
AS
BEGIN
  INSERT INTO @Table
    SELECT WORKER_ID,FIRST_NAME, Cast(JOINING_DATE AS Date) AS DOJ
    FROM Worker where first_name like 'V%';
  Return
End

SELECT * FROM MLTVF_GetWorker()

/*
What are the differences between Inline and Multi-Statement Table-Valued Functions in SQL Server?
In an Inline Table-Valued Function, the returns clause cannot define the structure of the table that the function is going to return whereas in the Multi-Statement Table-Valued Function the returns clause defines the structure of the table that the function is going to return.

The Inline Table-Valued Function cannot have BEGIN and END blocks whereas the Multi-Statement Table-Valued Function has the Begin and End blocks.

It is possible to update the underlying database table using the inline table-valued function but it is not possible to update the underlying database table using the multi-statement table-valued function.

Inline Table-Valued functions are better for performance than the Multi-Statement Table-Valued function. So, if the given task can be achieved using an Inline Table-Valued Function, then it is always preferred to use Inline Table-valued Function over the Multi-Statement Table-Valued function.

Reason For Better Performance: Internally SQL Server treats an Inline Table-Valued function much like a view and treats a Multi-Statement Table-Valued function as a stored procedure.*/

--Update underlying database table using the inline table-valued function in SQL Server

SELECT * FROM dbo.ILTVF_GetWorker()

--For the above function, Employee is the underlying database table.

UPDATE ILTVF_GetWorker() SET FIRST_NAME='Monika' WHERE WORKER_ID= 1

/*
What is the Difference Between Functions and Procedures in SQL Server?
A function must return a value, it is mandatory whereas a procedure returning a value is optional.
The procedure can have parameters of both input and output whereas a function can have only input parameters.
In a procedure, we can perform Select. Update, Insert and Delete operations whereas function can only be used to perform select operations. It cannot be used to perform Insert, Update, and Delete operations that can change the state of the database.
A procedure provides the options to perform Transaction Management, Error Handling, etc whereas these operations are not possible in a function.
We call a procedure using EXECUTE/ EXEC command whereas a function is called by using SELECT command only.
From a procedure, we can call another procedure or a function whereas from a function we can call another function but not a procedure.
User-Defined Functions can be used in the SQL statements anywhere in the WHERE/HAVING/SELECT section where as Stored procedures cannot be.*/

----------------------------------------------------------------------
/*In 1970's the product called 'SEQUEL', structured English query language, developed by IBM and later SEQUEL was renamed to 'SQL' which stands for Structured Query Language.

In 1986, SQL was approved by ANSI (American national Standards Institute) and in 1987, it was approved by ISO (International Standards Organization).

SQL is a structure query language which is a common database language for all RDBMS products. Different RDBMS product vendors have developed their own database language by extending SQL for their own RDBMS products.

T-SQL stands for Transact Structure Query Language which is a Microsoft product and is an extension of SQL Language.

Example
MS SQL Server - SQL\T-SQL

ORACLE - SQL\PL-SQL*/

--STORED PROCEDURES

--The MS SQL Server Stored procedure is used to save time to write code again and again 
--by storing the same in database and also get the required output by passing parameters.

/*A stored procedure is a group of one or more pre-compiled SQL statements into a logical unit.
 It is stored as an object inside the database server. 
 It is a subroutine or a subprogram in the common computing language that has been created and stored in the database. 
 Each procedure in SQL Server always contains a name, parameter lists, and Transact-SQL statements. 
 The SQL Database Server stores the stored procedures as named objects. 

SYNTAX:
CREATE PROCEDURE [schema_name].procedure_name  
                @parameter_name data_type,   
                ....   
                parameter_name data_type  
AS  
   BEGIN  
      -- SQL statements  
      -- SELECT, INSERT, UPDATE, or DELETE statement  
   END  */

--SQL Server builds an execution plan when the stored procedure is called the first time and stores them in the cache memory. 
--The plan is reused by SQL Server in subsequent executions of the stored procedure, allowing it to run quickly and efficiently.

/*Features of Stored Procedures in SQL Server
The following are the features of stored procedure in SQL Server:

Reduced Traffic: A stored procedure reduces network traffic between the application and the database server, resulting in increased performance. It is because instead of sending several SQL statements, the application only needs to send the name of the stored procedure and its parameters.

Stronger Security: The procedure is always secure because it manages which processes and activities we can perform. It removes the need for permissions to be granted at the database object level and simplifies the security layers.

Reusable: Stored procedures are reusable. It reduces code inconsistency, prevents unnecessary rewrites of the same code, and makes the code transparent to all applications or users.

Easy Maintenance: The procedures are easier to maintain without restarting or deploying the application.

Improved Performance: Stored Procedure increases the application performance. Once we create the stored procedures and compile them the first time, it creates an execution plan reused for subsequent executions. The procedure is usually processed quicker because the query processor does not have to create a new plan.

Types of Stored Procedures
SQL Server categorizes the stored procedures mainly in two types:
User-defined Stored Procedures
System Stored Procedures*/

--Example:
select * from onlinecustomers;
ALTER PROCEDURE sp_onlinecustomers 
AS  
BEGIN  
    SELECT customerid,customername,customercity 
	FROM onlinecustomers 
    ORDER BY customercity desc;  
END;   

exec sp_onlinecustomers;

/*SET NOCOUNT ON in Stored Procedure
In some cases, we use the SET NOCOUNT ON statement in the stored procedure. 
This statement prevents the message that displays the number of rows affected by SQL queries from being shown. 
NOCOUNT denotes that the count is turned off. 
It means that if SET NOCOUNT ON is set, no message would appear indicating the number of rows affected.*/

SELECT * FROM sys.procedures;  

--Input Parameters in Stored Procedure

ALTER PROCEDURE sp_customercity (@city VARCHAR(50))  
AS  
BEGIN   
  SELECT customerid,customername,customercity 
	FROM onlinecustomers 
    WHERE customercity=@city;  
END 

exec sp_customercity @city='New York';
--or
exec sp_customercity 'Chicago';

--Output Parameters in Stored Procedure
select * from orders1
CREATE PROCEDURE sp_ordertotal (@ordertotal INT OUTPUT)  --100
AS  
BEGIN  
    SELECT @ordertotal = sum(ordertotal) FROM orders1;  
END;  

--int add(int a)
--{
--return a;
--}
--void main()
--{
--int res=add(10);
--cout<<res;
--}

-- Declare an Int Variable that corresponds to the Output parameter in SP  
DECLARE @Total INT   
  
-- Don't forget to use the keyword OUTPUT  
EXEC sp_ordertotal @Total OUTPUT  
  
-- Print the result  
PRINT @Total  

ALTER PROCEDURE sp_name_city @name varchar(30), @city varchar(30)
AS
SELECT * FROM onlinecustomers WHERE customername=@name OR customercity=@city

EXEC sp_name_city 'Stella', 'New York'
--or
EXEC sp_name_city @name='Edward',@city= 'Phoenix'

--Temporary Stored Procedure
--We can create temporary procedures in the same way as we can create temporary tables.
-- The tempdb database is used to create these procedures. 
--We can divide the temporary procedures into two types:

--Local Temporary Stored Procedures
--Global Temporary Procedures.

ALTER PROCEDURE #Temp  
AS  
BEGIN  
PRINT 'Local temp procedure'  
END  

exec #Temp 
ALTER PROCEDURE ##TEMP  
AS  
BEGIN  
PRINT 'Global temp procedure'  
END  

exec ##Temp 

CREATE TABLE ##GlobalTemp
(
 UserID int,
 Name varchar(50), 
 Address varchar(150)
)

CREATE TABLE #LocalTemp
(
 UserID int,
 Name varchar(50), 
 Address varchar(150)
)

/*Disadvantages of Stored Procedures
The following are the limitations of stored procedures in SQL Server:

Debugging: Since debugging stored procedures is never simple, it is not advised to write and execute complex business logic using them. As a result, if we will not handle it properly, it can result in a failure.

Dependency: As we know, professional DBAs and database developers handle vast data sets in large organizations. And the application developers must depend on them because any minor changes must be referred to a DBA, who can fix bugs in existing procedures or build new ones.

Expensive: Stored procedures are costly to manage in terms of DBAs because organizations would have to pay extra costs for specialist DBAs. A DBA is much more qualified to handle complex database procedures.

Specific to a Vendor: Stored procedures written in one platform cannot run on another. Since procedures written in Oracle are more complicated, we will need to rewrite the entire procedure for SQL Server.
*/

-----------------------------------------------
--STORED PROCEDURE EXAMPLES

-- Create a Procedure with table variables
CREATE PROCEDURE sp_AddTwoNumbers(@no1 INT, @no2 INT)
AS
BEGIN
  --SET NOCOUNT ON; 
  DECLARE @Result INT
  SET @Result = @no1 + @no2
  PRINT 'RESULT IS: '+ CAST(@Result AS VARCHAR)
END
GO
-- Calling the procedure:
EXECUTE sp_AddTwoNumbers 10, 20
-- OR 
EXECUTE sp_AddTwoNumbers @no1=10, @no2=20
--OR
EXEC sp_AddTwoNumbers @no1=10, @no2=20
--OR
sp_AddTwoNumbers @no1=10, @no2=20
-- OR calling the procedure by declaring two variables as shown below

DECLARE @num1 INT, @num2 INt
SET @num1 = 10
SET @num2 = 20
EXECUTE sp_AddTwoNumbers @num1, @num2

-- Create a Procedure for Update
select * from batch35;

ALTER PROCEDURE sp_UpdateBatch35byID
(
  @Name VARCHAR(50), 
  @Salary INT,
  @Dept VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Batch35 SET 
      Empname = @Name, 
      Designation = @Dept
  WHERE salary=@salary;
END

-- Executing the Procedure
-- If you are not specifying the Parameter Names then the order is important
EXECUTE sp_UpdateBatch35byID 'john',60000, 'HR'

select * from Batch35;

--Procedure with input and output parameters
CREATE PROCEDURE sp_GetResult
  @No1 INT,
  @No2 INT,
  @Result INT OUTPUT
AS
BEGIN
  SET @Result = @No1 + @No2
END

-- To Execute Procedure
DECLARE @Result INT
EXECUTE sp_GetResult 10, 20, @Result OUT
PRINT @Result

select * from trainees35;
create table T_HR
(
id int,
empid int,
empname varchar(25),
depid int,
designation varchar(25)
)
drop table T_HR;
--CREATE PROCEDURE FOR INSERT
ALTER PROCEDURE sp_InsertStoredProcedure
	@des VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO T_HR(id,empid,empname,depid,designation)
	                   SELECT id,empid,empname,depid,designation
			   FROM Trainees35
			   WHERE designation=@des;
			   --select * from T_HR;
			   --ALTER PROCEDURE AND TRY WITH DELETE
END
select * from T_HR
exec sp_InsertStoredProcedure 'HR'

--PROCEDURE WITH IF THEN
ALTER PROCEDURE sp_conditional
AS
BEGIN
    DECLARE @x INT = 10, @y INT = 20;

    IF (@x > 0)
    BEGIN
        IF (@x > @y)
            PRINT 'IF PART';
        ELSE
            PRINT 'ELSE PART';
    END			
END

exec sp_conditional


select * from trainees35;
ALTER PROCEDURE sp_trainees35_cond
@empid INT
AS
BEGIN
    IF (@empid  > 0)
    BEGIN
        IF (@empid  > 110)
            select * from trainees35 where empid=@empid;
        ELSE
            PRINT 'Record no found';
    END			
END

EXEC sp_trainees35_cond 115

----PROCEDURE WITH IF THEN on table Trainees28
Create PROCEDURE sp_Name_Finder
( @name varchar(50) )
AS
BEGIN
  IF((SELECT empname FROM Trainees35 
  WHERE empname = 'Tommy') = @name)
    BEGIN
	Print 'The Trainee is: '+@name 
    END
   ELSE
    BEGIN
	Print 'The Trainee '+@name+' is not present'
    END
END

exec sp_Name_Finder 'Tommy';

--Procedure using case statement
select * from trainees35;

CREATE PROCEDURE sp_case
AS
BEGIN
SELECT empid,empname,designation,
CASE depid
  WHEN '100' THEN '.NET Core Upskilling'
  WHEN '103' THEN 'Playwright Training'
  WHEN '101' THEN 'Java Upskilling'
END AS 'Training Schedule'
FROM trainees35;
END;

exec sp_case;





