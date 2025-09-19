SELECT 
    sd.skill_id,
    sd.skills AS skill_name,
    COUNT(*) AS skill_count
FROM 
    skills_dim sd
INNER JOIN skills_job_dim sjd ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact j ON sjd.job_id = j.job_id
WHERE 
     j.job_work_from_home = 'True' AND 
     j.job_title_short = 'Data Analyst'
GROUP BY 
    sd.skill_id , sd.skills
ORDER BY 
    skill_count DESC
LIMIT 5