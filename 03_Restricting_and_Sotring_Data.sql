
/*
Restricting and Sorting Data
- Limiting Rows Returned in a SQL statement
- Applying Rules of Precedence for operators in an expression
- Sorting Data
- Using Substitution Variables
- Using the DEFINE and VERIFY commands
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

/*
Comparison Operators:
= Equal to
> Greater than
>= Greater than or equal to
< Less than
<= Less than or equal to
<> Not equal to
BETWEEN ... AND ... Between two values (inclusive)
IN(set) Match any of a list of values
LIKE Match a character pattern
IS NULL Is a null value
*/


/*
What you should know when using WHERE:
- Character strings and date values are enclosed with single quotation marks
- Character values are case-sensitive and date values are format-sensitive
- The default display format is DD-MON-YY (e.g. '01-JAN-20')
*/

--3 using WHERE in a Char column
SELECT employee_id, first_name, last_name, job_id
FROM employees
WHERE first_name = 'Steven';                        -- not 'steven'

SELECT employee_id, first_name, last_name, job_id
FROM employees
WHERE first_name = 'steven';                        -- the data is case sensitive


--4 using WHERE in Date column
SELECT hire_date
FROM employees
WHERE hire_date = '03-06-17';       -- 'YY-MM-DD'

SELECT hire_date
FROM employees;


--5 using the comparison operators
SELECT *
FROM employees
WHERE salary >= 10000;

SELECT *
FROM employees
WHERE hire_date > '99-12-31';       -- 'YY-MM-DD''

SELECT *
FROM employees
WHERE first_name > 'Alberto';

SELECT *
FROM employees
WHERE first_name > 'Alberto'
ORDER BY first_name;

SELECT *
FROM employees
WHERE first_name < 'Alberto'
ORDER BY first_name;

-- for more info refer to https://docs.oracle.com/cd/B12037_01/server.101/b10759/sql_elements002.htm


--6 using the BETWEEN ... AND ... operator
SELECT *
FROM employees
WHERE salary BETWEEN 10000 AND 20000;       -- always the lower limit first, then the higher limit

-- try to do the query by making the high limit first: no result
SELECT * 
FROM employees
WHERE salary BETWEEN 20000 AND 10000;

-- you can also use the operators in Varchar columns
SELECT *
FROM employees
WHERE first_name BETWEEN 'A' AND 'C'
ORDER BY first_name;

SELECT *
FROM employees
ORDER BY first_name;


--7 using the IN operator
SELECT *
FROM employees
WHERE salary IN (10000, 25000, 17000);      -- order is not important


--8 using the LIKE operator
-- It usualy comes with _ and %
-- % means zero or more characters
-- _ means one character

SELECT *
FROM employees
WHERE first_name LIKE 'S%';     -- all the first_name that starts with S

SELECT *
FROM employees
WHERE first_name LIKE '%s';     -- all the first_name that ends with s

SELECT *
FROM employees
WHERE first_name LIKE '%am%';   -- all the first_name that includes am

SELECT *
FROM employees
WHERE first_name LIKE '_d%';    -- all the first_name that has d in its second letter

SELECT *
FROM employees
WHERE first_name LIKE '__s%';   -- all the frist_name that has s in its third letter

-- now suppose there is a value in a column that contains _ or % (example job_id: ST_CLERK)
SELECT job_id
FROM jobs
WHERE job_id LIKE 'SA_%';

-- let's add a new job_id value called 'SAP cons'
SELECT job_id
FROM jobs
WHERE job_id LIKE 'SA_%';

-- this is the correct method
SELECT job_id
FROM jobs
WHERE job_id LIKE 'SA/_%' ESCAPE '/';       -- same as LIKE 'SA[_%' ESCAPE '['

-- another example: suppose we have a job_id called 'MANA%GER'
SELECT job_id
FROM jobs
WHERE job_id LIKE 'MAN/%%' ESCAPE '/';


--9 using the IS NULL operator
SELECT first_name, commission_pct
FROM employees;

SELECT *
FROM employees
WHERE commission_pct IS NULL;       -- this is different from commission_pct = ' '

SELECT *
FROM employees
WHERE commission_pct = NULL;        -- this is not correct


--10 using the NOT operator
-- NOT BETWEEN ... AND ..., NOT IN, NOT LIKE, IS NOT NULL
SELECT *
FROM employees
WHERE employee_id NOT IN (100, 101);

SELECT *
FROM employees
WHERE first_name NOT LIKE 'S%';     -- All the first_name that does not start with S

SELECT *
FROM employees
WHERE commission_pct IS NOT NULL;

-- the next 2 queries are the same
SELECT *
FROM employees
WHERE department_id <> 50;

SELECT *
FROM employees
WHERE department_id != 50;


--11 Defining conditions using the Logical operators (AND/OR/NOT)
-- AND requires both component conditions to be TRUE
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE salary >= 10000 
      AND department_id = 90;

-- OR requires either of component conditions to be TRUE
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE salary >= 10000 
      OR department_id = 90;

-- Using the AND operator twice
SELECT employee_id, last_name, job_id, salary, department_id
FROM employees
WHERE salary > 2000 
      AND department_id IN (60, 90) 
      AND commission_pct IS NULL;

-- Here, you should know the priorities
-- The AND operator has a priority over the OR operator
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = 'SA_REP'
      OR job_id = 'AD_PRES' AND salary > 15000;     -- this whole line is one set

-- This query below and the one above are the same
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = 'SA_REP'
      OR (job_id = 'AD_PRES' AND salary > 15000);   -- using parentheses

-- When you use parantheses (), you can override AND/OR priorities
SELECT last_name, job_id, salary
FROM employees
WHERE (job_id = 'SA_REP' OR job_id = 'AD_PRES')
      AND salary > 15000;

