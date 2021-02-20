
/*
Use DDL to manage tables and their relationships
- Describing and Working with Tables
- Describing and Working with Columns and Data Types
- Creating tables
- Managing Constraints

- Dropping columns and setting column UNUSED    

- Truncating tables                             [ON DELETE CASCADE/SET NULL?]
- Creating and using Temporary Tables           [subquery?]
- Creating and using external tables
*/


-- 1: DDL & Naming Rules

/*
Some Database Objects:

Table
  - Is the basic unit of storage; composed of rows
View
  - Logically represents subsets of data from one or more tables
Sequence
  - Generates numeric values
Index
  - Improves the performance of some queries
Synonym
  - Gives alternative name to an object


Oracle Table Structures:
  - Tables can be created at any time, even when users are using the database
  - You do not need to specify the size of table. 
    The size is ultimately defined by the amount of space allocated to the database as a whole.
    It is important, however, to estimate how much space a table will use over time.
  - Table structure can be modified online


Naming Rules:
  Table names and column names must
  - Begin with a letter
  - Be 1-30 characters long
  - Contain only A-Z, a-z, 0-9, _, $, and #
  - Not duplicate the name of another object owned by the same user
  - Not be an Oracle server-reserved word


Naming Guidelines:
  - Use descriptive names for tables and other database objects.
  Note: Names are not case-senstitive. 
        For example, EMPLOYEES is treated to be the same name as eMPloyees or eMpLOYEES.
        However, quoted identifiers " " are case-sensitive.
        
*/

  --1 The object(table) should start by letter
      CREATE TABLE 2EMP (
                        empno NUMBER
                        );

  --2 The table name should be 30 char or less
      CREATE TABLE employees_and_hr_information_table (
                                                      empno NUMBER
                                                      );
  
  --3 Table name should contain only A-Z, a-z, _, $, #
      CREATE TABLE Emp-t (
                         empno NUMBER
                         );
  
  --4 Table name should not be duplicates with another object used by the same user
      CREATE TABLE Employees (
                             empno NUMBER
                             );
  
  --5 Table name should not be an ORACLE-reserved word (select, from, where, table, ...)
      CREATE TABLE Select (
                          empno NUMBER
                          );
                          

-- 2: Data Types 

/*
Data Types:

VARCHAR2(max_size) ****
  - Variable-length character data
  - Maximum size must be specified
  - Minimum size is: 1
  - Maximum size is:
    32767 bytes if MAX_SQL_STRING_SIZE = EXTENDED
    4000 bytes if MAX_SQL_STRING_SIZE = LEGACY

CHAR[(max_size)] ****
  - Fixed-length character data of length 'size' bytes
  - Default and minimum size is: 1
  - Maximum size is: 2,000

NUMBER[(precision, scale)] ****
  - Precision is the total number of digits.
    - ranges from 1 to 38
  - Scale is the number of digits to the right of the decimal point
    - ranges from -84 to 127

DATE ****
  - Date and time values to the nearest second 
    between January 1, 4712 B.C. and December 31, 9999 A.D.
    
LONG
  - Variable-length "character" data (up to 2 GB)
    Guidelines:
    - A LONG column is not copied when a table is created using a subquery
    - A LONG column cannot be included in a GROUP BY or an ORDER BY clause
    - Only one LONG column can be used per table
    - No constraints can be defined on a LONG column
    - You might want to use a CLOB column rather than a LONG column

CLOB ****
  - A "character" large object containing single-byte or multibyte characters
  - Maximum size is: 4 gigabytes
  - Stores national character set data

NCLOB

RAW(size)

LONG RAW
  - Raw binary data of variable length up to 2 gigabytes
  
BLOB ****
  - A "binary" large object
  - Maximum size is: 4 gigabytes
  
BFILE

ROWID

TIMESTAMP ****
  - Date with fractional seconds

INTERVAL YEAR TO MONTH
  - Stored as an interval of years and months

INTERVAL DAY TO SECOND
  - Stored as an interval of days, hours, minutes, and seconds

*/

  --1 Number
      CREATE TABLE Test1 (
                         n1 NUMBER,
                         n2 NUMBER (5, 3)
                         );
    
      INSERT INTO Test1 VALUES (1655.66, 1.34);
      INSERT INTO Test1 VALUES (20.25, 23.347);
      INSERT INTO Test1 VALUES (444.25, 23.3496666); -- rounded off     
      INSERT INTO Test1 VALUES (444.25, 500);        -- error here
      
      SELECT      *     FROM     Test1;


