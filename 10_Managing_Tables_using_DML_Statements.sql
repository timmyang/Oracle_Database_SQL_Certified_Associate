
/*
Managing Tables using DML Statements
- Perform INSERT, UPDATE and DELTE operations
- Performing Multi-Table Inserts
- Performing MERGE statements
- Managing Database Transactions
- Controlling Transactions
*/


-- Types of SQL Statements:

    -- Data Manipulation Language (DML):
        SELECT
        INSERT INTO
        UPDATE
        DELETE
        MERGE
        
    -- Data Definition Language (DDL):
        CREATE
        ALTER
        DROP
        RENAME
        TRUNCATE
        COMMENT
        
    -- Data Control Language (DCL):
        GRANT
        REVOKE
        
    -- Transaction Control:
        COMMIT
        ROLLBACK
        SAVEPOINT

--1 Data Manipulation Language (DML)

INSERT  -- Add new rows to a table
UPDATE  -- Modify existing rows in a table
DELETE;  -- Removing existing rows from a table      = TRUNCATE(DDL), cannot rollback


--2 INSERT statement

-- Always DESC the table before making any insert to know the columns and the constraints
DESC Departments;

/* 
INSERT Rules:

- Insert a new row containing values for each column
- list values in the default order of the columns in the table
- Optionally, list the columns in the INSERT cluase
- Enclose character and date values within 'single quotation' marks
*/

INSERT INTO Departments (department_id, department_name, manager_id, location_id)
VALUES                  (           71, 'Development 1',        100,        1700);

COMMIT;

-- you can ignore column names optionally, but must insert values to all columns
INSERT INTO Departments
VALUES      (72, 'Development 2', 100, 1700);

COMMIT;

-- you can change the order of columns
INSERT INTO Departments (department_name, manager_id, location_id, department_id)
VALUES                  ('Development 1',        100,        1700,            71);

COMMIT;

-- Inserting rows with NULL values
-- manager_id and location_id will become NULL automatically
INSERT INTO Departments (department_id, department_name)
VALUES                  (           74, 'Development 4');

-- explicit method (recommended)
INSERT INTO Departments (department_id, department_name, manager_id, location_id)
VALUES                  (           75, 'Development 5',       NULL,        NULL);

-- Inserting special values like SYSDATE, or some other functions
INSERT INTO Employees (employee_id, first_name, last_name,  email,               hire_date, job_id   )
VALUES                (          1,   'khaled', 'khudari', 'khaled@hotmail.com',   SYSDATE, 'IT_PROG');

INSERT INTO Employees (employee_id, first_name, last_name, email,               hire_date,                           job_id   )
VALUES                (          2,    'Samer',     'ali', 'samer@hotmail.com', to_date('20-07-2015', 'dd-mm-yyyy'), 'IT_PROG');

-- using the "&" with insert
INSERT INTO Departments (department_id, department_name)
VALUES                  (&dpet_id,      '&dname'       );


-- Insert with Subquery
CREATE TABLE Xx_emp (
                    empno  NUMBER,
                    fname  VARCHAR2(100),
                    salary NUMBER
                    );

SELECT   *
FROM     Xx_emp;

INSERT INTO Xx_emp (empno,       fname,      salary)
SELECT              employee_id, first_name, salary
FROM        Employees;

COMMIT;

SELECT   *
FROM     Xx_emp;


-- Errors in Inserting

-- Inserting existing values to a Primary Key (PK)
-- department_id = 10
-- (10, 'Administration', 200, 1700) already exists in the table
INSERT INTO Departments (department_id, department_name, manager_id, location_id)
VALUES                  (           10,  'Development1',        100,        1700);

-- Inserting Foreign Key (FK) value that does not exist in the reference table
-- location_id = 1
-- location is a primary key in the Locations table. Value 1 does not exist in the table.
INSERT INTO Departments (department_id, department_name, manager_id, location_id)
VALUES                  (            5, 'Development 1',        100,           1);

-- Inserting Mismatch data type
-- location_id = 'D1'
INSERT INTO Departments (department_id, department_name, manager_id, location_id)
VALUES                  (            5, 'Development 1',        100,        'D1');

-- Inserting value that is too long
-- 30 characters is the limit for department_name
INSERT INTO Departments (department_id, department_name,                           manager_id, location_id)
VALUES                  (            5, 'The development and research department',        100,        1700);

DESC Departments;


--3 UPDATE statement
-- Modifying existing values in a table
-- Use Primary Key column in the WHERE clause to identify a single row for an update
-- Otherwise, it will unexpectedly update multiple columns

SELECT   *
FROM     Employees
WHERE    employee_id = 100;

UPDATE   Employees
SET      salary = 24100
WHERE    employee_id = 100;

COMMIT;

