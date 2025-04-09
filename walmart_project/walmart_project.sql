select *
from walmart;

select count(*)
from walmart;

select distinct(branch)
from walmart
order by Branch desc;

select distinct(payment_method)
from walmart;

##Q.1 Find different payment method and number of transactions, number of qty sold

select distinct(payment_method),
	   count(*) as no_of_transaction,
	   sum(quantity) as total_quantity
from walmart
group by payment_method;

-- Project Question #2
-- Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING

select *
from (
select branch,
	   category, 
       avg(rating) as avg_rating,
       rank() over(partition by Branch order by avg(rating) desc) as ranking
from walmart
group by 1, 2
order by 1, 3 desc
) as ranked_data
where ranking = 1;



-- Q.3 Identify the busiest day for each branch based on the number of transactions

with ranked_data as (
select branch,
	   dayname(str_to_date(date, '%d/%m/%y')) as day,
       count(*) as no_of_transaction,
       rank() over(partition by Branch order by count(*) desc) as ranked
from walmart
group by 1, 2
order by 1, 3 desc
)
select *
from ranked_data
where ranked = 1;

-- Q. 4 
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.


SELECT 
	 payment_method,
	 -- COUNT(*) as no_payments,
	 SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method

-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.

SELECT 
	city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1, 2
order by 1, 2;

-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

SELECT 
	category,
	SUM(Total_price) as total_revenue,
	SUM(Total_price * profit_margin) as profit
FROM walmart
GROUP BY 1;

-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

WITH cte 
AS
(SELECT 
	branch,
	payment_method,
	COUNT(*) as total_trans,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
FROM walmart
GROUP BY 1, 2
)
SELECT *
FROM cte
WHERE rank = 1;

-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT branch,
	case 
		when hour((time)) < 12 then 'Morning'
		when hour((time)) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift, 
	count(*) as count
FROM walmart
group by 1,2
order by 1, 2;

-- #9 Identify 5 branch with highest decrese ratio in 
-- revevenue compare to last year(current year 2023 and last year 2022)

-- rdr == last_rev-cr_rev/ls_rev*100

with 
revenue_2022 as
(
select branch,
	   sum(Total_price) as revenue
from walmart
where year(str_to_date(date, '%d/%m/%y')) = 2022
group by 1
),
revenue2023 as
(
select branch,
	   sum(Total_price) as revenue
from walmart
where year(str_to_date(date, '%d/%m/%y')) = 2023
group by 1
)

select ls.branch,
	   ls.revenue as last_year_revenue,
       cy.revenue as current_revenue,
    round((ls.revenue - cy.revenue)/ls.revenue *100 ,2) as rec_des_ratio
from revenue_2022 as ls
join revenue2023 as cy
on ls.branch = cy.branch
where ls.revenue > cy.revenue
order by 4 desc



