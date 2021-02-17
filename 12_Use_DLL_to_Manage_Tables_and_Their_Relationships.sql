
/*
Use DDL to manage tables and their relationships
- Describing and Working with Tables
- Describing and Working with Columns and Data Types
- Creating tables
- Managing Constraints

- Dropping columns and setting column UNUSED
- Truncating tables
- Creating and using Temporary Tables
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
      

-- 4: Creating Tables with constraints (column level syntax)