-- Just for practice, let's copy the Employee table
CREATE TABLE Copy_emp
AS
SELECT       *
FROM         Employees;

-- If there is no WHERE condition, then the update will be applied to all columns
UPDATE Copy_emp
SET    phone_number = '515.123.4567';

SELECT *
FROM   Copy_emp;

-- Using Subquery in UPDATE
UPDATE Copy_emp
SET    salary = (SELECT   salary
                 FROM     Copy_emp
                 WHERE    employee_id = 200)
WHERE   employee_id = 100;

COMMIT;

SELECT   *
FROM     Copy_emp
WHERE    employee_id in (100, 200);

-- Using Subquery in UPDATE 2
UPDATE Copy_emp
SET    (salary, department_id) = (SELECT   salary, department_id
                                  FROM     Copy_emp
                                  WHERE    employee_id = 108)
WHERE  employee_id = 105;


--4 DELETE Statement
CREATE TABLE Dept_copy
AS
SELECT       *
FROM         Departments;

DESC Dept_copy;

--
SELECT *
FROM   Dept_copy
WHERE  department_id = 10;

DELETE FROM Dept_copy
WHERE       department_id = 10;

COMMIT;

-- If there is no WHERE condition, then all rows will be deleted
DELETE FROM Dept_copy;

-- ROLLBACK the DELETE
ROLLBACK;

SELECT *
FROM   Dept_copy;


-- DELETE based on Subquery
DELETE FROM Dept_copy
WHERE       department_id IN (SELECT department_id
                              FROM   Dept_copy
                              WHERE  department_name LIKE '%Public%');

DELETE FROM Dept_copy Dept
WHERE       NOT EXISTS (SELECT 1
                        FROM   Employees Emp
                        WHERE  Emp.department_id = Dept.department_id);
                        
-- You can not delete a Primary Key (parent) that is Foreign Key to another table (child)
DELETE FROM Departments
WHERE       department_id = 90;


--5 TRUNCATE statement (DDL)
TRUNCATE TABLE Dept_copy;   -- you cannot rollback

SELECT *
FROM   Dept_copy;

/*
Difference between DELETE and TRUNCATE:

  DELTE                             TRUNCATE
- DML Statement                     DDL Statement
- can rollback                      no rollback
- fire the triggers                 no fire the triggers
- can have WHERE clause             no WHERE clause
- delete does not delete space      deletes space
*/

--6 MERGE Statement

/*
MERGE INTO table1 alias1
    USING (table|view|sub_query) alias2
    ON (join conidtion)
    WHEN MATCHED THEN
        UPDATE
        SET column1 = value1,
            column2 = value2
    WHEN NOT MATCHED THEN
        INSERT
        VALUES (column_values);
*/

CREATE TABLE table_a (
                      id number,
                      name varchar2(100)
                      );

INSERT INTO table_a values (1, 'khaled');
INSERT INTO table_a values (2, 'ali');
INSERT INTO table_a values (3, 'ahmed');
COMMIT;

SELECT *
FROM   Table_a;

CREATE TABLE table_b (
                      id number,
                      name varchar2(100)
                      );
                      
INSERT INTO table_b values (1, 'xxxxx');
INSERT INTO table_b values (2, 'xxxxx');
COMMIT;

SELECT *
FROM   Table_b;

MERGE INTO             table_b b
    USING              (SELECT *
                        FROM   table_a) a
    ON                 (b.id = a.id)
    WHEN MATCHED THEN
        UPDATE
        SET            b.name = a.name
    WHEN NOT MATCHED THEN
        INSERT
        VALUES         (a.id, a.name);
        

--7 Database Transcations

/*
A Database transaction consists of one of the following:

- DML statements that constitute one consistent change to the data
- One DDL statement
- One Data Control Language (DCL) statement
*/


-- Start and End

/*
- Begin when the first DML SQL statement is executed
- End with one of the following events:
    - a COMMIT or ROLLBACK statement is issued
    - a DDL or DCL statement executes (automatic commit)
    - The user exists SQL Developer of SQL* Plus
    - The system crashes
*/


-- Advantage of COMMIT and ROLLBACK Statements

/*
With COMMIT and ROLLBACK statements, you can:

- Ensure data consistency
- Preview data changes before making changes permanent
- Group logically related operations
*/


-- Explicit Transaction Control Statements

/*
You can control the logic of transactions by using the 
    COMMIT, SAVEPOINT, ROLLBACK statements
*/


-- Implicit Transaction Processing

/*
An automatic COMMIT occurs in the following circumstances:

- a DDL statement issued
- a DCL statement issued
- Normal exit from SQL Developer or SQL*Plus,
    without explicitly issuing COMMIT or ROLLBACK statements

An automatic ROLLBACK occurs 
    when there is an abnormal termination of SQL Developer or SQL*Plus or s system failure
*/


