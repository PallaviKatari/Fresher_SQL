--SET OPERATORS
--create table Departments
use Trainees
create table Departments
(
id int IDENTITY (1,1),
Dept_id int,
Dept_name varchar(25),
constraint pk_id Primary Key(id),
constraint uk_id_name Unique (Dept_id,Dept_name)
)

insert into Departments(Dept_id,Dept_name) values(100,'Angular Development')
insert into Departments(Dept_id,Dept_name) values(101,'React Development')
insert into Departments(Dept_id,Dept_name) values(102,'PHP Development')
insert into Departments(Dept_id,Dept_name) values(103,'Testing')
insert into Departments(Dept_id,Dept_name) values(104,'HR')

select * from Departments
--create table Trainees35
create table Trainees35
(
id int IDENTITY (1,1),
empid int not null,
empname varchar(50) not null,
depid int,
designation varchar(25),
constraint fk_dept foreign key(depid,designation) references Departments(Dept_id,Dept_name),
constraint pk_eid primary key(id),
constraint uk_empid_empname Unique (empid,empname)
);

--insert command in Trainees28
insert into Trainees35(empid,empname,depid,designation) values(111,'Nick',100,'Angular Development');
insert into Trainees35(empid,empname,depid,designation) values(112,'Tom',100,'Angular Development');
insert into Trainees35(empid,empname,depid,designation) values(113,'John',104,'HR');
insert into Trainees35(empid,empname,depid,designation) values(114,'Rita',103,'Testing');
insert into Trainees35(empid,empname,depid,designation) values(115,'Paul',103,'Testing');
insert into Trainees35(empid,empname,depid,designation) values(116,'Amy',104,'HR');
insert into Trainees35(empid,empname,depid,designation) values(117,'Jancy',101,'React Development');
insert into Trainees35(empid,empname,depid,designation) values(118,'Jack',101,'React Development');

--SELECT Trainees35
select * from Trainees35;

--create table DeptDev
create table DeptDev
(
id int IDENTITY(1,1),
empid int,
empname varchar(50),
depid int,
designation varchar(25),
constraint fk_empdev foreign key(empid,empname) references Trainees35(empid,empname),
constraint fk_deptdev foreign key(depid,designation) references Departments(Dept_id,Dept_name),
constraint pk_devid primary key(id)
);

insert into DeptDev(empid,empname,depid,designation) values(111,'Nick',100,'Angular Development');
insert into DeptDev(empid,empname,depid,designation) values(112,'Tom',100,'Angular Development');
insert into DeptDev(empid,empname,depid,designation) values(117,'Jancy',101,'React Development');
insert into DeptDev(empid,empname,depid,designation) values(118,'Jack',101,'React Development');

select * from DeptDev

--create table Testing
create table Testing
(
id int IDENTITY(1,1),
empid int,
empname varchar(50),
depid int,
designation varchar(25),
constraint fk_emptest foreign key(empid,empname) references Trainees35(empid,empname),
constraint fk_depttest foreign key(depid,designation) references Departments(Dept_id,Dept_name),
constraint pk_testid primary key(id)
);

insert into Testing(empid,empname,depid,designation) values(114,'Rita',103,'Testing');
insert into Testing(empid,empname,depid,designation) values(115,'Paul',103,'Testing');

select empid,empname,depid,designation from Testing

--UNION
select empid,empname,depid,designation from DeptDev
union
select empid,empname,depid,designation from Testing
--ORDER BY empname

--UNION ALL
select empid,empname,depid,designation from DeptDev
union all
select empid,empname,depid,designation from Testing

--INTERSECT
select empid,empname,depid,designation from DeptDev
intersect
select empid,empname,depid,designation from Testing

--EXCEPT
SELECT empid,empname,depid,designation
	FROM Trainees35
EXCEPT
SELECT empid,empname,depid,designation
	FROM deptdev
	WHERE designation='Angular Development';

--GROUP BY
--The GROUP BY statement is often used with aggregate functions
--(COUNT(), MAX(), MIN(), SUM(), AVG()) to group the result-set by one or more columns.
	SELECT * FROM Trainees35;
	SELECT COUNT(empname) as 'No of Employees', designation FROM Trainees35 GROUP BY designation;
	SELECT AVG(empid) AS Average,designation FROM Trainees35 GROUP BY designation;
	SELECT MAX(empid) AS Maximum, designation FROM Trainees35 GROUP BY designation;
	SELECT MIN(empid) AS Minimum, designation FROM Trainees35 GROUP BY designation;
	SELECT SUM(empid) AS Sum, designation FROM Trainees35 GROUP BY designation;

