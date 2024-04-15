-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
CREATE PROCEDURE CalculateAverageSalary(IN department_id_param INT)
BEGIN
    -- Procedure to calculate the average salary of employees in a given department
    SELECT AVG(salary) AS average_salary
    FROM employees
    WHERE department_id = department_id_param;
END;

CREATE PROCEDURE UpdateSalaryByPercentage(IN emp_id_param INT, IN percentage DECIMAL(5,2))
BEGIN
    -- Procedure to update the salary of an employee by a specified percentage
    UPDATE employees
    SET salary = salary * (1 + percentage / 100)
    WHERE emp_id = emp_id_param;
END;

CREATE PROCEDURE ListEmployeesInDepartment(IN department_id_param INT)
BEGIN
    -- Procedure to list all employees in a given department
    SELECT *
    FROM employees
    WHERE department_id = department_id_param;
END;

CREATE PROCEDURE CalculateProjectBudget(IN project_id_param INT)
BEGIN
    -- Procedure to calculate the total budget allocated to a specific project
    SELECT budget
    FROM projects
    WHERE project_id = project_id_param;
END;

CREATE PROCEDURE FindHighestPaidEmployee(IN department_id_param INT)
BEGIN
    -- Procedure to find the employee with the highest salary in a given department
    SELECT *
    FROM employees
    WHERE department_id = department_id_param
    ORDER BY salary DESC
    LIMIT 1;
END;

CREATE PROCEDURE ListProjectsEndingWithin(IN days INT)
BEGIN
    -- Procedure to list all projects that are due to end within a specified number of days
    SELECT *
    FROM projects
    WHERE DATEDIFF(end_date, CURDATE()) <= days;
END;

CREATE PROCEDURE CalculateDepartmentSalaryExpenditure(IN department_id_param INT)
BEGIN
    -- Procedure to calculate the total salary expenditure for a given department
    SELECT SUM(salary) AS total_salary_expenditure
    FROM employees
    WHERE department_id = department_id_param;
END;

CREATE PROCEDURE GenerateEmployeeReport()
BEGIN
    -- Procedure to generate a report listing all employees along with their department and salary details
    SELECT e.first_name, e.last_name, e.salary, d.department_name
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id;
END;

CREATE PROCEDURE FindProjectWithHighestBudget()
BEGIN
    -- Procedure to find the project with the highest budget
    SELECT *
    FROM projects
    ORDER BY budget DESC
    LIMIT 1;
END;

CREATE PROCEDURE CalculateOverallAverageSalary()
BEGIN
    -- Procedure to calculate the average salary of employees across all departments
    SELECT AVG(salary) AS overall_average_salary
    FROM employees;
END;

CREATE PROCEDURE AssignNewManager(IN department_id_param INT, IN new_manager_id INT)
BEGIN
    -- Procedure to assign a new manager to a department and update the manager_id in the departments table
    UPDATE departments
    SET manager_id = new_manager_id
    WHERE department_id = department_id_param;
END;

CREATE PROCEDURE CalculateRemainingBudget(IN project_id_param INT)
BEGIN
    -- Procedure to calculate the remaining budget for a specific project
    DECLARE total_budget DECIMAL(10,2);
    DECLARE total_expenses DECIMAL(10,2);
    DECLARE remaining_budget DECIMAL(10,2);
    
    SELECT budget INTO total_budget
    FROM projects
    WHERE project_id = project_id_param;
    
    SELECT SUM(salary) INTO total_expenses
    FROM employees
    WHERE department_id IN (
        SELECT department_id
        FROM enrollments
        WHERE course_id = course_id_param
    );
    
    SET remaining_budget = total_budget - total_expenses;
    
    SELECT remaining_budget;
END;

CREATE PROCEDURE GenerateEmployeeReportByYear(IN join_year INT)
BEGIN
    -- Procedure to generate a report of employees who joined the company in a specific year
    SELECT *
    FROM employees
    WHERE YEAR(join_date) = join_year;
END;

CREATE PROCEDURE UpdateProjectEndDate(IN project_id_param INT, IN duration INT)
BEGIN
    -- Procedure to update the end date of a project based on its start date and duration
    UPDATE projects
    SET end_date = DATE_ADD(start_date, INTERVAL duration DAY)
    WHERE project_id = project_id_param;
END;

CREATE PROCEDURE CalculateEmployeeCountPerDepartment()
BEGIN
    -- Procedure to calculate the total number of employees in each department
    SELECT d.department_name, COUNT(e.emp_id) AS employee_count
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
    GROUP BY d.department_name;
END;
