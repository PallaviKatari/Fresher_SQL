use Trainees

--DATATYPES

create table types
 (
	bigint_col bigint,
	int_col INT,
	smallint_col SMALLINT,
	tinyint_col tinyint,
	dec_col DECIMAL (4, 2),
       	num_col NUMERIC (4, 2),
	bit_col BIT,
	val CHAR(3),
	val1 NCHAR(1) NOT NULL,
	val2 VARCHAR(10) NOT NULL,
	val3 NVARCHAR(20) NOT NULL,
	created_at DATETIME2,
	dob DATE NOT NULL,
	login TIME (0) NOT NULL,
	modified_on DATETIMEOFFSET NOT NULL
)

insert into types values

(
9223372036854775807,
		2147483647,
		32767,
		255,
		10.05, 
		20.05,
		1,
		'a',
		N'あ',
		'Hello',
		(N'ありがとうございました'),
		getdate(),
		'2000-01-31',
		'11:30:30',
		'2019-02-28 01:45:00.0000000 -08:00'
)

select * from types

--IMAGE STORAGE

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

--SCHEMA

create schema freshertrainees

create table freshertrainees.db
(
TID int,
TName varchar(20)
)

drop table freshertrainees.db
drop schema freshertrainees 

select * from batch35

--order by

select * from batch35 order by empname
select * from batch35 order by empname desc

--offset & fetch

select * from batch35 order by empname offset 0 rows fetch first 5 rows only

--Top

select Top 3 with ties empname,salary from batch35 order by salary desc

 insert into batch35 values('john',55000),('tom',100000),('peter',200000),('sam',300000)
 insert into batch35 values('Jancy',55000),('Rita',100000),('Paula',200000),('Shaun',300000)

 --Filtering Records - where clause

 select * from batch35 where salary >= 60000 -- Relational 

 --Conditional

 select * from batch35 where salary >= 60000 and salary <=90000 
 select * from batch35 where salary >= 60000 and empname='Tom'
 select * from batch35 where salary >= 60000 or empname='Tom'

 --Range

 select * from batch35 where salary between 50000 and 70000
 select * from batch35 where salary not between 50000 and 70000

 --Like - % _

  select * from batch35 where empname like 'R%'
  select * from batch35 where empname like '_a%'
  select * from batch35 where empname like '_a_i%'
  select * from batch35 where empname like '[PVS]%'
  select * from batch35 where empname NOT like '[PVS]%'
  select * from batch35 where empname NOT like '[A-J]%'

  --IN

  select * from batch35 where empname IN('Tom','Peter')
  select * from batch35 where empname NOT IN('Tom','Peter')
  
  -- retrieve case sensitive record

  select * from batch35 where empname='Sam' COLLATE SQL_Latin1_General_CP1_CS_AS;

--select collation_name, *
--from sys.columns
--where object_id = object_id('tblname')
--and name = 'stringdata';

  alter table batch35 alter column empname varchar(20) collate Modern_Spanish_CI_AS;

  select * from batch35 where empname like '[JTP]%' COLLATE SQL_Latin1_General_CP1_CS_AS;
  select * from batch35 where empname like 'sa%' COLLATE SQL_Latin1_General_CP1_CS_AS;