-- 3: Creating Tables (without constraints)

/*
CREATE TABLE statement

You must have:
  - The CREATE TABLE privilege
  - A storage area
  
You must specify:
  - The table name
  - The column name, column data type, and column size
  
  CREATE TABLE [schema.] table (
                              column datatype [DEFAULT expr]
                              );

*/
    
  --1 Example
      CREATE TABLE Xx_emp_test (
                                emp_id NUMBER,
                                ename VARCHAR2 (100),
                                salary NUMBER (8, 2),
                                start_date DATE,
                                commission NUMBER (2, 2),
                                emp_pic BLOB,
                                emp_notes LONG   -- CLOB is better
                                );
                                
      SELECT   *
      FROM     Xx_emp_test;    -- an empty table is returned


  --2 Using the DEFAULT
      CREATE TABLE Xx_emp_test1 (
                                emp_id NUMBER,
                                ename VARCHAR2 (100),
                                salary NUMBER (8, 2),
                                start_date DATE DEFAULT SYSDATE,    -- here
                                commission NUMBER (2, 2)
                                );
                    
      INSERT INTO Xx_emp_test1 (emp_id, ename)
      VALUES                   (     1, 'khaled');
      
      COMMIT;
      
      SELECT   *
      FROM     Xx_emp_test1;
     
  --3 Calling All the Tables Created (Dictionary)
      SELECT   table_name
      FROM     User_tables;     -- from the HR schema
      
      SELECT   OWNER, table_name
      FROM     All_tables       -- All_tables can see all the tables in the database from any owner
      WHERE    OWNER = 'HR';    
      

-- 4: Creating Tables (with constraints, column level syntax)
      
/*
Including Constraints:
  - Oracle server uses contraints to prevent invalid data entry into tables

You can use constraints to do the following:
  - Enforce rules on the data in a table whenever a row is inserted, updated, or deleted from that table.
    The constraint must be satistifed for the operation to succeed
  - Prevent the dropping of a table if there are dependencies from other tables
  - Provide rules for Oracle tools, such as Oracle Developer

Data Integrity Constraints:
  - NOT NULL
      specifies that the column cannot contain a null value
      it can only be defined at the column level
      Primary Key enforces the NOT NULL constraint (a PK cannot be null)
      
  - UNIQUE
      specifies a column or combination of columns whose values must be unique for all rows in the table
        Caution:
          record 1 --> column1 = (null), column2 = (null)
          record 2 --> column1 = (null), column2 = (null)  This is allowed. (null)+(null) are not unique.
            record 1 --> column1 = (1), column2 = (null)
            record 2 --> column1 = (1), column2 = (null) This is NOT allowed. (1)+(null) is one unique value.
  
  - PRIMARY KEY
      uniquely identifies each row of the table
      Only one PRIAMRY KEY can be created for each table
        Note:
          when you create a PRIMARY KEY or an UNIQUE KEY, Oracle automatically creates a unique index
  
  - FOREIGN KEY + (REFERENCES)
      establishes and enforces a referential integrity between the column and a column of the referenced table
      such that values in one table match values in another table.
      Foreign Key value must match an exisng value(PK) in the parent table or be NULL.
  
  - CHECK
      specifies a condition that must be true
      
Constraint Guidelines:
  - You can name a constraint or the Oracle server generates a name by using the SYS_Cn format
  - Create a constraint at either of the following items:
      At the same time as the creation of the table
      After the creatino of the table
  - Define a constraint at the column or table level
  - View a constraint in the data dictionary
  
  - Constraints are easy to reference if you give them a meaningful name
  - Functionally, a table-level constraint is the same as a column-level constraint
*/


