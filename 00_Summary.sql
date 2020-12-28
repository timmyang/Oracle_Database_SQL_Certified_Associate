
-- Keywords:
    --1 Statement
        SELECT 
    --2 Clause
        WHERE, ORDER BY, FETCH, HAVING, TOP, GROUP BY

-- Operator:
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
    --7
        NOT
    --8
        AND
    --9
        OR


DESCRIBE table1
DESC table1


-- Subsitution Variable
DEFINE   var1.name1
ACCEPT   var1.name1 PROMPT ''
    
UNDEFINE var1.name1
    
SET VERIFY ON/OFF
SET DEFINE OFF/ON
  

-- Return the number of rows (records)
SELECT count(*)/count(1)    


-- general SELECT statement
SELECT   [DISTINCT] *, column1 [||] column2 [AS] alias
FROM     table1                                        -------------------------- NOT ---------------------------
WHERE    column1 [=, >, <, != (&var_name, &&var_name), BETWEEN ... AND ..., IN(), LIKE '_%' (ESCAPE) '/', IS NULL] 
         (subquery)
         [AND, OR]
GROUP BY column1
HAVING   GROUP_FUNCTION() + condition
ORDER BY column1/alias/index [ASC, DESC, NULLS FIRST], column2
[OFFSET  row_num ROWS] FETCH FIRST row_num [PERCENT] ROWS ONLY/WITH TIES
                       [FETCH NEXT]


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
        FROM    table1
    
    --2 DECODE expression (Oracle syntax)
        SELECT  column1, column2
                DECODE(column1, 'value1', operation1,
                                'value2', operation2,
                                'value3', opeartion3,
                      [operation4]
                      )
                      alias
        FROM    table1;


-- 6: Multiple-Row functions [= Group Functions] (that is placed after SELECT)

    SELECT     COUNT/AVG/MAX/MIN/SUM([DISTINCT/ALL] column1) -- group function
    FROM       table1
    GROUP BY   column1
    [HAVING]   GROUP_FUNCTION() + condition                  -- act as WHERE for GROUP BY
    [ORDER BY] column1
   
    LISTAGG(column1, ', ') 
    WITHIN GROUP(ORDER BY column1) alias
    

-- 7: Displaying Data from Multiple Tables (using Joins)

    --1 Cartesian Product
            Outcome: table1_rows X table2_rows
    
    --2 Equijoin
            FROM  table1,             table2
            WHERE table1.column1    = table2.column1
        
        -- OR
            FROM  table1              JOIN table2
                  ON table1.column1 = table2.column1
    
    --3 Non Equijoin
            FROM  table1,             table2
            WHERE table1.column1      BETWEEN table2.column2 AND table2.column3
        
        -- OR
            FROM  table1              JOIN table2
                  ON table1.column1   BETWEEN table2.column2 AND table2.column3
    
    --4 Outer Join
        -- Left Outer Join
            FROM  table1,             table2
            WHERE table1.column1    = table2.column1(+)
            
            -- OR
            FROM table1               LEFT OUTER JOIN table2
                 ON table1.column1  = table2.column1
        
        -- Right Outer Join
            FROM  table1,             table2
            WHERE table1.column1(+) = table2.column1
            
            -- OR
            FROM table1               RIGHT OUTER JOIN table2
                 ON table1.column1  = table2.column1
                 
        -- Full Outer Join
            FROM table1               FULL OUTER JOIN table2
                 ON table1.column1  = table2.column1
        
    --5 Self Join
            FROM  table1 alias.1,     table1 alias.2
            WHERE alias.1.column3   = alias.2.column1
            
            -- OR
            FROM table1 alias.1       JOIN table1 alias.2
                 ON alias.1.column3 = alias.2.column1


-- 8: Using Subqueries to Solve Queries

