/*
Retrieving Data using the SQL SELECT Statement
- Using Column aliases
- Using the SQL SELECT statement
- Using concatenation operator, literal character strings, 
  alternavtive quote operator, and the DISTINCT keyword
- Using Arithmetic expressions and NULL values in the SELECT statement
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

--1 to select all the columns/rows in a table use:
SELECT *                        
FROM employees;                 -- use 'ctrl' + 'enter' to execute the code

SELECT *
FROM departments;

--2 to select specific columns;
SELECT department_id, department_name
FROM departments;

--3 using Arithmetic Expressions (+, -, *, /)
SELECT employee_id, first_name, salary
FROM employees;

SELECT employee_id, first_name, salary, salary + 100, salary + (salary * 0.10)
FROM employees;