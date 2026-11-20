/* ================================================================
   CIS 4720  Normalization Lab
   Starter file: normalization_lab_starter.sql

   Name: ______________________________
   Date: ______________________________

   Work in this file and keep its name. It lives in your OneDrive
   folder CIS4720_Normalization, and it is the one file you publish
   to GitHub at the end.

   Write a comment in your own words above every statement.
   Total: 10 points.

   For EVERY problem below, complete all five steps:

     Step 1  DIAGNOSE  Which normal form (1NF, 2NF, or 3NF) does the
                       table break? Why? Name the columns involved.
     Step 2  DESIGN    List your new tables. Mark the primary key (PK)
                       and every foreign key (FK).
     Step 3  CREATE    Write a CREATE TABLE statement for each table,
                       with PRIMARY KEY and FOREIGN KEY constraints.
                       Create parent tables before child tables.
     Step 4  INSERT    Insert at least TWO rows into EVERY table.
                       Insert parent rows before child rows.
     Step 5  JOIN      Write one SELECT with JOINs that shows the data
                       from all of the problem's tables together.

   Use ONLY the table names given in each problem.
   The whole file must run from top to bottom without errors.
   ================================================================ */

CREATE DATABASE IF NOT EXISTS misc_db;
USE misc_db;


/* ================================================================
   PROBLEM 1  Pet owners and their pets                 (2 points)
   ================================================================

   A pet grooming shop keeps one table named owner_pets:

     owner_id, owner_name, owner_city, pet1_name, pet2_name, pet3_name

   Sample rows:

   owner_id | owner_name   | owner_city | pet1_name | pet2_name | pet3_name
   =========+==============+============+===========+===========+==========
   1        | Maria Lopez  | Turlock    | Bella     | Max       | NULL
   2        | James Chen   | Modesto    | Luna      | NULL      | NULL
   3        | Priya Singh  | Ceres      | Rocky     | Daisy     | Coco

   The shop just signed up a customer with four pets.

   Use these table names:  owner, pet

   Step 1  DIAGNOSE:
   --this table breaks 1NF as it contains repeating groups and it limits the amount of pets a person can have. 
   Step 2  DESIGN:
-- owner table
-- primary key: owner_id | owner_name   | owner_city 
--pet table
--primary key: pet_id| pet_name   | owner_id
*/

/* Step 3  CREATE */
--creating the owner table with owner_id as primary key
create table IF NOT EXISTS owner(
   owner_id int primary key,
   owner_name varchar(25) not null,
   owner_city varchar(25) not null
);
--creating the pet table
create table if not exists pet(
   pet_id int primary key,
   pet_name varchar(25) not null,
   owner_id int not null,
   foreign key (owner_id) references owner(owner_id)
);

/* Step 4  INSERT */
--insertig the data from the example into the owner table
insert into owner(owner_id, owner_name, owner_city) values
(1, 'Maria Lopez', 'Turlock'),
(2, 'James Chen', 'Modesto'),
(3, 'Priya Singh', 'Ceres');
--insertig the data from the example into the pet table
insert into pet(pet_id, pet_name, owner_id) values
(1, 'Bella', 1),
(2, 'Max', 1),
(3, 'Luna', 2),
(4, 'Rocky', 3),
(5, 'Daisy', 3),
(6, 'Coco', 3);

/* Step 5  JOIN */
-- join that retreives owner details
select o.owner_id, o.owner_name, o.owner_city, p.pet_name
from owner o
join pet p ON o.owner_id = p.owner_id;

