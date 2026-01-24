
/*
creating database and the tables in bronze schema
*/
use master;
GO


-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Market_Study')
BEGIN
    ALTER DATABASE Market_Study SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Market_Study;
END;
GO


CREATE DATABASE Market_Study
use Market_study

create schema bronze;
go

create schema silver;
go

create schema gold;
go

-- Member Performance Tables - affiliate , partnership , referral

IF OBJECT_ID('bronze.affiliates', 'U') IS NOT NULL
    DROP TABLE bronze.affiliates;

CREATE TABLE bronze.affiliates (
    member_id BIGINT PRIMARY KEY,
    platform_joining_date DATE,
    promo_code VARCHAR(50),
    industry_class VARCHAR(100),
    active_last_7_days INT,
    revenue_1st_45_days DECIMAL(10,2)
);

IF OBJECT_ID('bronze.partnerships', 'U') IS NOT NULL
    DROP TABLE bronze.partnerships;

CREATE TABLE bronze.partnerships (
    member_id BIGINT PRIMARY KEY,
    platform_joining_date DATE,
    promo_code VARCHAR(50),
    industry_class VARCHAR(100),
    active_last_7_days INT,
    revenue_1st_45_days DECIMAL(10,2)
);

IF OBJECT_ID('bronze.referral', 'U') IS NOT NULL
    DROP TABLE bronze.referral;

CREATE TABLE bronze.referral (
    member_id BIGINT PRIMARY KEY,
    platform_joining_date DATE,
    promo_code VARCHAR(50),
    industry_class VARCHAR(100),
    active_last_7_days INT,
    revenue_1st_45_days DECIMAL(10,2)
);

--Promotion Metadata Tables affiliate_promo_code , partnership_promo_code , referral_promo_code


IF OBJECT_ID('bronze.affiliates_promo_code', 'U') IS NOT NULL
    DROP TABLE bronze.affiliates_promo_code;

CREATE TABLE bronze.affiliates_promo_code (
    promo_code VARCHAR(50),
    sub_channel VARCHAR(50),
    promo_type VARCHAR(20),
    member_incentive_amount DECIMAL(10,2),
    min_funding_amount DECIMAL(10,2),
    max_funding_days INT,
    min_spending_amount DECIMAL(10,2),
    max_spending_month INT
);

IF OBJECT_ID('bronze.partnerships_promo_code', 'U') IS NOT NULL
    DROP TABLE bronze.partnerships_promo_code;

CREATE TABLE bronze.partnerships_promo_code (
    promo_code VARCHAR(50),
    promo_type VARCHAR(20),
    member_incentive_amount DECIMAL(10,2),
    min_funding_amount DECIMAL(10,2),
    max_funding_days INT,
    min_spending_amount DECIMAL(10,2),
    max_spending_month INT
);

IF OBJECT_ID('bronze.referral_promo_code', 'U') IS NOT NULL
    DROP TABLE bronze.referral_promo_code;

CREATE TABLE bronze.referral_promo_code (
    promo_code VARCHAR(50),
    promo_type VARCHAR(20),
    member_incentive_amount DECIMAL(10,2),
    min_funding_amount DECIMAL(10,2),
    max_funding_days INT,
    min_spending_amount DECIMAL(10,2),
    max_spending_month INT
);



