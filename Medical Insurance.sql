create database medical;
use medical;

create table medical_insurance(
person_id int,
age int,
sex varchar(15),
region varchar(15),
urban_rural varchar(15),
income float,
education varchar(20),
marital_status varchar(20),
employment_status varchar(20),
household_size int,
dependents int,
bmi	 decimal(4,2),	
smoker varchar(15),
alcohol_freq varchar(15),
visits_last_year int,
hospitalizations_last_3yrs int,
days_hospitalized_last_3yrs int,
medication_count int,
systolic_bp int,
diastolic_bp int,
ldl decimal(4,2),
hba1c decimal(4,2),
plan_type varchar(5),
network_tier varchar(15),
deductible int,
copay int,
policy_term_years int,
policy_changes_last_2yrs int,
provider_quality decimal(2,2),
risk_score decimal(2,5),
annual_medical_cost float,
annual_premium float,
monthly_premium float,
claims_count int,
avg_claim_amount float,
total_claims_paid float,
chronic_count int,
hypertension int,
diabetes int,
asthma int,
copd int,
cardiovascular_disease int,
cancer_history int,
kidney_disease int,
liver_disease int,
arthritis int,
mental_health int,
proc_imaging_count int,
proc_surgery_count int,
proc_physio_count int,
proc_consult_count int,
proc_lab_count int,
is_high_risk int,
had_major_procedure int);


select * from medical_insurance;


-- A.  CUSTOMER DEMOGRAPHICS ANALYSIS


--  Total number of insured customer
SELECT
    COUNT(person_id) AS total_customers
FROM medical_insurance;

select * from medical_insurance;
--  Customer distribution by gender
SELECT
    sex,
    COUNT(*) AS total_customers
FROM medical_insurance
GROUP BY sex;


--  customer distribution by region
 SELECT
    region,
    COUNT(*) AS total_customers
FROM medical_insurance
GROUP BY region
ORDER BY total_customers DESC;


--  customer distribution by age group
SELECT
    CASE
        WHEN age < 25 THEN 'Below 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65 and Above'
    END AS age_group,
    COUNT(*) AS total_customers
FROM medical_insurance
GROUP BY age_group
ORDER BY MIN(age);


-- Compare income by Employment Status
SELECT
    employment_status,
    COUNT(*) AS total_customers,
    ROUND(AVG(income), 2) AS average_income,
    ROUND(MIN(income), 2) AS minimum_income,
    ROUND(MAX(income), 2) AS maximum_income
FROM medical_insurance
GROUP BY employment_status
ORDER BY average_income DESC;


-- Customer distribution by employment status
 SELECT
    employment_status,
    COUNT(*) AS total_customers
FROM medical_insurance
GROUP BY employment_status
ORDER BY total_customers DESC;



-- Customer distribution by Marital status
SELECT
    marital_status,
    COUNT(*) AS total_customers
FROM medical_insurance
GROUP BY marital_status;

-- B. HEALTH CONDITION AND RISK ANALYSIS


--  Number of customer with different medical conditions
   -- This helps identify the most prevalent medical conditions.
SELECT
    SUM(asthma) AS asthma_patients,
    SUM(copd) AS copd_patients,
    SUM(cardiovascular_disease) AS cardiovascular_patients,
    SUM(cancer_history) AS cancer_patients,
    SUM(kidney_disease) AS kidney_patients,
    SUM(liver_disease) AS liver_patients,
    SUM(arthritis) AS arthritis_patients,
    SUM(hypertension) AS hypertension_patients,
    SUM(diabetes) AS diabetes_patients
FROM medical_insurance;


--  high risk versus low risk customer
SELECT
    is_high_risk,
    COUNT(*) AS total_customers,
    ROUND(AVG(risk_score), 3) AS average_risk_score
FROM medical_insurance
GROUP BY is_high_risk;


--  Average medical cost by smoking status
SELECT
    smoker,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost
FROM medical_insurance
GROUP BY smoker;


