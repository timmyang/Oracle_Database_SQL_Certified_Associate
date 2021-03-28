
-- Keywords:
    --1 Data Manipulation Language (DML) = Statement
        SELECT, INSERT, UPDATE, DELETE(FROM), MERGE
    --2 Clause
        WHERE, ORDER BY, FETCH, HAVING, TOP, GROUP BY,
        FOR UPDATE
    --3 Data Definition Language (DDL) = Statement
        CREATE(TABLE), ALTER(TABLE), DROP(COLUMN), RENAME, TRUNCATE
    --4 Data Control Language (DCL)
        GRANT, REVOKE
    --5 Transaction Control Language (TCL)
        COMMIT, ROLLBACK, SAVEPOINT


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
FROM       Table1 [LEFT/RIGHT/FULL OUTER JOIN Table2] 
                [ON table1.column1 = table2.column2]     -------------------------- NOT ---------------------------
WHERE      column1 [=, >, <, != (&var_name, &&var_name), BETWEEN ... AND ..., IN(), LIKE '_%' (ESCAPE '/'), IS NULL] 
           (subquery) SELECT(...)
           [AND, OR]
[GROUP BY] column1
[HAVING]   GROUP_FUNCTION() + condition
ORDER BY   column1/alias/index/expression [ASC, DESC, NULLS FIRST], column2
[OFFSET    row_num ROWS] FETCH FIRST row_num [PERCENT] ROWS ONLY/WITH TIES
                         [FETCH NEXT]

UNION/UNION ALL/INTERSECT/MINUS

SELECT ...

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
    
    --4 Substitution variables
    
        -- discarded after used
        WHERE  column1 = %var_name;
        -- won't be discarded after used
        WHERE  column1 = %%var_name;
        -- for Varchar
        WHERE  column1 = '&var_name';
        
    --5 DEFEINE and UNDEFINE command
        DEFINE   column_name = value1  -- only valid for this session
        
        WHERE    column1 = &colunm_name;
        
        UNDEFINE column_name;
        
        -- ACCEPT command
        ACCEPT   column_name 'message here'
        [ACCEPT] column_name2 'message here2'
        
        WHERE    column1 = &column_name;
        
        -- using && to define, assign and store a value at the same time
        SELECT   column1, column2, &&column3
        FROM     Table1
        ORDER BY &column3;          -- read the same value as &&column3 above
        
        
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

    SELECT   column1, column2, column3, column4
    FROM     Table1

    UNION/UNION ALL/INTERSECT/MINUS 

    SELECT   columnA, columnB, to_char(NULL) alias1, 0 alias2
    FROM     Table2
    ORDER BY column1/index/alias

    --1 UNION operator
    /*
    The number of columns being selected must be the same.
    The data types must be the same.
    The names of the columns need NOT to be identical.
    UNION operators compare all of the columns being selected.
    NULL values are not ignored during duplicate checking.
    By default, the output is sorted in ascending order
    */
    
    --2 UNION ALL operator
    /*
    Will not remove duplicates
    Will not be ordered
    */

-- 10: Managing Tables using DML Statements

        DESC Table1
        
    --1 INSERT INTO
        INSERT INTO Table1 [(column1, column2, column3,  column4, [column5])]
        VALUES              ( value1,  value2, 'value3', &value4,    [NULL]);
        
        COMMIT;
        
        --
        INSERT INTO Table1 (column1, column2, column3)
        SELECT              column1, column2, column3
        FROM        Table2
        
        COMMIT;
        
            -- Errors:
                -- 1. cannot insert a new record with a Primary Key (PK) value that already exists
                -- 2. cannot insert a new record with a Foreign Key (FK) value that does not exist in its table as a Primary Key
                -- 3. cannot insert a new record into a column that does not match with its data type
                -- 4. cannot insert a new record that has a length longer than predefined values

    --2 UPDATE 
        UPDATE  Table1
        SET     column2 = value2,       column3 = value3
        [WHERE   pk_column1 = value1];
        
        COMMIT;
        
        --
        UPDATE  Table1
        SET    (column2, column3) = (SELECT  column2, column3
                                     FROM    Table1
                                     WHERE   pk_column1 = value3)
        [WHERE   pk_column1 = value1];
        
        COMMIT;
        
    --3 DELETE
        DELETE [FROM] table1
        [WHERE         column1 = value1];
        
        COMMIT;
        
        --
        DELETE [FROM] table1
        WHERE         column1 = (SELECT column1
                                  FROM   table1
                                  WHERE  column1 = value1)
        
            -- Erros:
                -- 1. You cannot delete a Primary Key (parent) record that is used as a Foreign Key (child) to another table
    
    --4 MERGE
        MERGE INTO table1 alias1
            USING (table|view|sub_query) alias2
            ON (alias1.column1 = alias2.column1)
            WHEN MATCHED THEN
                UPDATE
                SET alias1.column2 = alias2.column2,
                    alias1.column3 = alias2.column3
            WHEN NOT MATCHED THEN
                INSERT
                VALUES (alias2.column1, alias2.column2, alias2,column3);
    
    --5 Database Transactions
        COMMIT
        SAVEPOINT a
        ROLLBACK [TO SAVEPOINT a]
        
    --6 Controlling Transactions
        FOR UPDATE
        FOR UPDATE NOWAIT
        FOR UPDATE WAIT num
        
