
-- Keywords:
    --1 Statement
        SELECT 
    --2 Clause
        WHERE, ORDER BY, FETCH, HAVING, TOP, GROUP BY


-- Operator:
    --0 parentheses 
        ()
    --1 Arithmetic 
        +, -, *, /
    --2 Concatenation
        ||
    --3 Comparison
        =, >, >=, <, <=, <>, !=
    --4
        IS NULL, LIKE, IN (NOT)
    --5
        BETWEEN ... AND ... (NOT)
    --6
        EQUAL TO
    --7 Logical
        NOT
    --8
        AND
    --9
        OR


DESCRIBE Table1
DESC Table1


-- Subsitution Variable
DEFINE   var1.name1
ACCEPT   var1.name1 PROMPT ''
    
UNDEFINE var1.name1
    
SET VERIFY ON/OFF
SET DEFINE OFF/ON
  

-- Return the number of rows (records)
SELECT count(*)/count(1)    


-- general SELECT statement
SELECT     [DISTINCT] *, column1 [||] column2 [AS] alias
FROM       Table1                                        -------------------------- NOT ---------------------------
WHERE      column1 [=, >, <, != (&var_name, &&var_name), BETWEEN ... AND ..., IN(), LIKE '_%' (ESCAPE '/'), IS NULL] 
           (subquery) SELECT(...)
           [AND, OR]
[GROUP BY] column1
[HAVING]   GROUP_FUNCTION() + condition
ORDER BY   column1/alias/index/expression [ASC, DESC, NULLS FIRST], column2
[OFFSET    row_num ROWS] FETCH FIRST row_num [PERCENT] ROWS ONLY/WITH TIES
                         [FETCH NEXT]

UNION/UNION ALL/INTERSECT/MINUS

-- 2: Retrieving Data using the SQL SELECT Statement

    SELECT   *
    FROM     Table1

-- 3: Restricting and Sorting Data
    
    --1 WHERE clause
        WHERE  column1 = 'Character';    -- case sensitive, != 'character'
        WHERE  column1 = 'date-for-mat'; -- year, yyyy, yy, month, mm, mon, day, dy, dd
         
        -- Comparison  Operators
    
            WHERE  column1 =, >, >=, <, <=, <>, != value1;
        
            BETWEEN ... AND ...             -- ... values are inclusive
                --
                WHERE  column1 BETWEEN value1 AND value2;
                WHERE  column1 BETWEEN 'char1' AND 'char2';
            
            IN 
                -- 
                WHERE  column1 IN(value1, value2, NULL); -- NULL will be ignored
                WHERE  column1 NOT IN(NULL); -- same as != ALL (returns nothing)
           
            LIKE
                --
                WHERE  column1 LIKE 's%';   -- starts with s
                                    '%s';   -- ends with s
                                    '%s%';  -- includes s
                                    '_s';   -- has s in its second letter
                                    '__s';  -- has s in its third letter
                               LIKE 's/_%' ESCAPE '/'; -- means starts with s_
                               LIKE 's[%%' ESCAPE '['; -- means starts with s%
            IS NULL
                --
                WHERE  column1 IS NULL;     -- different from WHERE column1 = ''
        
        -- Logical operators
            -- NOT
            NOT BETWEEN ... AND..., NOT IN, NOT LIKE, IS NOT NULL
        
            -- AND
            WHERE  column1 = value1
                   AND column2 = value2;
        
            -- OR
            WHERE  column1 = value1
                   OR column2 = value2;
               
            -- AND > OR
            WHERE  column1 = value1 
                   OR column1 = value2 AND column2 = value3;

    --2 ORDER BY clause
    
        SELECT   *
        FROM     Table1
        [WHERE]  column1 = value1
        ORDER BY column1/alias/index/expression [ASC, DESC], column2; -- default = ASC, ascending
        
        -- NULL values
            -- by default, NULL comes last in ASC (can change by NULLS FIRST)
            -- by default, NULL comes first in DESC
            ORDER BY column1 [NULLS FIRST];
    
    --3 FETCH clause
    
        SELECT   column1, column2
        FROM     Table1
        ORDER BY column1
        FETCH FIRST row_num [PERCENT] ROWS ONLY/WITH TIES;
        
        -- to skip the first n rows
        OFFSET row_num ROWS FETCH NEXT row_num ROWS ONLY/WITH TIES;
    
        