--  Relationship between chronic condition and medical costs
SELECT
    chronic_count,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_premium
FROM medical_insurance
GROUP BY chronic_count
ORDER BY chronic_count;




--  Average medical cost by Alcohol status
SELECT
    alcohol_freq,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost
FROM medical_insurance
GROUP BY alcohol_freq;


-- BMI  relationship with medical cost, which reveal
   -- Which BMI category has the highest average medical cost?
   -- Which BMI category has the highest number of customers?
   -- Do customers classified as obese incur higher average medical expenses?
   --  How does medical expenditure differ across BMI categories?
SELECT
    CASE
        WHEN bmi < 18.5 THEN 'Underweight <18.5'
        WHEN bmi < 25 THEN 'Normal Weight <25'
        WHEN bmi < 30 THEN 'Overweight <30'
        ELSE 'Obese 30above'
    END AS bmi_category,
    COUNT(*) AS total_customers,
    ROUND(AVG(bmi), 2) AS average_bmi,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost
FROM medical_insurance
GROUP BY bmi_category
ORDER BY AVG(bmi);


-- Which age group has the highest medical risk, which reveal;
   -- Which age group has the highest average risk score?
   -- Which age group has the highest number of high-risk customers?
   -- Which age group has the highest percentage of high-risk customers?
   -- Which age group incurs the highest average medical cost?
SELECT
    CASE
        WHEN age < 25 THEN 'Below 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65 and Above'
    END AS age_group,
    COUNT(*) AS total_customers,
    ROUND(AVG(risk_score), 2) AS avg_risk_score,
    SUM(is_high_risk) AS high_risk_customers,
    ROUND(
        SUM(is_high_risk) / COUNT(*) * 100, 2
    ) AS high_risk_percentage,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost
FROM medical_insurance
GROUP BY age_group
ORDER BY MIN(age);


-- Compare medical condition between high risk and low risk customer
SELECT
    is_high_risk,
    COUNT(*) AS total_customers,
    SUM(asthma) AS asthma_patients,
    SUM(copd) AS copd_patients,
    SUM(cardiovascular_disease) AS cardiovascular_patients,
    SUM(cancer_history) AS cancer_patients,
    SUM(kidney_disease) AS kidney_patients,
    SUM(liver_disease) AS liver_patients,
    SUM(arthritis) AS arthritis_patients,
    SUM(hypertension) AS hypertension_patients,
    SUM(diabetes) AS diabetes_patients
FROM medical_insurance
GROUP BY is_high_risk;



-- Percentage of high risk customer with each medical condition
SELECT
    COUNT(*) AS total_high_risk_customers,
    ROUND(SUM(asthma) / COUNT(*) * 100, 2) AS asthma_percentage,
    ROUND(SUM(copd) / COUNT(*) * 100, 2) AS copd_percentage,
    ROUND(SUM(cardiovascular_disease) / COUNT(*) * 100, 2) AS cardiovascular_percentage,
    ROUND(SUM(cancer_history) / COUNT(*) * 100, 2) AS cancer_percentage,
    ROUND(SUM(kidney_disease) / COUNT(*) * 100, 2) AS kidney_percentage,
    ROUND(SUM(liver_disease) / COUNT(*) * 100, 2) AS liver_percentage,
    ROUND(SUM(arthritis) / COUNT(*) * 100, 2) AS arthritis_percentage,
    ROUND(SUM(hypertension) / COUNT(*) * 100, 2) AS hypertension_percentage,
    ROUND(SUM(diabetes) / COUNT(*) * 100, 2) AS diabetes_percentage
FROM medical_insurance
WHERE is_high_risk = 1;


-- C. Healthcare utilization analysis


--  Average hospital visits by risk category
SELECT
    is_high_risk,
    COUNT(*) AS total_customers,
    ROUND(AVG(visits_last_year), 2) AS avg_visits,
    ROUND(AVG(hospitalizations_last_3yrs), 2) AS avg_hospitalizations,
    ROUND(AVG(days_hospitalized_last_3yrs), 2) AS avg_hospital_days