-- 5: Creating Tables (column-level constraints)

  -- column-level constraints are less flexible than table-level constraints (b/c it can only create a primary key with one column), 
  -- although they are functionally the same.
  -- Column-level constrainsts are not the best practices.
  
     CREATE TABLE Xx_emp_col_const1(
                                   emp_id  NUMBER        CONSTRAINT xx_emp_col_const_pk  PRIMARY KEY,
                                   ename   VARCHAR2(100) CONSTRAINT xx_emp_col_const_uk1 UNIQUE,
                                   salary  NUMBER NOT NULL,
                                   gender  CHAR(1)       CONSTRAINT xx_emp_col_const_chq CHECK (gender IN ('M', 'F')),
                                   dept_id NUMBER        CONSTRAINT xx_emp_col_const_fk1 REFERENCES Departments (department_id)
                                   );
    
     SELECT   *
     FROM     User_constraints
     WHERE    table_name = 'Xx_emp_col_const';
    
     --Let's try inserting data
       INSERT INTO Xx_emp_col_const (emp_id, ename,    salary, gender, dept_id)
       VALUES                       (     1, 'khaled',    500,    'D',    NULL);  -- CHECK Constraint is violated from gender

       INSERT INTO Xx_emp_col_const (emp_id, ename,    salary, gender, dept_id)
       VALUES                       (     1, 'khaled',    500,   NULL,    NULL);  -- this one works! (you can have NULL for CHECK and FK Constriants)
    
       INSERT INTO Xx_emp_col_const (emp_id, ename,    salary, gender, dept_id)
       VALUES                       (     2, 'khaled',    500,   NULL,    NULL);  -- UNIQUE Constraint is violated
    

-- 6: Creating Tables (table-level constraints)

  -- creating table-level constraints is the best practice
  -- you can create more than one Primary Key "column" in a table (composite PK)
  -- it forces you to name the constraint
  
     CREATE TABLE Xx_emp_col_const2 (
                                    emp_id1 NUMBER,
                                    emp_id2 NUMBER,
                                    ename   VARCHAR2(100),
                                    salary  NUMBER         NOT NULL,    -- you can not make the NOT NULL constraint at the table level
                                    gender  CHAR(1),
                                    dept_id NUMBER,
                                    
                                    CONSTRAINT Xx_emp_col_const1_pk  
                                            PRIMARY KEY (emp_id1, emp_id2),    -- composite PK
                                    CONSTRAINT Xx_emp_col_const1_uk1 
                                            UNIQUE (ename),
                                    CONSTRAINT Xx_emp_col_const1_ch1 
                                            CHECK (gender IN ('M', 'F')),
                                    CONSTRAINT Xx_emp_col_const1_fk1 
                                            FOREIGN KEY (dept_id) REFERENCES Departments (department_id)
                                    );
    

-- 7: ON DELETE cascade 
      -- deletes the records(FKs) of a child table that correspond to "deleted" records(PKs) of its parent table

      DELETE FROM Departments;   -- Error: Integrity constraint (HR.EMP_DEMP_FK) violated. child record found
      
      CREATE TABLE 
            Dept1 (
                    deptno NUMBER
                  , dname  VARCHAR2(100)
                  
                  , CONSTRAINT dept1_pk 
                            PRIMARY KEY (deptno)
                  );
                         
      INSERT INTO Dept1 VALUES (1, 'HR DEPT');
      INSERT INTO Dept1 VALUES (2, 'PO DEPT');
      COMMIT;
      
      SELECT   *
      FROM     Dept1;
      
      --
      CREATE TABLE 
            Emp1 (
                   empid NUMBER PRIMARY KEY
                 , ename VARCHAR2(100)
                 , deptno NUMBER
                        
                 , CONSTRAINT emp1_pk 
                        FOREIGN KEY (deptno) REFERENCES Dept1(deptno) 
                                ON DELETE CASCADE
                 );
      
      INSERT INTO Emp1 VALUES (1, 'khaled', '1');
      INSERT INTO Emp1 VALUES (2, 'ali', '1');
      INSERT INTO Emp1 VALUES (3, 'ahmed', '1');
      INSERT INTO Emp1 VALUES (4, 'rania', '2');
      INSERT INTO Emp1 VALUES (5, 'lara', '2');
      COMMIT;
      
      SELECT   *
      FROM     Emp1;
      
      SELECT   *
      FROM     Dept1
      WHERE    deptno = 1;
      
      -- when you delete the master record (Dept1), 
      -- Oracle will also delete relevent records from the detail recrods from other tables (Emp1)
      DELETE FROM Dept1
      WHERE       deptno = 1;
      
      SELECT   *
      FROM     Emp1;


