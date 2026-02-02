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

