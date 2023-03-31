/*A cursor in SQL Server is a database object that allows us to retrieve each row at a time and manipulate its data. 
A cursor is nothing more than a pointer to a row.
The SQL Server
cursor's purpose is to update the data row by row, change it, or perform calculations 
that are not possible when we retrieve all records at once. */

--SQL Server Cursor Example 
--A SQL Server cursor is a set of T-SQL logic to loop over a predetermined number of rows one at a time. 
--The purpose for the cursor may be to update one row at a time or perform an 
--administrative process such as SQL Server database backups in a sequential

/*
Life Cycle of the cursor

1: Declare Cursor
DECLARE cursor_name CURSOR  
    FOR select_statement;  

2: Open Cursor
OPEN cursor_name;  

3: Fetch Cursor
FETCH NEXT FROM cursor INTO variable_list;  

WHILE @@FETCH_STATUS = 0    
    BEGIN  
        FETCH NEXT FROM cursor_name;    
    END;  

4: Close Cursor
CLOSE cursor_name;  

5: Deallocate Cursor
DEALLOCATE cursor_name;  

Types of Cursors in SQL Server
The following are the different types of cursors in SQL Server listed below:

Static Cursors
Dynamic Cursors
Forward-Only Cursors
Keyset Cursors

Static Cursors
The result set shown by the static cursor is always the same as when the cursor was first opened. 
Since the static cursor will store the result in tempdb, they are always read-only.
We can use the static cursor to move both forward and backward.

Dynamic Cursors
The dynamic cursors are opposite to the static cursors that allow us to perform 
the data updation, deletion, and insertion operations while the cursor is open. 
It is scrollable by default. It can detect all changes made to the rows, order,
and values in the result set, whether the changes occur inside the cursor or outside the cursor. 
Outside the cursor, we cannot see the updates until they are committed.

Forward-Only Cursors
It is the default and fastest cursor type among all cursors.
It is called a forward-only cursor because it moves only forward through the result set. 
This cursor doesn't support scrolling. 
It can only retrieve rows from the beginning to the end of the result set.
The Forward-Only cursors are three categorize into three types: 
-Forward_Only Keyset
-Forward_Only Static
-Fast_Forward

Keyset Driven Cursors
This cursor functionality lies between a static and a dynamic cursor regarding its ability to detect changes. 
It can't always detect changes in the result set's membership and order like a static cursor. 
It can detect changes in the result set's rows values as like a dynamic cursor. 
It can only move from the first to last and last to the first row. 
The order and the membership are fixed whenever this cursor is opened.*/

--Sample clearing memory
DBCC FREESYSTEMCACHE ('ALL') 
DBCC FREESESSIONCACHE
DBCC FREEPROCCACHE 
GO 
DBCC DROPCLEANBUFFERS 
GO 

CREATE TABLE customer 
(      
  id int PRIMARY KEY,      
  c_name nvarchar(45) NOT NULL,      
  email nvarchar(45) NOT NULL,      
  city nvarchar(25) NOT NULL      
); 

INSERT INTO customer (id, c_name, email, city)       
VALUES (1,'Steffen', 'stephen@gmail.com', 'Texas'),       
(2, 'Joseph', 'Joseph@gmail.com', 'Alaska'),       
(3, 'Peter', 'Peter@gmail.com', 'California'),    
(4,'Donald', 'donald@gmail.com', 'New York'),       
(5, 'Kevin', 'kevin@gmail.com', 'Florida'),  
(6, 'Marielia', 'Marielia@gmail.com', 'Arizona'),    
(7,'Antonio', 'Antonio@gmail.com', 'New York'),       
(8, 'Diego', 'Diego@gmail.com', 'California');       

SELECT * FROM customer;  

--Example 1
--Declare the variables for holding data.  
DECLARE @id INT, @c_name NVARCHAR(50), @city NVARCHAR(50)  
   
--Declare and set counter.  
DECLARE @Counter INT  
SET @Counter = 1  
   
