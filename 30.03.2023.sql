/*A transaction in SQL Server is a sequential group of statements or queries to perform single or multiple tasks in a database. 
Each transaction may have single read, write, update, or delete operations or a combination of all these operations. 
Each transaction must happen two things in SQL Server:
Either all modification is successful when the transaction is committed.
Or, all modifications are undone when the transaction is rollback.
A transaction cannot be successful until all of the operations in the set are completed. It means that if any argument fails, the transaction operation will fail.
Each transaction begins with the first executable SQL statement and ends when it finds a commit or rollback, either explicitly or implicitly. 
It uses the COMMIT or ROLLBACK statements explicitly, as well as implicitly when a DDL statement is used.*/

--Transaction Properties-ACID Properties
-------------------------------------------
/*Atomicity: This property ensures that all statements or operations included in the transaction must be performed successfully. 
Otherwise, the whole transaction will be aborted, and all operations are rolled back into their previous state when any operation is failed.
Consistency: This property ensures that the database changes state only when a transaction will be committed successfully. 
It is also responsible for protecting data from crashes.
Isolation: This property guarantees that all transactions are isolated from other transactions, meaning each operation in the transaction is operated independently. 
It also ensures that statements are transparent to each other.
Durability: This property guarantees that the result of committed transactions persists in the database permanently even if the system crashes or failed.*/

/*Transaction Modes in SQL Server
----------------------------------
There are three different transaction modes that SQL Server can use:
Auto-commit Transaction Mode: It is the SQL Server's default transaction mode. 
It will evaluate each SQL statement as a transaction, and the results are committed or rolled back accordingly. 
Thus the successful statements are immediately committed, while the failed statements are immediately rolled back.

Implicit Transaction Mode. This mode allows SQL Server to begin the implicit transaction for each DML statement, 
but it explicitly requires the use of commit or rollback commands at the end of the statements.

Explicit Transaction Mode: This mode is defined by the user that allows us to identify a transaction's beginning and ending points exactly. 
It will automatically abort in case of a fatal error.

Transaction Control
----------------------
The following are the commands used to control transactions:
BEGIN TRANSACTION: It is a command that indicates the beginning of each transaction.
COMMIT: It is a command used to save the changes permanently in the database.
ROLLBACK: It is a command used to cancel all modifications and goes into their previous state.
SAVEPOINT: This command creates points within groups of transactions that allow us to roll back only a portion of a transaction rather than the entire transaction.
RELEASE SAVEPOINT: It is used to remove an already existing SAVEPOINT.
SET TRANSACTION: This command gives a transaction a name, which can be used to make it read-only or read/write or assign it to a specific rollback segment.*/

use trainees

select * from Person

CREATE TABLE Person (
    PersonID int PRIMARY KEY IDENTITY(1,1),
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255),
	Age INT
)

INSERT INTO Person VALUES('Hayes', 'Corey','123  Wern Ddu Lane','LUSTLEIGH',23)
INSERT INTO Person VALUES('Macdonald','Charlie','23  Peachfield Road','CEFN EINION',45)
INSERT INTO Person VALUES('Frost','Emma','85  Kingsway North','HOLTON',26)
INSERT INTO Person VALUES('Thomas', 'Tom','59  Dover Road', 'WESTER GRUINARDS',51)
INSERT INTO Person VALUES('Baxter','Cameron','106  Newmarket Road','HAWTHORPE',46)
INSERT INTO Person VALUES('Townsend','Imogen ','100  Shannon Way','CHIPPENHAM',20)
INSERT INTO Person VALUES('Preston','Taylor','14  Pendwyallt Road','BURTON',19)
INSERT INTO Person VALUES('Townsend','Imogen ','100  Shannon Way','CHIPPENHAM',18)
INSERT INTO Person VALUES('Khan','Jacob','72  Ballifeary Road','BANCFFOSFELEN',11)

--IMPLICIT TRANSACTIONS

SET IMPLICIT_TRANSACTIONS ON 
UPDATE 
    Person 
SET 
    Lastname = 'S', 
    Firstname = 'Sam' 
WHERE 
    PersonID = 2 

SELECT 
    IIF(@@OPTIONS & 2 = 2, 
    'Implicit Transaction Mode ON', 
    'Implicit Transaction Mode OFF'
    ) AS 'Transaction Mode' 
