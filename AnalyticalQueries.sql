/*
Charles Bennington
April 25th 2026

The purpose of this SQL script is to perform analytical queries on the healthcare dataset. Each of these queries is 
used in the looker studio to get various data. 
*/

-- We maybe need to match the issuer id to get the network to plan? Below gets the rates crossed by the networks. 
SELECT *
FROM `final-project-492620.verify_final_project_pipeline.Rate` AS r
JOIN `final-project-492620.verify_final_project_pipeline.Network` AS n
 ON r.IssuerId = n.IssuerId
LIMIT 1000;

-- Getting the top 1,000 network providers(largest providers) with the most number of plans and looking at their average rates.
SELECT NetworkName ,
 COUNT(*) AS num_plans ,
 AVG(IndividualRate) AS avg_rate ,
FROM `final-project-492620.verify_final_project_pipeline.Rate` AS r
JOIN `final-project-492620.verify_final_project_pipeline.Network` AS n
 ON r.IssuerId = n.IssuerId
GROUP BY NetworkName
ORDER BY num_plans DESC
LIMIT 1000;

--Looking for the highest rates by each state. 
SELECT IndividualRate , StateCode
FROM `final-project-492620.verify_final_project_pipeline.Rate`
ORDER BY IndividualRate DESC


-- Looking at average rates for each plan type / name! 
SELECT
BenefitName ,
COUNT(*) AS num_plans ,
AVG(IndividualRate) AS avg_rate ,
FROM `final-project-492620.verify_final_project_pipeline.Rate` AS r
JOIN `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing` AS cbc
ON cbc.PlanId
= r.PlanId
GROUP BY BenefitName
ORDER BY num_plans DESC , avg_rate ASC
LIMIT 2000;




-- Looking to see for which benefit names, what provider is the cheapest, and what plans are available. 
SELECT
BenefitName ,
NetworkName ,
COUNT(*) AS num_plans ,
AVG(IndividualRate) AS avg_rate ,
MIN(IndividualRate) AS min_rate ,
MAX(IndividualRate) AS max_rate
FROM `final-project-492620.verify_final_project_pipeline.Rate` AS r
JOIN `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing` AS cbc
ON cbc.PlanId = r.PlanId
JOIN `final-project-492620.verify_final_project_pipeline.Network` AS net
ON r.IssuerId = net.IssuerId
GROUP BY BenefitName , NetworkName;



-- Aggregate Rates for each state. 
SELECT StateCode,
AVG(IndividualRate) AS individual_rate ,  
AVG(PrimarySubscriberAndOneDependent) AS Avg_PrimarySubscriberAndOneDependent,
   AVG(PrimarySubscriberAndTwoDependents) AS Avg_PrimarySubscriberAndTwoDependents,
   AVG(PrimarySubscriberAndThreeOrMoreDependents) AS Avg_PrimarySubscriberAndThreeOrMoreDependents,
   AVG(CoupleAndOneDependent) AS Avg_CoupleAndOneDependent,
   AVG(CoupleAndTwoDependents) AS Avg_CoupleAndTwoDependents,
   AVG(CoupleAndThreeOrMoreDependents) AS Avg_CoupleAndThreeOrMoreDependents
FROM `final-project-492620.verify_final_project_pipeline.Rate`
GROUP BY StateCode
LIMIT 50;


-- Correlation between age and rate.
SELECT Age ,
AVG(IndividualRate) AS individual_rate ,  
AVG(PrimarySubscriberAndOneDependent) AS Avg_PrimarySubscriberAndOneDependent,
   AVG(PrimarySubscriberAndTwoDependents) AS Avg_PrimarySubscriberAndTwoDependents,
   AVG(PrimarySubscriberAndThreeOrMoreDependents) AS Avg_PrimarySubscriberAndThreeOrMoreDependents,
   AVG(CoupleAndOneDependent) AS Avg_CoupleAndOneDependent,
   AVG(CoupleAndTwoDependents) AS Avg_CoupleAndTwoDependents,
   AVG(CoupleAndThreeOrMoreDependents) AS Avg_CoupleAndThreeOrMoreDependents
FROM `final-project-492620.verify_final_project_pipeline.Rate`
GROUP BY Age
ORDER BY Age ASC
LIMIT 1000;


-- Looking at coins over the years
SELECT CoinsInnTier1 , BusinessYear
FROM `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing`;

-- Making a Box and whiskers chart for coins(co insurance )
SELECT BusinessYear ,
 MAX(CoinsInnTier1) AS max_coins,
 APPROX_QUANTILES(CoinsInnTier1, 4)[OFFSET(1)] AS first_quartile_coins ,
 AVG(CoinsInnTier1) AS avg_coins,
 APPROX_QUANTILES(CoinsInnTier1, 4)[OFFSET(3)] AS third_quartile_coins ,
 MIN(CoinsInnTier1) AS min_coins
FROM `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing`
GROUP BY BusinessYear;


-- Getting the most frequent word in the BenfitisName
-- Note: It is necessary here to exclude some of the words, this cleans up the chart and makes it much more useful. 

SELECT
 word,
 COUNT(*) AS frequency
FROM
 `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing`,
 UNNEST(SPLIT(LOWER(BenefitName), ' ')) AS word
WHERE
 word != '' AND word != 'services' AND word != 'care' AND word != 'and' AND word != 'for' AND word != '-'
GROUP BY
 word
ORDER BY
 frequency DESC;




--Getting the most frequent benefit name for BenfitsName
SELECT
 BenefitName,
 COUNT(*) AS frequency
FROM
 `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing`
GROUP BY
 BenefitName
ORDER BY
 frequency DESC;


--By plan type and weather or not child only or adult only
SELECT AgeGroupType , COUNT(*) AS countOf,
 MAX(CoinsInnTier1) AS max_coins,
APPROX_QUANTILES(CoinsInnTier1, 4)[OFFSET(1)] AS first_quartile_coins ,
AVG(CoinsInnTier1) AS avg_coins,
APPROX_QUANTILES(CoinsInnTier1, 4)[OFFSET(3)] AS third_quartile_coins ,
MIN(CoinsInnTier1) AS min_coins
FROM `final-project-492620.verify_final_project_pipeline.NewBenefitsCostSharing`
GROUP BY AgeGroupType
LIMIT 100;
