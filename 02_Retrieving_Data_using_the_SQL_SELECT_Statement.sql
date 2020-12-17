
/*
Retrieving Data using the SQL SELECT Statement
- Using the SQL SELECT statement
- Using Arithmetic expressions and NULL values in the SELECT statement
- Using Column aliases
- Using concatenation operator, literal character strings, 
  alternavtive quote operator, and the DISTINCT keyword
*/


--this is a single line comment

/* this is a 
multiple lines
comment
*/

--1 to select all the columns/rows in a table use:
SELECT *                        
FROM employees;                 -- use 'ctrl' + 'enter' to execute the code

SELECT *
FROM departments;


--2 to select specific columns
SELECT department_id, department_name
FROM departments;

/*
Capabilities of SQL SELECT statements:

- Retrieving the columns from the table is called "Projection"
- Retrieving the rows from the table is called "Selection"
- Retrieving the data from multiple tables is called "Join"


Basic SELECT statement:
SELECT {*| [DISTINCT] column| expression [alias], ...}
FROM table;

- SELECT identifies the columns to be displayed
- FROM identifies the table containing those columns


Writing SQL statements:

- SQL statements are not case sensitive
- SQL statements can be entered on one or more lines
- KEYWORDS cannot be abbreviated or split across lines
- Clauses (WHERE, ORDER BY, HAVING, TOP, GROUP BY) are usually placed on separate lines
- Indents are used to enhance readability
- In SQL Developer, SQL statements can be optionally terminated by a semicolon(;)
    Semicolons are required when you execute multiple SQL statements
- In SQL Plus, you are required to end each SQL statement with a semicolon(;)
*/


--3 using Arithmetic Expressions (+, -, *, /)
SELECT employee_id, first_name, salary
FROM employees;

SELECT employee_id, first_name, salary, salary + 100, salary + (salary * 0.10)
FROM employees;


--4 to know NULL values
-- NULL is a value that is unavailable, unassigned, unknown, or inapplicable
-- NULL is not the same as zero or a blank space
SELECT last_name, job_id, salary, commission_pct
FROM employees;


--5 Arithmetic expressions containing a NULL value evaluate to NULL
SELECT last_name, job_id, salary, commission_pct, commission_pct + 10
FROM employees;


--6 Defining a column alias (remanes a column heading)
SELECT last_name, last_name AS name, last_name lname, last_name " LAST nAME"
FROM employees;


--7 Concatenation Operator "||" Links columns or character strings
-- Literal (A Literal is a character, a number, or a date that is included in the SELECT statement)
SELECT first_name, last_name, 
       first_name||last_name, 
       first_name||last_name "full name", 
       first_name||' '||last_name "full name with space"            -- using literal character strings
FROM employees;

SELECT first_name||' work in department '||department_id
FROM employees;

SELECT first_name||q'[ work in depart'''ment]'||department_id      -- q stands for quote
FROM employees;

SELECT first_name||q'( work in depart'''ment)'||department_id
FROM employees;


--8 Using DISTINCT
SELECT department_id
FROM employees;                     -- this will pick all the DEPARTMENT_ID from the table EMPLOYEES

SELECT DISTINCT department_id       -- in the beginning of the SELECT statement
FROM employees;

SELECT DISTINCT job_id
FROM employees;

-- you can use many columns in distinct
SELECT DISTINCT department_id, job_id
FROM employees;

SELECT DISTINCT *                   -- an entire row is one distinct value
FROM employees;

--9 DESCRIBE or DESC command
-- Use the DESCRIBE command to display the structure of a table
DESCRIBE employees;

DESC employees;