FROM medical_insurance
GROUP BY is_high_risk;


--  most frequent performed medical procedures
SELECT
    SUM(proc_imaging_count) AS imaging_procedures,
    SUM(proc_surgery_count) AS surgery_procedures,
    SUM(proc_physio_count) AS physiotherapy_procedures,
    SUM(proc_consult_count) AS consultation_procedures,
    SUM(proc_lab_count) AS laboratory_procedures
FROM medical_insurance;


--  Relationship between medication count and medical expenses
SELECT
    medication_count,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost
FROM medical_insurance
GROUP BY medication_count
ORDER BY medication_count;


-- Average number of hospital visit per customer
SELECT
    COUNT(person_id) AS total_customers,
    SUM(visits_last_year) AS total_hospital_visits,
    ROUND(AVG(visits_last_year), 2) AS avg_hospital_visits_per_customer
FROM medical_insurance;


-- compare average hospital visit by age group
SELECT
    CASE
        WHEN age < 25 THEN 'Below 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65 and Above'
    END AS age_group,
    COUNT(person_id) AS total_customers,
    ROUND(AVG(visits_last_year), 2) AS avg_hospital_visits
FROM medical_insurance
GROUP BY age_group
ORDER BY MIN(age);


-- Average number of days spent in the hospital across customers
SELECT
hospitalizations_last_3yrs,
    COUNT(person_id) AS total_customers,
    SUM(days_hospitalized_last_3yrs) AS total_days_spent_IN_hospital,
    ROUND(AVG(days_hospitalized_last_3yrs), 2) AS avg_days_spent_IN_hospital
FROM medical_insurance
group by hospitalizations_last_3yrs
order by  COUNT(person_id);


-- D. INSURANCE FINANCIAL PERFORMANCE


--  Overall financial performance
SELECT
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost,
    ROUND(SUM(annual_premium), 2) AS total_premium,
    ROUND(SUM(total_claims_paid), 2) AS total_claims_paid,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_annual_premium
FROM medical_insurance;


-- Overall distribution of annual medical cost and premium
SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(MIN(annual_medical_cost), 2) AS min_medical_cost,
    ROUND(MAX(annual_medical_cost), 2) AS max_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_annual_premium,
    ROUND(MIN(annual_premium), 2) AS min_annual_premium,
    ROUND(MAX(annual_premium), 2) AS max_annual_premium
FROM medical_insurance;


-- Compare annual medical costs and premium by insurance plan which checks;
   -- Which insurance plan has the highest average medical cost?
   -- Which plan has the highest overall medical expenditure?
   -- Are customers paying higher premiums on plans with higher medical costs?
SELECT
    plan_type,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_premium,
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost,
    ROUND(SUM(annual_premium), 2) AS total_premium
FROM medical_insurance
GROUP BY plan_type
ORDER BY avg_premium DESC;


-- Compare annual medical cost and premium by age group;
   -- This helps establish whether older customers tend to have higher medical expenses and insurance premiums.
   SELECT
    CASE
        WHEN age < 25 THEN 'Below 25'
        WHEN age BETWEEN 25 AND 34 THEN '25 - 34'
        WHEN age BETWEEN 35 AND 44 THEN '35 - 44'
        WHEN age BETWEEN 45 AND 54 THEN '45 - 54'
        WHEN age BETWEEN 55 AND 64 THEN '55 - 64'
        ELSE '65 and Above'
    END AS age_group,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_premium
FROM medical_insurance
GROUP BY age_group
ORDER BY MIN(age);


-- categorize customers by annual medical cost which checks;
   -- Which medical cost category has the highest number of customers?
   -- Are medical expenses concentrated among a small group of customers?
   -- What is the average medical expenditure within each category?
