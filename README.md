# HR Attrition Analysis

## Project Overview

This project focuses on analyzing employee attrition using a structured dataset of more than 10,000 employees. The goal is to identify key factors driving employee turnover and provide actionable business insights to improve retention.
The project covers the entire data analysis pipeline from raw data handling and cleaning in MySQL Workbench to building an interactive dashboard in Power BI.

## Objectives

- Understand overall attrition trends
- Identify key drivers of employee turnover
- Analyze impact of factors like:
    - Work-life balance
    - Job satisfaction
    - Overtime
    - Business travel
    - Distance from home
- Provide data-driven recommendations for HR decision-making

## Tools & Technologies

- SQL (MySQL)
- Power BI
- Data Cleaning & Transformation
- Data Visualization
- Business Analysis

## Dataset Description

- Raw data: Contains missing values and duplicates
- Processed data: Cleaned dataset for analysis
- Key Features:
    - Demographics (Age, Gender)
    - Job-related (Role, Department, Salary)
    - Behavioral (Work-life balance, Job satisfaction, Overtime)
    - Experience (Years at company, Role tenure)
    - Target Variable: Attrition (Yes/No)

## Project Workflow

### Data Preparation

- Imported dataset into MySQL
- Created structured database and tables

### Data Cleaning & Transformation (SQL)

- Removed duplicates
- Handled missing values
- Removed/treated inconsistencies
- Fixed logical errors:
    - Experience ≤ Age constraint
    - Years at company ≤ total experience
    - Role tenure ≤ company tenure
    - Promotion years ≤ company tenure
- Created derived features:
    - Tenure Groups
    - Income Levels

### Data Analysis (SQL)

Performed exploratory and analytical queries:

- Overall attrition rate
- Attrition rate by department, role, and income
- Impact of:
    - Work-life balance
    - Job satisfaction
    - Overtime
    - Business travel
    - Distance from home
- Identified patterns and relationships between variables

### Dashboard Development (Power BI)

Built an interactive dashboard including:

- KPIs:
    - Total Employees
    - Active Employees
    - Attrition Count
    - Attrition Rate (~22.47%)
    - Average Salary
    - Average Age

- Visualizations:
    - Attrition distribution (Donut chart)
    - Attrition by Distance from home
    - Attrition rate by Work-Life Balance
    - Attrition rate by Job Satisfaction
    - Attrition rate by Overtime
    - Attrition rate by Business Travel
    - Attrition rate by Job Role

## Key Insights

- High Attrition Rate (~22%)
    - Indicates significant retention challenges
- Distance from home impacts retention
    - Attrition increases rapidly for distance > 10
- Work-Life Balance is the strongest driver
    - Poor balance: ~31% attrition
    - Good balance: ~16% attrition
- Job Satisfaction impacts retention
    - Low satisfaction: ~27% attrition
    - High satisfaction: ~18% attrition
- Overtime increases attrition
    - Employees working overtime show higher attrition rate
- Business Travel has major impact
    - No travel: ~ 18% attrition
    - Frequent travel: ~34% attrition (highest observed)
- Department, Salary, and Role have minimal impact
    - Attrition is consistent across these factors (range < 3%)

## Business Problems Identified

- High Employee Turnover
    - Increased hiring and training costs
- Distance of office from home
    - After a particular distance the attrition is increases rapidly
- Workload & Burnout Issues
    - Poor work-life balance and overtime
- Employee Dissatisfaction
    - Low engagement leading to resignations
- Business Travel Related Stress
    - Frequent business travel significantly increases attrition

## Recommended Solutions

- Improve work-life balance
    - Flexible working hours
    - Remote work options
- Compensation for long distance from home
    - Cab facilities
    - Tavel allowance
- Reduce excessive overtime
    - Better workload distribution
    - Hiring additional resources
- Enhance job satisfaction
    - Employee engagement programs
    - Career growth opportunities
- Optimize business travel policies
    -Reduce unnecessary travel
    - Provide compensation for frequent travelers

## Conclusion

This project demonstrates how data can be used to uncover hidden patterns in employee behavior. The analysis highlights that attrition is primarily driven by employee experience factors rather than salary or role, emphasizing the importance of organizational culture and work environment.

## Author
- Umesh Harsana
- B.Tech, IIT(BHU)
- Aspiring Data Analyst