--Declare a cursor  
DECLARE PrintCustomers CURSOR  --Forward-Only Cursor
FOR  
SELECT id, c_name, city FROM customer  
  
--Open cursor  
OPEN PrintCustomers  
   
--Fetch the record into the variables.  
FETCH NEXT FROM PrintCustomers INTO  
@id, @c_name, @city  
  
--LOOP UNTIL RECORDS ARE AVAILABLE.  
WHILE @@FETCH_STATUS = 0  --If the SQL query returned at least one row the first FETCH statement should be successful, else it should fail.
    BEGIN  
        IF @Counter = 1  
        BEGIN  
            PRINT 'id'  +space(7)+ 'c_name' +char(9) + char(9)+ 'city'  --char(9) tabspace
            PRINT '-------*********************-------'  
        END  
   
        --Print the current record  
        PRINT CAST(@id AS NVARCHAR(2)) + space(10) + @c_name + char(9)+ char(9)+ @city  
      
        --Increment the counter variable  
        SET @Counter = @Counter + 1  
   
        --Fetch the next record into the variables.  
        FETCH NEXT FROM PrintCustomers INTO  
        @id, @c_name, @city  
--When the FETCH statement doesn�t return any rows @@FETCH_STATUS function should return -1, and then the while loop is ended.
    END  
   
--Close the cursor  
CLOSE PrintCustomers  
  
--Deallocate the cursor  
DEALLOCATE PrintCustomers  

--Example 2
use trainees;
select * from batch35
DECLARE ex_cursor CURSOR --Forward-Only Cursor
FOR SELECT salary,empname FROM dbo.batch35
DECLARE @esalary INT
DECLARE @ename NVARCHAR(50)

OPEN ex_cursor

FETCH NEXT FROM ex_cursor INTO @esalary,@ename
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT  (CAST(@esalary AS VARCHAR(15)) + '-' + @ename)
FETCH NEXT FROM ex_cursor INTO @esalary,@ename
END

CLOSE ex_cursor
DEALLOCATE ex_cursor

--Example 3
--If you decide to only fetch rows without storing them within variables, the result will be displayed as a result of a select query:

SELECT TABLE_SCHEMA, TABLE_NAME from INFORMATION_SCHEMA.TABLES

DECLARE csr CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME from INFORMATION_SCHEMA.TABLES
  
OPEN csr --Forward-Only Cursor
FETCH NEXT FROM csr
WHILE @@FETCH_STATUS = 0 
BEGIN
FETCH NEXT FROM csr
END
  
CLOSE csr
DEALLOCATE csr

/*What is the @@FETCH_STATUS function?
@@FETCH_STATUS is a system function that returns the status of the last FETCH statement issued against any opened cursor. This function returns an integer value as mentioned in the table below (Reference: @@FETCH_STATUS (Transact-SQL)):

Value		Description

0			The FETCH statement was successful

-1			The FETCH statement failed, or the row was beyond the result set

-2			The row fetched is missing

-9			The cursor is not performing a fetch operation*/

--Example 4
DECLARE @Schema NVARCHAR(50)
DECLARE @name NVARCHAR(50)
  
DECLARE csr1 CURSOR FOR SELECT TABLE_SCHEMA, TABLE_NAME from INFORMATION_SCHEMA.TABLES
  
OPEN csr1 --Forward-Only Cursor
  
FETCH NEXT FROM csr1 INTO @Schema, @name
  
WHILE @@FETCH_STATUS = 0
  BEGIN
    FETCH NEXT FROM csr1 INTO @Schema, @name
	PRINT @Schema +'-'+ @name
  END
  
CLOSE csr1
DEALLOCATE csr1

--Example 5

DECLARE @Id int
 
CREATE TABLE #TBLTEMP (
  Id int not null PRIMARY KEY
  )
  
INSERT INTO #TBLTEMP (Id) VALUES (1),(2)
  
DECLARE csr CURSOR KEYSET FOR SELECT Id FROM #TBLTEMP ORDER BY Id
OPEN Csr --Keyset Cursor
FETCH NEXT FROM csr INTO @Id
  
