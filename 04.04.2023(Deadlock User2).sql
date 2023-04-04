create database deadlock
use deadlock

DBCC USEROPTIONS; -- Check Isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select * from TableA;
select * from TableB;
-- Transaction 2
BEGIN TRANSACTION
UPDATE TableB SET Name = 'Priyanka From Transaction2' WHERE Id = 1001
WAITFOR DELAY '00:00:15'
UPDATE TableA SET Name = 'Anurag From Transaction2' WHERE Id = 101
Commit Transaction

-- Transaction 2
SET DEADLOCK_PRIORITY HIGH
GO
BEGIN TRANSACTION
UPDATE TableB SET Name = 'Priyanka From Transaction2' WHERE Id = 1001
WAITFOR DELAY '00:00:15'
UPDATE TableA SET Name = 'Anurag From Transaction2' WHERE Id = 101
Commit Transaction

----------------------------------------------------------------------------
SELECT * FROM Productslock

--1) Dirty Read Concurrency Problem Example in SQL Server: 
--The default Transaction Isolation level in SQL Server is Read committed
--READ UNCOMMITTED - Can read the data before completion of transaction 1
--Transaction 2 in another sql user instance
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED --READ COMMITTED TO AVOID DIRTY READ OR SELECT * FROM Productslock (NOLOCK) WHERE Id=1001
SELECT * FROM Productslock WHERE Id=1001

--First, run transaction 1 and then immediately run the Transaction2 and you will see that the Transaction returns the Quantity as 5. 
--Then Transaction 1 is rollback and it will update the quantity to its previous state i.e. 10. 
--But Transaction 2 working with the value 5 which does not exist in the database anymore and this is nothing but dirty data.

 --2) Lost Update Concurrency Problem in SQL Server 
 -- Transaction 2 another user instance
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION 
  DECLARE @QuantityAvailable int
  SELECT @QuantityAvailable = Quantity FROM Productslock WHERE Id=1001
  SET @QuantityAvailable = @QuantityAvailable - 2
  UPDATE Productslock SET Quantity = @QuantityAvailable WHERE Id=1001
  Print @QuantityAvailable
COMMIT TRANSACTION

--How to Overcome the Lost Update Concurrency Problem?
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ in both the transactions

--Now run Transaction1 first and then run the second transaction and you will see that Transaction 2 was completed successfully while Transaction 1 competed with the error.
-- The transaction was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction. 

--Once you rerun Transaction 1, the Quantity will be updated correctly as expected in the database table. 

--3) Non-Repeatable Read Concurrency Problem

-- Transaction 2 in another user instance
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
UPDATE Productslock SET Quantity = 10 WHERE Id = 1001

--Notice that when Transaction 1 is completed, it gets a different value for reading 1 and reading 2, resulting in a non-repeatable read concurrency problem. 
--In order to solve the Non-Repeatable Read Problem in SQL Server, we need to use either Repeatable Read Transaction Isolation Level or any other higher isolation level such as Snapshot or Serializable. 

 --4) Phantom Read Concurrency Problem in SQL Server:
 
SELECT * FROM Employeeslock;

-- Transaction 2 in another user instance
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
INSERT into Employeeslock VALUES(1006, 'Sambit', 'Male')
COMMIT TRANSACTION

/* From the first instance execute the Transaction 1 code and from the second instance execute the Transaction 2 code. 
Notice that when Transaction 1 is completed, it gets a different number of rows for reading 1 and reading 2, resulting in a phantom read problem. 
The Read Committed, Read Uncommitted, and Repeatable Read Transaction Isolation Level causes Phantom Read Concurrency Problem in SQL Server. 
In the above Transactions, we used REPEATABLE READ Transaction Isolation Level, even you can also use Read Committed and Read Uncommitted Transaction Isolation Levels.*/

/*to fix the Phantom Read Concurrency Problem let set the transaction isolation level of Transaction 1 to serializable.
 The Serializable Transaction Isolation Level places a range lock on the rows returns by the transaction based on the condition.
 In our example, it will place a lock where Gender is Male, which prevents any other transaction from inserting new rows within that Gender. 
 This solves the phantom read problem in SQL Server. */

 --5) Snapshot Isolation Level in SQL Server:
 --Types of Snapshot Isolation Level in SQL Server:

 --5.1)ALLOW_SNAPSHOT_ISOLATION:

 --EXAMPLE 1
 -- Session 2
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
SELECT * FROM Productslock WHERE Id = 1001 

--EXAMPLE 2

--session 2
	--insert into Productslock values( 3,'Desktop',110)
	insert into Productslock values( 4,'Mouse',10)
     UPDATE Productslock SET Quantity = 50 WHERE Id = 1001
    select * from Productslock

	--Session 2 queries will be executed in parallel as transaction in session 1 won't lock the table Productslock.



