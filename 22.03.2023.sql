use trainees;

/*SQL indexes
An index is a schema object. 
It is used by the server to speed up the retrieval of rows by using a pointer. 
It can reduce disk I/O(input/output) by using a rapid path access method to locate data quickly. 
An index helps to speed up select queries and where clauses, but it slows down data input, 
with the update and the insert statements. 
Indexes can be created or dropped with no effect on the data. 

For example, if you want to reference all pages in a book that discusses a certain topic, 
you first refer to the index, which lists all the topics alphabetically and 
is then referred to one or more specific page numbers. */

--CREATE INDEX index ON TABLE column;

-- CREATE INDEX index ON TABLE (column1, column2,.....); --For multiple columns

--CREATE UNIQUE INDEX index ON TABLE column;
--Unique indexes are used for the maintenance of the integrity of the data present 
--in the table as well as for the fast performance, 
--it does not allow multiple values to enter into the table. 

/*When should indexes be created ? 
 
A column contains a wide range of values
A column does not contain a large number of null values
One or more columns are frequently used together in a where clause or a join condition

When should indexes be avoided ? 
 
The table is small
The columns are not often used as a condition in the query
The column is updated frequently*/

--DROP INDEX index; --drop/delete index

--ALTER INDEX IndexName ON TableName REBUILD; --modify

--select * from USER_INDEXES;  --confirming the index

--EXEC sp_rename  index_name, new_index_name,  N'INDEX'; 

/*Types of indexes in SQL Server
SQL Server Indexes are divided into two types. They are as follows:

Clustered index
Non- clustered index*/

/*The Clustered Index in SQL Server defines the order in which the data is physically stored in a table. 
In the case of a clustered index,  the leaf node store the actual data. 
As the leaf nodes store the actual data a table can have only one clustered index. 
The Clustered Index by default was created when we created the primary key constraint for that table. 
That means the primary key column creates a clustered index by default.
When a table has a clustered index then that table is called a clustered table.
If a table has no clustered index its data rows are stored in an unordered structure.*/

 /*In SQL Server Non-Clustered Index, the arrangement of data in the index table 
 will be different from the arrangement of data in the actual table. 
 The data is stored in one place and the index is stored in another place. 
 Moreover, the index will have pointers to the storage location of the actual data.*/
 
 use trainees;
 select * from trainees35 where empid=115 ; --display execution or ctrl+L
 --You will not find any performance issues currently as the number of records is less. 
 --But if your table contains a huge amount of data let say 1000000 records, then it will definitely take much more time to get the data.

 --CREATE CLUSTERED INDEX index_name ON table_name(column_name ASC);

 --Creating a non-clustered index is basically the same as creating clustered index,
 --but instead of specifying the CLUSTERED clause we specify NONCLUSTERED.
 --We can also omit this clause altogether as a non-clustered is the default when creating an index. 

 --CREATE INDEX index_name ON table_name(column_name ASC);

 --DROP INDEX table_name.index_name;

select * from batch35;
create clustered index ind_empname on batch35(empname)
create index ind_des on batch35(designation)
drop index batch35.ind_des;

EXEC sp_helpindex 'batch35'
EXEC sp_helpindex 'trainees35'

SELECT
 name AS Index_Name,
 type_desc  As Index_Type,
 is_unique,
 OBJECT_NAME(object_id) As Table_Name
FROM
 sys.indexes
WHERE
 object_id = OBJECT_ID('Trainees35');

--INNER JOIN 3 TABLES (ctrl+L) Excecution plan
SELECT OC.CUSTOMERID,customerName, customercity, customermail, salestotal,o.orderid
FROM onlinecustomers AS oc
   INNER JOIN
   orders1 AS o
   ON oc.customerid = o.customerid
   INNER JOIN
   sales AS s
   ON o.orderId = s.orderId;

--The Index scan retrieves all rows from the specified table. 
--Therefore, it might be suitable for small tables, but retrieving 
--all rows from that table is not optimal for SQL Server if it has a massive number of records. 
--The Index Seek refers only to the qualified rows and pages, i.e., it is selective in nature. 
--Therefore, the Index seek is faster compared to Index scans. 

--Index Seek example
select * from trainees35 WHERE id=3; -- specific record

--A filtered index is created simply by adding a WHERE clause to any non-clustered index creation statement.

--CREATE NONCLUSTERED INDEX index_name ON table_name (column_name) WHERE condition

create index ind_hr on batch35(designation) where designation='HR'

select designation from batch35 where designation='HR'

