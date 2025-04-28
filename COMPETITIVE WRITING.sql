DROP database IF EXISTS `COMPETITIVE_GRADING`;
CREATE DATABASE `COMPETITIVE_GRADING`;
USE `COMPETITIVE_GRADING`;

SELECT Count(*) FROM `uneg recruitment 2024&2025`;

-- Section 1: Basic Data Retrieval
-- 1. List all candidates and their departments
SELECT * FROM `uneg recruitment 2024&2025`;
SELECT Name, Department
FROM `uneg recruitment 2024&2025`;

-- 2. Retrieve the top 10 candidates based on their average Net score (Net_AVG)
SELECT Name, `Net_Avg(100%)`
FROM `uneg recruitment 2024&2025`
order by `Net_Avg(100%)` DESC
LIMIT 10;

-- 3. Find all candidates from the Pharmacy department.
SELECT * FROM `uneg recruitment 2024&2025`;
SELECT Name, Department
FROM `uneg recruitment 2024&2025`
WHERE Department = "Pharmacy";

-- 4. Show candidates who scored above 25 in Content_A
SELECT Name, `Content_A (30%)`
FROM `uneg recruitment 2024&2025`
WHERE `Content_A (30%)` > 25;

 -- 5. Display the names and departments of candidates who had no penalty
 SELECT * FROM `uneg recruitment 2024&2025`;
 SELECT Name, Department, `Net_Avg(100%)`, Penalty_A, Penalty_B, Penalty_Avg 
 FROM `uneg recruitment 2024&2025`
 WHERE Penalty_A = 0 AND Penalty_B = 0 AND Penalty_Avg = 0; 
 
 -- 6. Find the number of candidates assessed
 SELECT Count(*) FROM `uneg recruitment 2024&2025`;
 
 --  7. Show all candidates whose Mechanics_AVG is above 15
 SELECT Name, `Mechanics_AVG (20%)`
 FROM `uneg recruitment 2024&2025`
 WHERE `Mechanics_AVG (20%)` > 15;
 
 -- Section 2: Filtering and Conditions
 -- 1. List departments and how many candidates came from each
SELECT Department, COUNT(Department) AS Stud
FROM `uneg recruitment 2024&2025`
GROUP BY Department;

-- 2. Retrieve candidates who have a negative penalty (Penalty_AVG less than 0)
SELECT Name, Penalty_Avg
FROM `uneg recruitment 2024&2025`
WHERE Penalty_Avg < 0;

-- 3. Display candidates who scored above 80 in their Net_AVG
SELECT Name, `Net_Avg(100%)`
FROM `uneg recruitment 2024&2025`
WHERE `Net_Avg(100%)` > 80;

 -- 4. Find candidates whose Content_A score is greater than Structure_A score.
 SELECT Name
 FROM `uneg recruitment 2024&2025`
 WHERE `Content_A (30%)` > `Structure_A (20%)`;
 
 -- Section 3: Aggregations and Group Analysis
--  1. Calculate the overall average of Content_AVG, Structure_AVG, Style_AVG, and Mechanics_AVG.
SELECT Name, `Content_Avg (30%)`,
			 `Structure_Avg (20%)`,
             `Style_Avg (30%)`, 
             `Mechanics_Avg (20%)`,
             (`Content_Avg (30%)` + `Structure_Avg (20%)`+ `Style_Avg (30%)` + `Mechanics_Avg (20%)`) /4 AS Overall_Avg
FROM `uneg recruitment 2024&2025`;

--  2. Group candidates by Department and compute the average Net_AVG for each department
SELECT Department, avg(`Net_Avg(100%)`) AS Net_avg_Score
FROM `uneg recruitment 2024&2025`
Group By Department;

--  3. Identify departments with an average Net_AVG greater than 85.
SELECT Department, avg(`Net_Avg(100%)`) AS Net_avg_Score
FROM `uneg recruitment 2024&2025`
Group By Department
HAVING avg(`Net_Avg(100%)`) > 85;

--  Section 4: Ranking and Advanced Filters
 -- 1. Create a ranking of candidates based on their Net_AVG, highest to lowest.
 SELECT Name, `Net_Avg(100%)`,  Row_Number() OVER (ORDER BY `Net_Avg(100%)` DESC) AS position
 FROM `uneg recruitment 2024&2025`;
 
 --  2. Identify candidates who improved significantly (Content_B > Content_A by at least 5 points)
 SELECT Name,
		`Content_A (30%)`,
        `Content_B (30%)`
FROM `uneg recruitment 2024&2025`
WHERE `Content_B (30%)` - `Content_A (30%)` >= 5;

-- 3. Find the candidate with the highest Penalty_B deduction
SELECT Name, Penalty_B
FROM `uneg recruitment 2024&2025`
ORDER BY Penalty_B
LIMIT 1;

--  Section 5: Calculations and New Metrics
 -- 1. For each candidate, calculate a new Total_Avg_Score as the mean of Content_AVG, Structure_AVG, Style_AVG, and Grammar_AVG. Then rank them.
 SELECT Name, 
		(`Content_AVG (30%)` + `Structure_AVG (20%)` + `Style_Avg (30%)` + `Mechanics_Avg (20%)`)/4 AS  Total_Avg_Score,
        ROW_NUMBER() OVER (ORDER BY (`Content_AVG (30%)` + `Structure_AVG (20%)` + `Style_Avg (30%)` + `Mechanics_Avg (20%)`)/4 DESC) AS Ranking
FROM `uneg recruitment 2024&2025`;

--  2. Find out if penalties impacted results by comparing Net_AVG before and after penalties for candidates with penalties.
SELECT Name,
		`Total_Avg(100%)`, 
        `Net_Avg(100%)`,
        `Total_Avg(100%)` - `Net_Avg(100%)`as Penalty_Impact
FROM `uneg recruitment 2024&2025`
WHERE `Total_Avg(100%)` <> `Net_Avg(100%)`;


-- Display the occurences of violations by candidates
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

--  Section 6: View Creation for Reporting
--  1. Write a query that creates a view showing: Name, Department, Total_Avg_Score, Penalty_AVG, and Net_AVG for future analysis
CREATE VIEW Candidate_Summary AS
SELECT Name, 
		`Total_Avg(100%)`, 
        `Net_Avg(100%)`,
         Penalty_Avg,
        `Net_B(100%)`
FROM `uneg recruitment 2024&2025`;
 
 SELECT * FROM Candidate_Summary;