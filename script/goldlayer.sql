-- EDA ANALYSIS
--DB EXPLORATION

select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where TABLE_SCHEMA='silver'
select * from silver.affiliates

--CHECKING FOR NULL VALUES IN TABLES
--1. CHECK NULL VALUES IN AFFILIATES TABLE	
SELECT * FROM silver.affiliates
WHERE member_id IS NULL

--2. CHECK NULL VALUES IN AFFILIATES_PROMO_CODE TABLE

select *
from silver.affiliates_promo_code
where sub_channel is null 
or promo_type is null
or member_incentive_amount is null
or min_funding_amount is null
or max_funding_days is null

--CEHCKING FOR DUPLICATE PROMO CODES IN AFFILIATES_PROMO_CODE TABLE
SELECT promo_code, COUNT(*) AS promo_code_count
FROM silver.affiliates_promo_code
GROUP BY promo_code
HAVING COUNT(*) > 1



--CONSLIDATE THE AFFILIATES DATA WITH PROMO CODE DETAILS - DATA CLEANING AND DATA STANDARDIZATION

WITH Cleaned_Affiliates AS
(
select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
from silver.affiliates a	
INNER JOIN silver.affiliates_promo_code apc
	on a.promo_code = apc.promo_code
)
SELECT *
FROM Cleaned_Affiliates

--Below code block creates a cleaned affiliates table with only valid sub_channel and promo_type values
--ANALYSIS OF EACH CHANNEL SEPERATLY

-- 1. TOP 5 PROMO CODES BY TOTAL REVENUE IN FIRST 45 DAYS
WITH Cleaned_Affiliates AS
(
select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
from silver.affiliates a	
INNER JOIN silver.affiliates_promo_code apc
	on a.promo_code = apc.promo_code
),
Final_Cleaned_Affiliates AS
(
select
promo_code,
COUNT(member_id) AS total_members,
sum(revenue_1st_45_days) AS total_revenue_45_days,
avg(revenue_1st_45_days) AS avg_revenue_45_days,
ROW_NUMBER() OVER (ORDER BY sum(revenue_1st_45_days) DESC) AS revenue_rank
FROM Cleaned_Affiliates
GROUP BY promo_code
)
SELECT
*
FROM Final_Cleaned_Affiliates
WHERE revenue_rank <= 5


--2. TOP 5 PROMO CODES BY HIGH AVERAGE REVENUE IN FIRST 45 DAYS
WITH Cleaned_Affiliates AS
(
select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
from silver.affiliates a	
INNER JOIN silver.affiliates_promo_code apc
	on a.promo_code = apc.promo_code
),
Final_Cleaned_Affiliates AS
(
select
promo_code,
COUNT(member_id) AS total_members,
sum(revenue_1st_45_days) AS total_revenue_45_days,
avg(revenue_1st_45_days) AS avg_revenue_45_days,
ROW_NUMBER() OVER (ORDER BY avg(revenue_1st_45_days) DESC) AS revenue_rank
FROM Cleaned_Affiliates
GROUP BY promo_code
)
SELECT
*
FROM Final_Cleaned_Affiliates
WHERE revenue_rank <= 5

--3. TOP 5 PROMO CODES BY HIGHEST MEMBER COUNT

WITH Cleaned_Affiliates AS
(
select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
from silver.affiliates a	
INNER JOIN silver.affiliates_promo_code apc
	on a.promo_code = apc.promo_code
),
Final_Cleaned_Affiliates AS
(
select
promo_code,
COUNT(member_id) AS total_members,
sum(revenue_1st_45_days) AS total_revenue_45_days,
avg(revenue_1st_45_days) AS avg_revenue_45_days,
ROW_NUMBER() OVER (ORDER BY COUNT(member_id) DESC) AS revenue_rank
FROM Cleaned_Affiliates
GROUP BY promo_code
)
SELECT
*
FROM Final_Cleaned_Affiliates
WHERE revenue_rank <= 5

