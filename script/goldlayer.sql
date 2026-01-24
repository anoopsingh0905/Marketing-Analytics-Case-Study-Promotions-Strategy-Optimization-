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
  