-- 8: ON DELETE SET NULL
      -- does NOT delete the child's record, but makes it NULL instead
      ... 
      , CONSTRAINT emp1_pk 
                FOREIGN KEY (deptno) REFERENCES Dept1(deptno) 
                        ON DELETE SET NULL
      

-- 9: Creating a table AS subquery

/*
- Create a table and insert rows by combining the CREATE TABLE statement and the AS subquery option
- Match the number of specified oclumns to the number of subquery columns
- Define columns with column names and default values
- When you use expressions, you should use column alias
*/
      CREATE TABLE 
            E_emp (emp_id, fname, lname, sal DEFAULT 0, dept_id)
                  AS SELECT 
                          employee_id
                        , first_name
                        , last_name
                        , salary
                        , department_id
                     FROM
                        Employees
                     WHERE
                        department_id = 90;
                        
      DESC E_emp;    -- no Constraints are copied, except for NOT NULL for the last_name
                     -- PK(employee_id)'s constraint NOT NULL is not copied, because it is PK
      SELECT   *
      FROM     E_emp;


/*
Use the ALTER TABLE statement to:

- Add a new column
- Modify an existing column definition
- Define a default value for the new column
- Drop a column
- Rename a column
- Change table to read-only status

Also:

- Add a new constraint to the table
- Disable a constraint in the table
- Drop a constraint from the table
*/


-- 10: ALTER TABLE (ADD columns)

/*
Guidelines for Adding a Column:

- You cannot specify where the column is to appear
- The new column becomes the last column

  Note:
    - If a table already contains rows when a column is added, 
      the new column is initially null or takes the default value for all the rows.
    - You can add a mandatory NOT NULL column to a table that contains data in the other columns,
      only if you specify a default value.
    - You can add a NOT NULL column to an empty table without the default value.
*/
       DESC E_emp;
       SELECT * FROM E_emp;
       
       ALTER TABLE
            E_emp 
                ADD (gender CHAR(1));
        
       ALTER TABLE
            E_emp
                ADD (commission NUMBER
                                    DEFAULT 0 NOT NULL);
       
       ALTER TABLE
            E_emp
                ADD (commission1 NUMBER
                                    DEFAULT 0);    -- can make it to NULL
       ALTER TABLE
            E_emp
                ADD (commission2 NUMBER
                                    NOT NULL);     -- this will not work, b/c NOT NULL must have a default value
    
       ALTER TABLE
            E_emp
                ADD ( create_date DATE
                                    DEFAULT SYSDATE
                    , created_by VARCHAR2(100)
                                    DEFAULT USER
                    );
                    
        SELECT * FROM E_emp;
                    
                    
-- 11: ALTER TABLE (MODIFY columns)

/*
Modifying a Column
- You can change a column's Date Type, Size, and Default value
- A change to the default value affects only subsequent insertions to the table

Guidelines:
- You can decrease the width of a column if:
    - The column contains only null values
    - The table has no rwos
    - The decrease in column width is not less than the existing values in that column
*/
       SELECT * FROM E_emp;
       DESC E_emp;
       
       ALTER TABLE
            E_emp
                MODIFY (created_by VARCHAR2(200));
                
       ALTER TABLE
            E_emp
                MODIFY (created_by NOT NULL);
                
       UPDATE 
            E_emp
                SET gender = 'M';
        
       SELECT * FROM E_emp;


