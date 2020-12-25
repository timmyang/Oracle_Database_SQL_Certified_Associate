
/*
Displaying Data from Multiple Tables
- Using SELF-JOINS
- Using various types of JOINS
- Using non equiJoins
- Using OUTER JOINS
- Understanding and Using Cartesian Products
*/


/*
Cartesian Products:
    - Retreiving data from multiple tables without using JOINS

A Cartesian Product is formed when:
    - A join condition is omitted
    - A join condition is invalid
    - All rows in the first table are joined to all rows in the second table

To avoid a Cartesian product, always include a valid JOIN condition in a WHERE clause
*/

SELECT employee_id, first_name, department_id       -- department_id is a foreign key to the Departments table
FROM Employees;

SELECT department_id, department_name
FROM Departments;

-- Cartesian Product
SELECT Employees.employee_id, Employees.first_name, Employees.last_name,
       Departments.department_id, Departments.department_name
FROM Employees, Departments                         -- 107 rows (Employees) X 27 rows (Departments) = 2889 rows
ORDER BY employee_id;                               -- each row in Employees are joined with each row in Departments


/*
Types of Joins:

1. Oracle Proprietary Joins (8i and prior):
    - Equijoin
    - Noneequijoin
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
SELECT Employees.employee_id, Employees.first_name, Employees.department_id,
       Departments.department_name          -- department_id exists in both tables, so should not remove the table
FROM Employees, Departments
WHERE Employees.department_id = Departments.department_id
ORDER BY employee_id;

-- using additional conditions
SELECT Employees.employee_id, Employees.first_name, Employees.department_id,
       Departments.department_id, Departments.department_name
FROM Employees, Departments
WHERE Employees.department_id = Departments.department_id
      AND Employees.department_id > 40
ORDER BY employee_id;
-- using table Alias
SELECT Emp.employee_id, Emp.first_name, Emp.department_id,
       Dept.department_name
FROM   Employees Emp, Departments Dept
WHERE  Emp.department_id = Dept.department_id
ORDER BY employee_id;

-- joining more than 2 tables
SELECT Emp.employee_id, Emp.first_name, Emp.department_id,
       Dept.department_name, Dept.location_id,
       Loc.city
FROM Employees Emp, Departments Dept, Locations Loc
WHERE Emp.department_id = Dept.department_id 
      AND Dept.location_id = Loc.location_id
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
VALUES ('A', 3000, 5999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('A', 6000, 9999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('A', 10000, 14999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('A', 15000, 24999);
INSERT INTO Job_grades (grade_level, lowest_sal, highest_sal)
VALUES ('A', 25000, 40000);

COMMIT;

SELECT *
FROM Job_grades;

SELECT Emp.employee_id, Emp.first_name, Emp.salary,
       Grades.grade_level
FROM   Employees Emp, Job_grades Grades
WHERE  Emp.salary BETWEEN Grades.lowest_sal AND Grades.highest_sal;