SELECT id FROM #TBLTEMP
DELETE FROM #TBLTEMP WHERE Id = 2
  
FETCH NEXT FROM csr INTO @Id
SELECT id FROM #TBLTEMP  
SELECT @@FETCH_STATUS as [Fetch_Status]
  
CLOSE csr
DEALLOCATE csr
DROP TABLE #TBLTEMP

--Example 6
DECLARE B35Cursor CURSOR SCROLL --DYNAMIC CURSOR

FOR SELECT salary,empname FROM batch35

OPEN B35Cursor

FETCH first FROM B35Cursor --FETCH FIRST CANNOT BE USED WITH FORWARD ONLY

WHILE @@FETCH_STATUS = 0

CLOSE B35Cursor

DEALLOCATE B35Cursor

--Example 7
DECLARE Cursor1 CURSOR SCROLL --DYNAMIC CURSOR

FOR SELECT salary,empname FROM batch35

OPEN Cursor1

FETCH LAST FROM Cursor1

WHILE @@FETCH_STATUS = 0

FETCH PRIOR FROM Cursor1

CLOSE Cursor1

DEALLOCATE Cursor1

--Example 8
use trainees
DECLARE Cursor2 CURSOR SCROLL --DYNAMIC CURSOR

FOR SELECT salary,empname FROM batch35

OPEN Cursor2

FETCH ABSOLUTE 3 FROM Cursor2
FETCH RELATIVE 5 FROM Cursor2
FETCH ABSOLUTE 5 FROM Cursor2

WHILE @@FETCH_STATUS = 0

CLOSE Cursor2

DEALLOCATE Cursor2

--Example 9
--SQL Server static cursors are always read-only. 
--Because the result set of a static cursor is stored in a worktable in tempdb, 
--the size of the rows in the result 
--set cannot exceed the maximum row size for a SQL Server table.

DECLARE B35Cursor1 CURSOR STATIC

FOR SELECT salary,empname FROM batch35

OPEN B35Cursor1

FETCH LAST FROM B35Cursor1

CLOSE B35Cursor1

DEALLOCATE B35Cursor1

--Example 10
--When we open keyset-driven cursor then it creates a list of unique values in the tempdb database. 
--These values are called keyset. Every keyset uniquely identifies a single row in the result set.
 --A Keyset is created after the opening of the cursor so the number of rows is fixed until we close the cursor.
 
DECLARE B35Cursor2 CURSOR KEYSET

FOR SELECT salary,empname FROM batch35

OPEN B35Cursor2

FETCH LAST FROM B35Cursor2

CLOSE B35Cursor2

DEALLOCATE B35Cursor2

/*
1.FETCH NEXT	
Moves the cursor to the next record in the result set. 
If this is the first time a fetch has been used on this cursor it is moved to the first record.	
FETCH NEXT FROM T28Cursor

2.FETCH PRIOR	
Moves the cursor to the previous row in the result set.	
FETCH PRIOR FROM T28Cursor

3.FETCH FIRST	
Moves the cursor to the first record in the result set.
FETCH FIRST FROM T28Cursor

4.FETCH LAST	
Moves the cursor to the last record in the result set.	
FETCH LAST FROM T28Cursor

5.FETCH ABSOLUTE n	
Moves the cursor to the specified record in the result set where n 
is the number of the row you want to return. 
If you specify a negative number for n it will return the record 
that is n rows before the end of the result set.	
FETCH ABSOLUTE 5 FROM T28Cursor

6.FETCH RELATIVE n	
Moves the cursor the specified number of rows forwards or backwards 
from its current position. Use positive numbers to move forwards and 
negative numbers to move backwards	
FETCH RELATIVE -3 FROM T28Cursor*/