--4. ANALYSIS OF PROMO CODES BASED ON SUB_CHANNEL AND PROMO TYPE
WITH Cleaned_Affiliates AS
(
select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
from silver.affiliates a	
INNER JOIN silver.affiliates_promo_code apc
	on a.promo_code = apc.promo_code
),
Final_Cleaned_Affiliates AS
(
SELECT
sub_channel,
promo_type,
SUM(revenue_1st_45_days) as  total_revenue_45_days,
COUNT(member_id) as total_members,
AVG(revenue_1st_45_days) avg_revenue_45_days,
ROW_NUMBER() OVER (ORDER BY SUM(revenue_1st_45_days) DESC) AS revenue_rank
FROM Cleaned_Affiliates
group by
	sub_channel,
	promo_type
)
select
* 
from Final_Cleaned_Affiliates

-- 5. promo_type wise analysis
WITH Cleaned_Affiliates AS
(select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
	from silver.affiliates a
	INNER JOIN silver.affiliates_promo_code apc
		on a.promo_code = apc.promo_code
		),
		Final_Cleaned_Affiliates AS
		(
		SELECT
		promo_type,
		SUM(revenue_1st_45_days) as  total_revenue_45_days,
		COUNT(member_id) as total_members,
		AVG(revenue_1st_45_days) avg_revenue_45_days,
		ROW_NUMBER() OVER (ORDER BY SUM(revenue_1st_45_days) DESC) AS revenue_rank
		FROM Cleaned_Affiliates
		group by
			promo_type
		)	
		select
		*
		from Final_Cleaned_Affiliates


--6. promo_type wise analysis
WITH Cleaned_Affiliates AS
(select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
	from silver.affiliates a
	INNER JOIN silver.affiliates_promo_code apc
		on a.promo_code = apc.promo_code
		)
		
	select
	promo_code,
	COUNT(member_id) AS total_members,
	SUM(revenue_1st_45_days) AS total_revenue_45_days,
	sum(member_incentive_amount) as total_incentive_amount
	from Cleaned_Affiliates
	group by promo_code
	

--7. PROMO CODES WITH ABOVE AVERAGE REVENUE IN FIRST 45 DAYS	
with Cleaned_Affiliates AS
(
select
promo_code,
sum(revenue_1st_45_days) as total_revenue_45_days,
avg(revenue_1st_45_days) as avg_revenue_45_days
from silver.affiliates
group by promo_code
),
Final_Cleaned_Affiliates AS
(
select 
promo_code,
total_revenue_45_days,
AVG(total_revenue_45_days) OVER () AS overall_avg_revenue,
total_revenue_45_days - AVG(total_revenue_45_days) OVER () AS difference_from_avg,
SUM(total_revenue_45_days) OVER (ORDER BY total_revenue_45_days DESC) AS cumulative_revenue
from Cleaned_Affiliates
)
select *
from Final_Cleaned_Affiliates
where difference_from_avg>0



--8.Check industry wise revenue
WITH Cleaned_Affiliates AS
(select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
from silver.affiliates a
INNER JOIN silver.affiliates_promo_code apc
	on a.promo_code = apc.promo_code
)
select
industry_class,
SUM(revenue_1st_45_days) as  total_revenue_45_days,
COUNT(member_id) as total_members,
AVG(revenue_1st_45_days) avg_revenue_45_days
FROM Cleaned_Affiliates
group by
	industry_class
order by total_revenue_45_days desc

