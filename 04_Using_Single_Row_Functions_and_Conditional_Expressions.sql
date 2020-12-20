
/*
Using Single-Row Functions to Customize Output
- Manipulating strings with character functions in SQL SELECT and WHERE clauses
- Manipulating numbers with the ROUND, TRUNC and MOD functions
- Performing arithmetic with Date data
- Manipulating dates with the Date function
- Nesting multiple functions
*/

/*
A Function is a subprogram that takes an input (argument) and return a value

Functions are very powerful feature of SQL. They can do:

- Perform calculations on data
- Modify individual data items
- Manipulate output for groups of rows
- Format dates and numbers for display
- Convert column data types

SQL functions "sometimes" take arguments and "always" return a value
*/

/*
Two types of SQL functions:

- Single-Row functions: return one result per row
- Multiple-Row functions: return one result per set of rows
*/

/*
Single-row functions:

- Manipulate data items
- Accept arguments and return one value
- Act on each row that is returned
- Reutrn one result per row
- May modify the data type
- Can be nested
- Accept arguments that can be a column or an expression

function_name [(arg1, arg2, ...)]
*/

/*
Single-row functions have five categories:

- Character: 
    (case-conversion functions) LOWER, UPPER, INITCAP
    (character-manipulation) CONCAT, SUBSTR, LENGTH, INSTR, LPAD, RPAD, TRIM, REPLACE
- Number: 
    ROUND, TRUNC, MOD
- Date:
    MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, ROUND, TRUNC
- Conversion:
    TO_DATE, TO_CHAR
- General:
    NVL, NVL2, NULLIF, COALESCE, DECODE, CASE
*/


--1 Character function

/*
- LOWER(column/expression):
    Converts alpha character values to lowercase
- UPPER(column/expression):
    Converts alpha character values to uppercase
- INITCAP(column/expression):
    Converts alpha character values to uppercase for the first letter of each word.
    All other letters in lower case
*/


-- case converstion functions (UPPER, LOWER, INITCAP)
SELECT employee_id, first_name, UPPER(first_name), LOWER(first_name), INITCAP(first_name)
FROM employees;

-- Single row function can be used in SELECT, WHERE and ORDER BY

SELECT employee_id, first_name, UPPER(first_name), LOWER(first_name), INITCAP(first_name)
FROM employees
WHERE UPPER(first_name) = 'PATRICK';

SELECT employee_id, first_name, UPPER(first_name), LOWER(first_name), INITCAP(first_name)
FROM employees
WHERE UPPER(first_name) = UPPER('patrick')
ORDER BY UPPER(first_name);


-- character manipulation function
/*
- CONCAT(column1/expression1, column2/expression2):
    Concatenates the first character value to the second character value.
    Equivalent to concatenation operator (||)
- SUBSTR(column/expression, m[, n]):
    Returns specified characters from character value starting at character position
    "m" for "n" characters long.
    If "m" is negative, the count starts from the end of the character value.
    If "n" is ommited, all characters to the end of the string are returned.
- LENGTH(column/expression):
    Returns the number of characters in the expression
- INSTR(column/expression, 'string', [,m], [n]):
    Returns the numeric position of a named string.
    Optionally, you can provide a position "m" to start searching,
    and the occurence "n" of the string. 
    "m" and "n" are default to 1, meaning it starts the search at the beginning
    of the string and reports the first occurrence.
- LPAD(column/expression, n, 'string'):
    Returns an expression left-padded to length of "n" characters with a character expression
- RPAD(column/expression, n, 'string'):
    Returns an expression right-padded to length of "n" characters with a character expression.
- TRIM(leading/trailing/both, trim_character FROM trim_source):
    Enables you to trim leading or trailing characters (or both) from a character string.
    If trim_character or trim_source is a character literal, you must enclose it in single quotation marks.
    This is a feature that is available in Oracle 8i or later versions.
- REPLACE(text, search_string, replacement_string):
    Searches a text expression for a character string and, if found, replaces it
    with a specified replacement string
*/


-- CONCAT function
SELECT employee_id, first_name, last_name, CONCAT(first_name, last_name)
FROM employees;

-- the CONCAT function can only take two arguments, whereas || can take multiple
SELECT employee_id, first_name, last_name, first_name || ' ' || last_name || salary name
FROM employees;


