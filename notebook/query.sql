USE insurance_db;

-- 1. Total premium collected in 2024

SELECT SUM(Premium) as Total_Premium
FROM policy_sales;

-- 2. Claim cost per year(monthly)
SELECT YEAR(Claim_Date) as years,
MONTH(Claim_Date) as months,
SUM(Claim_Amount) as Total_Claim_Cost
FROM claims_data
GROUP BY years, months
ORDER BY years, months;

-- 3. Claim to premium ratio by tenure
SELECT p.Policy_Tenure,
SUM(c.Claim_Amount)/ SUM(Premium) AS claim_ratio
FROM policy_sales p
JOIN claims_data c
ON p.Vehicle_ID = c.Vehicle_ID
GROUP BY p.Policy_Tenure;

-- 4. Claim ratio by policy purchase month
SELECT MONTH(p.Policy_Purchase_Date) as sale_month,
SUM(c.Claim_Amount)/SUM(p.Premium) as Ratio
FROM policy_sales p
JOIN claims_data c
ON p.Vehicle_ID= c.Vehicle_ID
GROUP BY sale_month
ORDER BY sale_month;

-- 5. total potential claim liability if every vehicle that has not yet made a claim eventually files exactly one claim during the remaining policy tenure
SELECT (COUNT(*) -COUNT(DISTINCT c.Vehicle_ID)) * 10000 AS potential_claim_liability
FROM policy_sales p
LEFT JOIN claims_data c
ON p.Vehicle_ID= c.Vehicle_ID
;

-- 6. premium earned until FEB 28 2026
SELECT SUM(
	(Premium/(Policy_Tenure * 365)) * DATEDIFF(LEAST('2026-02-28', Policy_End_Date), Policy_Start_Date)
) as premium_earned
FROM policy_sales
WHERE Policy_Start_Date <= '2026-02-28';

-- monthly premium fro remaining months
SELECT (SUM(Premium) - SUM(
	(Premium/(Policy_Tenure * 365)) * DATEDIFF(LEAST('2026-02-28', Policy_End_Date), Policy_Start_Date)
))/46 as expected_monthly_premium
FROM policy_sales
WHERE Policy_Start_Date <= '2026-02-28';