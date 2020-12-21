
/*
Using Conversion Functions and Conditional Expressions
- Understanding Implicit and Explicit data type conversion
- Using the TO_CHAR, TO_NUMBER and TO_DATE conversion functions
- Applying the NVL, NULLIF, and COALESCE functions to data
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


/*
There are two types of Conversion functions:

- Implicit data type conversion:
    done by Oracle
- Explicit data type conversion:
    done by a user, using conversion functions
*/


--1 Implicit data type conversion
/*
Expression:
VARCHAR2 or CHAR -> NUMBER
VARCHAR2 or CHAR -> DATE
*/
SELECT *
FROM Employees
WHERE employee_id = '100'
      OR hire_date = '05-09-21';
      
/*
Expression Evaluation:
NUMBER -> VARCHAR2 or CHAR
DATE -> VARCHAR2 or CHAR
*/
SELECT CONCAT(employee_id, first_name),
       CONCAT(hire_date, first_name)
FROM Employees;

-- Although Implicit data type coversion is available, it is recommended that
-- you do the Explicit data type conversion to ensure the reliability of your SQL statements.


--2 Explicit data type conversion
/*
Character -> TO_DATE -> Date -> TO_CHAR -> Character
Character -> TO_NUMBER -> Number -> TO_CHAR -> Character
*/


--2.1 TO_CHAR with Dates
/*
TO_CHAR(Date[, 'format_model'])

The format model:

- Must be enclosed with single quotation marks
- Is case-sensitive
- Can include any valid date format element
- Has an "fm" element to remove padded blanks or suppress leading zeros
- Is separated from the date value by a comma

Elements of the Date format model:

- yyyy: full year in numbers
- year: year spelled out
- mm: two-digit value for the month
- month: full name of the month
- mon: three-letter abbreviation of the month
- dy: three-letter abbreviation of the day of the week
- day: full name of the day of the week
- dd: numeric day of the month
*/

/*
Other formats:

- [/ . , - :]: punctuation is reproduced in the result
- "of the": quoted string is reproduced in the result

Specifying suffixes to influence number display:

- TH: ordinal number (for example, DDTH for 4TH)
- SP: spelled-out number (for example, DDSP for FOUR)
- SPTH or THSP: spelled-out ordinal numbers (for example, DDSPTH for FOURTH)
*/


/*
Elements of the Time format model:

- AM or PM: meridian indicator
- A.M. or P.M.: meridian indicator with periods
- HH or HH12: 12 hour format
- HH24: 24 hour format
- MI: minute (0-59)
- SS: second (0-59)
- SSSSS: seconds past midnight (0-86399)
*/

SELECT SYSDATE
FROM Dual;

SELECT TO_CHAR(SYSDATE, 'dd.mm.yyyy')
FROM Dual;

SELECT TO_CHAR(SYSDATE, 'dd-mm-yyyy hh:mi:ss AM') -- AM and PM are the same
FROM Dual;

SELECT TO_CHAR(SYSDATE, 'dd-mm-yyyy hh24:mi:ss PM')
FROM Dual;

SELECT first_name, hire_date, 
       TO_CHAR(hire_date, 'dd month yyyy') AS hiredate1,
       TO_CHAR(hire_date, 'fmdd yyyy') AS hiredate2 -- remove 0 in days
FROM Employees;

SELECT TO_CHAR(SYSDATE, 'fmdd "of" month yyyy')
FROM Dual;

SELECT TO_CHAR(SYSDATE, 'fmddsp "of" month yyyy') -- spell out the day number
FROM Dual;

SELECT TO_CHAR(SYSDATE, 'fmddth "of" month yyyy') -- add "th" to the day
FROM Dual;

SELECT TO_CHAR(SYSDATE, 'fmddspth "of" month yyyy') -- spell out and add 'th' to the day
FROM Dual;

-- list all the employees who were employed in 2003
SELECT *
FROM Employees
WHERE TO_CHAR(hire_date, 'yyyy') = '2003';

-- list all the employees who were employed in Feb
SELECT *
FROM Employees
WHERE TO_CHAR(hire_date, 'mm') = '02';      -- '2' is not correct

SELECT *
FROM Employees
WHERE TO_CHAR(hire_date, 'fmmm') = 2;


--2.2 TO_CHAR with Numbers
-- TO_CHAR(number[, 'format_model'])

