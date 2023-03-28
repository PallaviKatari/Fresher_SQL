use trainees;
/*Pivot and Unpivot in SQL
In SQL, Pivot and Unpivot are relational operators that are used 
to transform one table into another in order to achieve more simpler view of table. 
Conventionally we can say that Pivot operator converts the rows
data of the table into the column data. 
The Unpivot operator does the opposite that is it transform the column based data into rows.*/

--EXAMPLE 1

Create Table course 
( 
CourseName nvarchar(50) primary key, 
CourseCategory nvarchar(50),
Price int  
) 

Insert into course  values('C', 'PROGRAMMING', 5000) 
Insert into course  values('JAVA', 'PROGRAMMING', 6000) 
Insert into course  values('PYTHON', 'PROGRAMMING', 8000) 
Insert into course  values('C#', 'PROGRAMMING', 8000) 
Insert into course  values('SQL', 'RDBMS', 8000) 
Insert into course  values('ORACLE', 'RDBMS', 8000) 
Insert into course  values('MySQL', 'RDBMS', 8000) 
Insert into course  values('Angular', 'Frontend', 10000) 
Insert into course  values('Angular', 'Frontend', 10000) 

SELECT * FROM course 

--SYNTAX
/*SELECT (ColumnNames) 
FROM (TableName) 
PIVOT/UNPIVOT
 ( 
   AggregateFunction(ColumnToBeAggregated)
   FOR PivotColumn IN (PivotColumnValues)
 ) AS (Alias) //Alias is a temporary name for a table*/


--Now, applying PIVOT operator to this data:

SELECT CourseName,coalesce(PROGRAMMING,0) as Programming,coalesce(RDBMS,0) as DB,coalesce(Frontend,0) as Frontend
FROM course 
PIVOT 
( 
SUM(Price) FOR CourseCategory IN (PROGRAMMING, RDBMS,Frontend ) 
) AS PivotTable 

--Applying UNPIVOT operator:

SELECT CourseName,CourseCategory, Price
FROM 
(
SELECT CourseName, coalesce(PROGRAMMING,0) as Programming,coalesce(RDBMS,0) as DB,coalesce(Frontend,0) as Frontend FROM course 
PIVOT 
( 
SUM(Price) FOR CourseCategory IN (PROGRAMMING, RDBMS,Frontend ) 
) AS PivotTable
) P 
UNPIVOT 
( 
Price FOR CourseCategory IN (PROGRAMMING, DB,Frontend)
) 
AS UnpivotTable

--EXAMPLE 2
CREATE TABLE pivot_demo    
(    
   Region varchar(45),    
   Year int,    
   Sales int    
)  

INSERT INTO pivot_demo  
VALUES ('North', 2010, 72500),  
('South', 2010, 60500),  
('South', 2010, 52000),  
('North', 2011, 45000),  
('South', 2011, 82500),    
('North', 2011, 35600),  
('South', 2012, 32500),   
('North', 2010, 20500);   

--PIVOT Operator
SELECT * FROM pivot_demo;

--SELECT Year, North, South FROM     
--(SELECT Region, Year, Sales FROM pivot_demo ) AS Tab1    
--PIVOT    
--(SUM(Sales) FOR Region IN (North, South)) AS Tab2    
--ORDER BY tab2.Year;  

SELECT Year, North, South FROM     
(SELECT Region, Year, Sales FROM pivot_demo ) AS Tab1    
PIVOT    
(SUM(Sales) FOR Region IN (North, South)) AS Tab2    
ORDER BY Year;  

SELECT Region, [2010], [2011], [2012] FROM     
(SELECT Region, [Year], Sales FROM pivot_demo ) AS Tab1    
PIVOT    
(SUM(Sales) FOR [Year] IN ([2010], [2011], [2012])) AS Tab2  
ORDER BY Tab2.Region;

--UNPIVOT Operator

SELECT Region, Year, Sales FROM (  
SELECT Year, North, South FROM     
(SELECT Region, Year, Sales FROM pivot_demo ) AS Tab1    
PIVOT    
(SUM(Sales) FOR Region IN (North, South)) AS PivotTable    
) P  
--Perform UNPIVOT Operation  
UNPIVOT    
(    
Sales FOR Region IN (North, South)    
) AS UnpivotTable  

