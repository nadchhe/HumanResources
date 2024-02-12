SELECT * from `HumanResources`;
 ALTER TABLE `HumanResources`
   CHANGE COLUMN `id` `emp_id` VARCHAR(20);
DESCRIBE `HumanResources`;
SELECT `birthdate` FROM `HumanResources`;

UPDATE `HumanResources`
SET `birthdate` = CASE
   WHEN `birthdate` LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(`birthdate`, '%m/%d/%Y'), '%d-%m-%Y')
   WHEN `birthdate` LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(`birthdate`, '%m-%d-%Y'), '%d-%m-%Y')
   ELSE NULL
 END;


SELECT * from `HumanResources`;
 
 
UPDATE `HumanResources`
SET `birthdate` = STR_TO_DATE(`birthdate`, '%d-%m-%Y'); 
ALTER TABLE `HumanResources`
CHANGE COLUMN `birthdate` `birth_date` DATE;
DESCRIBE `HumanResources`;
SELECT `birth_date` FROM `HumanResources`;


 UPDATE `HumanResources`
SET `hire_date` = CASE
   WHEN `hire_date` LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(`hire_date`, '%m/%d/%Y'), '%d-%m-%Y')
   WHEN `hire_date` LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(`hire_date`, '%m-%d-%Y'), '%d-%m-%Y')
   ELSE NULL
 END;
SELECT `hire_date` FROM `HumanResources`;



UPDATE `HumanResources`
SET `hire_date` = STR_TO_DATE(`hire_date`, '%d-%m-%Y'); 
ALTER TABLE `HumanResources`
CHANGE COLUMN `hire_date` `hiredate` DATE;
SELECT `hiredate` FROM `HumanResources`;
DESCRIBE `HumanResources`;


UPDATE `HumanResources`
SET `termdate` = date(STR_TO_DATE(`termdate`, '%Y-%m-%d %H:%i:%s UTC'))
WHERE `termdate` IS NOT NULL AND `termdate` != ' ';
SELECT `termdate` FROM `HumanResources`;


UPDATE `HumanResources`
SET `termdate` = STR_TO_DATE(`termdate`, '%Y-%m-%d'); 
ALTER TABLE `HumanResources`
CHANGE COLUMN `termdate` `term_date` DATE;
SELECT `term_date` FROM `HumanResources`;
DESCRIBE `HumanResources`;

 SELECT * from `HumanResources`;
 
ALTER TABLE `HumanResources`
 ADD COLUMN `Age` INT;
 
 UPDATE `HumanResources`
 SET `Age` = TIMESTAMPDIFF(YEAR, `birth_date`, CURDATE());
 
 SELECT
 MIN(`Age`) As youngest,
 MAX(`Age`) AS oldest
 FROM `HumanResources`;
 
 SELECT COUNT(*)
 FROM `HumanResources` WHERE `Age` <18;
 
 /* These are some questions for analysis */