-- 9. find roi of each promo code 
WITH Cleaned_Affiliates AS
(select
	a.member_id,
	apc.promo_code,
	CASE
		WHEN apc.sub_channel in ('Digital', 'Non-Digital') THEN apc.sub_channel
		ELSE NULL
	END AS sub_channel,
	a.industry_class,
	CASE
		WHEN apc.promo_type in ('Cash', 'Non-Cash') THEN apc.promo_type
		ELSE NULL
	END AS promo_type,
	apc.member_incentive_amount,
	apc.min_spending_amount,
	A.platform_joining_date,
	DATEADD(DD,45,A.platform_joining_date) AS revenue_45_days_date,
	a.revenue_1st_45_days,
	a.active_last_7_days
	from silver.affiliates a
	INNER JOIN silver.affiliates_promo_code apc
		on a.promo_code = apc.promo_code
		)
select
promo_type,
SUM(revenue_1st_45_days) as  total_revenue_45_days,
SUM(member_incentive_amount) as total_incentive_amount,
CAST(SUM(revenue_1st_45_days) AS DECIMAL(18,2)) / replace(coalesce(SUM(member_incentive_amount),0),0,1) AS roi
FROM Cleaned_Affiliates
group by
	promo_type
	order by roi desc

SELECT
    ROUND(AVG(active_last_7_days) * 100, 5) AS active_rate_percentage
FROM silver.affiliates;


SELECT
    CASE
        WHEN p.min_funding_amount < 50 THEN 'Low Funding'
        WHEN p.min_funding_amount BETWEEN 50 AND 100 THEN 'Medium Funding'
        ELSE 'High Funding'
    END AS funding_bucket,
    ROUND(AVG(a.revenue_1st_45_days),2) AS avg_revenue
FROM silver.affiliates a
JOIN silver.affiliates_promo_code p
    ON a.promo_code = p.promo_code
group by
	CASE
		WHEN p.min_funding_amount < 50 THEN 'Low Funding'
		WHEN p.min_funding_amount BETWEEN 50 AND 100 THEN 'Medium Funding'
		ELSE 'High Funding'
	END

SELECT *
FROM silver.affiliates
WHERE revenue_1st_45_days >
      (SELECT AVG(revenue_1st_45_days) * 5 FROM silver.affiliates)
ORDER BY revenue_1st_45_days DESC;

-- CONSOLIDATED view that has all channels data combined with their promo code details
-- The view should have a new column 'Channel' to identify the source channel of the data (Affiliate, Partnership, Referral)

create or alter view gold.consolidated_channel_analysis as
WITH CONS_DATA AS
(select 
	'Affiliate' as Channel,
	A.member_id,a.platform_joining_date, a.promo_code, a.industry_class, a.active_last_7_days, a.revenue_1st_45_days,
	apc.promo_type, apc.member_incentive_amount, apc.min_funding_amount, apc.max_funding_days,apc.min_spending_amount, apc.max_spending_month
	from silver.affiliates a
	INNER JOIN silver.affiliates_promo_code apc
		on a.promo_code = apc.promo_code

UNION ALL
select
	'Partnership' as Channel,
	A.member_id,a.platform_joining_date, a.promo_code, a.industry_class, a.active_last_7_days, a.revenue_1st_45_days,
	apc.promo_type, apc.member_incentive_amount, apc.min_funding_amount, apc.max_funding_days,apc.min_spending_amount, apc.max_spending_month
	from silver.partnerships a
	INNER JOIN silver.partnerships_promo_code apc
		on a.promo_code = apc.promo_code

UNION ALL
select
	'Referral' as Channel,
	A.member_id,a.platform_joining_date, a.promo_code, a.industry_class, a.active_last_7_days, a.revenue_1st_45_days,
	apc.promo_type, apc.member_incentive_amount, apc.min_funding_amount, apc.max_funding_days,apc.min_spending_amount, apc.max_spending_month
	from silver.referral a
	INNER JOIN silver.referral_promo_code apc
		on a.promo_code = apc.promo_code
		)
select
*
from
CONS_DATA

-- Top 5 members by revenue across all channels
WITH Ranked_Members AS (
	SELECT 
		Channel,
		member_id,
		revenue_1st_45_days,
		RANK() OVER (ORDER BY revenue_1st_45_days DESC) AS revenue_rank
	FROM 
		gold.consolidated_channel_analysis
)
select 
	Channel,
	member_id,
	revenue_1st_45_days
	from
	Ranked_Members
	where
		revenue_rank <= 5

