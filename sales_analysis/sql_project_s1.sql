--creat new table
Drop table if exists sales;
create table sales (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,	
	total_sale FLOAT
	)

--explore data
select * from sales;

--row count
select count(*)
from sales;

--deal with null values
select *
from sales
where transactions_id isnull 
	  or sale_date isnull
	  or sale_time isnull
	  or customer_id isnull
	  or gender isnull
	  or age isnull
	  or category isnull
	  or quantiy isnull
	  or price_per_unit isnull
	  or cogs isnull
	  or total_sale isnull;

-- fill age with avg age w.r.t gender

with avg_table as(
select gender, avg(age) as avg_age 
from sales
where age is not null
group by gender
)

UPDATE sales
SET age = avg_table.avg_age
FROM avg_table
WHERE avg_table.gender = sales.gender
AND sales.age IS NULL;

-- delete the rest of the rows

delete from sales
where transactions_id isnull 
	  or sale_date isnull
	  or sale_time isnull
	  or customer_id isnull
	  or gender isnull
	  or age isnull
	  or category isnull
	  or quantiy isnull
	  or price_per_unit isnull
	  or cogs isnull
	  or total_sale isnull;

-- how many customers 

select count(distinct customer_id) as total_customer
from sales;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select *
from sales 
where sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022:


select *
from sales 
where category = 'Clothing' 
and quantiy > 3
and to_char(sale_date, 'yyyy-mm') = '2022-11';

--Write a SQL query to calculate the total sales (total_sale) for each category.:

select category, sum(total_sale) as total_sale, count(*) as total_order
from sales 
group by category

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age),2) as average_age
from sales
where category = 'Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select distinct(transactions_id)
from sales
where total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select gender, category, count(transactions_id) as transactions_id_count
from sales
group by gender, category;

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select year, month, avg_sale
from (
select extract(year from sale_date) as year,  
	   extract(month from sale_date) as month,
	   avg(total_sale) as avg_sale,
	   rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc)
from sales
group by month, year
order by year, avg_sale desc
)
where rank = 1

--**Write a SQL query to find the top 5 customers based on the highest total sales **:

select customer_id, sum(total_sale) as total_amount
from sales
group by customer_id
order by total_amount desc
limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category.:


select  category, count(distinct customer_id) as unique_customer
from sales
group by category;

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hrs_sales
as
(
select *,
	case 
		when extract(hour from sale_time) < 12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from sales
)
select shift, count(*) as total_order
from hrs_sales
group by shift

--option 2

SELECT 
    COUNT(CASE WHEN sale_time < '12:00:00' THEN transactions_id END) AS mong,
    COUNT(CASE WHEN sale_time BETWEEN '12:00:00' AND '18:00:00' THEN transactions_id END) AS afternoon,
    COUNT(CASE WHEN sale_time >= '18:00:00' THEN transactions_id END) AS evening
FROM sales;