/*
   What is the gender breakdown of employees in the company?
*/
 Select `gender` , COUNT(*) AS COUNT
 from `HumanResources`
 Where `Age`>=18 AND `term_date`= '0000-00-00'
 GROUP BY `gender`;
 
 /*What is the race/etnicity breakdown of employees in the company?*/
 SELECT `race` , COUNT(*) AS COUNT
 FROM `HumanResources`
  Where `Age`>=18 AND `term_date`= '0000-00-00'
 GROUP BY `race`
 ORDER BY COUNT(*) DESC;
 
 /*What is the age distribution of employees in the company?*/
 
 SELECT MIN(`Age`) AS Youngest,
 MAX(`Age`) AS Oldest
 FROM `HumanResources`
  Where `Age`>=18 AND `term_date`= '0000-00-00';
  
  SELECT 
   CASE
      WHEN `Age`>=18 AND `Age`<=24 THEN '18-24'
      WHEN `Age`>=25 AND `Age`<=34 THEN '25-34'
      WHEN `Age`>=35 AND `Age`<=44 THEN '35-44'
      WHEN `Age`>=45 AND `Age`<=54 THEN '45-54'
      WHEN `Age`>=55 AND `Age`<=64 THEN '55-64'
      ELSE '65+'
    END AS 'Age_Group',
     COUNT(*) AS COUNT
   FROM `HumanResources`
   Where `Age`>=18 AND `term_date`= '0000-00-00'
   GROUP BY `Age_Group`
   ORDER BY `Age_Group`;
   
   
   SELECT 
   CASE
      WHEN `Age`>=18 AND `Age`<=24 THEN '18-24'
      WHEN `Age`>=25 AND `Age`<=34 THEN '25-34'
      WHEN `Age`>=35 AND `Age`<=44 THEN '35-44'
      WHEN `Age`>=45 AND `Age`<=54 THEN '45-54'
      WHEN `Age`>=55 AND `Age`<=64 THEN '55-64'
      ELSE '65+'
    END AS 'Age_Group', `gender` ,
     COUNT(*) AS COUNT
   FROM `HumanResources`
   Where `Age`>=18 AND `term_date`= '0000-00-00'
   GROUP BY `Age_Group`, `gender`
   ORDER BY `Age_Group`, `gender`;
   
  /*How many employees work at headquarters vs remote locations? */
  SELECT `location` , COUNT(*) AS COUNT
  FROM `HumanResources`
  Where `Age`>=18 AND `term_date`= '0000-00-00'
  GROUP BY `location`;
  
  /*What is the average length of employment for employees who have been terminated?*/
  
  SELECT 
   ROUND(AVG(DATEDIFF(`term_date`, `hiredate`))/365,0) AS Average
  FROM `HumanResources`
  WHERE `term_date` <= CURDATE() AND `term_date` <> '0000-00-00' AND `age`>=18;
  
  /*How does the age distribution vary across departments and job titles?*/
  
  SELECT `department`,`gender`, COUNT(*) AS COUNT
  FROM `HumanResources`
  Where `Age`>=18 AND `term_date`= '0000-00-00'
  GROUP BY `department` , `gender`
  ORDER BY `department`;
  
  /*What is the age distribution of job titles across the company?*/
  
  SELECT `jobtitle`, COUNT(*) AS COUNT
  FROM `HumanResources`
   Where `Age`>=18 AND `term_date`= '0000-00-00'
   GROUP BY `jobtitle`
  ORDER BY `jobtitle` DESC;
  
  /*Which department has the highest turnover rate?*/
 
  SELECT
  `department`,
  `total_count`,
  `terminated_count`,
  `terminated_count` / `total_count` AS termination_rate
FROM (
  SELECT
    `department`,
    COUNT(*) AS total_count,
    SUM(CASE WHEN `term_date` <> '0000-00-00' AND `term_date` <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
  FROM `HumanResources`
  WHERE `Age` >= 18
  GROUP BY `department`
) AS sub_query
ORDER BY `termination_rate` DESC;

/* What is the distribution of employees across the locations by city and state?*/

SELECT `location_state` , COUNT(*) AS COUNT
FROM `HumanResources`
WHERE `Age` >= 18 AND `term_date` = '0000-00-00'
GROUP BY `location_state`
ORDER BY `COUNT` DESC;

/*How has the company's employee count changed over time based on hire and term date*/

SELECT 
`year`,
`hires`,
`terminations`,
`hires` - `terminations` AS Net_Change,
ROUND((`hires` - `terminations`)/`hires`* 100, 2) AS Net_Change_percent
FROM (
    SELECT YEAR(`hiredate`) AS year,
     COUNT(*) AS hires,
     SUM(CASE WHEN `term_date` <> '0000-00-00' AND `term_date` <= CURDATE() THEN 1 ELSE 0 END) AS terminations
     FROM `HumanResources`
     WHERE `Age`>= 18
     GROUP BY YEAR(`hiredate`)
     ) AS subquery
ORDER BY `year` ASC;


/* What is the tenure distribution for each department?*/
SELECT `department` , ROUND(AVG(DATEDIFF(`term_date`,`hiredate`) /365),0) AS average_tenure
from `HumanResources`
WHERE `term_date` <= CURDATE() AND `term_date` <> '0000-00-00' AND `Age`>= 18
GROUP BY `department`;
