##📊 Marketing Analytics Case Study
Promotions Strategy Optimisation
##📌 Project Overview
Promotions play a critical role in customer acquisition at Tide across multiple marketing channels. However, unregulated promotion strategies—such as uncontrolled incentive amounts and flexible terms & conditions—have led to increased incentive costs, lower member quality, and misuse of promotions.

This project focuses on analysing historical promotion performance across marketing channels to help the marketing team optimize future promotion strategies. The goal is to identify promotions that deliver the best return on investment (ROI) while minimizing financial and operational risks.

The analysis is based on past member performance, revenue generation, activity status, and promotion metadata, with insights presented in a business-friendly manner.

##🎯 Project Objectives
1. The key objectives of this project are: Understand the datasets and document assumptions in clear business language Evaluate promotion performance across different marketing channels
2. Identify high-ROI promotions and channels that deliver quality members
3. Detect inefficient or risky promotions contributing to higher incentive costs
4. Provide actionable recommendations to optimize future promotion planning
(Optional) Propose predictive modelling approaches for promotion selection

##📂 Datasets Description

The analysis uses six CSV files, grouped as follows:
1️⃣ Channel Performance Data
affiliates.csv
partnerships.csv
referral.csv
These datasets capture member-level performance after joining Tide through different marketing channels.
Key Fields:
member_id: Unique member identifier
platform_joining_date: Date of member onboarding
promo_code: Promotion code used at signup
industry_class: Member’s industry category
active_last_7_days: Member activity indicator (as of 15 March 2023)
revenue_1st_45_days: Net revenue generated in the first 45 days

##2️⃣ Promotion Metadata
affiliates_promo_code.csv
partnerships_promo_code.csv
referral_promo_code.csv
These datasets describe promotion design and incentive mechanics.
Key Fields:
promo_code: Unique promotion identifier
sub_channel: Sub-channel (available only for Affiliates)
promo_type: Cash or Non-Cash incentive
member_incentive_amount: Incentive cost (GBP)
min_funding_amount: Minimum funding requirement
max_funding_days: Time window for funding
min_spending_amount: Minimum spending requirement
max_spending_month: Spending time window

##🏗️ Data Architecture
The project follows a layered analytics architecture to ensure scalability, clarity, and analytical accuracy.
🔹 Architecture Layers
Raw Data (CSV Files)
        ↓
Staging Layer (SQL Server)
        ↓
Transformation Layer
        ↓
Analytics / Insights Layer

🔹 Layer Details
1. Raw Data Layer
Source CSV files provided for analysis
No transformations applied
Used for traceability and auditing

2. Staging Layer
Data loaded into SQL Server tables
Schema aligned with source structure
Minimal constraints applied
Enables reprocessing and validation

3. Transformation Layer
Data cleaning and standardization
Handling missing values and data types
Joining member data with promotion metadata
Feature creation (ROI, incentive ratios, activity flags)

4. Analytics Layer
Aggregated metrics by:
  Channel
  Sub-channel
  Promo type
  Incentive amount

Used for:
-Exploratory Data Analysis (EDA)
-Visualization
-Business insights
-Optional predictive modelling

##📈 Analytical Approach

The analysis focuses on the following dimensions:
1. Channel Performance- Revenue, activity rate, and incentive efficiency by channel
2. Promotion Effectiveness-Comparison of cash vs non-cash incentives
3. ROI Analysis- Revenue generated per unit of incentive spent
4. Member Quality- Activity status and revenue contribution in the first 45 days
5. Risk Indicators-High incentives with low revenue or engagement

Insights are presented using clear charts and summaries, designed for a non-technical marketing audience.

##💡 Key Outcomes (High Level)
1. Identification of best-performing promotions by channel
2. Detection of over-incentivized promotions with poor returns
3. Channel-wise guidance on optimal incentive levels
4. Strategic recommendations to improve promotion governance and controls


##🛠️ Tools & Technologies
SQL Server
VS Code
GitHub

##📁 Repository Structure (Suggested)
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
│   ├── EDA.ipynb
│   └── Analysis.ipynb
├── sql/
│   └── table_creation.sql
├── visuals/
├── README.md

✅ Final Note

This project demonstrates end-to-end analytical thinking, from raw data understanding to business-driven insights and strategic recommendations. It is designed to reflect real-world marketing analytics challenges and decision-making scenarios.
