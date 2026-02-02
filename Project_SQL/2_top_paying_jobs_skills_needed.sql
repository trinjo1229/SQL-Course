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

SELECT 
    top_10_jobs.job_id,
    top_10_jobs.job_title,
    top_10_jobs.salary_year_avg,
    job_to_skills.skills
FROM
    top_10_jobs
INNER JOIN
    job_to_skills ON job_to_skills.job_id = top_10_jobs.job_id