SELECT 
    @@TRANCOUNT AS OpenTransactions 
COMMIT TRAN 
SELECT 
    @@TRANCOUNT AS OpenTransactions

SET IMPLICIT_TRANSACTIONS OFF

--EXPLICIT TRANSACTIONS
select * from Person
--WITHOUT COMMIT
BEGIN TRAN
 
UPDATE Person 
SET    Lastname = 'L', 
        Firstname = 'Lucky' 
WHERE  PersonID = 1
 
SELECT @@TRANCOUNT AS OpenTransactions


--WITH COMMIT
BEGIN TRAN
UPDATE Person 
SET    Lastname = 'L', 
        Firstname = 'Lucky' 
WHERE  PersonID = 1
SELECT @@TRANCOUNT AS OpenTransactions 
COMMIT TRAN 
SELECT @@TRANCOUNT AS OpenTransactions

--ROLLBACK TRANSACTION
BEGIN TRAN
UPDATE Person 
SET    Lastname = 'Donald', 
        Firstname = 'Duck'  WHERE PersonID=2
 
 
SELECT * FROM Person WHERE PersonID=2
 
ROLLBACK TRAN 
 
SELECT * FROM Person WHERE PersonID=2

--SAVEPOINT
BEGIN TRANSACTION 
INSERT INTO Person 
VALUES('Mouse', 'Mini','500 South Buena Vista Street, Burbank','California',43)
SAVE TRANSACTION InsertStatement
DELETE Person WHERE PersonID=9
SELECT * FROM Person 
ROLLBACK TRANSACTION InsertStatement
COMMIT

SELECT * FROM Person

--AUTO ROLLBACK
BEGIN TRAN
INSERT INTO Person 
VALUES('Bunny', 'Bugs','742 Evergreen Terrace','Springfield',54)
    
UPDATE Person SET Age='MiddleAge' WHERE PersonID=7
SELECT * FROM Person
 
COMMIT TRAN

--MARKED TRANSACTIONS
BEGIN TRAN DeletePerson WITH MARK 'MarkedTransactionDescription' 
    DELETE Person WHERE PersonID BETWEEN 3 AND 4
    
    COMMIT TRAN DeletePerson

select * from batch35

BEGIN TRAN Deletebatch35 WITH MARK 'MarkedTransactionDescription' 
    DELETE from batch35 WHERE empname='peter'
    
    COMMIT TRAN Deletebatch35

--The logmarkhistory table stores details about each marked transactions that have been committed and it is placed in the msdb database.

SELECT * FROM msdb.dbo.logmarkhistory -- Options till version 2014 - To restore deleted files quickly based on the time logged in the logmarkhistory table

---------------------------------------------------------------------------------
create database sqltriggers1

use sqltriggers1
/*There are two types of triggers. They are as follows:

Instead of Triggers: The Instead Of triggers are going to be executed instead of the corresponding DML operations. 
That means instead of the DML operations such as Insert, Update, and Delete, the Instead Of triggers are going to be executed.

After Triggers: The After Triggers fires in SQL Server execute after the triggering action. 
That means once the DML statement (such as Insert, Update, and Delete) completes its execution, this trigger is going to be fired.

Types of Triggers in SQL Server:
There are four types of triggers available in SQL Server. They are as follows:

DML Triggers � Data Manipulation Language Triggers.
DDL Triggers � Data Definition Language Triggers
CLR triggers � Common Language Runtime Triggers (USING FRONT END PROGRAMMING LANGUAGE LIKE C#)
Logon triggers

What are DML Triggers in SQL Server?

As we know DML Stands for Data Manipulation Language and it provides Insert, Update and Delete statements to 
perform the respective operation on the database tables or view which will modify the data. 
The triggers which are executed automatically in response to DML events 
(such as Insert, Update, and Delete statements) are called DML Triggers.*/

-- Create Employee table
CREATE TABLE Employee
(
  Id int Primary Key,
  Name nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)
GO
-- Insert data into Employee table
INSERT INTO Employee VALUES (1,'John', 5000, 'Male', 3)
INSERT INTO Employee VALUES (2,'Jancy', 5400, 'Female', 2)
INSERT INTO Employee VALUES (3,'Andrew', 6500, 'Male', 1)
INSERT INTO Employee VALUES (4,'Sandra', 4700, 'Female', 2)
INSERT INTO Employee VALUES (5,'Jenny', 6600, 'Female', 3)