/* ================================================================
   PROBLEM 2  Apartment buildings and units             (2 points)
   ================================================================

   A property manager keeps one table named building_unit.
   Unit numbers repeat across buildings (every building has a 101),
   so the primary key is (building_id, unit_number).

     building_id, unit_number, building_name, building_address,
     bedrooms, monthly_rent

   Sample rows:

   building_id | unit_number | building_name | building_address  | bedrooms | monthly_rent
   ============+=============+===============+===================+==========+=============
   B1          | 101         | Oak Terrace   | 100 Oak St        | 1        | 1250.00
   B1          | 102         | Oak Terrace   | 100 Oak St        | 2        | 1600.00
   B2          | 101         | Canal Court   | 45 Canal Dr       | 2        | 1550.00
   B2          | 201         | Canal Court   | 45 Canal Dr       | 3        | 1900.00

   Hint: look at which columns need BOTH key columns and which
   need only one of them.

   Use these table names:  building, apartment_unit

   Step 1  DIAGNOSE:
--breaks 2nf rules as there is a partial dependency with building_id and building_name 

   Step 2  DESIGN:
--building: primary key: building_id, building_name, building_address
--apartment_unit: primary key: building_ida and unit_number, foreign key: building_id, bedrooms, monthly_rent)

*/

/* Step 3  CREATE */
--creating building table
create table if not exists building(
    building_id varchar(5) primary key,
    building_name VARCHAR(50) not null,
    building_address VARCHAR(100) not null
);
--creating apartment_unit table
create table if not exists apartment_unit(
   building_id varchar(5),
   unit_number int,
   bedrooms int not null,
   monthly_rent decimal(7,2) not null,
   primary key (building_id, unit_number),
   foreign key (building_id) references building(building_id)
);
/* Step 4  INSERT */
--inserting the example table data into the new building table
insert into building (building_id, building_name, building_address) values
('B1', 'Oak Terrace', '100 Oak St'),
('B2', 'Canal Court', '45 Canal Dr');

--inserting the example table data into the new apartment_unit table
insert into apartment_unit (building_id, unit_number, bedrooms, monthly_rent) values
('B1', 101, 1, 1250.00),
('B1', 102, 2, 1600.00),
('B2', 101, 2, 1550.00),
('B2', 201, 3, 1900.00);

/* Step 5  JOIN */
--join that returns building_id,name,address and unit_number, bedrooms, monthly_rent
select b.building_id, b.building_name, b.building_address, u.unit_number, u.bedrooms, u.monthly_rent
from building b
join apartment_unit u on b.building_id = u.building_id;

/* ================================================================
   PROBLEM 3  Employees and departments                 (2 points)
   ================================================================

   A company keeps one table named employee_info.
   The primary key is emp_id.

     emp_id, emp_name, hire_year, dept_id, dept_name, dept_phone

   Sample rows:

   emp_id | emp_name      | hire_year | dept_id | dept_name  | dept_phone
   =======+===============+===========+=========+============+=============
   E01    | Linda Park    | 2019      | D10     | Accounting | 209.555.0300
   E02    | Raj Mehta     | 2021      | D20     | Marketing  | 209.555.0400
   E03    | Carlos Vega   | 2022      | D10     | Accounting | 209.555.0300
   E04    | Emma Wilson   | 2024      | D20     | Marketing  | 209.555.0400

   Accounting gets a new phone number. How many rows must change?
   What happens to the Marketing department if Raj and Emma both quit?

   Use these table names:  department, employee

   Step 1  DIAGNOSE:
--this current table setup breaks 3NF rules as dept_name/phone rely on non-key information instead of the primary key.

   Step 2  DESIGN:
--department: primary key: dept_id, dept_name, dept_phone
--employee: primary key: emp_id, emp_name, hire_year, foreign key: dept_id
*/

/* Step 3  CREATE */
--creating department table
create table if not exists department (
    dept_id varchar(5) primary key,
    dept_name varchar(50) not null,
    dept_phone varchar(20) not null
);

--creating employee table
create table if not exists employee (
    emp_id varchar(5) primary key,
    emp_name varchar(50) not null,
    hire_year int not null,
    dept_id varchar(5) not null,
    foreign key (dept_id) references department(dept_id)
);