-- SUBSTR function
-- SUBSTR(column|expression, m, n)
-- "m" is the starting position, and "n" is the number of characters to be returned
SELECT employee_id, first_name, 
       SUBSTR(first_name, 1, 3),        -- from the first index, print 3 characters
       SUBSTR(first_name, 2, 4),        -- from the second index, print 4 characters
       SUBSTR(first_name, 2),           -- from the second index, print the rest
       SUBSTR(first_name, -3)           -- print last 3 characters
FROM employees;


-- LENGTH function
SELECT first_name, LENGTH(first_name)
FROM employees;


-- INSTR function
/*
INSTR(column|expression, m, n)
"m" is the starting position to search, and "n" is the nth occurrence 
1 is the default for "m" and "n"
*/
SELECT first_name,
       INSTR(first_name, 'e'),
       INSTR(first_name, 'e', 2),
       INSTR(first_name, 'e', 5),
       INSTR(first_name, 'e', 1, 2)
FROM employees
WHERE first_name = 'Nanette';


-- LPAD and RPAD
SELECT employee_id, first_name, salary, 
       LPAD(salary, 10, '#'),
       RPAD(salary, 10, '*')
FROM employees;


-- REPLACE function
SELECT employee_id, first_name, 
       REPLACE(first_name, 'a', '*'),
       REPLACE(first_name, 'en', '#')
FROM employees;


-- TRIM function
-- "dual" is a public table that you can use to view results from functions and calculations
SELECT *
FROM Dual;
-- it is a table containing one column and one dummy value x

SELECT 1 + 1 + 3
FROM Dual;

SELECT 1 + 5 
FROM Employees;     -- the number of results equals to the number of records in the table


-- TRIM([BOTH/LEADING/TRAILING] 'letter' FROM 'string')
SELECT TRIM (' ' FROM ' tim yang ') V 
FROM Dual;

-- the above is equal to
SELECT TRIM(BOTH ' ' FROM ' tim yang ') V
FROM Dual;

SELECT TRIM (LEADING ' ' FROM ' tim yang ') V
FROM Dual;

SELECT TRIM (TRAILING ' ' FROM ' tim yang ') V
FROM Dual;

SELECT TRIM ('k' FROM 'khaled khudari') V
FROM Dual;

SELECT TRIM (' tim yang ' ) V
FROM Dual;


--2 Numeric functions
/*
ROUND: Rounds a value to a specified decimal
    ROUND(45.926, 2) -> 45.93
TRUNC: Truncates value to a specified decimal
    TRUNC(45.926, 2) -> 45.92
MOD: Returns a remainder of a division
    MOD(1600, 300) -> 100
*/

SELECT ROUND(10.5)      -- if you dont specify the decimal place, 
FROM Dual;              -- it will round to the nearest integer

SELECT ROUND(150.49)
FROM Dual;

SELECT ROUND(10.48, 1)
FROM Dual;

SELECT ROUND(10.499, 1)
FROM Dual;

SELECT ROUND(10.499, 2)
FROM Dual;

SELECT ROUND(10.493, 2)
FROM Dual;

SELECT ROUND(55.993, 1)
FROM Dual;

SELECT ROUND(55.993, 0)
FROM Dual;

SELECT ROUND(55.993, -1)
FROM Dual;

SELECT ROUND(55.493, -2)
FROM Dual;

SELECT ROUND(555.493, -2)
FROM Dual;

SELECT ROUND(570.493, -3)
FROM Dual;


-- TRUNC function
SELECT TRUNC(10.6565)
FROM Dual;

SELECT TRUNC(10.6565, 2)
FROM Dual;

SELECT TRUNC(998.6565, -2)
FROM Dual;

SELECT TRUNC(9988.6565, -2)
FROM Dual;

SELECT TRUNC(998.993, -3)
FROM Dual;


-- MOD function
SELECT MOD(15, 2) 
FROM Dual;

SELECT MOD(15, 3) 
FROM Dual;

-- the MOD function is often used to check if a number is even or odd
SELECT MOD(100, 2) 
FROM Dual;

SELECT MOD(101, 2) 
FROM Dual;


--3 Date functions
-- Century, Year, Month, Day, Hours, Minutes, Seconds
-- The default date display format is DD-MON-YY
SELECT last_name, hire_date
FROM Employees
WHERE hire_date < '08-02-01';       -- 'YY-MM-DD'

SELECT first_name, hire_date
FROM Employees;

-- In general, if the value of the year is between 50-99, it returns a 19xx year
-- If the value of the year is between 00-49, it returns a 20xx year


-- SYSDATE
-- returns the current database server date and time
SELECT SYSDATE
FROM Dual;