/*
Limitations of SQL Server Cursor
A cursor has some limitations so that it should always use only when there is no option except the cursor.
These limitations are:
Cursor consumes network resources by requiring a network roundtrip each time it fetches a record.

A cursor is a memory resident set of pointers, which means it takes some memory that other processes could use on our machine.

It imposes locks on a portion of the table or the entire table when processing data.

The cursor's performance and speed are slower because they update table records one row at a time.

Cursors are quicker than while loops, but they do have more overhead.

The number of rows and columns brought into the cursor is another aspect that affects cursor speed. 

It refers to how much time it takes to open your cursor and execute a fetch statement.*/

/*
How can we avoid cursors?
The main job of cursors is to traverse the table row by row. The easiest way to avoid cursors are given below:

Using the SQL while loop

The easiest way to avoid the use of a cursor is by using a while loop that allows the inserting of a result set into the temporary table.

User-defined functions

Sometimes cursors are used to calculate the resultant row set. We can accomplish this by using a user-defined function that meets the requirements.

Using Joins

Join processes only those columns that meet the specified condition and thus reduces the lines of code that give faster performance than 
cursors in case huge records need to be processed.*/

DECLARE B35Cursor2 CURSOR static

FOR SELECT salary,empname FROM batch35

OPEN B35Cursor2

FETCH Last FROM B35Cursor2 

WHILE @@FETCH_STATUS = 0

CLOSE B35Cursor2

DEALLOCATE B35Cursor2

SELECT salary,empname FROM batch35

delete from batch35 where empname='sam';

---------------------------------------
--REAL-TIME EXAMPLE
use trainees;
CREATE TABLE Students
    (  
      Id INT ,  
      RollNo INT ,  
      EnrollmentNo NVARCHAR(15) ,  
      Name NVARCHAR(50) ,  
      Branch NVARCHAR(50) ,  
      University NVARCHAR(50)  
    )  

INSERT  INTO Students  
        ( Id, RollNo, EnrollmentNo, Name, Branch, University )  
VALUES  ( 1, 1, N'', N'John', N'CE', N'Oxford University' ),  
        ( 2, 2, N'', N'Peter', N'CE', N'Oxford University' ),  
        ( 3, 3, N'', N'Sam', N'IT', N'Oxford University' ),  
        ( 4, 4, N'', N'Dean', N'CE', N'Oxford University' ),  
        ( 5, 5, N'', N'Jancy', N'CE', N'Oxford University' ),  
        ( 5, 5, N'', N'Andrea', N'EC', N'Oxford University' ),  
        ( 6, 6, N'', N'Shaun', N'ME', N'Oxford University' )  

SELECT * FROM Students
--CURSOR 
DECLARE @Id INT ,  
@RollNo INT,  
@Branch NVARCHAR(50) ,  
@Year AS INT  
   
SET @Year = RIGHT(YEAR(GETDATE()), 2)  -- RIGHT(2023,2) -> 23
   
DECLARE MY_data CURSOR  
FOR  
    SELECT  Id ,  
            Branch,  
            RollNo,  
            @Year  
    FROM    Students  
   
OPEN MY_data  
FETCH NEXT FROM MY_data INTO @Id, @Branch, @RollNo,@Year  
WHILE @@FETCH_STATUS = 0  
    BEGIN  
        DECLARE @EnrollmentNo NVARCHAR(15)  
                SET @EnrollmentNo = 'SOE' + CAST(@Year AS VARCHAR(2)) + CAST(@Branch AS NVARCHAR(50)) + '000' + CAST(@RollNo AS NVARCHAR(10))  
                  
                UPDATE Students SET EnrollmentNo =  @EnrollmentNo WHERE Id =  @Id  
   
        FETCH NEXT FROM MY_data INTO  @Id, @Branch, @RollNo,@Year 
    END			
SELECT * FROM Students
CLOSE MY_data  
DEALLOCATE MY_data

--"EnrollmentNo" where "SOE" Indicates "School of Engineering",
--23 Indicates Last Two Digits of Current Year and 
--Last Digits of EnrollmentNo Indicates the RollNo of Student and 
--finally update the column "EnrollmentNo" in table Students 
--with New Generated EnrollmentNo based on unique Identity column @Id for each and every student in the table.