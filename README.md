# Introduction 
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background 
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries ?
5. What are the most optimal skills to learn ?

# Tools I Used 
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analytics, ensuring collaboration and project tracking.

# The Analysis 
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, i filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT 
     j.job_id,
     job_title_short,
     job_title,
     job_location,
     job_schedule_type,
     salary_year_avg,
     job_posted_date,
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000 , indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset. Meta and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](/images/top_paying_roles.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; ChatGPT generated this graph from my SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles. 

```sql
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
      salary_year_avg DESC 
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like **R**, **Snowflake**, **Pandas** and **EXCEL** show varying degrees of demand.

![Top paying skills]()
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
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
```
Here's the breakdown of the most demanded skills for data analysts in 2023:

- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in the data processing and manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skill ID | Skill Name | Skill Count |
|----------|------------|-------------|
| 0        | SQL        | 7291        |
| 181      | Excel      | 4611        |
| 1        | Python     | 4330        |
| 182      | Tableau    | 3745        |
| 183      | Power BI   | 2609        |

*Table of the demnd for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
```
Here's the breakdown for the top paying skills in 2023:

- **SVN** stands out with an extremely high average salary ($400k) — this is likely an outlier or a niche, high-paying role.

- **Solidity** is the top blockchain-related skill, showing strong demand in Web3 and smart contract development.

- **Couchbase, Datarobot, and Golang** highlight high-paying roles in data infrastructure, AI automation, and modern back-end engineering.

- **ML/AI** libraries like Keras, PyTorch, TensorFlow, and Hugging Face are well represented, reflecting the ongoing demand in AI/ML roles.

- Tools related to **DevOps and infrastructure** (e.g., Terraform, Puppet, Ansible, GitLab, Airflow) offer strong salaries, signaling value in deployment and automation skills.

- Collaboration and version control platforms like **GitLab, Bitbucket, and Atlassian** also fetch high compensation, indicating their importance in team workflows.

| Skill          | Average Salary (USD) |
|----------------|----------------------|
| SVN            | 400,000.00           |
| Solidity       | 179,000.00           |
| Couchbase      | 160,515.00           |
| Datarobot      | 155,485.50           |
| Golang         | 155,000.00           |
| MXNet          | 149,000.00           |
| Dplyr          | 147,633.33           |
| VMware         | 147,500.00           |
| Terraform      | 146,733.83           |
| Twilio         | 138,500.00           |
| GitLab         | 134,126.00           |
| Kafka          | 129,999.16           |
| Puppet         | 129,820.00           |
| Keras          | 127,013.33           |
| PyTorch        | 125,226.20           |
| Perl           | 124,685.75           |
| Ansible        | 124,370.00           |
| Hugging Face   | 123,950.00           |
| TensorFlow     | 120,646.83           |
| Cassandra      | 118,406.68           |
| Notion         | 118,091.67           |
| Atlassian      | 117,965.60           |
| Bitbucket      | 116,711.75           |
| Airflow        | 116,387.26           |
| Scala          | 115,479.53           |

*Table of the top paying skills in data analyst job postings*

### 5. Optimal Skills 
This reveals the highest paying and highest demand skills.

```sql
SELECT 
    skills AS skill_name,
    COUNT(*) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact j
INNER JOIN skills_job_dim sjd ON j.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
     j.job_work_from_home = 'True' AND
     j.job_title_short = 'Data Analyst' AND 
     j.salary_year_avg IS NOT NULL 
GROUP BY 
    skills
ORDER BY 
     demand_count DESC,
     avg_salary DESC
LIMIT 25
```
Here's the breakdown for the top paying and top demand skills in 2023:

- **SQL, Excel, and Python** are the most frequently requested skills, reflecting their foundational role in data analysis and business intelligence.
- While some of these high-paying skills have lower demand, they tend to be specialized or technical, like **Go, Hadoop, and Snowflake**.

### 📋 Skill Demand and Average Salary

| Skill Name   | Demand Count | Average Salary (USD) |
|--------------|--------------|-----------------------|
| SQL          | 398          | 97,237                |
| Excel        | 256          | 87,288                |
| Python       | 236          | 101,397               |
| Tableau      | 230          | 99,288                |
| R            | 148          | 100,499               |
| SAS          | 126          | 98,902                |
| Power BI     | 110          | 97,431                |
| PowerPoint   | 58           | 88,701                |
| Looker       | 49           | 103,795               |
| Word         | 48           | 82,576                |
| Snowflake    | 37           | 112,948               |
| Oracle       | 37           | 104,534               |
| SQL Server   | 35           | 97,786                |
| Azure        | 34           | 111,225               |
| AWS          | 32           | 108,317               |
| Sheets       | 32           | 86,088                |
| Flow         | 28           | 97,200                |
| Go           | 27           | 115,320               |
| SPSS         | 24           | 92,170                |
| VBA          | 24           | 88,783                |
| Hadoop       | 22           | 113,193               |
| Jira         | 20           | 104,918               |
| JavaScript   | 20           | 97,587                |
| SharePoint   | 18           | 81,634                |
| Java         | 17           | 106,906               |

*Table of the optimal skills in data analyst job postings*

# What I Learned 

Throughout this adventure, i've turbocharged my SQL toolkit with some serious firepower:

- **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables and wielding WITH clauses.
- **Data Aggregation:** Got more understanding with GROUP BY and aggregate functions like COUNT() and AVG()

# Conclusions

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.