select * from Employee
truncate table Employee
--1)For/After Insert DML Trigger in SQL Server

CREATE TRIGGER trInsertEmployee 
ON Employee
FOR INSERT
AS
BEGIN
  PRINT 'YOU CANNOT PERFORM INSERT OPERATION'
  ROLLBACK TRANSACTION
END

--Let�s try to insert the following record into the employee table.
INSERT INTO Employee VALUES (6, 'Sam', 7600, 'Male', 1)

--When you try to execute the above Insert statement it gives you the below error. First, the INSERT statement is executed, 
--and then immediately this trigger fired and roll back the INSERT operation as well as print the message.

--2)For/After Update DML Trigger in SQL Server
update Employee set Name='John J' where id=1

CREATE TRIGGER trUpdateEmployee 
ON Employee
FOR UPDATE
AS
BEGIn
  PRINT 'YOU CANNOT PERFORM UPDATE OPERATION'
  ROLLBACK TRANSACTION
END

--Let�s try to update one record in the Employee table
update Employee set Name='John' where id=1
select * from Employee
--When you try to execute the above Update statement it will give you the following error. First, the UPDATE statement is executed, 
--and then immediately this trigger fired and roll back the UPDATE operation as well as print the message.

--3)For/After Delete DML Triggers in SQL Server

CREATE TRIGGER trDeleteEmployee 
ON Employee
FOR DELETE
AS
BEGIN
  PRINT 'YOU CANNOT PERFORM DELETE OPERATION'
  ROLLBACK TRANSACTION
END

--Let�s try to delete one record from the Employee table
DELETE FROM Employee WHERE Id = 1
--When we try to execute the above Delete statement, it gives us the below error. First, the DELETE statement is executed, 
--and then immediately this trigger fired and roll back the DELETE operation as well as print the message.

--4)For Insert/Update/Delete DML Trigger in SQL Server

DROP TRIGGER trDeleteEmployee
DROP TRIGGER trInsertEmployee
DROP TRIGGER trUpdateEmployee

CREATE TRIGGER trAllDMLOperationsOnEmployee 
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  PRINT 'YOU CANNOT PERFORM DML OPERATION'
  ROLLBACK TRANSACTION
END

--5) Create a Trigger that will restrict all the DML operations on the Employee table on MONDAY only.

ALTER TRIGGER trAllDMLOperationsOnEmployee 
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  IF DATEPART(DW,GETDATE())= 2
  BEGIN
    PRINT 'DML OPERATIONS ARE RESTRICTED ON MONDAY'
    ROLLBACK TRANSACTION
  END
END

--6) Create a Trigger that will restrict all the DML operations on the Employee table before 1 pm.

CREATE TRIGGER trAllDMLOperationsOnEmployee 
ON Employee
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  IF DATEPART(HH,GETDATE()) > 11
  BEGIN
    PRINT 'INVALID TIME'
    ROLLBACK TRANSACTION
  END 
END

DROP TRIGGER trAllDMLOperationsOnEmployee 

DELETE FROM Employee WHERE Id = 1

select * from Employee

/*
Why do we need DML Triggers in SQL Server?
DML Triggers are used to enforce business rules and data integrity. These triggers are very much similar to constraints in the way they enforce integrity. 
So, with the help of DML Triggers, we can enforce data integrity which cannot be done with the help of constraints that is comparing values with values of another table, etc.*/

--7) Understanding the INSERTED Table in SQL Server:

CREATE TRIGGER trInsertEmployee 
ON Employee
FOR INSERT
AS
BEGIN
  SELECT * FROM INSERTED
END

--Let�s Insert one record into the Employee table
select * from Employee;
INSERT INTO Employee VALUES (7, 'Peter', 7700, 'Male', 2);

/*So when we execute the above insert statement, the data is inserted as expected in the Employee table 
along with a copy of the inserted new data also available in the Inserted table. So, we get the following output. 
Please note, the structure of the Inserted table is exactly the same as the structure of the Employee table.*/

/*When we add a new row into the Employee table a copy of the row will also be made into the INSERTED table which only a trigger can access.
 We cannot access this table outside the context of the trigger. */

 --8) Deleted Table in SQL Server

 CREATE TRIGGER trDeleteEmployee 