/*
Elements of the Numbers format model:

- 9: represents a number                        999999 -> 1234
- 0: forces a zero to be displayed              099999 -> 001234
- $: places a floating dollar sign              $999999 -> $1234
- L: uses the floating local currency symbol    L999999 -> FF1234
- .: prints a decimal point                     999999.99 -> 1234.00
- ,: prints a comma as a thousands indicator    999,999 -> 1,234

Also:

- D: returns the decimal character in the specified position    9999D99 -> 1234.00
- G: returns the group seperator in the specified position      9G999 -> 1,234
- MI: minus signs to the right (negative values)                999999MI -> 1234-
- PR: parenthesizes negative numbers                            999999PR -> <1234>
- EEEE: scientific notation (format must specify four Es)       99.999EEEE -> 1.234E + 03
- U: returns the "Euro" dual currency in the specified position U9999   -> ¢æ1234
- V: multiplies by 10 "n" times (n = number of 9s after V)      9999V99 -> 123400
- S: returns a negative or positive value                       S9999 -> -1234 or +1234
- B: dispalys zero values as blanks, not 0                      B9999.99 -> 1234.00
*/

SELECT TO_CHAR(1598) 
FROM Dual;

SELECT TO_CHAR(1598, '9999')
FROM Dual;

SELECT TO_CHAR(1598, '99999')
FROM Dual;

SELECT TO_CHAR(1598, '9,999')
FROM Dual;

SELECT TO_CHAR(1598, '$9,999')
FROM Dual;

SELECT TO_CHAR(1598, '$9G999')
FROM Dual;

------------------------------

SELECT TO_CHAR(1598.87)
FROM Dual;

SELECT TO_CHAR(1598.87, '9999')
FROM Dual;

SELECT TO_CHAR(1598.87, '9,999.99')
FROM Dual;

SELECT TO_CHAR(1598.87, '$9,999.99')
FROM Dual;

SELECT TO_CHAR(1598.87, '$9G999D99')
FROM Dual;

SELECT TO_CHAR(1598.87, '9999.9')
FROM Dual;

------------------------------

SELECT TO_CHAR(1598, '99')      -- it will fail
FROM Dual;

SELECT TO_CHAR(1598, '0000')    -- it will deal zero like 9
FROM Dual;

SELECT TO_CHAR(1598, '00000')
FROM Dual;

SELECT TO_CHAR(1598, '00000000')
FROM Dual;

SELECT TO_CHAR(1598, '0999')
FROM Dual;

SELECT TO_CHAR(1598, '00999')
FROM Dual;

SELECT TO_CHAR(1598, '9G999G999')
FROM Dual;

SELECT TO_CHAR(-1598, '9999')
FROM Dual;

SELECT TO_CHAR(-1598, '9999mi')     -- minus sign to the right
FROM Dual;

SELECT TO_CHAR(1598, '9999PR')
FROM Dual;

SELECT TO_CHAR(-1598, '9999PR')     -- parenthesize negative numbers
FROM Dual;

SELECT TO_CHAR(1598, '999,999,999')
FROM Dual;

SELECT TO_CHAR(1598, 'FM999,999,999')
FROM Dual;

-- white space
SELECT TO_CHAR(7, '9')      -- there is a space before 7
FROM Dual;

SELECT TO_CHAR(7, 'fm9')    -- removes the space
FROM Dual;

SELECT TO_CHAR(-7, '9')     -- no space
FROM Dual;

SELECT LENGTH('-7')
FROM Dual;


--2.3 TO_DATE
-- cannot convert 'ABC' to date
SELECT TO_DATE('10-11-2015', 'dd-mm-yyyy')
FROM Dual;

SELECT TO_DATE('10.11.2015', 'dd.mm.yyyy')
FROM Dual;

SELECT TO_DATE('10.november.2015', 'dd.month.yyyy')
FROM Dual;

SELECT *
FROM Employees
WHERE hire_date > TO_DATE('10-11-2003', 'dd-mm-yyyy');

SELECT *
FROM Employees
WHERE hire_date > TO_DATE('10-11-       2003', 'dd-mm-yyyy');       -- Oracle removes the space


SELECT *
FROM Employees
WHERE hire_date > TO_DATE('10-11-   2003', 'fzdd-mm-yyyy');         -- if you put "fx", then exact match should be made

-- RR and YY
-- rr format
-- in general, if the value is between 50-99, it will return a 19xx year
-- between 0-49 will return a 20xx year

SELECT TO_DATE('1-1-85', 'dd-mm-rr')
FROM Dual;

SELECT TO_CHAR(TO_DATE('1-1-85', 'dd-mm-rr'), 'yyyy')
FROM Dual;

SELECT TO_DATE('1-1-85', 'dd-mm-yy')
FROM Dual;

SELECT TO_CHAR(TO_DATE('1-1-85', 'dd-mm-yy'), 'yyyy')
FROM Dual;


--2.4 TO_NUMBER
-- cannot convert 'ABC' to number


--3 General functions

-- NVL(expr1, expr2)
-- converts a NULL value to an actual value
SELECT employee_id, first_name, commission_pct, 
       NVL(commission_pct, 0)
