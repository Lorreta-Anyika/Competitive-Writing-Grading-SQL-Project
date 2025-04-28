# Competitive Writing & Grading SQL Project

## Project Overview
**Project Title:** Competitive Writing & Grading Analysis  
**Level:** Intermediate  
**Database:** COMPETITIVE_GRADING

This project explores the grading and evaluation of candidates during a competitive writing recruitment process. Using SQL, we perform data retrieval, cleaning, analysis, ranking, and reporting to understand candidates’ performance across metrics such as content, structure, style, mechanics, penalties, and departmental distribution.

It is ideal for analysts seeking to practice intermediate SQL concepts such as filtering, aggregation, window functions, and view creation.
![image](https://github.com/user-attachments/assets/3175a5de-2225-4f6b-9004-49ebd03dfe3d)

---

## Objectives
- Set up the `COMPETITIVE_GRADING` database and load candidate evaluation data.
- Retrieve and explore candidate assessment records.
- Analyze penalties, improvements, and departmental strengths.
- Create rankings and reusable views for reporting and insights.

---

## Project Structure

### 1. Database Setup
```sql
DROP DATABASE IF EXISTS COMPETITIVE_GRADING;
CREATE DATABASE COMPETITIVE_GRADING;
USE COMPETITIVE_GRADING;
```
Dataset: **uneg recruitment 2024&2025** with 28 candidates across various departments.

---

## 2. Data Exploration & Basic Retrieval

### 2.1 List all candidates and their departments
```sql
SELECT Name, Department
FROM `uneg recruitment 2024&2025`;
```

### 2.2 Retrieve the top 10 candidates based on Net Average Score (`Net_Avg`)
```sql
SELECT Name, `Net_Avg(100%)`
FROM `uneg recruitment 2024&2025`
ORDER BY `Net_Avg(100%)` DESC
LIMIT 10;
```
**Top 3 Candidates:**
- Alice Thompson: 88.0
- Daniel Evans: 87.0
- Benjamin Parker: 87.5

### 2.3 Find all candidates from the Pharmacy department
```sql
SELECT Name, Department
FROM `uneg recruitment 2024&2025`
WHERE Department = 'Pharmacy';
```
**Pharmacy Candidates:** 6 candidates.

### 2.4 Show candidates who scored above 25 in Content_A
```sql
SELECT Name, `Content_A (30%)`
FROM `uneg recruitment 2024&2025`
WHERE `Content_A (30%)` > 25;
```
**Candidates:** 7 candidates scored above 25.

### 2.5 Display the names and departments of candidates who had no penalty
```sql
SELECT Name, Department, `Net_Avg(100%)`, Penalty_A, Penalty_B, Penalty_Avg 
FROM `uneg recruitment 2024&2025`
WHERE Penalty_A = 0 AND Penalty_B = 0 AND Penalty_Avg = 0;
```
**Candidates with no penalty:** 1 candidate.

### 2.6 Find the number of candidates assessed
```sql
SELECT COUNT(*) 
FROM `uneg recruitment 2024&2025`;
```
**Total candidates:** 28

### 2.7 Show all candidates whose Mechanics_AVG is above 15
```sql
SELECT Name, `Mechanics_Avg (20%)`
FROM `uneg recruitment 2024&2025`
WHERE `Mechanics_Avg (20%)` > 15;
```
**Candidates:** 15 candidates have Mechanics average > 15.

---

## 3. Filtering and Conditional Queries

### 3.1 List departments and how many candidates came from each
```sql
SELECT Department, COUNT(*) AS Stud
FROM `uneg recruitment 2024&2025`
GROUP BY Department;
```
**Top Department:**
- Pharmacy: 6 candidates

### 3.2 Retrieve candidates with negative penalty (Penalty_Avg < 0)
```sql
SELECT Name, Penalty_Avg
FROM `uneg recruitment 2024&2025`
WHERE Penalty_Avg < 0;
```
**Candidates with penalties:** 27 candidates.

### 3.3 Display candidates who scored above 80 in their Net_Avg
```sql
SELECT Name, `Net_Avg(100%)`
FROM `uneg recruitment 2024&2025`
WHERE `Net_Avg(100%)` > 80;
```
**High Scorers:** 6 candidates.

### 3.4 Find candidates whose Content_A score is greater than Structure_A score
```sql
SELECT Name
FROM `uneg recruitment 2024&2025`
WHERE `Content_A (30%)` > `Structure_A (20%)`;
```
**Candidates:** 27 candidates have better Content_A scores.

---

## 4. Aggregations and Group Analysis

### 4.1 Calculate the overall average of Content_Avg, Structure_Avg, Style_Avg, and Mechanics_Avg
```sql
SELECT Name, 
(`Content_Avg (30%)` + `Structure_Avg (20%)` + `Style_Avg (30%)` + `Mechanics_Avg (20%)`) / 4 AS Overall_Avg
FROM `uneg recruitment 2024&2025`;
```

### 4.2 Group candidates by Department and compute average Net_Avg
```sql
SELECT Department, AVG(`Net_Avg(100%)`) AS Net_avg_Score
FROM `uneg recruitment 2024&2025`
GROUP BY Department;
```
**Top Department by Avg Net_Avg:**
- Electrical engineering: ~87.5

### 4.3 Identify departments with average Net_Avg greater than 85
```sql
SELECT Department, AVG(`Net_Avg(100%)`) AS Net_avg_Score
FROM `uneg recruitment 2024&2025`
GROUP BY Department
HAVING AVG(`Net_Avg(100%)`) > 85;
```
**Departments:** 
- Electrical Engineering: 87.5
- Biomedical Engineering: 86.5

---

## 5. Ranking and Advanced Filters

### 5.1 Rank candidates based on Net_Avg
```sql
SELECT Name, `Net_Avg(100%)`, ROW_NUMBER() OVER (ORDER BY `Net_Avg(100%)` DESC) AS position
FROM `uneg recruitment 2024&2025`;
```

### 5.2 Identify candidates who improved significantly (Content_B > Content_A by at least 5 points)
```sql
SELECT Name, `Content_A (30%)`, `Content_B (30%)`
FROM `uneg recruitment 2024&2025`
WHERE `Content_B (30%)` - `Content_A (30%)` >= 5;
```
**Candidates improved by 5+ points:** 2 candidates.
- Noah Peterson: A-	21, B- 27
- Henry Foster: A- 15, B- 27

### 5.3 Find the candidate with the highest Penalty_B deduction
```sql
SELECT Name, Penalty_B
FROM `uneg recruitment 2024&2025`
ORDER BY Penalty_B
LIMIT 1;
```
**Most penalized:** There is a tie:
- Logan Brooks (-20 points).
- Andrew Simmons: (-20 points).

---

## 6. Calculations and New Metrics

### 6.1 Calculate a new Total_Avg_Score and rank them
```sql
SELECT Name, 
(`Content_Avg (30%)` + `Structure_Avg (20%)` + `Style_Avg (30%)` + `Mechanics_Avg (20%)`) / 4 AS Total_Avg_Score,
ROW_NUMBER() OVER (ORDER BY (`Content_Avg (30%)` + `Structure_Avg (20%)` + `Style_Avg (30%)` + `Mechanics_Avg (20%)`) / 4 DESC) AS Ranking
FROM `uneg recruitment 2024&2025`;
```

### 6.2 Find penalty impact on Net_Avg
```sql
SELECT Name, `Total_Avg(100%)`, `Net_Avg(100%)`,
(`Total_Avg(100%)` - `Net_Avg(100%)`) AS Penalty_Impact
FROM `uneg recruitment 2024&2025`
WHERE `Total_Avg(100%)` <> `Net_Avg(100%)`;
```
---

## 7. Violation Analysis

### 7.1 Display occurrences of violations
```sql
SELECT Violation, COUNT(*) AS Occurrences
FROM (
    SELECT Violations_A AS Violation
    FROM `uneg recruitment 2024&2025`
    WHERE Violations_A IS NOT NULL
    UNION ALL
    SELECT Violations_B AS Violation
    FROM `uneg recruitment 2024&2025`
    WHERE Violations_B IS NOT NULL
) AS All_Violations
GROUP BY Violation
ORDER BY Occurrences DESC;
```
**Most common violations:**
- `E(v)`
---

## 8. Reporting View Creation

### 8.1 Create a reporting view
```sql
CREATE VIEW Candidate_Summary AS
SELECT Name, 
       `Total_Avg(100%)`, 
       `Net_Avg(100%)`, 
       Penalty_Avg,
       `Net_B(100%)`
FROM `uneg recruitment 2024&2025`;
```
Retrieve it with:
```sql
SELECT * FROM Candidate_Summary;
```

---

# 📈 Findings Summary
- **Top Performer:** Alice Thompson
- **Largest Penalty Impact:** Logan Brooks and Andrew Simmons
- **Strongest Department:** Pharmacy (highest participation)
- **Most Common Violation:** `E(v)`, 
---

## 📚 Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, ranking, and business-driven SQL queries.  
The findings from this project help drive better decision-making by understanding competititive writing; thereby showing candidate performance, penalty impacts, departmental strengths, and violation patterns.

---

## 🚀 How to Use
- **Clone the Repository:** Download or clone this project repository from GitHub.
- **Set Up the Database:** Run the SQL scripts provided in the section 1.0 of the `COMPETITIVE WRITING.sql` file to create the database.
- **Download and import dataaset**: Download the 'UNEG RECRUITMENT 2024&2025.csv' file. Import the dataset using the data import wizard in MySQL
- **Run the Queries:** Use the SQL queries provided in the `COMPETITIVE WRITING.sql` file to perform your analysis.
- **Explore and Modify:** Feel free to adjust queries to answer new business questions or perform deeper analysis.

---

## 👨‍💻 Author - Lorreta Anyika @ ALU DATATOK

This project is part of the ALU DATATOK portfolio, showcasing the essential SQL skills every aspiring data analyst should master.  
If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

---

## 🌐 Stay Updated and Join Our Community
For more content on SQL, data analysis, and related fields, connect with ALU DATATOK:

- **YouTube:** [Youtube](https://www.youtube.com/channel/UCQL3Wg_j3D5TWtn6ticnTsg) Subscribe for tutorials and insights
- **LinkedIn:** [LinkedIn](https://www.linkedin.com/in/uchechukwu-lorreta-anyika-7b5b4a253/) Connect professionally
- **WhatsApp:** [WhatsApp](https://chat.whatsapp.com/LhAFCcplWbf0MYfyShJTgf) Gain access to peers and resources

Thank you for your support — we look forward to learning and growing with you! 🚀


