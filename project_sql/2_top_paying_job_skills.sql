WITH top_paying_jobs AS (
    SELECT 
       j.job_id,
       job_title,
       salary_year_avg,
       name AS company_name
    FROM 
       job_postings_fact j
    LEFT JOIN company_dim c ON j.company_id = c.company_id
    WHERE 
       job_title_short = 'Data Analyst' AND 
       job_location = 'Anywhere' AND 
       salary_year_avg IS NOT NULL 
    ORDER BY 
       salary_year_avg DESC
    LIMIT 10 
)

SELECT 
     t.*,
     skills
FROM top_paying_jobs t
INNER JOIN skills_job_dim sjd ON t.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY 
      salary_year_avg