FROM Employees;

SELECT employee_id, first_name, job_id,
       NVL(job_id, 'No Job Yet')
FROM Employees;

SELECT employee_id, first_name, hire_date,
       NVL(hire_date, '03-01-01')
FROM Employees;

SELECT employee_id, first_name, commission_pct,
       NVL(TO_CHAR(commission_pct), 'no comm') 
FROM Employees;


-- NVL2(expr1, expr2, expr3)
-- If "expr1" is not NULL, it returns "expr2". 
-- If "expr1" is NULL, it returns "expr3"
SELECT employee_id, first_name, commission_pct,
       NVL2(commission_pct, commission_pct, 0)
FROM Employees;

SELECT employee_id, first_name, commission_pct,
       NVL2(commission_pct, 'sal and comm', 'only salary') AS income
FROM Employees;

-- NULLIF(expr1, expr2)
-- compares two expressions and returns NULL if they are equal
-- returns the "expr1" if they are not equal
SELECT first_name, LENGTH(first_name), last_name, LENGTH(last_name),
       NULLIF(LENGTH(first_name), LENGTH(last_name)) AS results
FROM Employees;


-- COALESCE(expr1, expr2, ..., exprn)
-- returns the first non-NULL expression in the list
SELECT employee_id, first_name, commission_pct, manager_id, salary,
       COALESCE(commission_pct, manager_id, salary),
       NVL(NVL(commission_pct, manager_id), salary)
FROM Employees;


--4 Conditional Expressions
/*
- provide the use of the IF, THEN, ELSE logic within a SQL statement
- use two methods:
    CASE expression: complies with the ANSI SQL (more flexible)
    DECODE function: specific to the Oracle syntax
*/


--4.1 CASE function
/*
CASE expr WHEN comparison_expr1 THEN return_expr1
         [WHEN comparison_expr2 THEN return_expr2]
         [WHEN comparison_exprn THEN return_exprn]
         [ELSE else_expr]
END alias
*/
    
SELECT first_name, job_id, salary,
       CASE job_id WHEN 'IT_PROG' THEN salary * 1.10
                   WHEN 'ST_CLERK' THEN salary * 1.15
                   WHEN 'SA_REP' THEN salary * 1.20
       ELSE salary
       END "REVISED_SALARY"
FROM Employees;

-- you can make the condition after WHEN
SELECT first_name, job_id, salary,
       CASE WHEN job_id = 'IT_PROG' THEN salary * 1.10
            WHEN job_id = 'ST_CLERK' THEN salary * 1.15
            WHEN job_id = 'SA_REP' THEN salary * 1.20
       ELSE salary
       END "REVISED_SALARY"
FROM Employees;

-- if you don't put ELSE, then NULL will appear for that condition
SELECT first_name, job_id, salary,
       CASE job_id WHEN 'IT_PROG' THEN salary * 1.10
                   WHEN 'ST_CLERK' THEN salary * 1.15
                   WHEN 'SA_REP' THEN salary * 1.20
       END REVISED_SALARY
FROM Employees;

-- correct order
SELECT salary,
       CASE WHEN salary > 10000 THEN 'salary > 10000'
            WHEN salary > 4000 THEN 'salary > 4000'
            WHEN salary > 3000 THEN 'salary > 3000'
       END FFF
FROM Employees;

-- wrong order
SELECT salary,
       CASE WHEN salary > 3000 THEN 'salary > 3000'
            WHEN salary > 4000 THEN 'salary > 4000'
            WHEN salary > 10000 THEN 'salary > 10000'
       END FFF
FROM Employees;


--4.2 DECODE function
/*
DECODE(col|expression, search1, result1
                      [search2, result2, ..., ]
                      [, defualt])
*/

SELECT last_name, job_id, salary,
       DECODE(job_id, 'IT_PROG', salary * 1.10,
                      'ST_CLERK', salary * 1.15,
                      'SA_REP', salary * 1.20,
              salary)
              "REVISED_SALARY"
FROM Employees;

-- without the ELSE statement
SELECT last_name, job_id, salary,
       DECODE(job_id, 'IT_PROG', salary * 1.10,
                      'ST_CLERK', salary * 1.15,
                      'SA_REP', salary * 1.20
              )
              "REVISED_SALARY"
FROM Employees;

-- Example
/*
If salary < 3000 then tax = 0%
If 3000 <= salary <= 7000 then tax = 10%
If 7000 < salary then tax = 20%
*/

SELECT employee_id, first_name, salary,
       CASE WHEN salary < 3000 THEN '0%'
            WHEN salary BETWEEN 3000 AND 7000 THEN '10%'
            WHEN salary > 7000 THEN '20%'
       END tax
FROM Employees;