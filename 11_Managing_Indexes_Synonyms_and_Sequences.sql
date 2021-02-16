
/*
Managing Indexes Synonyms and Sequences
- Managing Indexes
- Managing Synonyms
- Managing Sequences
*/

--1 Indexes

/*
An index:

- It's a schema object
- Can be used by the Oracle Server to speed up the retrieval of rows by using a pointer
- Can reduce disk input/output (I/O) by using rapid path access method to locate data quickly
- Is dependent on the table that it indexes
- Is used and maintained automatically by the Oracle Server

Note: when you drop a table, the corresponding indexes are also dropped


How are Indexes created?

- Automatically
  - A unique index is created automatically when you define a Primary Key or Unique constraint in a table definition
    The name of index will be as the constraint name

- Manually
  - You can create unique or non-unique index on cloumns to speed up access to the rows
  

Creating an Index

CREATE [UNIQUE] [BITMAP] INDEX index
ON table (column[, column] ...);

UNIQUE
- to indicate that the value of the column (or columns) upon which the index is based must be uqniue

BITMAP
- to indicate that the index is to be created with a bitmap for each distinct key, rather than indexing each row separately
  Bitmap indexes store the 'rowids' associated with a key value as a bitmap
  Index for a group of rows (ex. all the rows with Males)
  
*/

DROP TABLE Emp_ind;

CREATE TABLE Emp_ind (
                     empno NUMBER CONSTRAINT emp_ind_pk PRIMARY KEY,
                     ename VARCHAR2(100) UNIQUE,
                     nickname VARCHAR2 (100),
                     email VARCHAR2 (100)
                     );
                     
INSERT INTO Emp_ind (empno, ename,         nickname,      email                  )
VALUES              (  '1', 'Ahmed Samer', 'Ahmed.Samer', 'Ahmed.Samer@gmail.com');

INSERT INTO Emp_ind (empno, ename,         nickname,      email                   )
VALUES              (  '2', 'Rami Nader',  'Rami.Nader',  'Rami.Nader@hotmail.com');

INSERT INTO Emp_ind (empno, ename,         nickname,      email                   )
VALUES              (  '3', 'Khaled Ali',  'Khaled.Ali',  'Khaled.Ali@hotmail.com');

INSERT INTO Emp_ind (empno, ename,          nickname,       email                   )
VALUES              (  '4', 'Hassan Nabil', 'Hassan.Nabil', 'Hassan.Nabil@yahoo.com');

COMMIT;

-- The Oracle will create implicit UNIQUE indexes for the Primary Key and Unique Key
-- and the name for the index will be the same name of the constraint name

SELECT   *
FROM     User_indexes
WHERE    Table_name = 'Emp_ind';

SELECT   *
FROM     User_ind_columns
WHERE    Table_name = 'Emp_ind';

-- Now, the Oracle will use the index in the WHERE clause to speed the query

SELECT   *
FROM     Emp_ind
WHERE    empno = 1;

SELECT   *
FROM     Emp_ind
WHERE    ename = 'Ahmed Samer';

SELECT   *
FROM     Emp_ind
WHERE    nickname = 'Ahmed.Samer';

-- Creating an index
CREATE INDEX emp_ind_nickname 
ON           Emp_ind (nickname);


-- Creating a UNIQUE index
CREATE UNIQUE INDEX emp_ind_email
ON                  Emp_ind (email);

-- Now, if you try to insert an existing email, you will see an error
INSERT INTO Emp_ind
VALUES              ('10', 'Ahmed Samer', 'Ahmed.Samer', 'Ahmed.Samer@gmail.com');


/*
Index Creation Guidlines

Create an index when:

- A column contains a wide range of values
- A column contains a large number of null values
- One or more columns are frequently used together in a WHERE clause or a join condition
- The table is large and most queries are expected to retrieve less than 2% to 4% of the rows in the table

Do not create an index when:

- The columns are not often used as a condition in the query
- The table is small or most queries are expected to retrieve more than 2% to 4% of the rows in the table
- The table is updated frequently
- The indexed columns are referenced as part of an exTEpression

*/

