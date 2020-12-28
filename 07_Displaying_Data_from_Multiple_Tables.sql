
/*
Displaying Data from Multiple Tables
- Understanding and Using Cartesian Products
- Using various types of Joins
- Using Non Equijoins
- Using Outer Joins
- Using Self-Joins
*/


/*
Cartesian Products:
    - Retreiving data from multiple tables without using Joins

A Cartesian Product is formed when:
    - A join condition is omitted
    - A join condition is invalid
    - All rows in the first table are joined to all rows in the second table

To avoid a Cartesian product, always include a valid JOIN condition in a WHERE clause
*/

SELECT   employee_id, first_name, department_id       -- department_id is a foreign key to the Departments table
FROM     Employees;

SELECT   department_id, department_name
FROM     Departments;

-- Cartesian Product
SELECT   Employees.employee_id,     Employees.first_name,       Employees.last_name,
         Departments.department_id, Departments.department_name
FROM     Employees,                 Departments                 -- 107 rows (Employees) X 27 rows (Departments) = 2889 rows
ORDER BY employee_id;                                           -- each row in Employees are joined with each row in Departments


/*
Types of Joins:

1. Oracle Proprietary Joins (8i and prior):
    - Equijoin
    - Nonequijoin
    - Outer Join
    - Self Join
    
2. SQL: 1999 Compliant Joins:
    - Cross Joins
    - Natural Joins
    - Using Clause
    - Full or Two Sided Outer Joins
    - Arbitrary Join Conditions for Outer Joins
*/


--1 Equijoin (Simple Joins / Inner Joins)
SELECT   Employees.employee_id,         Employees.first_name,       Employees.department_id,
         Departments.department_name -- department_id exists in both tables, so should not remove the table
FROM     Employees,                     Departments
WHERE    Employees.department_id      = Departments.department_id
ORDER BY employee_id;

-- using additional conditions
SELECT   Employees.employee_id,        Employees.first_name,        Employees.department_id,
         Departments.department_id,    Departments.department_name
FROM     Employees,                    Departments
WHERE    Employees.department_id     = Departments.department_id
         AND Employees.department_id > 40
ORDER BY employee_id;

-- using table Alias
SELECT   Emp.employee_id,              Emp.first_name,              Emp.department_id,
         Dept.department_name
FROM     Employees Emp,                Departments Dept
WHERE    Emp.department_id           = Dept.department_id
ORDER BY employee_id;

-- joining more than 2 tables
SELECT   Emp.employee_id,              Emp.first_name,              Emp.department_id,
         Dept.department_name,         Dept.location_id,
         Loc.city
FROM     Employees Emp,                Departments Dept,            Locations Loc
WHERE    Emp.department_id           = Dept.department_id 
         AND Dept.location_id        = Loc.location_id
ORDER BY employee_id;


--2 Nonequijoin
-- creating a new table
CREATE TABLE Job_grades
(
grade_level VARCHAR2 (3),
lowest_sal NUMBER,
highest_sal NUMBER
);

