use dml
--Identity -auto-increment
--Syntax: IDENTITY [(seed,increment)]
/*Seed: Starting value of a column. The default value is 1.
Increment: It specifies the incremental value that is added to the identity column 
value of the previous row. 
The default value is 1.*/

Create Table Person
(
     PersonId int identity(1, 1),
     Name nvarchar(20)
);

Create Table Person1
(
     PersonId int identity(1, 1),
     Name nvarchar(20)
);

Insert into Person values ('Nevetha');
Insert into Person values ('James');
select * from Person;

Insert into Person1 values ('Nevetha');
Insert into Person1 values ('James');
select * from Person1;
select * from Person;

alter TRIGGER InsertTriger
ON [Person]
after INSERT AS
   BEGIN
   INSERT into [Person1] VALUES ('Lyon')
   END
GO
INSERT INTO [dbo].[Person]VALUES('Ashley')
SELECT SCOPE_IDENTITY() AS SCOPEIDENTITYOUTPUT
SELECT @@IDENTITY AS IDENTITYOUTPUT
GO

Select IDENT_CURRENT('Person1')

/*
SCOPE_IDENTITY(): The SCOPE_IDENTITY() built-in function returns the last identity column value that is created within the same session and the same scope.
@@IDENTITY: The @@IDENTITY() built-in function returns the last identity column value that is created in the same session but with any scope.
IDENT_CURRENT(�TableName�): The IDENT_CURRENT() built-in function returns the last identity column value that is created for a specific table across any session and any scope.
*/
--In detail in triggers


--@@ROWCOUNT  
UPDATE Person 
SET Name = 'John' 
WHERE PersonId=4 
IF @@ROWCOUNT = 0  
PRINT 'Warning: No rows were updated';  
GO  

UPDATE Person  
SET Name = 'John' 
WHERE PersonId=6 
IF @@ROWCOUNT = 0  
PRINT 'Warning: No rows were updated';  
GO  

select * from Person