SELECT * FROM pivot_demo;

--EXAMPLE 3
create table Project
(
empid int Primary key,
projectname varchar(25),
developername varchar(25),
department varchar(25)
)

select * from project;

select projectname, Designer,Developer,Tester from
(Select department,empid,projectname from Project) as t1
PIVOT
(count(empid) for department in (Designer,Developer,Tester)) as t2;

----------------------------------------------------------------
/*The Common Table Expressions (CTE) were introduced into standard SQL in order to simplify various classes of SQL Queries for which a derived table was just unsuitable. 
CTE was introduced in SQL Server 2005, the common table expression (CTE) is a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. 
You can also use a CTE in a CREATE a view, as part of the view�s SELECT query. In addition, as of SQL Server 2008, you can add a CTE to the new MERGE statement.

Using the CTE �
We can define CTEs by adding a WITH clause directly before SELECT, INSERT, UPDATE, DELETE, or MERGE statement. 
The WITH clause can include one or more CTEs seperated by commas. */

/*SYNTAX
[WITH  [, ...]]  
 
::=
cte_name [(column_name [, ...])]
AS (cte_query) 

SYNTAX

WITH cte_name (column_names)   
AS (query)     
SELECT * FROM cte_name;   
*/

use trainees;

--EXAMPLE 1
create table Sales1
(
Product varchar(2),
Year int,
Quarter varchar(2),
Sales int
);

insert into Sales1(Product, Year, Quarter, Sales) values
('A','2020','Q1',100), ('A','2020','Q2',200),
('A','2020','Q3',150), ('A','2020','Q4',300),
('B','2020','Q1',50), ('B','2020','Q2',100),
('B','2020','Q3',75), ('B','2020','Q4',150),
('C','2020','Q1',150), ('C','2020','Q2',200),
('C','2020','Q3',175), ('C','2020','Q4',150);

SELECT * FROM Sales1;

WITH CTE_Sales AS (
SELECT Product, Year, Quarter, Sales
FROM Sales1
)
SELECT Product,
SUM(CASE WHEN Year = 2020 AND Quarter = 'Q1' THEN Sales ELSE 0 END) AS Q1_2020,
SUM(CASE WHEN Year = 2020 AND Quarter = 'Q2' THEN Sales ELSE 0 END) AS Q2_2020,
SUM(CASE WHEN Year = 2020 AND Quarter = 'Q3' THEN Sales ELSE 0 END) AS Q3_2020,
SUM(CASE WHEN Year = 2020 AND Quarter = 'Q4' THEN Sales ELSE 0 END) AS Q4_2020
FROM CTE_Sales
GROUP BY Product

--EXAMPLE 2
WITH customers_in_NewYork --cte result set  
AS (SELECT * FROM onlinecustomers WHERE customercity = 'New York')  
SELECT customerid,customername,customercity FROM customers_in_NewYork;  

--EXAMPLE 3
--Multiple CTE
WITH customers_in_NewYork  --first cte
AS (SELECT * FROM onlinecustomers WHERE customercity = 'New York') , 

customers_in_Chicago --second
AS (SELECT * FROM onlinecustomers WHERE customercity = 'Chicago')  

SELECT * FROM customers_in_NewYork
UNION ALL  
SELECT * FROM customers_in_Chicago; 

--EXAMPLE 3
CREATE TABLE CTEtable
(
  EmployeeID int NOT NULL PRIMARY KEY,
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NOT NULL,
  ManagerID int NULL
)

INSERT INTO CTEtable VALUES (1, 'Ken', 'Thompson', NULL)
INSERT INTO CTEtable VALUES (2, 'Terri', 'Ryan', 1)
INSERT INTO CTEtable VALUES (3, 'Robert', 'Durello', 1)
INSERT INTO CTEtable VALUES (4, 'Rob', 'Bailey', 2)
INSERT INTO CTEtable VALUES (5, 'Kent', 'Erickson', 2)
INSERT INTO CTEtable VALUES (6, 'Bill', 'Goldberg', 3)
INSERT INTO CTEtable VALUES (7, 'Ryan', 'Miller', 3)
INSERT INTO CTEtable VALUES (8, 'Dane', 'Mark', 5)
INSERT INTO CTEtable VALUES (9, 'Charles', 'Matthew', 6)
INSERT INTO CTEtable VALUES (10, 'Michael', 'Jhonson', 6) 