SELECT
    CASE
        WHEN annual_medical_cost <= 2000
            THEN 'Very Low (0-2,000)'
        WHEN annual_medical_cost <= 5000
            THEN 'Low (2,001-5,000)'
        WHEN annual_medical_cost <= 10000
            THEN 'Moderate (5,001-10,000)'
        WHEN annual_medical_cost <= 20000
            THEN 'High (10,001-20,000)'
        WHEN annual_medical_cost <= 35000
            THEN 'Very High (20,001-35,000)'
        ELSE 'Extremely High (Above 35,000)'
    END AS medical_cost_category,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(MIN(annual_medical_cost), 2) AS min_cost,
    ROUND(MAX(annual_medical_cost), 2) AS max_cost
FROM medical_insurance
GROUP BY medical_cost_category
ORDER BY MIN(annual_medical_cost);


-- Compare medical costs and premium by risk category;
   -- This will help determine whether high-risk customers have higher average medical costs and whether their premiums reflect their risk profiles.
   SELECT
    is_high_risk,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_premium,
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost,
    ROUND(SUM(annual_premium), 2) AS total_premium
FROM medical_insurance
GROUP BY is_high_risk;


-- Categorize customers by annual insurance premium which checks;
   -- Which premium category has the highest number of customers?
   -- Is the customer population concentrated within the lower or higher premium categories?
   -- What is the average premium within each category?
SELECT
    CASE
        WHEN annual_premium <= 500
            THEN 'Very Low (0-500)'
        WHEN annual_premium <= 1000
            THEN 'Low (501-1,000)'
        WHEN annual_premium <= 2000
            THEN 'Moderate (1,001-2,000)'
        WHEN annual_premium <= 3500
            THEN 'High (2,001-3,500)'
        WHEN annual_premium <= 5000
            THEN 'Very High (3,501-5,000)'
        ELSE 'Extremely High (Above 5,000)'
    END AS premium_category,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_premium), 2) AS avg_premium,
    ROUND(MIN(annual_premium), 2) AS min_premium,
    ROUND(MAX(annual_premium), 2) AS max_premium
FROM medical_insurance
GROUP BY premium_category
ORDER BY MIN(annual_premium);


--  Financial performance by insurance plan
SELECT
    plan_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(annual_premium), 2) AS total_premium,
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost,
    ROUND(SUM(total_claims_paid), 2) AS total_claims_paid
FROM medical_insurance
GROUP BY plan_type
ORDER BY total_premium DESC;


--  Average premium by network tier
SELECT
    network_tier,
    COUNT(*) AS total_customers,
    ROUND(AVG(annual_premium), 2) AS avg_premium,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost
FROM medical_insurance
GROUP BY network_tier
ORDER BY avg_premium DESC;


-- Compare medical cost across deductible categories
SELECT
    CASE
        WHEN deductible <= 500 THEN 'Low (0-500)'
        WHEN deductible <= 1000 THEN 'Moderate (501-1000)'
        WHEN deductible <= 2000 THEN 'High (1001-2000)'
        WHEN deductible <= 3500 THEN 'Very High (2001-3500)'
        ELSE 'Extremely High (Above 3500)'
    END AS deductible_category,
    COUNT(person_id) AS total_customers,
    ROUND(AVG(deductible), 2) AS average_deductible,
    ROUND(AVG(annual_medical_cost), 2) AS average_medical_cost,
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost
FROM medical_insurance
GROUP BY deductible_category
ORDER BY MIN(deductible);


-- does provider quality influence medical cost?
SELECT
    CASE
        WHEN provider_quality < 2.5 THEN 'Low'
        WHEN provider_quality < 3.5 THEN 'Moderate'
        WHEN provider_quality < 4.5 THEN 'High'
        ELSE 'Excellent'
    END AS provider_quality_category,
 COUNT(person_id) AS total_customers,
    ROUND(AVG(annual_medical_cost), 2) AS avg_medical_cost,
    ROUND(SUM(annual_medical_cost), 2) AS total_medical_cost,
    ROUND(AVG(annual_premium), 2) AS avg_annual_premium
