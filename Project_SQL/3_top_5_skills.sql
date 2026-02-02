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