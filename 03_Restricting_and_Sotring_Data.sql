/*
Restricting and Sorting Data
- Applying Rules of Precedence for operators in an expression
- Limiting Rows Returned in a SQL statement
- Using Substitution Variables
- Using the DEFINE and VERIFY commands
- Sorting Data
*/


--1 to select all the rows and columns in a table
SELECT *
FROM employees;

--2 to limit the rows that are selected, we use WHERE clause and it always comes after FROM
SELECT *
FROM employees
WHERE department_id = 90;

SELECT *
FROM employees
WHERE salary = 24000;