----------------------------------------------------------------------------------
select * from batch35;
/*RANK Function in SQL Server
The RANK Function in SQL Server is a kind of Ranking Function. 
This function will assign the number to each row within the partition of an output. 
It assigns the rank to each row as one plus the previous row rank.
When the RANK function finds two values that are identical within the same partition, 
it assigns them with the same rank number. 
In addition, the next number in the ranking will be the previous rank plus duplicate numbers. 
Therefore, this function does not always assign the ranking of rows in consecutive order.

The RANK function is also a sub-part of window functions. 
The following points should be remembered while using this function:

It always works with the OVER() clause.
It assigns a rank to each row based on the ORDER BY clause.
It assigns a rank to each row in consecutive order.
It always assigns a rank to rows, starting with one for each new partition.*/

--RANK() Function
--This function is used to determine the rank for each row in the result set.
--skips the rank - likerank system in schools

select * from batch35;

SELECT empname,designation,salary,
RANK () OVER (ORDER BY salary desc) AS Rank_No   
FROM batch35; 

--PARTITION BY CLAUSE
SELECT empname,designation,salary,
RANK () OVER (partition by designation ORDER BY salary desc) AS Rank_No   
FROM batch35; 

/*In the above example
The OVER clause sets the partitioning and ordering of a result before the associated window function is applied.
The PARTITION BY clause divides the output produces by the FROM clause into the partition. 
Then the function is applied to each partition and re-initialized when the division border crosses partitions. 
If we have not defined this clause, the function will treat all rows as a single partition.
The ORDER BY is a required clause that determines the order of the rows in a descending or ascending manner
based on one or more column names before the function is applied.*/

 /*ROW_NUMBER() Function
This function is used to return the unique sequential number for each row within its partition. 
The row numbering begins at one and increases by one until the partition's total number of rows is reached.
It will return the different ranks for the row having similar values that make it different from the RANK() function.*/

SELECT empname,designation,salary,
ROW_NUMBER() OVER (ORDER BY salary desc) AS Rank_No   
FROM batch35; 

SELECT empname,designation,salary,
ROW_NUMBER() OVER (partition by designation  ORDER BY salary desc) AS Rank_No   
FROM batch35; 

/*DENSE_RANK() Function
This function assigns a unique rank for each row within a partition as per the specified column value without any gaps. 
It always specifies ranking in consecutive order. 
If we get a duplicate value, this function will assign it with the same rank, and the next rank being the next sequential number.
This characteristic differs DENSE_RANK() function from the RANK() function. */

SELECT empname,designation,salary,
DENSE_RANK() OVER (ORDER BY salary desc) AS Rank_No   
FROM batch35; 

SELECT empname,designation,salary,
DENSE_RANK() OVER (partition by designation ORDER BY salary desc) AS Rank_No   
FROM batch35; 

/*NTILE(N) Function
This function is used to distribute rows of an ordered partition into a pre-defined number (N) of approximately equal groups. 
Each row group gets its rank based on the defined condition and starts numbering from one group. 
It assigns a bucket number for every row in a group representing the group to which it belongs.*/

SELECT empname,designation,salary,
NTILE(3) OVER (ORDER BY salary desc) AS Rank_No   
FROM batch35;

SELECT empname,designation,salary,
NTILE(2) OVER (ORDER BY salary desc) AS Rank_No   
FROM batch35;

SELECT empname,designation,salary,
NTILE(2) OVER (partition by designation ORDER BY salary desc) AS Rank_No   
FROM batch35;

-------------------------------------------------------------------
--The FIRST_VALUE() function is a window function that returns the first value in an ordered partition of a result set.
select * from batch35
SELECT 
    empname,designation,salary,
    FIRST_VALUE(designation) OVER(ORDER BY salary) firstvalue
FROM 
    batch35;

SELECT 
	empname,designation,salary,
    FIRST_VALUE(salary) OVER(
        ORDER BY salary
    ) lowest_salary
FROM 
	batch35;

SELECT 
	empname,designation,salary,
    FIRST_VALUE(salary) OVER(
        partition by designation ORDER BY salary
    ) lowest_salary
FROM 
	batch35;

--The LAST_VALUE() function is a window function that returns the last value in an ordered partition of a result set.

SELECT empname, 
designation, salary, LAST_VALUE(salary) 
OVER 
(ORDER BY designation ASC ) AS Last_salary
FROM batch35;

--SQL Server LEAD() is a window function that provides access to a row at a specified physical offset which follows the current row.
SELECT 
    empname,designation,salary,
    FIRST_VALUE(salary) OVER(ORDER BY salary) firstvalue
FROM 
    batch35;

SELECT 
    empname,designation,salary,
	LEAD(salary,1) OVER(ORDER BY salary) Lead
FROM 
    batch35;


--SQL Server LAG() is a window function that provides access to a row at a specified physical offset which comes before the current row.

