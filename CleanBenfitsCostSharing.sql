/*
Charles Bennington
April 25th 2026

The purpose of this SQL script is to clean the BenefitsCostSharing dataset, which is INCREDIBLY messy. This makes a new 
table with greatly reduced features.  
*/


--Initial Cleaning of this horrible table.
CREATE OR REPLACE TABLE `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing` AS
SELECT
CASE
 WHEN CoinsInnTier1 = '$0' THEN 0.0
 WHEN CoinsInnTier1 = 'No Charge after deductible' THEN 0.0
 WHEN CoinsInnTier1 = 'Not Applicable' THEN 0.0
 WHEN CoinsInnTier1 = 'No Charge' THEN 0.0
 WHEN CONTAINS_SUBSTR(CoinsInnTier1 , '% Coinsurance after deductible' )  THEN
   CAST(REPLACE(CoinsInnTier1, '% Coinsurance after deductible', '') AS FLOAT64) / 100.0
 WHEN CONTAINS_SUBSTR(CoinsInnTier1 , 'Copay' ) THEN CAST(FLOOR((10 * RAND()) + 20) AS FLOAT64)
 ELSE SAFE_CAST(REPLACE(CoinsInnTier1, '%', '') AS FLOAT64) / 100.0
END AS CoinsInnTier1,
CASE
  WHEN IsCovered = 'Yes' THEN TRUE
  WHEN IsCovered = 'No' THEN FALSE
  ELSE NULL
END AS IsCovered,
CASE
  WHEN BenefitName LIKE '%Child%' AND BenefitName LIKE '%Adult%' THEN 'Both'
  WHEN BenefitName LIKE '%Child%' THEN 'Child Only'
  WHEN BenefitName LIKE '%Adult%' THEN 'Adult Only'
  ELSE 'Not Specified'
END AS AgeGroupType,
BenefitName,
BusinessYear,
IssuerId,
PlanId,
StateCode,
FROM `final-project-492620.verify_final_project_pipeline.BenefitsCostSharing`;

-- Weird ID bug ("There are two separate formats of ID in this row. ")
-- Notes:
-- The BenefitsCostSharing has a bad id, with the last two chars are bad, and should be chopped off.
-- Then we can merge on planID.
-- They are the same id, just the benefits cost sharing has the weird concatenated thing. 
-- Below is fixing the issue with the BenefitsCostSharing, this fixes the issue with the planID having the concatenated strings on the end. 
UPDATE `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing` SET PlanId = LEFT (PlanId, LENGTH(PlanId) - 3)
WHERE (LENGTH(PlanId) >= 3);