-- Naming an index while create the table
CREATE TABLE Emp_ind1 (
                      empno NUMBER CONSTRAINT emp_ind1_pk PRIMARY KEY USING INDEX (CREATE INDEX emp_ind1_ind
                                                                                   ON           emp_ind1 (empno)
                                                                                   ),
                      fname VARCHAR2(100),
                      lname VARCHAR2(100),
                      email VARCHAR2(100),
                      gender CHAR(1)
                      );

-- You can create an index of composit columns
CREATE INDEX emp_ind1_comp
ON           Emp_ind1 (fname, lname);

-- You can create an index with type bitmap
CREATE INDEX emp_ind_b 
ON           Emp_ind1 (gender);

-- Dropping an index
DROP INDEX Emp_ind1_comp;


--2 Synonyms

/*
Is an alternative name for an object.

There are two types of synonyms: 
    private synonyms and public synonyms
 
    
A Synonym

- Is a database object
- Can be created to give an alternative name to a table or to an other database object
- Requires no storage other than its definition in the data dictionary
- Is useful for hiding the identify and location of an uderlying schema object


Creating a Synonym for an Object

- Simplifies access to objects by creating a synonym (another name for an object).
- With synonyms, you can:
  - Create an easier reference to a table that is owned by another user
  - Shorten lengthy object names
  
CREATE [PUBLIC] SYNONYM synonym
FROM                    object;

*/

-- Creating PRIVATE SYNONYM E for Employees table
CREATE SYNONYM E
FOR            Employees;

-- so you can use the SYNONYM now to call the table
SELECT   *
FROM     E;

-- the SYNONYM info in a dictionary view is called user_SYNONYMS / ALL_SYNONYMS
SELECT   *
FROM     user_SYNONYMS;

-- you can drop the SYNONYM
DROP SYNONYM E;


-- You should create public SYNONYM privilages, in order to create PUBLIC SYNONYM
CREATE PUBLIC SYNONYM Employees
FOR                   Hr.employees; -- now, other users accessing Employees can use the above synonym


--3 Sequences

/*
Is a database object to generate sequence numbers.


A Sequence:

- Can automatically generate unique numbers
- Is a shareable object
- Can be used to create a primary key value
- Replaces application code
- Speeds up the efficiency of accessing sequence values when cached in memory


CREATE SEQUENCE name_for_a_sequence
                [INCREMENT BY / START WITH integer
                 MAXVALUE integer / NOMAXVALUE
                 MINVALUE integer / NOMINVALUE
                 CYCLE / NOCYCLE
                 CACHE integer / NOCAHCE
                 ORDER / NOORDER
                ];
                
Note: Do not use the CYLCE option if the sequence is used to generate primary key values


NEXTVAL and CURRVAL

- NEXTVAL returns the next available sequence value.
  It returns a unique value every time it is referenced, even for different users.
- CURRVAL obtains the current sequence value
- NEXTVAL must be issued for that sequence beforre CURRVAL contains a value


Rules for using NEXTVAL and CURRVAL:

Can use:

- The SELECT list of a SELECT statement that is not part of a subquery
- The SELECT list of a subquery in an INSERT statement
- The VALUES clause of an INSERT statement
- The SET cllause of an UPDATE statement

Can NOT use:

- The SELECT list of a view
- A SELECECT statement with the DISTINCT keyword
- A SELECT statement with GROUP BY, HAVING, or ORDER BY clause
- A subquery in s SELECT, DELETE, or UPDATE statement


Caching Sequence Values

- Caching sequence values in memory gives faster access to those values
- Gaps in sequence values can occur when:
  - A rollback occurs
  - The system crashes
  - A sequence is used in another table


Guidlines for Modifying a Sequence

- You must be the owner or have the ALTER privilege for the sequence
- Only future sequence numbers are affected
- The sequence must be dropped or re-created to restart the sequence at a different number
- Some validation is performed
- To remove a sequence, use the DROP statement:
  DROP SEQUENCE name_for_the_sequence;


Sequence Information

- The USER_SEQUENCES view describes all sequenecs that you own
  DESCRIBE user_sequences;
- Verify your sequence values in the USER_SEQUENCES data dictionary table
  SELECT   sequence_name, min_value, max_value, increment_by, last_number
  FROM     user_sequences;

*/

