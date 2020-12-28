
/*
Reporting Aggregated Data using Group Functions
- Using Group Functions
- Creating Groups of Data
- Restricting Group Results
*/


/*
Two types of SQL functions:

- Single-Row functions: return one result per row
- Multiple-Row functions: return one result per set of rows
*/


/*
What are Group functions?

- Group functions operate on sets of rows to give one result per group
*/


/*
Types of Group functions:

- AVG
- COUNT
- MAX
- MIN
- SUM
- LISTAGG
- STDDEV
- VARIANCE
*/


/*
Syntax:
group_function([DISTINCT|ALL] expr)                  

- DISTINCT considers only non-duplicate values;
  ALL considers every value, including the duplicates (default)
- The data types the functiosn can take are: CHAR, VARCHAR2, NUMBER, DATE
- All group functions ignore NULL values. 
  To substitute a value for NULL values, use the NVL, NVL2, COALESCE, CASE, or DECODE
*/


--1 MAX and MIN 
SELECT salary
FROM Employees
ORDER BY salary DESC;

SELECT MAX(salary), MIN(salary)
FROM Employees;

-- using the Date data type
SELECT MAX(hire_date), MIN(hire_date)
FROM Employees;


--2 SUM and AVG functions
SELECT SUM(salary), AVG(salary)
FROM Employees;

-- you cannot use SUM and AVG with VARCAHR and DATES
SELECT SUM(first_name), AVG(first_name)
FROM Employees;


--3 COUNT function
SELECT *
FROM Employees;

SELECT COUNT(*)         -- counting the number of rows (records)
FROM Employees;

SELECT COUNT(1)         -- same as above
FROM Employees;

SELECT COUNT(commission_pct)    -- does not count NULL values
FROM Employees;         

SELECT COUNT(department_id)     -- does not count NULL values
FROM Employees;

SELECT COUNT(DISTINCT department_id)
FROM Employees;

-- you can handle NULL values using the NVL function
SELECT COUNT(NVL(commission_pct, 0))
FROM Employees;

SELECT COUNT(employee_id)
FROM Employees
WHERE department_id = 90;


--4 LISTAGG function
SELECT first_name
FROM Employees
WHERE department_id = 30
ORDER BY first_name;

SELECT LISTAGG(first_name, ', ')
       WITHIN GROUP(ORDER BY first_name) "Emp_list"
FROM Employees
WHERE department_id = 30;


--5 GROUP BY fucntion
SELECT department_id, SUM(salary)
FROM Employees;
/*
ORA-00937: not a single-group function
00937. 00000 -  "not a single-group group function"
*/

SELECT department_id, SUM(salary)
FROM Employees
GROUP BY department_id;

SELECT department_id, job_id, SUM(salary)
FROM Employees
GROUP BY department_id, job_id          -- All columns in the SELECT statement should appear in GROUP BY
ORDER BY 1, 2;

-- you cannot use GROUP BY using Alias
SELECT department_id d, SUM(salary)
FROM Employees
GROUP BY d;

-- you can use ORDER BY using Alias
SELECT department_id d, SUM(salary)
FROM Employees
GROUP BY department_id
ORDER BY d;

-- WHERE -> GROUP BY -> ORDER BY
SELECT department_id, SUM(salary)
FROM Employees
WHERE department_id > 30
GROUP BY department_id
ORDER BY department_id;


--6 HAVING function
-- you cannot use WHERE to restrict groups (very important)
-- this returns an error
SELECT department_id, SUM(salary)
FROM Employees
WHERE SUM(salary) > 156400
GROUP BY department_id
ORDER BY department_id;

SELECT department_id, SUM(salary)
FROM Employees
GROUP BY department_id
HAVING SUM(salary) > 150000
ORDER BY department_id;


--7 Nested Group functions
SELECT department_id, SUM(salary)
FROM Employees
GROUP BY department_id
ORDER BY 1;

SELECT MAX(SUM(salary))      -- only 2 Group functions can be nested
FROM Employees
GROUP BY department_id
ORDER BY 1;