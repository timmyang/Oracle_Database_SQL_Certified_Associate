
/*
Managing Tables using DML Statements
- Perform INSERT, UPDATE and DELTE operations
- Managing Database Transactions
- Controlling transactions
- Performing multi table Inserts
- Performing Merge statements
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
        
    -- Data Control Language (DC):
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


--5 TRUNCATE statement
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