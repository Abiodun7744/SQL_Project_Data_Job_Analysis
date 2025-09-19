SELECT 
     skills,
     ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
     job_postings_fact j 
INNER JOIN skills_job_dim sjd ON j.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
     j.job_title_short = 'Data Analyst' AND
     j.salary_year_avg IS NOT NULL 
GROUP BY
     skills
ORDER BY
     avg_salary DESC 
LIMIT 25