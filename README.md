# SQL-Course-Project
## Introduction
In preparation for transitioning into data analytics I've completed this course project! It has not only helped me gain and improve on the skills I need to become a data analyst, but it provided great insight into the the job market for data analyst. This includes the most prodominant skills requested of data analyst and what combination of skills will increase a data analyst's market appeal.

To see my queries please click here!

## Background
The purpose of this project was to properly evaluate the job market for those who want to get into data. Since it's my goal to become a data analyst I decided to focus my insights around this position. In doing so I aimed to answer the following questions:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. What skills are asscociated with higher salaries?
5. What are the msot optimal skills to learn for a data analyst looking to maximize job market value?

In order to conduct this analyst I used to the data provided by Luke Barouse's SQL course. The data comprised of job posting data from 2023 including: job titles, location, remote availability, required skills, and more.

## Languages and Tools I Used
In order to complete this project I used the following tools:
- **SQL:** This language allowed me to create insert my data into a database, and then query that data to gain insights.

- **PostgreSQL:** This database management system allowed me to store all of my data.

- **Visual Studio Code:** This code editor allowed for me to connect and query into my database.

## The Analysis
### 1. What are the top-paying data analyst jobs?
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

### 5. What are the msot optimal skills to learn for a data analyst looking to maximize job market value?
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

## What I Learned
## Conclustions