-- insert the records for the table
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('A', 1000, 2999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('B', 3000, 5999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('C', 6000, 9999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('D', 10000, 14999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('E', 15000, 24999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('F', 25000, 40000);

COMMIT;

SELECT *
FROM Job_grades;

SELECT Emp.employee_id,     Emp.first_name,     Emp.salary,
       Grades.grade_level
FROM   Employees Emp,       Job_grades Grades
WHERE  Emp.salary BETWEEN Grades.lowest_sal AND Grades.highest_sal;

-- the above is the same as
SELECT Emp.employee_id,     Emp.first_name,     Emp.salary, 
       Grades.grade_level
FROM   Employees Emp,       Job_grades Grades
WHERE  Emp.salary        >= Grades.lowest_sal
       AND Emp.salary    <= Grades.highest_sal;
       

--3 Outer Join (+), Casel
-- all data on the "opposite" side of (+) will appear

-- this is an Equijoin example 
SELECT   Employees.employee_id,         Employees.first_name,       Employees.department_id,
         Departments.department_name
FROM     Employees,                     Departments
WHERE    Employees.department_id      = Departments.department_id
ORDER BY employee_id;

-- here is the Outer Join 
-- Employees is the main table
SELECT   Employees.employee_id,         Employees.first_name,       Employees.department_id,
         Departments.department_name
FROM     Employees,                     Departments
WHERE    Employees.department_id      = Departments.department_id(+)
ORDER BY employee_id;

-- Departments is the main table
SELECT   Employees.employee_id,         Employees.first_name,       Employees.department_id,
         Departments.department_name
FROM     Employees,                     Departments
WHERE    Employees.department_id(+)  = Departments.department_id
ORDER BY employee_id;

-- Exercise
/*
Retrieve all the Employees (employee_id, first_name, department_id) who's salary > 2500
and display their Department department_name, location_id, 
and Locations city and country_id
and Countries country_name.
All employees should appear even if they have no department
*/

-- determine how many records should be returned
SELECT   count(1)
FROM     Employees
WHERE    salary > 2500;

--
SELECT   Emp.employee_id,       Emp.first_name,       Emp.department_id,
         Dept.department_name,  Dept.location_id, 
         Loc. city,      
         Cont.country_name      
FROM     Employees Emp,         Departments Dept,     Locations Loc,      Countries Cont
WHERE    Emp.department_id    = Dept.department_id(+)
         AND Dept.location_id = Loc.location_id(+)
         AND Loc.country_id   = Cont.country_id(+)
         AND salary           > 2500
ORDER BY employee_id;




--4 Self Joins
SELECT   employee_id, first_name, manager_id
FROM     Employees;

-- I want to display the manager name, so it is a Self Join
SELECT   Worker.employee_id,    Worker.first_name,  Worker.manager_id,
         Manager.first_name
FROM     Employees Worker,      Employees Manager
WHERE    Worker.manager_id    = Manager.employee_id;

SELECT   Worker.employee_id,    Worker.first_name,  Worker.manager_id,
         Manager.first_name
FROM     Employees Worker,      Employees Manager
WHERE    Worker.manager_id    = Manager.employee_id(+);


-- SQL: 1999 Syntax
/*
- Cross Joins
- Natural Joins
- Using Clause
- Full or Two Sided Outer Joins
- Arbitrary Join Conditions for Outer Joins
*/

--5 CROSS JOIN
-- same as Cartesian Product
SELECT   last_name, department_name
FROM     Employees, Departments;

-- the only difference is replacing "," with CROSS JOIN
SELECT   last_name, department_name
FROM     Employees CROSS JOIN Departments;


--6 NATURAL JOINs
SELECT   Departments.department_id, Departments.department_name,
         location_id,               -- you do not put the prefix table name in the match column
         Locations.city         
FROM     Departments NATURAL JOIN Locations;

-- NATURAL JOIN using the old format, Equijoin (same as above)
SELECT   Departments.department_id, Departments.department_name,
         Departments.location_id,   -- here you should put the prefix   
         Locations.city          
FROM     Departments, Locations
WHERE    Departments.location_id  = Locations.location_id;


--7 USING Clause
SELECT   Employees.employee_id,         Employees.first_name,
         department_id,              -- no prefix table name in the match column
         Departments.department_name
FROM     Employees JOIN Departments
         USING (department_id)
ORDER BY employee_id;

-- using Equijoin, it is the same as the above
SELECT   Employees.employee_id,         Employees.first_name,       Employees.department_id,
         Departments.department_name
FROM     Employees,                     Departments
WHERE    Employees.department_id      = Departments.department_id
ORDER BY employee_id;


--8 ON Clause
SELECT   Employees.employee_id,         Employees.first_name,
         Departments.department_id,     Departments.department_name     -- prefix should be used
FROM     Employees JOIN Departments
         ON Employees.department_id   = Departments.department_id
ORDER BY employee_id;

-- the above is the same as (Equijoin)
SELECT   Employees.employee_id,     Employees.first_name,
         Departments.department_id, Departments.department_name
FROM     Employees,                 Departments
WHERE    Employees.department_id  = Departments.department_id
ORDER BY employee_id;

-- (Nonequijioin)
SELECT   Emp.employee_id,   Emp.first_name,     Emp.salary, 
         Grades.grade_level
FROM     Employees Emp      JOIN Job_grades Grades
         ON Emp.salary BETWEEN Grades.lowest_sal AND Grades.highest_sal;

-- (Self Join)
SELECT   Worker.employee_id,    Worker.first_name, Worker.manager_id,
         Manager.first_name
FROM     Employees Worker       JOIN Employees Manager
         ON Worker.manager_id = Manager.employee_id;

-- Joining 3 tables
SELECT   Emp.Employee_id,       Emp.first_name,     Emp.department_id,
         Dept.department_name,  Dept.location_id,
         Loc.city
FROM     Employees Emp          JOIN Departments Dept
         ON Emp.department_id = Dept.department_id
                                JOIN Locations Loc
         ON Dept.location_id  = Loc.location_id
ORDER BY employee_id;


--9 LEFT OUTER JOIN
SELECT   Emp.employee_id,       Emp.first_name,          Emp.department_id,
         Dept.department_name
FROM     Employees Emp          LEFT OUTER JOIN Departments Dept
         ON Emp.department_id   = Dept.department_id
ORDER BY employee_id;

-- the above is the same as
SELECT   Emp.employee_id,       Emp.first_name,     Emp.department_id,
         Dept.department_name
FROM     Employees Emp,         Departments Dept
WHERE    Emp.department_id    = Dept.department_id(+)
ORDER BY employee_id;


--10 RIGHT OUTER JOIN
SELECT   Emp.employee_id,       Emp.first_name,         Emp.department_id,
         Dept.department_name
FROM     Employees Emp          RIGHT OUTER JOIN Departments Dept
         ON Emp.department_id = Dept.department_id
ORDER BY employee_id;

-- the above is the same as
SELECT   Emp.employee_id,       Emp.first_name,     Emp.department_id,
         Dept.department_name
FROM     Employees Emp,         Departments Dept
WHERE    Emp.department_id(+) = Dept.department_id
ORDER BY employee_id;


--11 FULL OUTER JOIN
SELECT   Emp.employee_id,       Emp.first_name,     Emp.department_id,
         Dept.department_name
FROM     Employees Emp          FULL OUTER JOIN Departments Dept
         ON Emp.department_id = Dept.department_id
ORDER BY employee_id;