FROM medical_insurance
GROUP BY provider_quality_category
ORDER BY AVG(provider_quality);


-- E. CLAIMS AND PROFITABILITY ANALYSIS

-- Calculate overall claims performance which checks;
   --  How many claims have customers submitted?
   -- What is the average number of claims per customer?
   -- What is the average claim amount?
   -- How much has the insurance company paid in total?
   -- What is the average claims payment per customer?
SELECT
    COUNT(*) AS total_customers,
    SUM(claims_count) AS total_claims,
    ROUND(AVG(claims_count), 2) AS avg_claims_per_customer,
    ROUND(AVG(avg_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claims_paid), 2) AS total_claims_paid,
    ROUND(AVG(total_claims_paid), 2) AS avg_claims_paid_per_customer
FROM medical_insurance;


-- Examine claim frequency
   -- This analysis identifies how many customers fall into different claims-frequency categories which checks;
   -- Which claims-frequency category has the highest number of customers?
SELECT
    CASE
        WHEN claims_count = 0 THEN 'No Claims'
        WHEN claims_count BETWEEN 1 AND 5 THEN 'Low Frequency 1-5'
        WHEN claims_count BETWEEN 6 AND 10 THEN 'Moderate Frequency 6-10'
        WHEN claims_count BETWEEN 11 AND 15 THEN 'High Frequency 11-15'
        ELSE 'Very High Frequency 16 above'
    END AS claims_frequency_category,
    COUNT(*) AS total_customers,
    SUM(claims_count) AS total_claims,
    ROUND(AVG(claims_count), 2) AS avg_claims
FROM medical_insurance
GROUP BY claims_frequency_category
ORDER BY MIN(claims_count);


-- Examine total claims paid
   -- This analysis measures the total financial obligation associated with customer claims.
SELECT
    ROUND(SUM(total_claims_paid), 2) AS total_claims_paid,
    ROUND(AVG(total_claims_paid), 2) AS avg_claims_paid,
    ROUND(MIN(total_claims_paid), 2) AS minimum_claims_paid,
    ROUND(MAX(total_claims_paid), 2) AS maximum_claims_paid
FROM medical_insurance;


-- Identify the customer with the highest claims paid
SELECT
    person_id,
    claims_count,
    avg_claim_amount,
    total_claims_paid
FROM medical_insurance
ORDER BY total_claims_paid DESC
LIMIT 10;


--  Claims to premium ratio by insurance plan
   -- A higher claims ratio means a larger proportion of premium revenue is being used to pay claims
SELECT
    plan_type,
    ROUND(SUM(total_claims_paid), 2) AS total_claims_paid,
    ROUND(SUM(annual_premium), 2) AS total_premium,
    ROUND(
        SUM(total_claims_paid) /
        NULLIF(SUM(annual_premium), 0) * 100, 2
    ) AS claims_ratio
FROM medical_insurance
GROUP BY plan_type
ORDER BY claims_ratio DESC;


-- Compare claims performance across insurance plans which checks;
   -- Which insurance plan has the highest number of claims?
   -- Which plan has the highest average claim amount?
   -- Which insurance plan accounts for the highest total claims paid?
   -- Which plan has the highest claims frequency per customer?
SELECT
    plan_type,
    COUNT(*) AS total_customers,
    SUM(claims_count) AS total_claims,
    ROUND(AVG(claims_count), 2) AS avg_claims_per_customer,
    ROUND(AVG(avg_claim_amount), 2) AS avg_claim_amount,
    ROUND(SUM(total_claims_paid), 2) AS total_claims_paid
FROM medical_insurance
GROUP BY plan_type
ORDER BY total_claims_paid DESC;


-- Diffrence between premiun and claims paid 
SELECT
    ROUND(SUM(annual_premium), 2) AS total_premium,
    ROUND(SUM(total_claims_paid), 2) AS total_claims,
    ROUND(
        SUM(annual_premium) - SUM(total_claims_paid), 2
    ) AS Differences
FROM medical_insurance;
 
 
 
 