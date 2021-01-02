
/*
Using Subqueries to Solve Queries
- Using Single Row Subqueries
- Using Multiple Row Subqueries
- Update and delete rows using correlated subqueries
*/


--1 using a Subquery
-- Who has salary > Abel's salary

-- first, find Abel's salary
SELECT   salary
FROM     Employees
WHERE    last_name = 'Abel';

-- second, use the Subquery
SELECT   employee_id, first_name, last_name, salary
FROM     Employees
WHERE    salary    > (SELECT   salary
                      FROM     Employees
                      WHERE    last_name = 'Abel');
         

--2 using a Single-Row Subquery
-- the Subquery should return a single row (value)
SELECT   *
FROM     Employees
WHERE    job_id   = (SELECT   job_id
                     FROM     Employees
                     WHERE    last_name = 'Abel');
    
-- the below will return an error because this Subquery returns multiple rows
SELECT   *
FROM     Employees
WHERE    salary   > (SELECT   salary
                     FROM     Employees
                     WHERE    department_id = 30);
         
-- Subquery with Multiple-Row functions
SELECT   *
FROM     Employees
WHERE    salary   = (SELECT   MAX(salary)
                     FROM     Employees);
          
-- Subquery with HAVING
SELECT   department_id,        COUNT(employee_id)
FROM     Employees
GROUP BY department_id
HAVING   COUNT(employee_id) > (SELECT   COUNT(1)
                               FROM     Employees
                               WHERE    department_id = 90)
ORDER BY department_id;                               

-- if the Subquery returns nothing, the whole SELECT statement will return nothing
SELECT   employee_id,   first_name,     last_name,      salary
FROM     Employees
WHERE    salary      > (SELECT   salary
                        FROM     Employees
                        WHERE    last_name = 'dddd');


--3 Multiple-Row Subqueries
-- returns more than one row
-- uses multiple-row comparison operators
    -- IN, ANY, ALL

SELECT   salary
FROM     Employees
WHERE    department_id = 90;

SELECT   first_name,    last_name,      salary
FROM     Employees
WHERE    salary     IN (SELECT   salary
                        FROM     Employees
                        WHERE    department_id = 90);
                        
SELECT   first_name,    last_name,      salary
FROM     Employees
WHERE    salary >= ANY (SELECT   salary
                        FROM     Employees
                        WHERE    department_id = 90);

SELECT   first_name,    last_name,      salary
FROM     Employees
WHERE    salary >= ALL (SELECT   salary
                        FROM     Employees
                        WHERE    department_id = 90);

-- NULL values
SELECT   *
FROM     Employees
WHERE    manager_id IS NULL;

-- IN is equal to = ANY
-- NULL will be ignored here
SELECT   *
FROM     Employees
WHERE    manager_id IN(100, 101, NULL);

SELECT   employee_id,   first_name,    last_name,      salary
FROM     Employees
WHERE    employee_id IN(SELECT   manager_id
                        FROM     Employees);

-- this query will not return anything
SELECT   *
FROM     Employees
WHERE    manager_id NOT IN(100, 101, NULL);     -- NOT IN is equal to != ALL

SELECT   employee_id,   first_name,     last_name,    salary
FROM     Employees
WHERE    employee_id    NOT IN(SELECT   manager_id
                               FROM     Employees);
                            

-- EXISTS / NOT EXISTS
-- retrieve all the departments info that have employees

-- not the best practice
SELECT   *
FROM     Departments Dept
WHERE    department_id IN(SELECT department_id
                          FROM   Employees Emp);

-- this is a good way
SELECT   *
FROM     Departments Dept
WHERE    EXISTS (SELECT   department_id
                 FROM     Employees Emp
                 WHERE    Emp.department_id = Dept.department_id);

-- retrieve all the departments info that does not have any employee                
SELECT   *
FROM     Departments Dept
WHERE    NOT EXISTS (SELECT   department_id
                     FROM     Employees Emp
                     WHERE    Emp.department_id = Dept.department_id);