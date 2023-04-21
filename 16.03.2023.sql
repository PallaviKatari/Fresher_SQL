--DATA DEFINITION
USE Trainees

select * from batch35

alter table b35 add salary int

select * from b35

alter table b35 drop column id

--insert into select (b35 must be manually created)
insert into b35(name,salary) 

select * from batch35 where salary <100000

-- select into (t35 will be created automatically)
select * into t35 from b35

select * from t35

--Rename a schema using transfer method
create schema S1

create table S1.T1
(
id int
)

insert into s1.t1 values(1)

create schema S2

alter schema S2 transfer s1.t1

--Concatenate

select * from batch35
select 'My name is ' + empname as Details from batch35
select 'My id is ' + CAST(empid as varchar(20)) as Details from batch35

--Computed column
create table demo
(
fname varchar(25),
lname varchar(25),
designation varchar(25)
)

insert into demo values('John','J','Dev')
insert into demo values('James','J','Des')
insert into demo values('Jamie','J','Tes')
insert into demo values('Jenny','J','HR')

select * from demo

alter table demo add fullname as (fname + ' ' + lname)

select fullname from demo

--IDENTITY COLUMN

select id from s2.t1

alter table s2.t1 add name varchar(25)

truncate table s2.t1

alter table s2.t1 add id int identity(1,1)

insert into s2.t1(name) values ('John')

select * from s2.t1

set identity_insert s2.t1 on

insert into s2.t1(id,name) values (7,'John')

set identity_insert s2.t1 off

insert into s2.t1(name) values ('John')

Select SCOPE_IDENTITY()

DBCC CHECKIDENT('s2.t1', RESEED, 0)

Select IDENT_CURRENT('s2.t1')

-- CONSTRAINTS - SET OF RULES
-- PRIMARY KEY
-- UNIQUE 
-- FOREIGN
-- CHECK
-- DEFAULT
-- NOT NULL

create table emp
(
EID int Primary Key, --avoid duplicates, no null values
EName varchar(25) NOT NULL UNIQUE,
EAge int check(EAge>18),
EDesignation varchar(25) default 'Trainee'
)

--default constraint
insert into emp(EID,EName,EAge) values(3,'Jamie',25)

select * from emp

select * from s2.t1

alter table s2.t1 add empid as (id+100)