/*
Rules of Precedence for operators:
- 0: Parentheses ()
- 1: Arithmetic operators (+, -, *, /)
- 2: Concatenation operator (||)
- 3: Comparison conditions (=, >, >=, <, <=, <>, !=)
- 4: IS [NOT] NULL, [NOT] LIKE, [NOT] IN
- 5: [NOT] BETWEEN ... AND ...
- 6: [NOT] EQUAL TO
- 7: NOT logical operator
- 8: AND logical operator
- 9: OR logical operator
*/


--12 ORDER BY
SELECT *
FROM employees
ORDER BY hire_date;     -- default = ASC, ascending


--13 ASC: ascending
SELECT *
FROM employees
ORDER BY hire_date ASC;


--14 DESC: descending
SELECT *
FROM employees
ORDER BY hire_date DESC;


--15 WHERE and ORDER BY
SELECT *
FROM employees
WHERE department_id = 90
ORDER BY employee_id;


--16 NULL values in ORDER BY
SELECT *
FROM employees
ORDER BY commission_pct;        -- by default, NULL comes last in the ascending order

SELECT *
FROM employees
ORDER BY commission_pct DESC;   -- by default, NULL comes first in the descending order

-- you can use NULLS FIRST to make the NULL values appear first
SELECT *
FROM employees
ORDER BY commission_pct NULLS FIRST;


--17 you can also sort by the column Alias
SELECT first_name AS n
FROM employees
ORDER BY n;


--18 you can also sort by the Expression
SELECT employee_id, salary, salary + 100
FROM employees
ORDER BY salary + 100;


--19 you can sort by the column that is not in the SELECT statement
SELECT employee_id, salary
FROM employees
ORDER BY department_id;


--20 you can sort by more than one column
SELECT department_id, first_name, salary
FROM employees
ORDER BY department_id, first_name;     -- sort first by the department_id, then by the first_name

SELECT department_id, first_name, salary
FROM employees
ORDER BY department_id ASC, first_name DESC;


--21 you can sort by the column number in the SELECT statement
SELECT department_id, first_name, salary
FROM employees
ORDER BY 1;         -- 1 means the first column in the SELET statement, which is department_id

SELECT department_id, first_name, salary
FROM employees
ORDER BY 1, 3;


--22 the FETCH clause
SELECT employee_id, first_name
FROM employees
ORDER BY employee_id;       -- 107 rows

SELECT employee_id, first_name
FROM employees
ORDER BY employee_id
FETCH FIRST 5 ROWS ONLY;

SELECT employee_id, first_name
FROM employees
ORDER BY employee_id
FETCH FIRST 50 PERCENT ROWS ONLY;       -- Rounds up to the nearest integer (54 rows)

SELECT employee_id, first_name
FROM employees
ORDER BY employee_id
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;   -- Skips the first 5 rows

SELECT employee_id, first_name
FROM employees
ORDER BY employee_id
OFFSET 4 ROWS FETCH NEXT 50 PERCENT ROWS ONLY;  -- 50 percent of the whole table (54 rows), not after the OFFSET

-- how to deal with ties
SELECT employee_id, first_name, salary
FROM employees
ORDER BY salary DESC;

SELECT employee_id, first_name, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 2 ROWS ONLY;

SELECT employee_id, first_name, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 2 ROWS WITH TIES;


--23 Substitution Variables
/* 
Temporarily store values with & and &&.

Substitution variables can be used in:
- WHERE conditions
- ORDER BY clauses
- Column expressions
- Table names
- Entire SELECT statements
*/

SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &employee_num; -- defining a employee_num variable, which will be discarded after it is used

-- include '' for Varchar
SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE first_name = '&ename'
ORDER BY 2;

SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE first_name = &ename       -- put 'Name' as an answer
ORDER BY 2;

-- Exercise
-- &column_name = salary, &condition = salary > 1000, &order_column = employee_id
SELECT employee_id, last_name, job_id, &column_name
FROM employees
WHERE &condition
ORDER BY &order_column;


--24 the DEFINE and UNDEFINE command
-- DEFINE to create and assign a value to a variable
-- UNDEFINE to remove a variable
DEFINE employee_num = 200      -- this variable is valid only for this session

SELECT employee_id, last_name, salary, department_id
FROM employees
WHERE employee_id = &employee_num;

UNDEFINE employee_num;


-- Defining a variable using the ACCEPT command
ACCEPT dept_id PROMPT 'please enter dept_id'     -- must be executed together
SELECT * 
FROM employees
WHERE department_id = &dept_id;

UNDEFINE dep_id;

-- Using multiple ACCEPT commands
ACCEPT emp_from PROMPT 'please enter employee_from '    -- must be executed together
ACCEPT emp_to PROMPT 'please enter employee_to '
SELECT *
FROM employees
WHERE employee_id BETWEEN &emp_from AND &emp_to;


UNDEFINE emp_from
UNDEFINE emp_to;

-- Using && to define a variable, and assign and store a value at the same time
SELECT *
FROM departments
WHERE department_id = &&p;

UNDEFINE p;


SELECT employee_id, last_name, job_id, &&column_name
FROM employees
ORDER BY &column_name;      -- read the same value as &&column_name above

UNDEFINE column_name;


--25 using the VERIFY command
-- to toggle the display of the Substitution variable,
-- both before and after the SQL Developer replaces the substitution varaibles with values

SET VERIFY ON       -- must be executed together with the below statement
SELECT employee_id, last_name, salary
FROM employees
WHERE employee_id = &e_num;

-- using the SET DEFINE OFF;
SELECT *
FROM departments
WHERE department_name LIKE '%&t%';


SET DEFINE OFF
SELECT *
FROM departments
WHERE department_name LIKE '%&t%';

SET DEFINE ON