-- 11: Managing Indexes, Synonyms and Sequences

    --1 Creating an Index
        CREATE [UNIQUE/BITMAP] INDEX name_for_the_index 
        ON                           table1 (column1);
      
        DROP INDEX index_name;
        
    --2 Creating a Synonym
        CREATE [PUBLIC] SYNONYM name_for_the_synonym
        FOR                     object_name(table1);
        
        SELECT   *
        FROM     name_for_the_synonym;
        
        DROP SYNONYM            name_for_the_synonym;
        
    --3 Creating a Sequence
        CREATE SEQUENCE name_for_the_sequence;
        [START WITH     integer1]
        [INCREMENT BY   integer2]
        [MAXVALUE       integer3/NOMAXVALUE]
        [CACHE          integer4/NOCACHE]       
        [CYCLE/NOCYCLE]
        [ORDER/NOORDER]
        
        INSERT INTO table1 (column1, column2)
        VALUES             (name_for_the_sequence.NEXTVAL/CURRVAL, value1);
        
        DROP SEQUENCE   name_for_the_sequence;
        
-- 12: Use DDL to Manage Tables and Their Relationships

    --1 Creating Tables
        CREATE TABLE 
            table1 (
                      column1 CHAR[(max_size)]
                    , column2 VARCHAR2(max_size)
                    , column3 NUMBER[(p.recision, s.cale)]
                    , column4 DATE       [DEFAULT SYSDATE]
                    , column5 CLOB
                    , column6 BLOB
                    , column7 TIMESTAMP
                    );
    
    --2 Constraints (column-level) not recommended
        CREATE TABLE 
            table1 (
                      column1 NUMBER     NOT NULL
                    , column2 VARCHAR2() CONSTRAINT name_for_the_const UNIQUE
                    , column3 NUMBER     CONSTRAINT name_for_the_const PRIMARY KEY
                    , column4 NUMBER     CONSTRAINT name_for_the_const REFERENCES table2 (column10)
                    , column5 CHAR       CONSTRAINT name_for_the_const CHECK (column5 IN ())
                    );
                             
    --3 Constraints (table-level) recommended (with ON DELETE CASECADE/SET NULL)
        CREATE TABLE 
            table1 (
                     column1 NUMBER [PRIMARY KEY]
                   , column2 NUMBER [PRIMARY KEY]
                   , column3 VARCHAR2()
                   , column4 NUMBER      NOT NULL    -- cannot make NOT NULL constraint at the table level
                   , column5 CHAR()
                   , column6 NUMBER
                            
                  [, CONSTRAINT name_for_the_const 
                            PRIMARY KEY (column1, column2)]
                   , CONSTRAINT name_for_the_const 
                            UNIQUE (column3)
                   , CONSTRAINT name_for_the_const 
                            CHECK (column5 IN ())
                   , CONSTRAINT name_for_the_const 
                            FOREIGN KEY (column6) REFERENCES Table2 (column10)    -- notice the syntax now includes FOREGIN KEY
                                    [ON DELETE CASCADE/SET NULL]
                   );
    
    --4 Creating Tables AS a subquery
        CREATE TABLE
            table1 [(col_name1, col_name2, colname3, colname4)]
                    AS SELECT 
                            column1
                          , column2
                          , column3
                          , column4
                       FROM
                          table1
                       WHERE
                          column4 = number1;
    
    --5 ALTER TABLE statements
        -- ADD
           ALTER TABLE 
                table1
                    ADD ( new_column1 NUMBER [DEFAULT number1  [NOT NULL]]
                        , new_column2 VARCHAR2(num1)    -- this column will be automatically filled with (null)s
                        );
        -- MODIFY
           ALTER TABLE
                table1
                    MODIFY (  column1 NOT NULL
                            , column2 VARCHAR2(num2)       
                           );
        -- DROP COLUMN
           ALTER TABLE
                table1
                    DROP COLUMN column1;                -- () is NOT needed, b/c only one column can be dropped at once. (column1, column2) is NOT allowed.
        -- SET UNUSED
           ALTER TABLE
                table1
                    SET UNUSED(column1)
                            [ONLINE];                   -- allows DML operation while making the column unused
                            
           ALTER TABLE
                table1
                    DROP UNUSED COLUMNS;                -- removes all UNUSED columns physically
        -- READ ONLY/READ WRITE
           ALTER TABLE
                table1                                  -- ONLY: prevents DML, DDL(except when it does NOT change data e.g. ADD a column)
                    READ ONLY/WRITE;                    -- WRITE: allows DML, DLL
        -- RENAME [COLUMN]
           ALTER TABLE
                table1
                    RENAME COLUMN column1
                            TO new_col_name;            -- renaming a column
            
            RENAME
                table1
                    TO new_table_name;                  -- renaming an object(table)

    --6 Dropping a Table
        DROP TABLE table1 [PURGE];                            -- skips the recycle bin.
        
        SELECT     *
        FROM       USER_RECYCLEBIN
        WHERE      original_name = 'table1';            -- Querying the table in the recycle bin
    


-- 99: Questions
    --3 Restricting and Sorting Data
        -- LIKE operator
            -- Will the value in column1 that starts with "s" 
            -- be included in the following result?
            WHERE  column1 LIKE '%s%';  -- includes s