/* 
Arithmetic with Dates
- Add or subtract a number from a date for a resultant date value
- Subtract two dates to find the number of days between those dates
- Add hours to a date by dividing the number of hours by 24

date + number: date
    Adds a number of days to a date
date - number: date
    Subtracts a number of days from a date
date - date: number of days
    Finds the number of days between two dates
date + number/24: date
    Adds a number of hours to a date
*/

-- date + number = date
SELECT SYSDATE, SYSDATE + 3
FROM Dual;

-- date - number = date
SELECT SYSDATE, SYSDATE - 3
FROM Dual;

-- date - date = the number of days between two dates
SELECT employee_id, SYSDATE, hire_date, SYSDATE - hire_date, ROUND(SYSDATE - hire_date)
FROM Employees;

-- date + number/24 = adding the number of hours to a date
SELECT SYSDATE + 5/24
FROM Dual;

-- Example: I need to know how many weeks an employee 'Adam' has worked as of now
SELECT employee_id, first_name,
       SYSDATE - hire_date "number of days", 
       (SYSDATE - hire_date) / 7 "number of weeks"
FROM Employees;


-- MOTHS_BETWEEN
SELECT employee_id, first_name,
       MONTHS_BETWEEN(SYSDATE, hire_date),
       (SYSDATE - hire_date) / 30
FROM Employees;

-- If the first date is earlier than the second date, it will return a negative value
SELECT employee_id, first_name,
       MONTHS_BETWEEN(hire_date, SYSDATE)
FROM Employees;


-- ADD_MONTHS
SELECT employee_id, first_name, hire_date, ADD_MONTHS(hire_date, 4)
FROM Employees;

SELECT employee_id, first_name, hire_date, ADD_MONTHS(hire_date, -2)
FROM Employees;


-- NEXT_DAY
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY')
FROM Dual;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 1)        -- 1 = 'Sunday', 2 = 'Monday', ... , 7 = 'Saturday'
FROM Dual;


-- LAST_DAY
-- picks the last day of the month
SELECT LAST_DAY(SYSDATE)
FROM Dual;

-- Example
/*
Display the employee_number, first_name, hire_date, "number of months employeed",
"six month review date", "first Friday after the hire_date"
for all employees who have been employeed for fewer than 150 months
*/
SELECT employee_id, first_name, hire_date,
       MONTHS_BETWEEN(SYSDATE, hire_date),
       ADD_MONTHS(hire_date, 6),
       NEXT_DAY(hire_date, 6)
FROM Employees
WHERE MONTHS_BETWEEN(SYSDATE, hire_date) < 155;


-- ROUND 
/*
If the format model is MONTH, dates 1-15 results in the first day of the current month.
Dates 1-16 results in the first day of the next month

If the format model is YEAR, months 1-6 results in January 1st of the current year.
Months 7-12 results in January 1 of the next year.
*/

ROUND(SYSDATE, 'MONTH');
ROUND(SYSDATE, 'YEAR');


-- TRUNC
TRUNC(SYSDATE, 'MONTH');
TRUNC(SYSDATE, 'YEAR');

-- Examples
SELECT employee_id, first_name, hire_date,
       ROUND(hire_date, 'MONTH'),
       TRUNC(hire_date, 'MONTH')
FROM Employees
ORDER BY hire_date;

SELECT employee_id, first_name, hire_date,
       ROUND(hire_date, 'YEAR'),
       TRUNC(hire_date, 'YEAR')
FROM Employees
ORDER BY hire_date;


-- Nesting Functions
/*
Single-row functions can be nested to any level.
Nested functions are evaluated from the deepest level to the least deep level.
*/

SELECT first_name, UPPER(first_name), SUBSTR(UPPER(first_name), 1, 3),
       LPAD(SUBSTR(UPPER(first_name), 1, 3), 10, '*')
FROM Employees;

SELECT 'ahmed ali naser' full_name,
       SUBSTR('ahmed ali naser', 1, (INSTR('ahmed ali naser', ' ', 1, 1) - 1)) first_name,
       SUBSTR('ahmed ali naser', INSTR('ahmed ali naser', ' ', 1, 1) + 1,
            INSTR('ahmed ali naser', ' ', 1, 2) - 1 
          - INSTR('ahmed ali naser', ' ', 1, 1)) middle_name,
       SUBSTR('ahmed ali naser', INSTR('ahmed ali naser', ' ', 1, 2) + 1) last_name
FROM Dual;