-- Average revenue by channel
		select
		Channel,
			SUM(revenue_1st_45_days) AS total_revenue,
			AVG(revenue_1st_45_days) AS average_revenue
			from
			gold.consolidated_channel_analysis
			group by
			Channel
			order by
			total_revenue DESC
  
---- Top 10 revenue based on channel and promo code wise
/*
S.No	Channel		 Promo_Code			Total_Member	Total_Revenue_45_Daya	Total_AVG_45_Daya	Rank
1		Partnership	 REFER75			561				8733.2					15.567201			1
2		Referral	 MSM5FREE			284				8717.7					30.696126			2
3		Referral	 MONEY5FREE			257				6101.5					23.741245			3
4		Partnership	 MTA22				599				4678.8					7.811018			4
5		Referral	 6FREEBUSINESS		126				2622.1					20.810317			5
6		Partnership	 MADE_SIMPLE		140				1900.1					13.572142			6
7		Partnership	 REFORM				131				1428.1					10.901526			7
8		Partnership	 BUSINESSTOOLBOX	55				870.5					15.827272			8
9		Affiliate	 XMAS22				78				813.2					10.425641			9
10		Affiliate	 UBERLDN50FM		159				633.6					3.984905			10


-- Top 5 and Bottom 5 promo code and channel detail wise total_revenue / top and bottom analysis
S.No	Channel			Promo_Code		Total_Member	Total_Revenue_45_Days	Total_AVG_45_Days	Rank
1		Partnership		REFER75			561				8733.2					15.567201			1
2		Referral		MSM5FREE		284				8717.7					30.696126			2
3		Referral		MONEY5FREE		257				6101.5					23.741245			3
4		Partnership		MTA22			599				4678.8					7.811018			4
5		Referral		6FREEBUSINESS	126				2622.1					20.810317			5
6		Partnership		WEBBLES			1				0.4						0.4					131
7		Partnership		ULTIMATEFINANCE	1				0.4						0.4					132
8		Partnership		WORKLIFE		1				0.2						0.2					133
9		Partnership		IPSE			1				0.2						0.2					134
10		Partnership		HYSONS			1				0						0					135

*/
select 
* from
(
select
	channel,
	promo_code,
	COUNT(member_id) AS total_members,
	sum(revenue_1st_45_days) AS total_revenue_45_days,
	avg(revenue_1st_45_days) AS avg_revenue_45_days,
	ROW_NUMBER() OVER (ORDER BY sum(revenue_1st_45_days) DESC) AS revenue_rank
FROM gold.consolidated_channel_analysis
GROUP BY channel,promo_code--,promo_code
	)top_bottom
WHERE revenue_rank <= 5 OR revenue_rank > (SELECT MAX(revenue_rank) - 5 FROM
(
	select
	channel,
	promo_code,
	COUNT(member_id) AS total_members,
	sum(revenue_1st_45_days) AS total_revenue_45_days,
	avg(revenue_1st_45_days) AS avg_revenue_45_days,
	ROW_NUMBER() OVER (ORDER BY sum(revenue_1st_45_days) DESC) AS revenue_rank
	FROM gold.consolidated_channel_analysis
	GROUP BY channel,promo_code
)AS subquery)

-- Channel and Promo code wise active vs inactive members analysis

