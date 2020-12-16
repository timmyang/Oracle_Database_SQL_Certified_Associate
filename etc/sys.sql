--1
SHOW con_name;

--2
SELECT name, con_id
FROM v$pdbs;

--3
Alter session set container=orclpdb;

--4
SHOW con_name;

--5
SELECT name, open_mode
FROM v$pdbs;

--6
ALTER PLUGGABLE DATABASE open;

--7
SELECT *
FROM all_users;

--8
ALTER USER hr identified by hr account unlock;