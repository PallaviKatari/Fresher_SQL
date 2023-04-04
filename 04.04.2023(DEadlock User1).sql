create database deadlock
use deadlock

DBCC USEROPTIONS;  -- Check Isolation level / Query->Query Options -> Advanced
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--Deadlock Example
-- Create table TableA
CREATE TABLE TableA
(
    ID INT,
    Name NVARCHAR(50)
)
Go
-- Insert some test data
INSERT INTO TableA values (101, 'Anurag')
INSERT INTO TableA values (102, 'Mohanty')
INSERT INTO TableA values (103, 'Pranaya')
INSERT INTO TableA values (104, 'Rout')
INSERT INTO TableA values (105, 'Sambit')
Go
-- Create table TableB
CREATE TABLE TableB
(
    ID INT,
    Name NVARCHAR(50)
)
Go
-- Insert some test data
INSERT INTO TableB values (1001, 'Priyanka')
INSERT INTO TableB values (1002, 'Dewagan')
INSERT INTO TableB values (1003, 'Preety')

select * from TableA;
select * from TableB;

Truncate table TableB
Truncate table TableA
--Example 1
-- Transaction 1
BEGIN TRANSACTION
UPDATE TableA SET Name = 'Anurag From Transaction1' WHERE Id = 101
WAITFOR DELAY '00:00:15'
UPDATE TableB SET Name = 'Priyanka From Transaction1' WHERE Id = 1001
COMMIT TRANSACTION

--Example 2 with Priority level
-- Transaction 1
BEGIN TRANSACTION
UPDATE TableA SET Name = 'Anurag From Transaction1' WHERE Id = 101
WAITFOR DELAY '00:00:15'
UPDATE TableB SET Name = 'Priyanka From Transaction1' WHERE Id = 1001
COMMIT TRANSACTION

--------------------------------------------------------------------------------

--The default Transaction Isolation level in SQL Server is Read committed

-- Create Products table
CREATE TABLE Productslock
(
    Id INT PRIMARY KEY,
    Name VARCHAR(100),
    Quantity INT
)
Go
-- Insert test data into Products table
INSERT INTO Productslock values (1001, 'Mobile', 10)
INSERT INTO Productslock values (1002, 'Tablet', 20)
INSERT INTO Productslock values (1003, 'Laptop', 30)

SELECT * FROM Productslock

--1) Dirty Read Concurrency Problem Example in SQL Server: 
--Transaction 1
BEGIN TRANSACTION
  UPDATE Productslock SET Quantity = 10 WHERE Id=1001
  -- Billing the customer
  Waitfor Delay '00:00:25'
  -- Insufficient Funds. Rollback transaction
Rollback TRANSACTION
  
SELECT * FROM Productslock WHERE Id=1001

 --2) Lost Update Concurrency Problem in SQL Server 

-- Transaction 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION
  DECLARE @QuantityAvailable int
  SELECT @QuantityAvailable = Quantity FROM Productslock WHERE Id=1001
  -- Transaction takes 5 seconds
  WAITFOR DELAY '00:00:5'
  SET @QuantityAvailable = @QuantityAvailable + 1
  UPDATE Productslock SET Quantity = @QuantityAvailable  WHERE Id=1001
  Print @QuantityAvailable
COMMIT TRANSACTION

--3) Non-Repeatable Read Concurrency Problem

-- Transaction 1
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ -- USE REPEATABLE READ TO AVOID 2 SET OF VALUES
BEGIN TRANSACTION
SELECT Quantity FROM Productslock WHERE Id = 1001
-- Do Some work
WAITFOR DELAY '00:00:15'
SELECT Quantity FROM Productslock WHERE Id = 1001
COMMIT TRANSACTION

--4) Phantom Read Concurrency Problem in SQL Server: 

-- Create Employee table
CREATE TABLE Employeeslock
(
    Id INT PRIMARY KEY,
    Name VARCHAR(100),
    Gender VARCHAR(10)
)
Go
-- Insert some dummy data
INSERT INTO  Employeeslock VALUES(1001,'Anurag', 'Male')
INSERT INTO  Employeeslock VALUES(1002,'Priyanka', 'Female')
INSERT INTO  Employeeslock VALUES(1003,'Pranaya', 'Male')
INSERT INTO  Employeeslock VALUES(1004,'Hina', 'Female')

SELECT * FROM Employeeslock

-- Transaction 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION
SELECT * FROM Employeeslock where Gender = 'Male'
-- Do Some work
WAITFOR DELAY '00:00:5'
SELECT * FROM Employeeslock where Gender = 'Male'
-- Do Some work
WAITFOR DELAY '00:00:5'
SELECT * FROM Employeeslock where Gender = 'Male'
COMMIT TRANSACTION

--5) Snapshot Isolation Level in SQL Server:
 --Types of Snapshot Isolation Level in SQL Server:

 --5.1)ALLOW_SNAPSHOT_ISOLATION:
ALTER DATABASE trainees
SET ALLOW_SNAPSHOT_ISOLATION ON
-- Set the transaction isolation level to snapshot
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SELECT * FROM Productslock WHERE Id = 1001

--EXAMPLE 1
-- Session 1
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
 UPDATE Productslock SET Quantity = 15 WHERE Id = 1001

 --EXAMPLE 2
/*
Snapshot isolation is similar to Serializable isolation. 
The difference is Snapshot does not hold lock on table during the 
transaction so table can be modified in other sessions. 
Snapshot isolation maintains versioning in Tempdb for old data in 
case of any data modification occurs in other sessions then existing 
transaction displays the old data from Tempdb.*/

--session 1
  set transaction isolation level snapshot
    begin tran
    select * from Productslock
    waitfor delay '00:00:5'
    select * from Productslock
    COMMIT