ON Employee
FOR DELETE
AS
BEGIN
  SELECT * FROM DELETED
END

--Let�s Delete one record from the Employee table

DELETE FROM Employee WHERE Id = 6;
select * from Employee;

--When we execute the above Delete statement, the data gets deleted from the Employee
--table whose Id is 6 along with it also displays the following deleted data as part of the deleted table.

--9) How to view the updating data in a table?

-- Create Update Trigger
CREATE TRIGGER trUpdateEmployee 
ON Employee
FOR UPDATE
AS
BEGIN
  SELECT * FROM DELETED
  SELECT * FROM INSERTED
END

--Let�s Update one record in the Employee table by executing the following update statement.
UPDATE Employee SET Name = 'Rocky', Salary = 9000 WHERE Id = 5

--Updating multiple records
UPDATE Employee SET Salary = 20000 WHERE Gender = 'Female'
-----------------------------------------------------------------
/*What are DDL TRIGGERS in SQL Server?
The DDL triggers in SQL Server are fired in response to a variety of data definition language (DDL) 
events such as Create, Alter, Drop, Grant, Deny, and Revoke (Table, Function, Index, Stored Procedure, etc�).
 That means DDL triggers in SQL Server are working on a database.

DDL triggers are introduced from SQL Server 2005 version which will be used to restrict 
the DDL operations such as CREATE, ALTER and DROP commands.*/

/*Types of DDL triggers in SQL Server?
There are two types of DDLs triggers available in SQL Server. They are as follows:

Database Scoped DDL Trigger
Server Scoped DDL Trigger*/

--1) Database Scoped DDL Triggers in SQL Server

/*Expand the Programmability folder. 
Then Expand the Database Triggers folder for a Database Scoped DDL Triggers*/

--Example 1
CREATE  TRIGGER  trRestrictCreateTable 
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
  PRINT 'YOU CANNOT CREATE A TABLE IN THIS DATABASE'
  ROLLBACK TRANSACTION
END
use sqltriggers1
create table sample2(id int);
select * from sample;
drop table sample

--Example 2
--Create a trigger that will restrict ALTER operations on a specific database table.

CREATE TRIGGER  trRestrictAlterTable  
ON DATABASE
FOR  ALTER_TABLE
AS
BEGIN
  PRINT 'YOU CANNOT ALTER TABLES'
  ROLLBACK TRANSACTION
END

select * from sample
alter table sample add score int
alter table sample drop column age

--Example 3
--Create a trigger that will restrict dropping the tables from a specific database.
CREATE TRIGGER  trRestrictDropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
  PRINT 'YOU CANNOT DROP TABLES'
  ROLLBACK TRANSACTION
END

drop table sample1

--Example 4
--Prevent users from creating, altering, or dropping tables from a specific database using a single trigger.
DROP TRIGGER trRestrictCreateTable ON DATABASE
DROP TRIGGER trRestrictAlterTable ON DATABASE
DROP TRIGGER trRestrictDropTable ON DATABASE

CREATE TRIGGER trRestrictDDLEventsdml
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN 
   PRINT 'You cannot create, alter or drop a table'
   ROLLBACK TRANSACTION
END

--Example 5
--Disable/Enable a Database Scoped DDL trigger in SQL Server

DISABLE TRIGGER trRestrictDDLEventsdml ON DATABASE

ENABLE TRIGGER trRestrictDDLEventsdml ON DATABASE

--Example 6
CREATE TRIGGER trRenameTable
ON DATABASE
FOR RENAME
AS
BEGIN
    PRINT 'You just renamed something'
END

sp_rename 'Emp', 'Employee'

select * from Employee

--2) Server-scoped DDL Triggers in SQL Server

CREATE TRIGGER trServerScopedDDLTrigger
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN 
   PRINT 'You cannot create, alter or drop a table in any database of this server'
   ROLLBACK TRANSACTION
END

/*
Where can I find the Server-scoped DDL triggers?
To find the Server-Scoped DDL Triggers in SQL Server Follow the below steps

In the Object Explorer window, expand the �Server Objects� folder
Then Expand the Triggers folder*/