select * from CTEtable;

WITH
  cteReports (EmpID, FirstName, LastName, MgrID, EmpLevel)
  AS
  (
    SELECT EmployeeID, FirstName, LastName, ManagerID, 1
    FROM CTEtable
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.ManagerID, 
      r.EmpLevel + 1
    FROM CTEtable e
      INNER JOIN cteReports r
        ON e.ManagerID = r.EmpID
  )
SELECT
  FirstName + ' ' + LastName AS FullName, 
  EmpLevel,
  (SELECT FirstName + ' ' + LastName FROM CTEtable 
    WHERE EmployeeID = cteReports.MgrID) AS Manager
FROM cteReports 
ORDER BY EmpLevel, MgrID 

/*Why do we need CTE?
Like database views and derived tables, CTEs can make it easier to write and manage complex queries by making them more readable and simple. 
We can accomplish this characteristic by breaking down the complex queries into simple blocks that can reuse in rewriting the query.

Some of its use cases are given below:

It is useful when we need to define a derived table multiple times within a single query.
It is useful when we need to create an alternative to a view in the database.
It is useful when we need to perform the same calculation multiple times on multiple query components simultaneously.
It is useful when we need to use ranking functions like ROW_NUMBER(), RANK(), and NTILE().
Some of its advantages are given below:

CTE facilitates code maintenance easier.
CTE increases the readability of the code.
It increases the performance of the query.
CTE makes it possible to implement recursive queries easily.

Types of CTE in SQL Server
SQL Server divides the CTE (Common Table Expressions) into two broad categories:

Recursive CTE- query that calls itself
Non-Recursive CTE-doesn't reference itself*/

/*The following are the limitations of using CTE in SQL Server:

CTE members are unable to use the keyword clauses like Distinct, Group By, Having, Top, Joins, etc.
The CTE can only be referenced once by the Recursive member.
We cannot use the table variables and CTEs as parameters in stored procedures.
We already know that the CTE could be used in place of a view, but a CTE cannot be nested, while Views can.
Since it's just a shortcut for a query or subquery, it can't be reused in another query.
The number of columns in the CTE arguments and the number of columns in the query must be the same.*/

CREATE TABLE orders3 
 ( order_id  int      identity(1,1) primary key
 , amount    numeric(10,2)
 , order_dt  datetime
) ;


INSERT orders3 
( amount, order_dt ) VALUES
 ( 10.01, '4-01-2019' )
,(  9.99, '3-16-2019' )
,(  7.01, '1-15-2019' )
,( 23.46, '4-15-2019' )
,(  3.16, '2-14-2019' )
,(  4.13, '2-11-2019' )
,( 12.14, '7-04-2019' )
,( 13.16, '5-20-2019' )
,(  6.10, '8-23-2019' )
,(  1.53, '1-01-2020' )
,( 40.66, '1-18-2020' )
;

with cte_amt as
( select [amount], year(order_dt) as [yr], yr_amount, month(order_dt) as [mo]
  from [orders3] o
  JOIN ( select year([order_dt]) as [yr], sum([amount]) as [yr_amount] from [orders3] group by year([order_dt]) ) as y 
    ON year([order_dt]) = y.[yr]
)
select yr as [Year], [yr_amount] as [Annual Total]
  , coalesce([1] ,0) as  [Jan], coalesce([2] ,0) as  [Feb], coalesce([3] ,0) as  [Mar]
  , coalesce([4] ,0) as  [Apr], coalesce([5] ,0) as  [May], coalesce([6] ,0) as  [Jun]
  , coalesce([7] ,0) as  [Jul], coalesce([8] ,0) as  [Aug], coalesce([9] ,0) as  [Sep]
  , coalesce([10],0) as  [Oct], coalesce([11] ,0) as [Nov], coalesce([12],0) as  [Dec]
from cte_amt
pivot(sum(amount) for mo in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]) ) as pvt
;
