/*
Charles Bennington
April 25th 2026

This script is investigating and cleaning the weird "million dollar rates". These are most definitely mistakes
or plans that are not intended to actually be purchased. 
*/

--Lookin for the highest rates.
SELECT IndividualRate , StateCode
FROM `final-project-492620.verify_final_project_pipeline.Rate`
ORDER BY IndividualRate DESC
LIMIT 100;

-- WEIRD : some of the health insurance claims are set to "1 Million$" per year. 
-- This must be a mistake.
-- How many million dollar rates are there?
SELECT COUNT(*) AS million_dollar_plan_counts
FROM `final-project-492620.verify_final_project_pipeline.Rate`
WHERE IndividualRate >= 999999.0;

-- Remove those weird “million dollar” rates. Note: These account for less than 0.3% of the dataset. 
DELETE FROM `final-project-492620.verify_final_project_pipeline.Rate`
WHERE IndividualRate >= 999999.0;