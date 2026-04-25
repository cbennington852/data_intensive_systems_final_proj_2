--Initial Cleaning of this horrible table.
CREATE OR REPLACE TABLE `final-project-492620.final_project.NewBenefitsCostSharing` AS
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
FROM `final-project-492620.final_project.BenefitsCostSharing`

-- Weird ID bug ("There are two separate formats of ID in this row. ")
UPDATE `final-project-492620.final_project.NewBenefitsCostSharing` SET PlanId = LEFT (PlanId, LENGTH(PlanId) - 3)
WHERE (LENGTH(PlanId) >= 3);