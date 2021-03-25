
/*
Using the Set Operators
- Using The UNION and UNION ALL operators
- Using The INTERSECT operator
- Using The MINUS operator
- Matching the SELECT statements
- Using the ORDER BY clause in set operations
*/

/*
Set Operators combine the results of two or more component queries into one result.
Queries containing Set Operators are called "compound queries".

UNION: returns rows from both queries after eliminating duplicates
UNION ALL: retruns rows from both queries, including all duplicates
INTERSECT: returns rows that are common to both queries
MINUS: returns rows in the first query that are not present in the second query
*/

--1 UNION operator
/*
The number of columns being selected must be the same.
The data types must be the same.
The names of the columns need NOT to be identical.
UNION operators compare all of the columns being selected.
NULL values are not ignored during duplicate checking.
By default, the output is sorted in ascending order
*/

SELECT   *
FROM     Employees
WHERE    Employee_id = 176;

SELECT   *
FROM     Job_history
WHERE    employee_id = 176;

--
SELECT   employee_id, job_id
FROM     Employees
WHERE    employee_id = 176 

UNION

SELECT   employee_id, job_id
FROM     Job_history
WHERE    employee_id = 176;

--
SELECT   employee_id, job_id
FROM     Employees

UNION

SELECT   employee_id, job_id
FROM     Job_history;

--
SELECT   employee_id emp_id, job_id job
FROM     Employees

UNION

SELECT   employee_id emno, job_id jobid
FROM     Job_history;


--2 UNION ALL
SELECT   employee_id, job_id
FROM     Employees

UNION ALL       -- does not sort the result in an ascending/descending order

SELECT   employee_id, job_id
FROM     Job_history;


--3 INTERSECT operator
SELECT   employee_id emp_id, job_id job
FROM     Employees

INTERSECT

SELECT   employee_id emno, job_id jobid
FROM     Job_history;


--4 MINUS operator
SELECT   employee_id
FROM     Employees

MINUS

SELECT   employee_id
FROM     job_history;


--5 creating a dummy column (char)
SELECT   employee_id, job_id, email
FROM     Employees

UNION

SELECT   employee_id, job_id, to_char(NULL) email
FROM     Job_history;

-- creating a dummy column (number)
SELECT   employee_id, job_id, salary
FROM     Employees

UNION

SELECT   employee_id, job_id, 0 salary
FROM     Job_history;


--6 ORDER BY comes the last and only once
-- it only reads the column names from the first query
SELECT   employee_id, job_id, salary
FROM     Employees

UNION

SELECT   employee_id, job_id, 0 salary
FROM     Job_history
ORDER BY employee_id;

-- you can also use the column number for ORDER BY
SELECT   employee_id emp_id, job_id, salary
FROM     Employees

UNION

SELECT   employee_id empno, job_id, 0 salary
FROM     Job_history
ORDER BY 1;


--7 Exercises

SELECT   *
FROM     Employees
WHERE    employee_id = 176;

SELECT   *
FROM     Job_history
WHERE    employee_id = 176;

-- the UNION between Employees and Job_history
/* 1- the number of columns should match
   2- the data type should match
   3- duplicates has been eliminated
   4- the query order is ASC for all columns
*/

SELECT   employee_id, job_id
FROM     Employees
WHERE    employee_id = 176

UNION

SELECT   employee_id, job_id
FROM     Employees
WHERE    employee_id = 176;

--
SELECT   employee_id, job_id
FROM     Employees

UNION

SELECT   employee_id, job_id
FROM     Job_history;

-- UNION ALL 
-- will not remove duplicates
-- will not be ordered

SELECT   employee_id, job_id
FROM     Employees

UNION ALL

SELECT   employee_id, job_id
FROM     Job_history;


-- the column name from the first query will appear in the reuslt
SELECT   employee_id emp_id, job_id job1
FROM     Employees

UNION

SELECT   employee_id emno, job_id jobid
FROM     Job_history;


-- INTERSECT operator
SELECT   employee_id emp_id, job_id job1
FROM     Employees

INTERSECT

SELECT   employee_id emno, job_id jobid
FROM     Job_history;

-- now the comparison is across 3 columns, so the result differs
SELECT   employee_id emp_id, job_id job1, department_id
FROM     Employees

INTERSECT

SELECT   employee_id emno, job_id jobid, department_id
FROM     Job_history;


-- the MINUS operator
SELECT   employee_id
FROM     Employees

MINUS

SELECT   employee_id
FROM     Job_history;


-- matching Dummy Column
SELECT   employee_id, job_id, email
FROM     Employees

UNION

SELECT   employee_id, job_id, to_char(NULL) email
FROM     Job_history;  
