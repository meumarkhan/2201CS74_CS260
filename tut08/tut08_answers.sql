-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 
-- Trigger to automatically increase salary by 10% for employees whose salary is below ?60000 when a new record is inserted into the employees table
CREATE TRIGGER IncreaseSalaryTrigger BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 60000 THEN
        SET NEW.salary = NEW.salary * 1.10;
    END IF;
END;

-- Trigger to prevent deleting records from the departments table if there are employees assigned to that department
CREATE TRIGGER PreventDeleteTrigger BEFORE DELETE ON departments
FOR EACH ROW
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count FROM employees WHERE department_id = OLD.department_id;
    IF emp_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete department with assigned employees';
    END IF;
END;

-- Trigger to log salary updates into a separate audit table
CREATE TRIGGER SalaryUpdateAuditTrigger AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit (emp_id, old_salary, new_salary, employee_name, update_date)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary, CONCAT(NEW.first_name, ' ', NEW.last_name), NOW());
END;

-- Trigger to automatically assign a department to an employee based on their salary range
CREATE TRIGGER AssignDepartmentTrigger BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 60000 THEN
        SET NEW.department_id = 3;
    -- Add additional conditions for other salary ranges and corresponding department assignments
    END IF;
END;

-- Trigger to update the salary of the manager (highest-paid employee) in each department whenever a new employee is hired in that department
CREATE TRIGGER UpdateManagerSalaryTrigger AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    UPDATE employees e
    JOIN (
        SELECT department_id, MAX(salary) AS max_salary FROM employees GROUP BY department_id
    ) AS max_salaries ON e.department_id = max_salaries.department_id
    SET e.salary = NEW.salary
    WHERE e.salary = max_salaries.max_salary AND e.department_id = NEW.department_id;
END;

-- Trigger to prevent updating the department_id of an employee if they have worked on projects
CREATE TRIGGER PreventDepartmentUpdateTrigger BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE works_on_count INT;
    SELECT COUNT(*) INTO works_on_count FROM works_on WHERE emp_id = OLD.emp_id;
    IF works_on_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update department for employee with project assignments';
    END IF;
END;

-- Trigger to calculate and update the average salary for each department whenever a salary change occurs
CREATE TRIGGER UpdateAverageSalaryTrigger AFTER INSERT, UPDATE ON employees
FOR EACH ROW
BEGIN
    UPDATE departments d
    SET d.average_salary = (
        SELECT AVG(e.salary) FROM employees e WHERE e.department_id = d.department_id
    );
END;

-- Trigger to automatically delete all records from the works_on table for an employee when that employee is deleted from the employees table
CREATE TRIGGER DeleteWorksOnRecordsTrigger AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    DELETE FROM works_on WHERE emp_id = OLD.emp_id;
END;

-- Trigger to prevent inserting a new employee if their salary is less than the minimum salary set for their department
CREATE TRIGGER PreventSalaryInsertTrigger BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(10,2);
    SELECT MIN(salary) INTO min_salary FROM employees WHERE department_id = NEW.department_id;
    IF NEW.salary < min_salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee salary cannot be less than minimum department salary';
    END IF;
END;

-- Trigger to automatically update the total salary budget for a department whenever an employee's salary is updated
CREATE TRIGGER UpdateBudgetTrigger AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    UPDATE departments d
    SET d.total_salary_budget = (
        SELECT SUM(e.salary) FROM employees e WHERE e.department_id = d.department_id
    );
END;

-- Trigger to send an email notification to HR whenever a new employee is hired
CREATE TRIGGER SendEmailNotificationTrigger AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    -- Code to send email notification to HR
    -- Example: CALL send_email('hr@example.com', 'New Employee Hired', 'A new employee has been hired.');
END;

-- Trigger to prevent inserting a new department if the location is not specified
CREATE TRIGGER PreventDepartmentInsertTrigger BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.location IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Department location must be specified';
    END IF;
END;

-- Trigger to update the department_name in the employees table when the corresponding department_name is updated in the departments table
CREATE TRIGGER UpdateDepartmentNameTrigger AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    UPDATE employees SET department_name = NEW.department_name WHERE department_id = NEW.department_id;
END;

-- Trigger to log all insert, update, and delete operations on the employees table into a separate audit table
CREATE TRIGGER EmployeeAuditTrigger AFTER INSERT, UPDATE, DELETE ON employees
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO employee_audit (action, emp_id, first_name, last_name, salary, department_id, audit_date)
        VALUES ('INSERT', NEW.emp_id, NEW.first_name, NEW.last_name, NEW.salary, NEW.department_id, NOW());
    ELSEIF UPDATING THEN
        INSERT INTO employee_audit (action, emp_id, first_name, last_name, old_salary, new_salary, department_id, audit_date)
        VALUES ('UPDATE', OLD.emp_id, OLD.first_name, OLD.last_name, OLD.salary, NEW.salary, OLD.department_id, NOW());
    ELSEIF DELETING THEN
        INSERT INTO employee_audit (action, emp_id, first_name, last_name, salary, department_id, audit_date)
        VALUES ('DELETE', OLD.emp_id, OLD.first_name, OLD.last_name, OLD.salary, OLD.department_id, NOW());
    END IF;
END;
