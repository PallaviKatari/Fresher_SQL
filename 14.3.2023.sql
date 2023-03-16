--Create database - Collection of Tables
create database Trainees
use Trainees

--Create Table - Collection of rows & columns
create table Batch35
(
TID int,
TName varchar(25),
TDesignation varchar(25)
)

-- STATEMENTS - DDL,DML,DQL,DCL,TCL
--DDL- DATA DEFINITION LANGUAGE - CREATE,ALTER,DROP,TRUNCATE
--DML- DATA MANIPULATION LANGUAGE - INSERT, UPDATE, DELETE
--DQL- DATA QUERY LANGUAGE - SELECT
--DCL- DATA CONTROL LANGUAGE - GRANT,REVOKE
--TCL- TRANSACTION CONTROL LANGUAGE - COMMIT,ROLLBACK,SAVE

--Select-DQL
select * from Batch35
insert into Batch35 values(1,'John',3500)

--insert - DML
insert into Batch35 values(1,'John','HR')
insert into Batch35 values(2,'Peter','Tester')
insert into Batch35 values(3,'Sam','Developer')
insert into Batch35 values(4,'Dean','Designer')
insert into Batch35 values(5,'Paul','HR')
insert into Batch35(TID,TName) values(6,'Dwayne')

--update - DML
update Batch35 set TDesignation='Developer' where TID=5

--delete - DML
delete from Batch35 where TID=6

--alter - DDL
alter table Batch35 add TSalary int

--update - DML
update Batch35 set TSalary=2500 where TDesignation='Tester'
update Batch35 set TSalary=2500 where TDesignation='Developer'
update Batch35 set TSalary=3500 where TDesignation='Designer'
update Batch35 set TSalary=3000 where TDesignation='HR'

--drop - DDL
alter table Batch35 drop column TDesignation

--truncate - DDL
truncate table Batch35

--drop - DDL
drop table Batch35

create table batch35(
 empid int,
 empname varchar(20)
)
 select * from batch35

 alter table batch35 add salary int
  alter table batch35 drop column empid

 -- insert

 insert into batch35 values('John',55000),('Tom',100000),('Peter',200000),('Sam',300000)
 insert into batch35 values('Jancy',55000),('Rita',100000),('Paula',200000),('Shaun',300000)

 update batch35 set salary=20000 where empname='Paula'

 delete from batch35 where empname='Paula'

 --DISTINCT 
 select salary from batch35
 select DISTINCT salary from batch35

 --Rename columns
 select empname,salary from batch35
 select empname Ename,salary ESal from batch35
 select empname as Ename,salary as ESal from batch35
 select empname as 'Employee name',salary as 'Employee Sal' from batch35

CREATE TABLE SaveFiles
(
    FileID INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    Files VARBINARY(MAX) NOT NULL
)

INSERT INTO [dbo].[SaveFiles] (Name, Files)
SELECT 'Image Demo', 
	BulkColumn FROM OPENROWSET(BULK N'C:\Users\cgvak-lt156\Desktop\sql.jfif', SINGLE_BLOB) image;

select * from SaveFiles

use Trainees

SELECT NEWID() FROM GUID

DECLARE 
    @id UNIQUEIDENTIFIER;
SET @id = NEWID();
SELECT 
    @id AS GUID;