--GROUP BY WITH ORDER BY
	SELECT AVG(empid) AS Average,designation FROM Trainees35 GROUP BY designation order by designation;
	SELECT MAX(empid) AS Maximum, designation FROM Trainees35 GROUP BY designation order by designation;
	SELECT MIN(empid) AS Minimum, designation FROM Trainees35 GROUP BY designation order by designation;
	SELECT SUM(empid) AS Sum, designation FROM Trainees35 GROUP BY designation order by designation;

--HAVING CLAUSE
	SELECT AVG(empid) AS Average,designation FROM Trainees35 GROUP BY designation WHERE AVG(empid)>112 order by designation;--NOT ALLOWED
	SELECT AVG(empid) AS Average,designation FROM Trainees35 GROUP BY designation HAVING AVG(empid)>112 order by designation;

/*GROUPING SET is an extension of the GROUP BY clause. 
The GROUP BY statement is GROUPING SET is an extension of the GROUP BY clause. 
The GROUP BY statement is used to summarize the data in conjunction with aggregate functions such as SUM, AVG, COUNT, etc. 
It groups the result set based on the single or multiple columns. 
The GROUPING SET was first introduced with the SQL Server 2008 version.*/

alter table batch35 add designation varchar(25)
update batch35 set designation='HR' where salary<60000
update batch35 set designation='Tester' where salary>=60000 and salary<=100000
update batch35 set designation='Developer' where salary=200000
update batch35 set designation='Lead Developer' where salary=300000
select * from batch35 where designation='Testing';

update batch35 set salary=60000 where empname='John'
update batch35 set salary=160000 where empname='Rita'
update batch35 set salary=360000 where empname='Sam'
--GROUPING SETS
SELECT COALESCE(DESIGNATION, 'All designations Total') as Designation, SUM(salary) AS TotalSalary  
FROM batch35   
GROUP BY GROUPING SETS  
(  
(designation,salary) ,
(designation) ,
()
)   
ORDER BY designation;  

--ROLLUP
/*The ROLLUP is an extension of the GROUP BY clause. 
The ROLLUP option allows you to include extra rows that represent the subtotals, 
which are commonly referred to as super-aggregate rows, along with the grand total row. 
By using the ROLLUP option, you can use a single query to generate multiple grouping sets.*/

SELECT 
    COALESCE(DESIGNATION, 'All designations Total') as Designation, SUM(salary) AS TotalSalary  
FROM
    BATCH35
GROUP BY DESIGNATION;

SELECT 
     COALESCE(DESIGNATION, 'All designations Total') as Designation, SUM(salary) AS TotalSalary  
FROM
    BATCH35
GROUP BY ROLLUP (DESIGNATION);

--CUBE
--CUBE is an extension of the GROUP BY clause. CUBE allows you to generate subtotals
--the CUBE extension will generate subtotals for all combinations of grouping columns specified in the GROUP BY clause.
  CREATE TABLE employee1
  (
      id INT PRIMARY KEY,
      name VARCHAR(50) NOT NULL,
      gender VARCHAR(50) NOT NULL,
      salary INT NOT NULL,
      department VARCHAR(50) NOT NULL
   )
   INSERT INTO employee1
  VALUES
  (1, 'David', 'Male', 5000, 'Sales'),
  (2, 'Jim', 'Female', 6000, 'HR'),
  (3, 'Kate', 'Female', 7500, 'IT'),
  (4, 'Will', 'Male', 6500, 'Marketing'),
  (5, 'Shane', 'Female', 5500, 'Finance'),
  (6, 'Shed', 'Male', 8000, 'Sales'),
  (7, 'Vik', 'Male', 7200, 'HR'),
  (8, 'Vince', 'Female', 6600, 'IT'),
  (9, 'Jane', 'Female', 5400, 'Marketing'),
  (10, 'Laura', 'Female', 6300, 'Finance'),
  (11, 'Mac', 'Male', 5700, 'Sales'),
  (12, 'Pat', 'Male', 7000, 'HR'),
  (13, 'Julie', 'Female', 7100, 'IT'),
  (14, 'Elice', 'Female', 6800,'Marketing'),
  (15, 'Wayne', 'Male', 5000, 'Finance')

  SELECT department, sum(salary) as Salary_Sum
  FROM employee1
  GROUP BY department

  SELECT coalesce (department, 'All Departments') AS Department,coalesce (gender,'All Genders') AS Gender,
  sum(salary) as Salary_Sum
  FROM employee1
  GROUP BY ROLLUP (department,gender)

  SELECT
  coalesce (department, 'All Departments') AS Department,
  coalesce (gender,'All Genders') AS Gender,
  sum(salary) as Salary_Sum
  FROM employee1
  GROUP BY CUBE (department, gender)

