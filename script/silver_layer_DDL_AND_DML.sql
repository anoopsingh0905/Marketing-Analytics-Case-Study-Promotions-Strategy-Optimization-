/*creating table for silver schema 
 we will create the tables in silver schema based on the transformations applied on bronze tables
 two task performed
 1. creating the silver layer tables
 2.  data cleaning from bronze layer and load the data in silver layer
*/

-- Member Performance Tables - affiliate , partnership , referral

IF OBJECT_ID('silver.affiliates', 'U') IS NOT NULL
    DROP TABLE silver.affiliates;

CREATE TABLE silver.affiliates (
    member_id BIGINT PRIMARY KEY,
    platform_joining_date DATE,
    promo_code VARCHAR(50),
    industry_class VARCHAR(100),
    active_last_7_days INT,
    revenue_1st_45_days DECIMAL(10,2)
);

IF OBJECT_ID('silver.partnerships', 'U') IS NOT NULL
    DROP TABLE silver.partnerships;

CREATE TABLE silver.partnerships (
    member_id BIGINT PRIMARY KEY,
    platform_joining_date DATE,
    promo_code VARCHAR(50),
    industry_class VARCHAR(100),
    active_last_7_days INT,
    revenue_1st_45_days DECIMAL(10,2)
);

IF OBJECT_ID('silver.referral', 'U') IS NOT NULL
    DROP TABLE silver.referral;

CREATE TABLE silver.referral (
    member_id BIGINT PRIMARY KEY,
    platform_joining_date DATE,
    promo_code VARCHAR(50),
    industry_class VARCHAR(100),
    active_last_7_days INT,
    revenue_1st_45_days DECIMAL(10,2)
);

--Promotion Metadata Tables affiliate_promo_code , partnership_promo_code , referral_promo_code


IF OBJECT_ID('silver.affiliates_promo_code', 'U') IS NOT NULL
    DROP TABLE silver.affiliates_promo_code;

CREATE TABLE silver.affiliates_promo_code (
    promo_code VARCHAR(50),
    sub_channel VARCHAR(50),
    promo_type VARCHAR(20),
    member_incentive_amount DECIMAL(10,2),
    min_funding_amount DECIMAL(10,2),
    max_funding_days INT,
    min_spending_amount DECIMAL(10,2),
    max_spending_month INT
);

IF OBJECT_ID('silver.partnerships_promo_code', 'U') IS NOT NULL
    DROP TABLE silver.partnerships_promo_code;

CREATE TABLE silver.partnerships_promo_code (
    promo_code VARCHAR(50),
    promo_type VARCHAR(20),
    member_incentive_amount DECIMAL(10,2),
    min_funding_amount DECIMAL(10,2),
    max_funding_days INT,
    min_spending_amount DECIMAL(10,2),
    max_spending_month INT
);

IF OBJECT_ID('silver.referral_promo_code', 'U') IS NOT NULL
    DROP TABLE silver.referral_promo_code;

CREATE TABLE silver.referral_promo_code (
    promo_code VARCHAR(50),
    promo_type VARCHAR(20),
    member_incentive_amount DECIMAL(10,2),
    min_funding_amount DECIMAL(10,2),
    max_funding_days INT,
    min_spending_amount DECIMAL(10,2),
    max_spending_month INT
);


/* --Loading data in silver 

-- loading data into silver schema where data is clean


--there is no duplicate or null data in affiliates table so as is data moving into silver layer
--inserting data into data channels table affiliates, partnerships and referral
*/
USE market_study
INSERT INTO silver.affiliates
            (member_id,
             platform_joining_date,
             promo_code,
             industry_class,
             active_last_7_days,
             revenue_1st_45_days)
SELECT member_id,
       platform_joining_date,
       promo_code,
       industry_class,
       active_last_7_days,
       revenue_1st_45_days
FROM   bronze.affiliates

--same for partnerships table
INSERT INTO silver.partnerships
            (member_id,
             platform_joining_date,
             promo_code,
             industry_class,
             active_last_7_days,
             revenue_1st_45_days)
SELECT member_id,
       platform_joining_date,
       promo_code,
       industry_class,
       active_last_7_days,
       revenue_1st_45_days
FROM   bronze.partnerships

--same for referral table as there is no negative or null revenue_1st_45_days
INSERT INTO silver.referral
            (member_id,
             platform_joining_date,
             promo_code,
             industry_class,
             active_last_7_days,
             revenue_1st_45_days)
SELECT member_id,
       platform_joining_date,
       promo_code,
       industry_class,
       active_last_7_days,
       revenue_1st_45_days
FROM   bronze.referral

--inserting data into promocode tables affiliates_promo_code,partnerships_promo_code and referral_promo_code
--inserting data into affiliates_promo_code table after removing duplicate promo_code
INSERT INTO silver.affiliates_promo_code
            (promo_code,
             sub_channel,
             promo_type,
             member_incentive_amount,
             min_funding_amount,
             max_funding_days,
             min_spending_amount,
             max_spending_month)
SELECT promo_code,
       sub_channel,
       promo_type,
       member_incentive_amount,
       min_funding_amount,
       max_funding_days,
       min_spending_amount,
       max_spending_month
FROM   (SELECT *,
               Row_number()
                 OVER(
                   partition BY promo_code
                   ORDER BY promo_code) AS row_num
        FROM   bronze.affiliates_promo_code) AS subquery
WHERE  row_num = 1;

--inserting data into partnerships_promo_code table after removing duplicate promo_code
INSERT INTO silver.partnerships_promo_code
            (promo_code,
             promo_type,
             member_incentive_amount,
             min_funding_amount,
             max_funding_days,
             min_spending_amount,
             max_spending_month)
SELECT DISTINCT *
FROM   bronze.partnerships_promo_code

--inserting data into referral_promo_code table after removing duplicate promo_code
INSERT INTO silver.referral_promo_code
            (promo_code,
             promo_type,
             member_incentive_amount,
             min_funding_amount,
             max_funding_days,
             min_spending_amount,
             max_spending_month)
SELECT DISTINCT *
FROM   bronze.referral_promo_code 