/* Step 4  INSERT */
--inserting the example department data into the new department table
insert into department (dept_id, dept_name, dept_phone) values
('D10', 'Accounting', '209.555.0300'),
('D20', 'Marketing', '209.555.0400');
--inserting the employee example table into the new employee table
insert into employee (emp_id, emp_name, hire_year, dept_id) values
('E01', 'Linda Park', 2019, 'D10'),
('E02', 'Raj Mehta', 2021, 'D20'),
('E03', 'Carlos Vega', 2022, 'D10'),
('E04', 'Emma Wilson', 2024, 'D20');

/* Step 5  JOIN */
-- a join that returns emp_id, emp_name, hire_year, dept_id, dept_name, and dept_phone
select e.emp_id, e.emp_name, e.hire_year, d.dept_id, d.dept_name, d.dept_phone
from employee e
join department d on e.dept_id = d.dept_id;


/* ================================================================
   PROBLEM 4  Students and courses                     (2.5 points)
              This problem REQUIRES a bridge table with a
              composite primary key.
   ================================================================

   A college keeps one table named student_course.
   One student takes many courses, and one course has many students.

     student_id, student_name, student_major, course_id,
     course_name, course_description, units, grade

   Sample rows:

   student_id | student_name | student_major | course_id | course_name        | course_description                 | units | grade
   ===========+==============+===============+===========+====================+====================================+=======+======
   S100       | Ana Torres   | CIS           | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | A
   S100       | Ana Torres   | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | B
   S200       | Ben Shah     | Business      | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | B
   S300       | Chloe Nguyen | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | A

   Questions to think about:
     Which columns describe only the STUDENT?
     Which columns describe only the COURSE?
     Which column describes "this student in this course"?

   Use these table names:  student, course, enrollment
   enrollment is the bridge table. Its primary key must be the
   composite key (student_id, course_id), and each of those columns
   must also be a foreign key.

   Step 1  DIAGNOSE:
--This example breaks 1nf rules as its a many to many relationship thats in the same table, resulting in dependencies.

   Step 2  DESIGN:
Step 2  DESIGN:
   - student: primary key: student_id, student_name, student_major
   - course: primary key: course_id, course_name, course_description, units
   - enrollment: primary key: student_id and course_id, foreign key: student_id, course_id, grade

*/

/* Step 3  CREATE */
--creating student table
create table if not exists student (
    student_id varchar(5) primary key,
    student_name varchar(50) not null,
    student_major varchar(30) not null
);

-- creating course talbe
create table if not exists course (
    course_id varchar(10) primary key,
    course_name varchar(50) not null,
    course_description varchar(150) not null,
    units int not null
);
--creating enrollment table
create table if not exists enrollment (
    student_id varchar(5),
    course_id varchar(10),
    grade varchar(2) not null,
    primary key (student_id, course_id),
    foreign key (student_id) references student(student_id),
    foreign key (course_id) references course(course_id)
);
/* Step 4  INSERT
   Enroll at least one student in two courses, and put at least two
   students in the same course, so the many to many relationship shows. */
-- inserting student information
insert into student (student_id, student_name, student_major) values
('S100', 'Ana Torres', 'CIS'),
('S200', 'Ben Shah', 'Business'),
('S300', 'Chloe Nguyen', 'CIS');

--inserting course information
insert into course (course_id, course_name, course_description, units) values
('CIS4720', 'Database Mgmt', 'Relational design and SQL', 3),
('CIS2000', 'Intro to Python', 'Programming fundamentals in Python', 3);

--inserting enrollment information and to show the many-to-many relationship
insert into enrollment (student_id, course_id, grade) values
('S100', 'CIS4720', 'A'),
('S100', 'CIS2000', 'B'),
('S200', 'CIS4720', 'B'),
('S300', 'CIS2000', 'A');

/* Step 5  JOIN  (three tables: student, enrollment, course) */
--join that returns the student_id, student_name, student_major, course_id, course_name, course_description, units and grades.
--also shows the many to many relationship
select s.student_id, s.student_name, s.student_major, c.course_id, c.course_name, c.course_description, c.units, e.grade
from student s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id;