/*The CHOOSE() function returns the item from a list of items at a specified index.

The following shows the syntax of the CHOOSE() function:

CHOOSE ( index, elem_1, elem_2 [, elem_n ] )*/

--example 1
SELECT CHOOSE(2, 'First', 'Second', 'Third') Result;

--example 2
select * from orders;

SELECT orderid,orderdate,
      CHOOSE(MONTH([orderdate]),'January','February','March','April','May','June',
      'July','August','September','October','November','December') AS ordermonth
  FROM orders;

insert into orders values(4,'2023-05-05'),(5,'2023-07-05'),(6,'2023-12-05'),(7,'2023-08-05')
--example 3
SELECT CHOOSE(1, 'Apple', 'Orange', 'Kiwi', 'Cherry') AS Result1;

SELECT CHOOSE(2, 'Apple', 'Orange', 'Kiwi', 'Cherry') AS Result2;

SELECT CHOOSE(3, 'Apple', 'Orange', 'Kiwi', 'Cherry') AS Result3;

SELECT CHOOSE(4, 'Apple', 'Orange', 'Kiwi', 'Cherry') AS Result4;

SELECT CHOOSE(5, 'Apple', 'Orange', 'Kiwi', 'Cherry','Strawberry') AS Result5;

SELECT CHOOSE(6, 'Apple', 'Orange', 'Kiwi', 'Cherry','Strawberry') AS Result5;


/*The SQL CASE Statement
The CASE statement goes through conditions and returns a value when the first condition is met (like an if-then-else statement). 
So, once a condition is true, it will stop reading and return the result. 
If no conditions are true, it returns the value in the ELSE clause.
If there is no ELSE part and no conditions are true, it returns NULL.*/

/*Types of CASE Statement
There are two forms of CASE statement in MS SQL Server:

Simple CASE Statement
Searched CASE Statement*/

--Example
select * from batch35;
--simple
SELECT empname,designation, salary,
CASE designation 
    WHEN 'Developer' THEN 'CGVAK DEVELOPER DEPARTMENT'  
    WHEN 'Tester' THEN 'CGVAK DESIGNER DEPARTMENT'  
    WHEN 'HR' THEN 'CGVAK HR DEPARTMENT'  
    ELSE 'CGVAK LEAD DEPARTMENT'  
END AS Department  
FROM batch35;  

--searched
SELECT empname,designation,salary,
CASE
    WHEN salary >= 200000 THEN 'Senior Employee'
    WHEN salary >= 100000 THEN 'Junior Employee'
    ELSE 'Trainee'
END AS 'Employee Details'
FROM batch35;

--sequence
/*A sequence is an object in SQL Server that is used to generate a number sequence. 
This can be useful when we need to create a unique number to act as a primary key.*/

CREATE SEQUENCE [dbo].[SequenceObject]
AS INT
START WITH 1 
INCREMENT BY 1 

--check created sequence in programmability folder under your database folder

--current sequence
SELECT * FROM sys.sequences WHERE name = 'SequenceObject';
--ALTER SEQUENCE [SequenceObject] RESTART WITH 1

--To ensure the value now going to starts from 1, select the next sequence value as shown below.
SELECT NEXT VALUE FOR [dbo].[SequenceObject];

CREATE TABLE Employees
(
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10)
);
-- Generate and insert Sequence values
INSERT INTO Employees VALUES
(NEXT VALUE for [dbo].[SequenceObject], 'Ben', 'Male');
INSERT INTO Employees VALUES
(NEXT VALUE for [dbo].[SequenceObject], 'Sara', 'Female');
--start from 1
ALTER SEQUENCE [SequenceObject] RESTART WITH 1
select * from employees;
truncate table employees;

/*
CREATE SEQUENCE [dbo].[SequenceObject] 
AS INT
START WITH 100
INCREMENT BY -1
CREATE SEQUENCE [dbo].[SequenceObject]
START WITH 100
INCREMENT BY 10
MINVALUE 100
MAXVALUE 150
If we call the NEXT VALUE FOR, when the value reaches 150 (MAXVALUE), we will get the following error.
ALTER SEQUENCE [dbo].[SequenceObject]
INCREMENT BY 10
MINVALUE 100
MAXVALUE 150
CYCLE
To Improve the Performance of Sequence Object
CREATE SEQUENCE [dbo].[SequenceObject]
START WITH 1
INCREMENT BY 1
CACHE 10
*/

--Drop Sequence object

Drop Sequence SequenceObject;
drop table employees;

/*
Using SQL Server Graphical User Interface (GUI) to create the sequence object: 
Expand the database folder
Expand Programmability folder
Right-click on the Sequences folder
Select New Sequence
*/