WITH promo_activity_summary AS (
    SELECT
        Channel,
        promo_code,
        active_last_7_days,
        COUNT(member_id) AS total_members,
        SUM(revenue_1st_45_days) AS total_revenue_45_days,
        ROUND(AVG(revenue_1st_45_days), 2) AS avg_revenue_45_days
    FROM gold.consolidated_channel_analysis
    GROUP BY Channel, promo_code, active_last_7_days
),
promo_pivot AS (
    SELECT
        Channel,
        promo_code,
        SUM(CASE WHEN active_last_7_days = 1 THEN total_members ELSE 0 END) AS active_members,
        SUM(CASE WHEN active_last_7_days = 0 THEN total_members ELSE 0 END) AS inactive_members,
        SUM(CASE WHEN active_last_7_days = 1 THEN total_revenue_45_days ELSE 0 END) AS active_revenue,
        SUM(CASE WHEN active_last_7_days = 0 THEN total_revenue_45_days ELSE 0 END) AS inactive_revenue
    FROM promo_activity_summary
    GROUP BY Channel, promo_code
)
SELECT
    Channel,
    promo_code,
    active_members + inactive_members AS total_members,
    active_revenue + inactive_revenue AS total_revenue_45_days,
    ROUND(active_revenue * 100.0 / NULLIF(active_revenue + inactive_revenue, 0), 2) AS active_revenue_pct,
    ROUND(inactive_revenue * 100.0 / NULLIF(active_revenue + inactive_revenue, 0), 2) AS inactive_revenue_pct
FROM promo_pivot
ORDER BY Channel, promo_code;

--detection of over incentive promotion

WITH promo_incentive_analysis AS (
	SELECT
		Channel,
		promo_code,
		member_incentive_amount,
		AVG(revenue_1st_45_days) AS avg_revenue_45_days,
		COUNT(member_id) AS total_members
	FROM gold.consolidated_channel_analysis
	GROUP BY Channel, promo_code, member_incentive_amount
)
SELECT
	Channel,
	promo_code,
	member_incentive_amount,
	avg_revenue_45_days,
	total_members,
	CASE
		WHEN member_incentive_amount > avg_revenue_45_days THEN 'Over-Incentivized'
		WHEN member_incentive_amount < avg_revenue_45_days THEN 'Incentivized'
		ELSE 'Adequately Incentivized'
	END AS incentive_evaluation
	FROM promo_incentive_analysis
	WHERE member_incentive_amount < avg_revenue_45_days
	ORDER BY Channel, promo_code;
	-- End of Script

--Channel-wise guidance on optimal incentive levels

WITH channel_incentive_guidance AS (
	SELECT
		Channel,
		promo_code,
		member_incentive_amount,
		AVG(revenue_1st_45_days) AS avg_revenue_45_days,
		COUNT(member_id) AS total_members
	FROM gold.consolidated_channel_analysis
	GROUP BY Channel, promo_code, member_incentive_amount
)
SELECT
	Channel,
	promo_code,
	member_incentive_amount,
	avg_revenue_45_days,
	total_members,
	CASE
		WHEN member_incentive_amount < avg_revenue_45_days * 0.8 THEN 'Consider Increasing Incentive'
		WHEN member_incentive_amount > avg_revenue_45_days * 1.2 THEN 'Consider Decreasing Incentive'
		ELSE 'Incentive Level Appropriate'
	END AS incentive_guidance
	FROM channel_incentive_guidance
	ORDER BY Channel, promo_code;

--Strategic recommendations to improve promotion governance and controls
WITH promo_performance AS (
	SELECT
		Channel,
		promo_code,
		member_incentive_amount,
		AVG(revenue_1st_45_days) AS avg_revenue_45_days,
		COUNT(member_id) AS total_members
	FROM gold.consolidated_channel_analysis
	GROUP BY Channel, promo_code, member_incentive_amount
)
SELECT
	Channel,
	promo_code,
	member_incentive_amount,
	avg_revenue_45_days,
	total_members,
	CASE
		WHEN member_incentive_amount > avg_revenue_45_days THEN 'Review Incentive Structure'
		WHEN total_members < 10 THEN 'Increase Promotion Awareness'
		ELSE 'Maintain Current Strategy'
	END AS strategic_recommendation
	FROM promo_performance
	ORDER BY Channel, promo_code;
	-- End of Script
