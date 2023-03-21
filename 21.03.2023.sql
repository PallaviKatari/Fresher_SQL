--JOINS
--A JOIN clause is used to combine rows from two or more tables, 
--based on a related column between them.

/*(INNER) JOIN: Returns records that have matching values in both tables
LEFT (OUTER) JOIN: Returns all records from the left table, and the matched records from the right table
RIGHT (OUTER) JOIN: Returns all records from the right table, and the matched records from the left table
FULL (OUTER) JOIN: Returns all records when there is a match in either left or right table*/
USE TRAINEES;

CREATE TABLE onlinecustomers (customerid INT PRIMARY KEY IDENTITY(1,1) ,CustomerName VARCHAR(100) 
,CustomerCity VARCHAR(100) ,Customermail VARCHAR(100))

CREATE TABLE orders1 (orderId INT PRIMARY KEY IDENTITY(1,1) , customerid INT  ,
ordertotal float ,discountrate float ,orderdate DATETIME)

CREATE TABLE sales (salesId INT PRIMARY KEY IDENTITY(1,1) , 
orderId INT  ,
salestotal FLOAT)

--INSERT COMMAND
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Salvador',N'Philadelphia',N'tyiptqo.wethls@chttw.org')
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Gilbert',N'San Diego',N'rrvyy.wdumos@lklkj.org')
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Ernest',N'New York',N'ymuea.pnxkukf@dwv.org')
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Stella',N'Phoenix',N'xvsfzp.rjhtni@rdn.com')
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Jorge',N'Los Angeles',N'oykbo.vlxopp@nmwhv.org')
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Jerome',N'San Antonio',N'wkabc.ofmhetq@gtmh.co')
INSERT INTO [dbo].[onlinecustomers]([CustomerName],[CustomerCity],[Customermail]) VALUES (N'Edward',N'Chicago',N'wguexiymy.nnbdgpc@juc.co')
-----
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (3,1910.64,5.49,CAST('03-Dec-2019' AS DATETIME))
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (4,150.89,15.33,CAST('11-Jun-2019' AS DATETIME))
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (5,912.55,13.74,CAST('15-Sep-2019' AS DATETIME))
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (7,418.24,14.53,CAST('28-May-2019' AS DATETIME))
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (55,512.55,13.74,CAST('15-Jun-2019' AS DATETIME))
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (57,118.24,14.53,CAST('28-Dec-2019' AS DATETIME))
-----
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (3,370.95)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (4,882.13)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (28,370.95)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (13,882.13)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (55,170.95)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (57,382.13)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (25,190.95)
INSERT INTO [dbo].[sales]([orderId],[salestotal]) VALUES (27,382.13)

--SELECT
select * from onlinecustomers;

select * from orders1;

select * from sales;

--INNER JOIN 2 TABLES
SELECT oc.customerid,customerName, customercity, customermail,o.orderdate
FROM onlinecustomers AS oc
   INNER JOIN
   orders1 AS o
   ON oc.customerid = o.customerid

SELECT onlinecustomers.customerid,customerName, customercity, customermail,orderid
FROM onlinecustomers
   INNER JOIN
   orders1
   ON onlinecustomers.customerid = orders1.customerid

--INNER JOIN 3 TABLES
SELECT oc.customerid,customerName, customercity, customermail, salestotal,o.orderid
FROM onlinecustomers AS oc
   INNER JOIN
   orders1 AS o
   ON oc.customerid = o.customerid
   INNER JOIN
   sales AS s
   ON o.orderId = s.orderId;

   
select * from sales;

--LEFT JOIN 2 TABLES
SELECT oc.customerid,customerName, customercity, customermail,orderid,orderdate
FROM onlinecustomers AS oc
   LEFT JOIN
   orders1 AS o
   ON oc.customerid = o.customerid

--RIGHT JOIN 2 TABLES
SELECT oc.customerid,customerName, customercity, customermail,orderid
FROM onlinecustomers AS oc
   RIGHT JOIN
   orders1 AS o
   ON oc.customerid = o.customerid