-- Creating a basic sequence
CREATE SEQUENCE dept_s;

SELECT   *
FROM     User_sequences
WHERE    sequence_name = 'dep_s';


CREATE TABLE dept_test_s (
                         depno NUMBER PRIMARY KEY,
                         dname VARCHAR2(100)
                         );
                        
INSERT INTO dept_test_s (depno,           dname)
VALUES                  (dept_s.NEXTVAL, 'Sales');

INSERT INTO dept_test_s (depno,           dname)
VALUES                  (dept_s.NEXTVAL, 'Operation');


SELECT   *
FROM     dept_test_s;

SELECT   dept_s.CURRVAL
FROM     Dual;

--
CREATE SEQUENCE dept_s1
START WITH      10
INCREMENT BY    20;

DELETE FROM dept_test_s;

INSERT INTO dept_test_s (depno,           dname)
VALUES                  (dept_s1.NEXTVAL, 'Marketing');

INSERT INTO dept_test_s (depno,           dname)
VALUES                  (dept_s1.NEXTVAL, 'Help Desk');

SELECT   *
FROM     Dept_test_s;

DELETE FROM dept_test_s;

--
DROP SEQUENCE dept_s2;
DELETE FROM dept_test_s;

CREATE SEQUENCE dept_s2
INCREMENT BY    -5;

INSERT INTO dept_test_s (depno,           dname)
VALUES                  (dept_s2.NEXTVAL, 'Marketing');

INSERT INTO dept_test_s (depno,           dname)
VALUES                  (dept_s2.NEXTVAL, 'Help Desk');

SELECT   *
FROM     Dept_test_s;

--
UPDATE dept_test_s
SET    depno = dept_s2.NEXTVAL;

SELECT   *
FROM     Dept_test_s
ORDER BY 1;

--
CREATE SEQUENCE emp_s;

CREATE TABLE Em1 (
                 empid NUMBER DEFAULT emp_s.NEXTVAL PRIMARY KEY,
                 ename VARCHAR2(100),
                 deptno NUMBER
                 );
                 
INSERT INTO Em1 (ename)
VALUES          ('James'); 

INSERT INTO Em1 (ename)
VALUES          ('Mark'); 

SELECT   *
FROM     Em1;



-- Using CURRVAL
DELETE FROM dept_test_s;
DELETE FROM Em1;

DROP SEQUENCE dept_s;
CREATE SEQUENCE dept_s;


INSERT INTO Dept_test_s (depno,          dname)
VALUES                  (dept_s.NEXTVAL, 'support');

INSERT INTO Em1         (ename, deptno)
VALUES                  ('ali', dept_s.CURRVAL);

INSERT INTO Em1         (ename,   deptno)
VALUES                  ('ahmed', dept_s.CURRVAL);

INSERT INTO Em1         (ename,   deptno)
VALUES                  ('samer', dept_s.CURRVAL);


-- Altering the sequence
ALTER SEQUENCE dept_s
INCREMENT BY   100;

ALTER SEQUENCE dept_s
CACHE          30;

ALTER SEQUENCE dept_s
MAXVALUE       9999;

ALTER SEQUENCE dept_s
START WITH     170;    -- You cannot change the START WITH


--
DROP SEQUENCE s_cycle;

CREATE SEQUENCE s_cycle
START WITH      1
INCREMENT BY    1
MAXVALUE        5
NOCACHE
CYCLE;

SELECT s_cycle.NEXTVAL
FROM   Dual;

SELECT s_cycle.NEXTVAL
FROM   Dual;

SELECT s_cycle.NEXTVAL
FROM   Dual;

SELECT s_cycle.NEXTVAL
FROM   Dual;

SELECT s_cycle.NEXTVAL
FROM   Dual;            -- reaches the maximum, 5

SELECT s_cycle.NEXTVAL
FROM   Dual;            -- returns to the starting value, 1


--
DESCRIBE user_sequences;