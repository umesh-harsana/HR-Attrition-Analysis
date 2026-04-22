-- ==================================================================================================================
-- HR ATTRITION ANALYSIS
-- Author: Umesh Harsana
-- ==================================================================================================================

-- 1. SELECTING DATABASE

USE HR_Project;

-- ------------------------------------------------------------------------------------------------------------------

-- 2. TABLE CREATION

CREATE TABLE hr_attrition (
    Employee_ID INT,
    Age INT,
    Attrition VARCHAR(10),
    Business_Travel VARCHAR(50),
    Department VARCHAR(50),
    Distance_From_Home INT,
    Education VARCHAR(50),
    Environment_Satisfaction INT,
    Gender VARCHAR(20),
    Salary INT,
    Job_Involvement INT,
    Job_Level INT,
    Job_Role VARCHAR(50),
    Job_Satisfaction INT,
    Marital_Status VARCHAR(20),
    Number_of_Companies_Worked_previously INT,
    Overtime VARCHAR(10),
    Salary_Hike_in_percent INT,
    Total_working_years_experience INT,
    Work_life_balance INT,
    No_of_years_worked_at_current_company INT,
    No_of_years_in_current_role INT,
    Years_since_last_promotion INT
);

-- -----------------------------------------------------------------------------------------------------------------

-- 3. DATA EXPLORATION

SELECT * FROM hr_attrition LIMIT 5;
SELECT COUNT(*) AS total_rows FROM hr_attrition;

-- -----------------------------------------------------------------------------------------------------------------

-- 4. DATA CLEANING

-- ## CHECKING DUPLICATES

SELECT COUNT(DISTINCT Employee_ID) AS unique_employees FROM hr_attrition;
SELECT Employee_ID, COUNT(*) 
	FROM hr_attrition 
	GROUP BY Employee_ID 
	HAVING COUNT(*) > 1;

-- ## DELETING DUPLICATES

DELETE t1 FROM hr_attrition t1
	JOIN hr_attrition t2
	ON t1.Employee_ID = t2.Employee_ID
	AND t1.Employee_ID > t2.Employee_ID;

-- ## CHECKING MISSING VALUES

SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_nulls,
    SUM(CASE WHEN Salary IS NULL THEN 1 ELSE 0 END) AS Salary_nulls,
    SUM(CASE WHEN Job_Satisfaction IS NULL THEN 1 ELSE 0 END) AS JS_nulls,
    SUM(CASE WHEN Work_life_balance IS NULL THEN 1 ELSE 0 END) AS WLB_nulls
FROM hr_attrition;

-- ## HANDLING MISSING VALUES

-- (using mean value of salary)
UPDATE hr_attrition 
	SET Salary = (SELECT AVG(Salary) FROM hr_attrition)
	WHERE Salary IS NULL;

-- (using median of rating levels)
UPDATE hr_attrition
	SET Job_Satisfaction = 3
	WHERE Job_Satisfaction IS NULL;

UPDATE hr_attrition
	SET Work_life_balance = 3
	WHERE Work_life_balance IS NULL;

-- ## CHECKING DATA CONSISTENCY (eg: MALE/male/Male, yes/y, no/n)

SELECT DISTINCT Gender FROM hr_attrition;
SELECT DISTINCT Overtime FROM hr_attrition;
-- (consistent data)

-- ## CHECKING OUTLIERS

SELECT MAX(Salary), MIN(Salary), AVG(Salary) FROM hr_attrition;
-- (no outliers)
SELECT MAX(Age), MIN(Age) FROM hr_attrition;
SELECT COUNT(*) FROM hr_attrition WHERE Age > 60;
-- (age > 60 for approx 6% so we will not delete this)

-- ## CHECKING LOGICAL CONSISTENCY

SET SQL_SAFE_UPDATES = 0;
-- (to update table)

SELECT COUNT(*)
	FROM hr_attrition
	WHERE No_of_years_in_current_role > No_of_years_worked_at_current_company;
-- (inconsistency found)
UPDATE hr_attrition
	SET No_of_years_in_current_role = No_of_years_worked_at_current_company
	WHERE No_of_years_in_current_role > No_of_years_worked_at_current_company;

SELECT COUNT(*)
	FROM hr_attrition
	WHERE Years_since_last_promotion > No_of_years_worked_at_current_company;
-- (inconsistency found)
UPDATE hr_attrition
	SET Years_since_last_promotion = No_of_years_worked_at_current_company
	WHERE Years_since_last_promotion > No_of_years_worked_at_current_company;

SELECT COUNT(*) FROM hr_attrition WHERE Total_working_years_experience > (Age-18);
-- (inconsistency found)
UPDATE hr_attrition
	SET Total_working_years_experience = Age - 18
	WHERE Total_working_years_experience > (Age - 18);

SELECT COUNT(*)
	FROM hr_attrition
	WHERE No_of_years_worked_at_current_company > Total_working_years_experience;