-- 12: ALTER TABLE (DROP COLUMN)

/*
Guidelines:
- The column may or may not contain data
- Only one column can be dropped at a time
- The table must have at least one column remaining in it, after it is altered
- A primary key that is referenced by another column cannot be dropped, unless the cascade option is added
- Dropping a column can take a while if the column has a large number of values
  In this case, it may be better to set it to be unused and drop it when there are fewer users on the system to avoid extended locks
*/
       SELECT * FROM E_emp;
       
       ALTER TABLE
            E_emp
                DROP COLUMN created_by;         
                
       ALTER TABLE
            E_emp
                DROP COLUMN (gender, created_date);   -- Error: cannot drop two columns at the same time
        

-- 13: ALTER TABLE (SET UNUSED)

/*
- You can use the SET UNUSED option to mark one or more columns unused
- You use the DROP UNUSED COLUMNS options to remove the columns that are marked as unused
- You can specify the ONLINE keyword to indicate that 
  DML operations on the table will be allowed while marking a column or columns unused
*/

       SELECT * FROM E_emp;
       
       ALTER TABLE
            E_emp
                SET UNUSED (salary);
       
       SELECT * FROM User_unused_col_tabs;
       
       UPDATE
            E_emp
                SET salary = 100;   -- Error: the salary column is gone(unused)
            
        
       ALTER TABLE 
            E_emp
                SET UNUSED(first_name) 
                    ONLINE;    -- allows DML operation while making the column unused. It could take time
        
       ALTER TABLE
            E_emp
                DROP UNUSED COLUMNS;


-- 14: ALTER TABLE (read only / read write)

/*
Read-Only Tables

You can use the ALTER TABLE syntax to:
  - Put a table in read-only mode, which prevents DDL or DML changes during table maintenance
  - Put the table back into read/write mode
*/
       SELECT * FROM E_emp;
       
       ALTER TABLE 
            E_emp
                READ ONLY;
        
       DELETE FROM
            E_emp;      -- Not allowed
        
       ALTER TABLE
            E_emp
                ADD (created_by VARCHAR2(100));     -- this DDL is allowed, because it does not change data
            
       ALTER TABLE
            E_emp
                DROP (created_by);                  -- this DDL is NOT allowed, because it changes data
                
      ALTER TABLE
            E_emp
                READ WRITE;                         -- Now, the above DDL, and below DML, are allowed
    
      DELETE FROM E_emp;


-- 15: Dropping a Table

/*
Dropping a Table:
- Moves a table to the recycle bin
- Removes the table and its data entirely, if the PURGE clause is specified
- Invalidates dependent objects and removes object privileges on the table

Guidelines:
- All data is delted from the table
- Any views and synonyms remain, but are invalid
- Any pending transactions are committed
- Only the creator of the table or a user with teh DROP ANY TABLE privilege can remove a table

  Note: use the FLASHBACK TABLE statement to restore a dropped table from the recycle bin
*/
      SELECT * FROM E_emp;
      
      DROP TABLE E_emp;
      
      SELECT * FROM E_emp;    -- Error: table or view does not exist
      
      SELECT * 
      FROM   USER_RECYCLEBIN
      WHERE  original_name = 'E_emp';  -- query the table in the recycle bin
      

-- 16: Renaming a Column
       CREATE TABLE
            Xx_dept_table ( depno NUMBER
                          , daname VARCHAR2(100)
                          );
       
       ALTER TABLE
            Xx_dept_table
                RENAME COLUMN daname 
                        TO dept_name;
      
       SELECT * FROM Xx_dept_table;
    
-- 17: Renaming an Object(table)
       RENAME
            Xx_dept_table
                    TO Xx_dept_t;
                    
       SELECT * FROM Xx_dept_table;   -- Error: this name no longer exist
       SELECT * FROM Xx_dept_t;