--Disable/Enable Server-Scoped DDL trigger in SQL Server

 ENABLE TRIGGER trServerScopedDDLTrigger ON ALL SERVER 

 DISABLE TRIGGER trServerScopedDDLTrigger ON ALL SERVER

 DROP TRIGGER trServerScopedDDLTrigger ON ALL SERVER

 ------------------------------------------------
/*
INSTEAD OF Trigger:

INSTEAD OF trigger causes the INSERT, UPDATE, or, DELETE operation to be cancelled.
Due to this the SQL command submitted to SQL Server is discarded by the INSTEAD OF trigger.
In-fact the code within the INSTEAD OF trigger is executed instead of the submitted SQL command.
The INSTEAD OF trigger might be programmed to repeat the requested operation so that it looks like it could do something else altogether.
When INSTEAD OF triggers fire, SQL Server hasn�t yet made any changes and, consequently, hasn�t logged any changes.
INSTEAD OF trigger also don�t report any error warning because it works although the operation doesn�t go through.
This will be more clearer to you, if you this example:*/
CREATE TRIGGER InsteadOfStud
ON Employee
INSTEAD OF INSERT
AS
SELECT * FROM Employee where gender='female'

INSERT INTO Employee VALUES (6, 'Sam', 7600, 'Male', 1)

DROP TRIGGER InsteadOfStud

/*
AFTER Trigger:

AFTER triggers are often used for complex data validation.
These triggers can rollback, or undo, the insert, update, or delete if the code inside the trigger doesn�t like the operation.
The code can also do something else or even fail the transaction.
But if the trigger doesn�t explicitly ROLLBACK the transaction, the data modification operation will go as it was originally intended.
AFTER triggers report an error code if an operation is rolled back.
AFTER trigger takes place after the modification but before the implicit commit, so the transaction is still open when the AFTER trigger is fired, that is what the main advantage of using AFTER trigger.
So if we want to redo all the transactions then we can use the ROLLBACK keyword for all the pending transactions.*/

CREATE TRIGGER AfterStud
ON Employee
AFTER INSERT
AS
PRINT 'After Trigger'
RAISERROR('Error',16,1);
ROLLBACK TRAN;

INSERT INTO Employee VALUES (7, 'Jack', 7600, 'Male', 1)
SELECT count(*) FROM Employee
SELECT GetDate()

select * from Employee

DROP TRIGGER AfterStud

--------------------------------------
--CREATED_DATE AND MODIFIED_DATE USING TRIGGERS

 CREATE TABLE dbo.recipe (
 ID INT IDENTITY(1,1) PRIMARY KEY,
 [name] VARCHAR(50) NOT NULL,
 category VARCHAR(50) NOT NULL,
 steps VARCHAR(500) NOT NULL,
 ing01 VARCHAR(75),
 ing02 VARCHAR(75),
 ing03 VARCHAR(75),
 created_date DATETIME NOT NULL DEFAULT GETDATE(),
 modifed_date DATETIME
 )

insert into dbo.recipe(name,category,steps,ing01,ing02,ing03)values('Noodles','AllTimeFav','3','Water','Vegetables','Noodles')

select * from dbo.recipe

update dbo.recipe set ing02='Vegetables' where id=1

 CREATE TRIGGER dbo.set_modified_date on dbo.recipe FOR UPDATE AS
 BEGIN
     UPDATE dbo.recipe
     SET modifed_Date = GETDATE()
     FROM dbo.recipe INNER JOIN deleted d ON dbo.recipe.id = d.id
 END
 
 ALTER TABLE dbo.recipe ENABLE TRIGGER [set_modified_date]
 
 
-- Soft Delete using Triggers - instead of permanently deleting the records
 ALTER TABLE dbo.recipe
  ADD IsDeleted BIT NOT NULL DEFAULT 0;

CREATE OR ALTER TRIGGER SoftDelete_Recipe ON dbo.recipe
  INSTEAD OF DELETE AS
BEGIN
SET NOCOUNT ON;
UPDATE dbo.recipe
  SET IsDeleted = 1
  WHERE Id IN (SELECT Id FROM deleted);
END

select * from dbo.recipe

insert into dbo.recipe(name,category,steps,ing01,ing02,ing03)values('Coffee','Beverage','3','MIlk','Sugar','Coffee Powder')

delete from dbo.recipe where id=1