-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/


CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);


CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" VARCHAR   NOT NULL,
    "to_date" VARCHAR   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Creating employee details view which includes : employee number, last name, first name, gender, and salary.


CREATE VIEW e_details AS
SELECT employees.emp_no, employees.last_name,employees.first_name,employees.gender,salaries.salary
FROM employees, salaries
WHERE employees.emp_no = salaries.emp_no;
-- I know we should delete the SELECT * lines so as to not show code we use for our own verification but if you want to see it quick I left it in for you
SELECT * FROM e_details


-- creating a list of employees who were hired in 1986.
CREATE VIEW hired_1986 AS
SELECT * FROM employees
WHERE hire_date LIKE '1986%';

SELECT * FROM hired_1986

-- Creating a view to List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

CREATE VIEW manager_list AS
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm ON
dm.dept_no = d.dept_no
JOIN employees AS e ON
e.emp_no = dm.emp_no;

SELECT * FROM manager_list

--creating a view for the department of each employee with the following information: employee number, last name, first name, and department name.
CREATE VIEW department_of_employee AS
SELECT e.emp_no, e.last_name, e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON
e.emp_no = de.emp_no
INNER JOIN departments AS dp ON
dp.dept_no = de.dept_no;

SELECT * FROM department_of_employee

-- Creating a view for the employees whose first name is "Hercules" and last names begin with "B."

CREATE VIEW Hercules_B AS
SELECT * FROM employees
WHERE first_name='Hercules'
AND last_name LIKE 'B%';

SELECT * FROM Hercules_B

-- Creating a view for all employees in the Sales department, including their employee number, last name, first name, and department name.
CREATE VIEW sales_employees AS
SELECT e.emp_no, e.last_name, e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON
e.emp_no = de.emp_no
INNER JOIN departments AS dp ON
dp.dept_no = de.dept_no
WHERE dp.dept_name = 'Sales';

SELECT * FROM sales_employees

-- Creating a List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE VIEW sales_development_employees AS
SELECT e.emp_no, e.last_name, e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON
e.emp_no = de.emp_no
INNER JOIN departments AS dp ON
dp.dept_no = de.dept_no
WHERE dp.dept_name = 'Development'
OR dp.dept_name = 'Sales';

SELECT * FROM sales_development_employees


-- Creating a view of In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

CREATE VIEW last_name_desc AS
SELECT last_name, COUNT(last_name) AS "count"
FROM employees
GROUP BY last_name
ORDER BY "count" DESC;

SELECT * FROM last_name_desc