-- 4: Single-Row Functions (that can be applied to SELECT, WHERE, ORDER BY)

    --1 Character
        -- case conversion function
            UPPER/LOWER/INITCAP(column1)
        -- character manipulation function
            CONCAT(column1, column2) 
            SUBSTR(column1, index, char.length) 
            LENGTH(column1)
            INSTR(column1, 'letter', index, nth occurrence) 
            LPAD/RPAD(column1, char.length, 'symbol')
            REPLACE(column1, 'letter', 'replacement') 
            TRIM([BOTH/LEADING/TRAILING] 'letter' FROM 'string')

    --2 Numeric
        ROUND/TRUNC(number1 [, decimal_place]) 
        MOD(number1, dividing_number)

    --3 Date
        SYSDATE
        MONTHS_BETWEEN(date_column1, date_column2)
        ADD_MONTHS(date_column1, number)
        NEXT_DAY(date_column1, 'date'/1...7)
        LAST_DAY(date_column1)
        ROUND/TRUNC(date_column1, 'month'/'year')
    
    --4 Conversion Functions
        TO_CHAR(date_column1, 'date_format')        -- yyyy, year, mm, month, mon, dy, day, dd
        TO_CHAR(number_column1, 'number_format')    -- 9, 0, $, L, ., ,
        TO_DATE(character_column1, 'date_format')
        TO_NUMBER
        
    --5 General
        NVL(column1, 'value')
        NVL2(column1, column2, column3, ...)
        NULLIF(column1, column2)
        COALESCE(column1, column2, ..., columnN)
        
        
-- 5: Conditional Expressions

    --1 CASE expression (ANSI SQL)
        SELECT  column1, column2
                CASE column1 WHEN 'value1' THEN operation1
                             WHEN 'value2' THEN operation2
                             WHEN 'value3' THEN opeartion3
                [ELSE operation4]
                END  alias
        FROM    Table1
    
    --2 DECODE expression (Oracle syntax)
        SELECT  column1, column2
                DECODE(column1, 'value1', operation1,
                                'value2', operation2,
                                'value3', opeartion3,
                      [operation4]
                      )
                      alias
        FROM    Table1;


-- 6: Multiple-Row functions [= Group Functions] (that is placed after SELECT)

    SELECT     COUNT/AVG/MAX/MIN/SUM([DISTINCT/ALL] column1) -- group function
    FROM       Table1
    GROUP BY   column1
    [HAVING]   GROUP_FUNCTION() + condition                  -- act as WHERE for GROUP BY
    [ORDER BY] column1
   
    LISTAGG(column1, ', ') 
    WITHIN GROUP(ORDER BY column1) alias
    

-- 7: Displaying Data from Multiple Tables (using Joins)

    --1 Cartesian Product
            Outcome: table1_rows X table2_rows
    
    --2 Equijoin
            FROM  Table1,             Table2
            WHERE Table1.column1    = Table2.column1
        
        -- OR
            FROM  Table1              JOIN Table2
                  ON table1.column1 = table2.column1
    
    --3 Non Equijoin
            FROM  Table1,             Table2
            WHERE Table1.column1      BETWEEN Table2.column2 AND Table2.column3
        
        -- OR
            FROM  Table1              JOIN Table2
                  ON Table1.column1   BETWEEN Table2.column2 AND Table2.column3
    
    --4 Outer Join
        -- Left Outer Join
            FROM  Table1,             Table2
            WHERE Table1.column1    = Table2.column1(+)
            
            -- OR
            FROM Table1               LEFT OUTER JOIN Table2
                 ON Table1.column1  = Table2.column1
        
        -- Right Outer Join
            FROM  Table1,             Table2
            WHERE Table1.column1(+) = Table2.column1
            
            -- OR
            FROM Table1               RIGHT OUTER JOIN Table2
                 ON Table1.column1  = Table2.column1
                 
        -- Full Outer Join
            FROM Table1               FULL OUTER JOIN Table2
                 ON Table1.column1  = Table2.column1
        
    --5 Self Join
            FROM  Table1 alias1,     Table1 alias.2
            WHERE alias.1.column3   = alias.2.column1
            
            -- OR
            FROM Table1 alias.1       JOIN Table1 alias.2
                 ON alias.1.column3 = alias.2.column1


-- 8: Using Subqueries to Solve Queries
    -- if the Subquery returns nothing, 
    -- the whole SELECT statement will not return anything

    --1 a Single-Row Subquery (must return a single value)
        SELECT   *
        FROM     Table1
        WHERE    column1 > (SELECT   column1
                            FROM     Table1
                            WHERE    column2 = value1);
    
        -- with a Multiple-Row function                    
        SELECT   *
        FROM     Table1
        WHERE    column1 = (SELECT   MAX(salary)
                            FROM     Table2);
                        
        -- with HAVING
        SELECT   column1, COUNT(column2)
        FROM     Table1
        GROUP BY column1
        HAVING   COUNT(column2) > (SELECT   COUNT(*)
                                   FROM     Table1
                                   WHERE    column1 = value1)
        ORDER BY column2;
    
    --2 a Multiple-Row Subquery (returns more than one value)
        -- uses multiple-row Comparison Operators (IN, ANY, ALL)
        
        SELECT   column1, column2, column3
        FROM     Table1
        WHERE    column1 IN(SELECT   column1
                            FROM     Table1
                            WHERE    column2 = value1);
                            
        SELECT   column1, column2, column3
        FROM     Table1
        WHERE    column1 < ANY/ALL(SELECT   column1
                                   FROM     Table1
                                   WHERE    column2 = value1);
    
-- 9: Using the Set Operators



-- 99: Questions
    --3 Restricting and Sorting Data
        -- LIKE operator
            -- Does the value in column1 that starts with s 
            -- will be included in the following result?
            WHERE  column1 LIKE '%s%';  -- includes s
        