SELECT 
    empname,designation,salary,
	LAG(salary,1) OVER(ORDER BY salary) Lag
FROM 
    batch35;

--The CUME_DIST() function calculates the cumulative distribution of a value within a group of values. 
--Simply put, it calculates the relative position of a value in a group of values.

SELECT 
    empname,designation,salary,
    CUME_DIST() OVER(ORDER BY salary) cumulative
FROM 
    batch35;--The result of CUME_DIST() is greater than 0 and less than or equal to 1.

select * from trainees35;
	
SELECT 
    empname,designation,
    CUME_DIST() OVER(ORDER BY empname) cumulative
FROM 
    trainees35;

--The PERCENT_RANK() function is similar to the CUME_DIST() function. 
--The PERCENT_RANK() function evaluates the relative standing of a value within a partition of a result set.

SELECT 
    empname,designation,salary,
    PERCENT_RANK() OVER(ORDER BY salary) percent_rank
FROM 
    batch35;--The result of PERCENT_RANK() is greater than 0 and less than or equal to 1.

SELECT 
    empname,designation,salary,
    format(PERCENT_RANK() OVER(ORDER BY salary),'c','fr-FR') percentage
FROM 
    batch35;
------------------------------------------------------------------------------
--Create Customers table
CREATE TABLE Customers1
(
CustID INT PRIMARY KEY IDENTITY(50,5),
FirstName VARCHAR(20),
LastName VARCHAR(20)
)

--Populate Customers it with data
INSERT INTO Customers1(FirstName, LastName)
VALUES
('Joshua','Porter'),
('Andrew','Bluefield'),
('Jack','Donovan'),
('Cindy','Thatcher'),
('Gordon','Acres'),
('Gretchen','Hamilton')
--Create Products table
CREATE TABLE Products1
(
ProductID INT PRIMARY KEY IDENTITY(20,2),
ProductName VARCHAR(20),
Price DECIMAL(5,2)
)

--Populate Products table with data
INSERT INTO Products1 (ProductName, Price)
VALUES
('Large Bench',198.00),
('Small Bench',169.40),
('Coffee Table',220.00),
('Side Tables',265.20),
('Coat Rack',45.00)

--Create Orders table
CREATE TABLE Orders2
(
OrderID INT PRIMARY KEY IDENTITY(100,10),
CustID INT,
ProdID INT,
Qty TINYINT,
Orderdate DATETIME
)

--Populate Orders table with data
INSERT INTO Orders2(CustID, ProdID, Qty, Orderdate)
VALUES
(55, 22, 1, '6/1/2021'),
(60, 28, 2, '6/6/2021'),
(75, 26, 1, '6/13/2021'),
(50, 20, 1, '7/1/2021'),
(55, 28, 1, '7/6/2021'),
(65, 24, 1, '7/14/2021'),
(55, 26, 1, '7/18/2021'),
(50, 26, 1, '7/24/2021'),
(70, 24, 1, '8/6/2021'),
(70, 26, 1, '8/6/2021'),
(70, 22, 3, '9/1/2021')

SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
O.Qty, O.OrderDate
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

--FIRST_VALUE
SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
FIRST_VALUE(P.Price)
OVER(PARTITION BY O.CustID ORDER BY O.OrderDate) AS 'First value each customer id'
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

--LAG
SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
LAG(P.Price)
OVER(PARTITION BY O.CustID ORDER BY O.OrderDate) AS 'Cost of previous product'
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

--LEAD
SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
LEAD(P.Price)
OVER(PARTITION BY O.CustID ORDER BY O.OrderDate) AS 'Cost of next product'
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

--CUME_DIST()
SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
CUME_DIST()
OVER(PARTITION BY O.CustID ORDER BY O.OrderDate) AS 'Cost of previous product'
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
format(PERCENT_RANK() OVER(PARTITION BY O.CustID ORDER BY O.OrderDate),'c', 'fr-FR') percentage -- C->currency,P-%
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
format(PERCENT_RANK() OVER(PARTITION BY O.CustID ORDER BY O.OrderDate),'c') percentage -- C->currency,P-%
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID

SELECT C.CustID, C.FirstName, C.LastName, P.ProductName, P.Price as 'Product Price', 
format(PERCENT_RANK() OVER(PARTITION BY O.CustID ORDER BY O.OrderDate),'c','ja-JP') percentage -- C->currency,P-%
FROM Orders2 as O
INNER JOIN Customers1 AS C
ON O.CustID = C.CustID
INNER JOIN Products1 as P
ON O.ProdID = P.ProductID


exec ##Temp 
use dml;

SELECT trainees.dbo.FN_CalculateAge ('01/07/2018')AS AGE