-- (inconsistency found)
UPDATE hr_attrition
	SET No_of_years_worked_at_current_company = Total_working_years_experience
	WHERE No_of_years_worked_at_current_company > Total_working_years_experience;

SELECT COUNT(*)
	FROM hr_attrition
	WHERE Distance_From_Home < 0;
-- (consistent data)

SELECT COUNT(*)
	FROM hr_attrition
	WHERE Number_of_Companies_Worked_previously < 0;
-- (consistent data)

SELECT COUNT(*)
	FROM hr_attrition
	WHERE Salary_Hike_in_percent < 0 OR Salary_Hike_in_percent > 100;
-- (consistent data)

SELECT Job_Level, MIN(Salary), MAX(Salary), AVG(Salary)
	FROM hr_attrition
	GROUP BY Job_Level;
-- (almost same for all levels showing limitations in dataset)

-- ## FEATURE ENGINEERING

-- ** CREATING COLUMN FOR TENURE GROUP

ALTER TABLE hr_attrition ADD COLUMN Tenure_Group VARCHAR(10);
UPDATE hr_attrition
	SET Tenure_Group =
	CASE
		WHEN No_of_years_worked_at_current_company <= 2 THEN 'New'
		WHEN No_of_years_worked_at_current_company BETWEEN 3 AND 5 THEN 'Mid'
		ELSE 'Senior'
	END;

-- ** CREATING COLUMN FOR INCOME LEVEL

ALTER TABLE hr_attrition ADD COLUMN Income_Level VARCHAR(20);
UPDATE hr_attrition
	SET Income_Level =
	CASE
		WHEN Salary < 70000 THEN 'Low'
		WHEN Salary BETWEEN 70000 AND 150000 THEN 'Medium'
		ELSE 'High'
	END;

SET SQL_SAFE_UPDATES = 1;
-- (for data safety)

-- -----------------------------------------------------------------------------------------------------------------

-- 5. CREATING BACKUP

CREATE TABLE hr_attrition_backup AS 
	SELECT * FROM hr_attrition;

-- -----------------------------------------------------------------------------------------------------------------

-- 6. DATA ANALYSIS

-- ## TOTAL ATTRITION

SELECT Attrition, COUNT(*) AS count
	FROM hr_attrition
    GROUP BY Attrition;

-- ## ATTRITION BY DEPARTMENT

SELECT Department, Attrition, COUNT(*) AS count
	FROM hr_attrition
    GROUP BY Department, Attrition
    ORDER BY Department;
-- (all the departments shows almost same attrition rate, range < 3%)

-- ## ATTRITION BY INCOME LEVEL

SELECT Income_Level, Attrition, COUNT(*) AS count
	FROM hr_attrition
    GROUP BY Income_Level, Attrition
    ORDER BY Income_Level;
-- (all the income levels shows almost same attrition rate, range < 1%)

-- ## ATTRITION BY WORK LIFE BALANCE

SELECT Work_life_balance, Attrition, COUNT(*) AS count
	FROM hr_attrition
	GROUP BY Work_life_balance, Attrition
	ORDER BY Work_life_balance;
-- (employees giving low rating in work life balance have higher attrition rate)

-- ## ATTRITION BY JOB SATISFACTION

SELECT Job_Satisfaction, Attrition, COUNT(*) AS count
	FROM hr_attrition
	GROUP BY Job_Satisfaction, Attrition
	ORDER BY Job_Satisfaction;
-- (employees giving low rating in work life balance have higher attrition rate)

-- ## ATTRITION BY OVERTIME

SELECT Overtime, Attrition, COUNT(*) AS count
	FROM hr_attrition
	GROUP BY Overtime, Attrition
	ORDER BY Overtime;
-- (employees working overtime have higher attrition rate)

-- ## ATTRITION BY TENURE GROUP

SELECT Tenure_Group, Attrition, COUNT(*) AS count
	FROM hr_attrition
	GROUP BY Tenure_Group, Attrition
	ORDER BY Tenure_Group;
-- (employees from all tenure groups have almost same attrition rate, range < 1%)

-- ## ATTRITION BY BUSINESS TRAVEL FREQUENCY
SELECT Business_Travel, Attrition, COUNT(*) AS count
	FROM hr_attrition
    GROUP BY Business_Travel, Attrition
    ORDER BY Business_Travel;
-- (employees with high travel frequency have higher attrition rate)

-- ## AVERAGE SALARY OF ATTRITION AND CURRENT EMPLOYEES

SELECT Attrition, AVG(Salary) AS avg_salary
	FROM hr_attrition
	GROUP BY Attrition;
-- (average salary is almost same for both)

-- ## TOP 5 ATTRITION FROM MULTIPLE FACTORS: DEPARTMENT, INCOME LEVEL, OVERTIME

SELECT Department, Income_Level, Overtime, COUNT(*) AS attrition_count
	FROM hr_attrition
    WHERE Attrition = 'Yes'
    GROUP BY Department, Income_Level, Overtime
    ORDER BY attrition_count DESC
    LIMIT 5;

-- -----------------------------------------------------------------------------------------------------------------