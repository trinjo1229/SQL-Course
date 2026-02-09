# SQL-For-Data-Analytics-Course-Project
## Introduction
In preparation for transitioning into data analytics, I've completed this course project! It has not only helped me gain and improve the skills I need to become a data analyst, but it provided great insight into the job market for data analyst. This includes the most predominant skills requested of data analyst and what combination of skills will increase a data analyst's market appeal.

To see my queries please click here!

## Background
The purpose of this project was to properly evaluate the job market for those who want to get into data. Since it's my goal to become a data analyst I decided to focus my insights around this position. In doing so I aimed to answer the following questions:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. What skills are asscociated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

In order to conduct this analysis I used data provided by Luke Barouse's SQL course. The data comprised of job posting data from 2023 including: job titles, location, remote availability, required skills, and more.

## Languages and Tools I Used
In order to complete this project I used the following tools:
- **SQL:** This language allowed me to create and insert my data into a database, and then query that data to gain insights.

- **PostgreSQL:** This database management system allowed me to store all of my data.

- **Visual Studio Code:** This code editor allowed for me to connect to and query into my database.

## The Analysis
### 1. What are the top-paying data analyst jobs?
I found the top 10 remote Data Analyst positions available and their respective salaries.
```
SELECT 
    job_id,
    company_dim.name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10
```

### 2. What skills are required for these top-paying jobs?
By joining the job postings and skills tables, I was able to identify the skills are associated with the highest compensated positions.
```
-- Find top 10 paying remote jobs 
WITH top_10_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
),

-- Find what skills are ass. with each job posting
job_to_skills AS (
    SELECT
        skills_dim.skill_id,
        skills,
        job_id
    FROM
        skills_dim
    INNER JOIN
        skills_job_dim ON skills_job_dim.skill_id = skills_dim.skill_id
)

-- Find average salary and skills needed for top 10 positions
SELECT 
    top_10_jobs.job_id,
    top_10_jobs.job_title,
    top_10_jobs.salary_year_avg,
    job_to_skills.skills
FROM
    top_10_jobs
INNER JOIN
    job_to_skills ON job_to_skills.job_id = top_10_jobs.job_id
```

### 3. What skills are most in demand for data analysts?
To gain insight on what skills to acquire as a Data Analyst, I identified the 5 most requested skills across all job postings.
```
-- Find all skills ass. with each job
WITH jobs_and_skills AS (
    SELECT 
        job_postings_fact.job_id AS jobs,
        skills_job_dim.skill_id as skills
    FROM
        job_postings_fact
    INNER JOIN
        skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE
        job_title_short = 'Data Analyst'
)

-- Find the most in-demand skills
SELECT 
    skills_dim.skills AS skill_name,
    COUNT(DISTINCT jobs) AS job_count
FROM 
    jobs_and_skills
INNER JOIN
    skills_dim ON skills_dim.skill_id = jobs_and_skills.skills
GROUP BY
    skill_name
ORDER BY
    job_count DESC
LIMIT 5
```

### 4. What skills are asscociated with higher salaries?
This query helped identify the most compensated skills assiciated with Data Analysis roles.
```
-- Match skills to jobs to get salary information
WITH skills_and_salary AS(
    SELECT
        skills.skills AS skill_name,
        jobs_w_salary.salary_avg AS salary_avg
    FROM
        skills_job_dim

    INNER JOIN (
        SELECT
            job_id,
            salary_year_avg AS salary_avg
        FROM    
            job_postings_fact
        WHERE
            job_title_short = 'Data Analyst' AND
            salary_year_avg IS NOT NULL
    ) AS jobs_w_salary
    ON jobs_w_salary.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
)

-- Find the average salary per each skill
SELECT 
    skill_name,
    ROUND(AVG(salary_avg),2) AS sal_average
FROM   
    skills_and_salary
GROUP BY 
    skill_name
ORDER BY
    sal_average DESC
```

### 5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?
To maximize a Data Analyst's chances of obtaining a well compensated position, I combined my previous findings to identify skills that are both highly compensated and highly requested. 
```
-- Match skills to jobs to get salary information
WITH skills_job_salary AS(
    SELECT
        skills.skills AS skill_name,
        jobs_w_salary.job_id,
        jobs_w_salary.salary_avg AS salary_avg
    FROM
        skills_job_dim

    INNER JOIN (
        SELECT
            job_id,
            salary_year_avg AS salary_avg
        FROM    
            job_postings_fact
        WHERE
            job_title_short = 'Data Analyst' 
            AND
            salary_year_avg IS NOT NULL
            AND
            job_work_from_home = TRUE
    ) AS jobs_w_salary
    ON jobs_w_salary.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim AS skills ON skills.skill_id = skills_job_dim.skill_id
)

-- Top 10 skills based on demand and salary
SELECT 
    skill_name,
    COUNT(DISTINCT job_id) AS job_count,
    ROUND(AVG(salary_avg),2) AS sal_average
FROM 
    skills_job_salary
GROUP BY
    skill_name
ORDER BY
    job_count DESC, 
    sal_average DESC
LIMIT 10
```

## Insights Learned
1. Top-paying Data Analyst Jobs:

    - The salary range for the highest paying Data Analyst positions is between $135,000 and $650,000. 
2. Skills Required For These Top-paying Jobs:

    - There are many skills required for these top-paying roles, but amongst them skills such as SQL, Tableau, Excel, and Python often repeated.
3. Skills In High Demand:

    - The most requested skills for a Data Analyst included: SQL, Excel, Python, Tableau, and Power BI, in the respective order.
4. Skills Asscociated With Higher Salaries:

    - The top two paying skills include SVN and Solidity. Given their lack of appearance in the top most requested skills list, but their high associated salary, it implies a more niche but highly valued use.
5. Most Optimal Skills to Learn:

    - SQL stands to be the most sought after and relatively well paid skill, cementing that it is a prized skill for Data Analysts to learn.

## Conclusion
This project demonstrates my ability to use SQL to analyze real-world data and extract insights relevant to the data analytics job market. By working with job posting data, I applied core SQL concepts such as joins, aggregations, subqueries, and common table expressions to answer practical business-focused questions.

Through this analysis, I identified in-demand skills, salary trends, and how specific technical skills correlate with higher compensation. Overall, this project showcases my proficiency in SQL, my analytical thinking, and my ability to turn raw data into actionable insights — skills directly applicable to a data analyst role.
