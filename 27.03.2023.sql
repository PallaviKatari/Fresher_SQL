use trainees;
/*A SUBQUERY is a SQL query within a SQL statement.
 A subquery can be part of a SELECT, INSERT, UPDATE or DELETE statement and is itself always a SELECT query. 
 It is also possible for a subquery to have another subquery within it. 
 A subquery within a subquery is called a NESTED SUBQUERY and the phenomenon is called NESTING. 
 SQL Server supports 32 levels of nesting i.e. 32 subqueries in a statement. 
 A SUBQUERY is also called an INNER QUERY or INNER SELECT and the main SQL statement 
 of which it is a part and which it feeds with data is called the OUTER QUERY or MAIN QUERY.*/

select * from onlinecustomers;
select * from orders1;
select * from sales;
select * from Trainees35;

 --SQL Server SUBQUERY �  WHERE subquery example
 --SELECT select_list FROM table_name WHERE (subquery);

SELECT customerid,orderid, orderdate,ordertotal
FROM orders1
WHERE customerid IN
(SELECT customerid FROM onlinecustomers WHERE customercity in ('New york','chicago'))--(3,7)
ORDER BY ordertotal DESC;

SELECT *   
    FROM sales
    WHERE salestotal IN (SELECT salestotal   
    FROM sales   
    WHERE salestotal>400); 

--SQL Server SUBQUERY �  SELECT subquery example

SELECT Customername,
       ordertotal = (SELECT COUNT(O.orderid)
                       FROM Orders1 O
                      WHERE O.CustomerId = C.CustomerId)
  FROM onlinecustomers C;
select * from onlinecustomers;
select * from orders1;
SELECT Customername,
       ordertotal = (SELECT sum(O.ordertotal)
                       FROM Orders1 O
                      WHERE O.CustomerId = C.CustomerId)
  FROM onlinecustomers C;

select * from onlinecustomers;
select * from orders1;
insert into orders1(customerid,ordertotal,discountrate,orderdate) values(3,200,10.5,'2019-08-10')

--SQL Server SUBQUERY �  FROM subquery example
--Find all customers whose ordertotal is greater than the average ordertotal.

select o.customerid,o.orderid,o.ordertotal from
(select avg(ordertotal) as averageOrdertotal from orders1) as o1, orders1 as o
where o.ordertotal>o1.averageOrdertotal;

select o.customerid,o.orderid,o.ordertotal,CustomerName = (select customername from onlinecustomers oc where oc.customerid=o.customerid) from
(select avg(ordertotal) as averageOrdertotal from orders1) as o1, orders1 as o
where o.ordertotal>o1.averageOrdertotal;

--Subqueries with the INSERT Statement
create table customersordersbackup
(
customerid int,
customername varchar(25),
customercity varchar(25),
customermail varchar(25),
);

INSERT INTO customersordersbackup 
   SELECT customerid,customername,customercity,customermail FROM onlinecustomers   
   WHERE customerid IN (SELECT customerid
   FROM orders1 where ordertotal >600); --(3,5)

select * from customersordersbackup;
truncate table customersordersbackup;

select * from orders1;

--Subqueries with the UPDATE Statement

   UPDATE orders1  
   SET discountrate = discountrate+(discountrate * 0.25)   
   WHERE customerid IN (SELECT customerid FROM onlinecustomers  
      WHERE customercity IN('Chicago','New York'));  

	select * from onlinecustomers;
	select * from orders1;

--Subqueries with the DELETE Statement

	DELETE FROM orders1   
	WHERE customerid IN (SELECT customerid FROM onlinecustomers  
      WHERE customercity IN('Chicago','New York'));  

INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (7,912.55,13.74,CAST('15-Sep-2019' AS DATETIME))
INSERT INTO [dbo].[orders1]([customerid],[ordertotal],[discountrate],[orderdate]) VALUES (3,418.24,14.53,CAST('28-May-2019' AS DATETIME))

--Subquery
--When a query is included inside another query, the Outer query is known as Main Query, and Inner query is known as Subquery.
--Nested Query �
--In Nested Query,  Inner query runs first, and only once. 
--Outer query is executed with result from Inner query.
--Hence, Inner query is used in execution of Outer query.

--There are mainly two types of nested queries:

/*Independent Nested Queries: In independent nested queries, query execution starts from innermost query to outermost queries. 
The execution of inner query is independent of outer query, but the result of inner query is used in execution of outer query.
Various operators like IN, NOT IN, ANY, ALL etc are used in writing independent nested queries.*/ --(3,7)

--Find details of customers who have ordered.(simple subquery)
SELECT * FROM onlineCustomers WHERE 
CustomerID IN (SELECT CustomerID FROM Orders1);

--If we want to find out customers who did not order,it can be done as:(subquery using NOT IN)

Select * from onlinecustomers where customerid NOT IN
(SELECT customerid from orders1);

--Nested query

--If we want to find out the sales details of customers who are either from �Chicago� or �New York�, it can be done as:
select * from onlinecustomers;
select * from orders1;
select * from sales;

Select salesid,orderid,salestotal,CustomerID = (select customerid from orders1 o where o.orderid=s.orderid) from sales s where orderid IN
(Select orderid from orders1 where customerid IN --(1,4)
(SELECT customerid from onlinecustomers where CustomerCity='Chicago'  or CustomerCity='New York'));--(3,7)

--ANY ALL OPERATORS
--ANY means that the condition will be true if the operation is true for any of the values in the range.
--ALL means that the condition will be true only if the operation is true for all values in the range. 
select * from onlinecustomers;
select * from orders1;
select * from sales;

SELECT customerid,customername,customercity,customermail FROM onlinecustomers 
WHERE customerid = All (SELECT customerid FROM orders1);

SELECT * , OrderID = (select orderid from orders1 o where o.customerid=oc.customerid)
FROM onlinecustomers oc
WHERE customerid > Any (SELECT customerid
                       FROM orders1
                       WHERE orderid<5);
					   
SELECT * , OrderID = (select orderid from orders1 o where o.customerid=oc.customerid)
FROM onlinecustomers oc
WHERE customerid > All (SELECT customerid
                       FROM orders1
                       WHERE orderid<5);
					 
/*Correlated Query �
In Correlated Query,  Outer query executes first and for every Outer query row Inner query is executed. 
Hence, Inner query uses values from Outer query.*/

--Find details of customers who have ordered.(correlated subquery)
SELECT * FROM onlineCustomers where 
EXISTS (SELECT CustomerID FROM Orders1 
WHERE Orders1.CustomerID=onlineCustomers.CustomerID);

SELECT * FROM onlineCustomers where 
NOT EXISTS (SELECT CustomerID FROM Orders1 
WHERE Orders1.CustomerID=onlineCustomers.CustomerID);