--FULL JOIN 2 TABLES
SELECT oc.customerid,customerName, customercity, customermail,orderid
FROM onlinecustomers AS oc
   FULL JOIN
   orders1 AS o
   ON oc.customerid = o.customerid

--FULL JOIN 3 TABLES
SELECT customerName, customercity, customermail, ordertotal,salestotal
FROM onlinecustomers AS c
   FULL JOIN
   orders1 AS o
   ON c.customerid = o.customerid
   FULL JOIN
   sales AS s
   ON o.orderId = s.orderId

--CROSS JOIN
   SELECT customerName, customercity, customermail, ordertotal,salestotal
   FROM onlinecustomers
   CROSS JOIN
   orders1
   CROSS JOIN
   sales
   WHERE onlinecustomers.customerid = orders1.customerid AND orders1.orderId=sales.orderId;

select * from onlinecustomers;
select * from orders1;
select * from sales;

--UPDATE JOIN
UPDATE orders1  
SET discountrate = discountrate + 2   
FROM orders1 o  
INNER JOIN sales s     
ON o.orderId = s.orderId;  

--SELF JOIN
create table Employees_Manager (
    EmployeeID int primary key,
    Name varchar(100),
    ManagerID int null
    CONSTRAINT FK_ManagerID FOREIGN KEY (ManagerID)
         REFERENCES Employees_Manager (EmployeeID)
);
 
insert into Employees_Manager Values(1,'John',null)
insert into Employees_Manager Values(2,'Peter',1)
insert into Employees_Manager Values(3,'Sam',2)
insert into Employees_Manager Values(4,'Shaun',2)
insert into Employees_Manager Values(5,'Paul',1)

select * from Employees_Manager
 
Select employee.EmployeeID,employee.Name, manager.EmployeeID as ManagerID, manager.Name As Manager
from Employees_Manager employee
left join Employees_Manager manager
on (employee.ManagerID=manager.EmployeeID)

--VIEW - Virtual table
--Types of Views
--In SQL Server we have two types of views.

--1)System Defined Views
/*System-defined Views are predefined Views that already exist in the Master database of SQL Server. 
These are also used as template Views for all newly created databases. 
These system Views will be automatically attached to any user-defined database.*/

--Information Schema View
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Trainees35';

--Catalog View
select * from sys.tables ;

--Dynamic Management View
/*These Views give the administrator information of the database about the current state of the SQL Server machine. 
These values help the administrator to analyze problems and tune the server for optimal performance. 
These are of two types:*/

/*Server-scoped Dynamic Management View
These are stored only in the Master database.

Database-scoped Dynamic Management View
These are stored in each database.*/

 --To see all SQL Server connections
SELECT connection_id,session_id,client_net_address,auth_scheme
FROM sys.dm_exec_connections ;

--2)User Defined Views
--These types of view are defined by users. We have two types of user-defined views.

--Simple View
--When we create a view on a single table, it is called a simple view.

select * from trainees35

-- Create view on single table Trainees35
create VIEW Trainees35_React
AS
Select *
From Trainees35 where designation='React Development';

select * from Trainees35_React;

--In the simple view we can insert, update, delete data. 
--We can only insert data in a simple view if we have a primary key and all not null fields in the view.

insert into Trainees35_React(empid,empname,depid,designation) values(119,'Jessy',101,'React Development');
select * from Trainees35_React; -- VIEW
select * from Trainees35; --TABLE

update Trainees35_React set empname='Jessie' where empid=119;

delete from Trainees35_React where empid=119;

--Complex View
--When we create a view on more than one table, it is called a complex view.

create view onlineshoppingview
as
SELECT customerName, customercity, customermail, ordertotal,salestotal
FROM onlinecustomers AS c
   FULL JOIN
   orders1 AS o
   ON c.customerid = o.customerid
   FULL JOIN
   sales AS s
   ON o.orderId = s.orderId

select * from onlineshoppingview;

--We can only update data in a complex view. We can't insert data in a complex view.

update onlineshoppingview set salestotal=salestotal-50;
 