-- State of the Data before COMMIT or ROLLBACK

/*
- The previous state of the data can be recovered
- The current session can review the results of the DML operations by using the SELECT statement
- Other sessions cannot view the results of the DML statements issued by the current session
- The affected rows are locked; other session cannot change the data in the affected rows
*/

    -- Case 1
    -- Doing some DML statements, then doing COMMIT
    SELECT *
    FROM   Employees
    WHERE  employee_id IN (200, 201);
    
    SELECT *
    FROM   Departments
    WHERE  Department_id = 1;
    
    -- DML1
    UPDATE Employees
    SET    salary = salary + 100
    WHERE  Employee_id = 200;
    
    -- DML2
    UPDATE Employees
    SET    salary = salary + 50
    WHERE  employee_id = 201;
    
    -- DML3
    INSERT INTO Departments (department_id, department_name,    manager_id, location_id)
    VALUES                  (            1, 'ADMINISTRATION 2',        200,        1700);
    
    -- All of the above DML statements will be committed (DML 1, 2, 3)
    COMMIT;
    
    -- Case 2
    -- Doing some DML statements, then doing ROLLBACK
    -- DML1
    DELETE FROM Departments
    WHERE       department_id = 1;
    
    -- DML2
    DELETE FROM Employees
    WHERE       employee_id = 1;
    
    SELECT *
    FROM   Departments
    WHERE  department_id = 1;
    
    SELECT *
    FROM   Employees
    WHERE  employee_id = 1;
    
    -- Both data will be restored (DML1, 2)
    ROLLBACK;
    
    -- Case 3
    -- Statement-level ROLLBACK
    SELECT *
    FROM   Employees
    WHERE  employee_id IN (106, 107);
    
    -- DML1
    DELETE FROM Employees
    WHERE       employee_id = 106;
    
    -- DML2
    -- error (Oracle rollbacks this statement itself)
    DELETE FROM Departments;
    
    -- DML3
    DELETE FROM Employees
    WHERE       employee_id = 107;
    
    -- It will roll back the first and third DML statements (DML1, 3) 
    ROLLBACK;
    
    -- Case 4
    -- Doing some DML statements, then doing one DDL/DCL statement
    -- This will make an automatic COMMIT
    -- DML1
    INSERT INTO Departments (department_id, department_name, manager_id, location_id)
    VALUES                  (         1000,         'dept1',        200,        1700);
    
    -- DML2
    INSERT INTO Departments (department_id, department_name, manager_id, location_id)
    VALUES                  (         1001,         'dept2',        200,        1700);
    
    -- DDL1
    -- an autocommit occurred for DML1, 2
    CREATE TABLE Test_table (
                             emp_id NUMBER,
                             name VARCHAR2(100)
                             );
    
    -- The DML1, 2 will not be rolled back here
    ROLLBACK;
    
    SELECT *
    FROM   Departments
    WHERE  department_id IN (1000, 1001);
    

--8 SAVEPOINT
-- If you make multiple DML statements, and ROLLBACK without any SAVEPOINTs
-- it will ROLLBACK al of the previous DML statements
SELECT *
FROM   Employees
WHERE  employee_id = 108;

UPDATE Employees
SET    salary = salary + 100
WHERE  employee_id = 108;

SAVEPOINT a;

--
SELECT *
FROM   Employees
WHERE  employee_id = 108;

UPDATE Employees
SET    salary = salary + 20
WHERE  employee_id = 108;

SELECT *
FROM   Employees
WHERE  employee_id = 108;

ROLLBACK TO SAVEPOINT a;

--
SELECT *
FROM   Employees
WHERE  employee_id = 108;

COMMIT;

SELECT *
FROM   Employees
WHERE  employee_id = 108;


--9 ROW Lock (data consistency)

/*
If you change the data value with DML, but does not COMMIT
    - only the first session will reflect the change, not other sessions
    - other sessions cannot modify the data value in the same row, until the first session completes the COMMIT
*/

SELECT *
FROM   Employees
WHERE  employee_id = 109;

UPDATE Employees
SET    salary = salary + 20
WHERE  employee_id = 109;

SELECT *
FROM   Employees
WHERE  employee_id = 109;


--10 FOR UPDATE clause
-- When you do this, no other users or other sessions can make a change on the same row, until the user COMMITs (they will wait)
SELECT *
FROM   Employees
WHERE  department_id = 10
FOR UPDATE;

COMMIT;

-- When the other session is making a change and did not commit, the code below prints the error source without having to wait
SELECT *
FROM   Employees
WHERE  department_id = 10
FOR UPDATE NOWAIT;

-- same as above, but waits 10 seconds
SELECT *
FROM   Employees
WHERE  department_id = 10
FOR UPDATE WAIT 10;