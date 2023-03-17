--SYNONYMS - ALIAS FOR THE TABLE

create schema freshertrainees

create table freshertrainees.employees
(
EID int Primary Key,
EName varchar(25) NOT NULL UNIQUE,
EAge int check(EAge>19),
EDesignation varchar(25) default 'Trainee'
)

insert into freshertrainees.employees values(100,'John',20,'Developer')
insert into freshertrainees.employees values(101,'Jamie',20,'Developer')
insert into freshertrainees.employees(EID,EName,EAge) values(102,'James',20)

select * from freshertrainees.employees

create synonym f_emp FOR freshertrainees.employees

select * from f_emp

--Primary Key and Foreign Key

--Department Table 
create table Department
(
DID int Primary Key,
DName varchar(25) NOT NULL UNIQUE
)

insert into Department values (100,'Development'),(101,'UI/UX'),(102,'Testing')

select * from Department

--Employee Table
create table Employee
(
EID int Primary Key,
EName varchar(25) NOT NULL UNIQUE,
EAge int check(EAge>19),
EDesignation varchar(25) default 'Trainee',
EDID int references Department(DID)
)

insert into Employee values(102,'Jancy',20,'Designer',101)

select * from Employee

--delete Primary key from Department

delete from Department where DID=100

update Department set DID=200 where DID=100

--Referential Integrity
--on delete no action/on update no action (DEFAULT SETTING)
--on delete cascade/on update cascade
--on delete set null/on update set null
--on delete set default/on update set default

--alter foreign key in Employee

--on delete/update cascade
alter table Employee drop constraint FK__Employee__EDID__6B24EA82

alter table Employee add constraint FK_Employee_EDID foreign key(EDID) references Department(DID) on delete cascade on update cascade

select * from Department
select * from Employee

delete from Department where DID=100

update Department set DID=200 where DID=102

insert into Employee values(101,'John',20,'Designer',101)
insert into Employee values(103,'Jamie',20,'Testing',200)

update Department set DID=100 where DID=200

--on delete set null/on update set null

alter table Employee drop constraint FK_Employee_EDID

alter table Employee add constraint FK_Employee_EDID foreign key(EDID) references Department(DID) on delete set null on update set null

select * from Department
select * from Employee

delete from Department where DID=100

update Department set DID=100 where DID=101

--on set set default/on update set default

alter table Employee drop constraint FK_Employee_EDID

alter table Employee drop column EDID

alter table Employee add EDID int default 100 constraint FK_Employee_EDID foreign key(EDID) references Department(DID) on delete set default on update set default

select * from Department
select * from Employee

delete from Department where DID=101

update Department set DID=103 where DID=102

insert into Department values(101,'Development'),(102,'Testing')

truncate table Employee

insert into Employee values(101,'John',20,'Designer',101)
insert into Employee values(103,'Jamie',20,'Testing',102)