
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

-- UNION operator
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


-- UNION ALL
SELECT   employee_id, job_id
FROM     Employees

UNION ALL       -- does not sort the result in an ascending/descending order

SELECT   employee_id, job_id
FROM     Job_history;


-- INTERSECT operator
SELECT   employee_id emp_id, job_id job
FROM     Employees

INTERSECT

SELECT   employee_id emno, job_id jobid
FROM     Job_history;


-- MINUS operator
SELECT   employee_id
FROM     Employees

MINUS

SELECT   employee_id
FROM     job_history;


-- creating a dummy column (char)
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


-- ORDER BY comes the last and only once
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