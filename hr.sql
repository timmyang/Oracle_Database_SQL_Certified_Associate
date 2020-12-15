/*
Section 4: Retrieving data using the select statement
*/

/*
23: Navigate HR schema
*/

/*
24: Capabilities of SQL SELECT Statements
*/

--this is a single line comment

/* this is a 
multiple lines
comment
*/

/*
Capabiilities of SQL SELECT Statements
Arithmetic expressions and NULL values in the SELECT statement
Column Aliases
Use of concatenation operator, literal character strings, alternative quote operator, and the DISTINCT keyword
DESCRIBE commad
*/


--1 to select all the columns/rows in a table use:
SELECT *                        -- use 'ctrl' + 'enter' to execute the code
FROM employees;

SELECT *
FROM departments;

--2 to select specific columns;
SELECT department_id, department_name
FROM departments;

--3 using Arithmetic Expressions (+, -, *, /)
SELECT employee_id, first_name, salary
FROM employees;