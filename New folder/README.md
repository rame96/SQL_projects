# Sales Data Analysis Project
# Overview
This project involves the creation, exploration, and analysis of sales data stored in a database. The dataset includes various fields related to transactions, such as transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, and total_sale. The goal is to clean the data, perform analysis, and answer important business questions related to sales performance.

# Creating the Sales Table
The first step is to create a table named sales to store transaction data with the following fields:

transactions_id: Unique ID for each transaction (Primary Key).

sale_date: Date of sale.

sale_time: Time of sale.

customer_id: ID of the customer.

gender: Gender of the customer.

age: Age of the customer.

category: Category of the item purchased.

quantity: Quantity of items purchased.

price_per_unit: Price per unit of the item.

cogs: Cost of Goods Sold.

total_sale: Total value of the transaction.

# Exploring the Data
# Dealing with NULL Values
Filling missing age values with the average age based on gender:

WITH avg_table AS (
    SELECT gender, AVG(age) AS avg_age FROM sales WHERE age IS NOT NULL GROUP BY gender
)
UPDATE sales SET age = avg_table.avg_age FROM avg_table WHERE avg_table.gender = sales.gender AND sales.age IS NULL;

# Customer Analysis
Count the total number of unique customers:

SELECT COUNT(DISTINCT customer_id) AS total_customer FROM sales;

# Retrieving Sales Data for Specific Dates
Retrieve all sales made on '2022-11-05':

SELECT * FROM sales WHERE sale_date = '2022-11-05';

# Category-Based Analysis
Retrieve all transactions in the 'Clothing' category where quantity is more than 3 during November 2022:

SELECT * FROM sales WHERE category = 'Clothing' AND quantity > 3 AND TO_CHAR(sale_date, 'yyyy-mm') = '2022-11';

# Sales Calculation by Category
Calculate the total sales and the total number of orders for each category:

SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_order FROM sales GROUP BY category;

# Customer Age Analysis for a Specific Category
Calculate the average age of customers who purchased items from the 'Beauty' category:

SELECT ROUND(AVG(age), 2) AS average_age FROM sales WHERE category = 'Beauty';

# Transactions Over a Specific Total Sale
Find all transactions where the total_sale is greater than 1000:

SELECT DISTINCT transactions_id FROM sales WHERE total_sale > 1000;

# Gender and Category-Based Transaction Count
Find the total number of transactions made by each gender in each category:

SELECT gender, category, COUNT(transactions_id) AS transactions_id_count FROM sales GROUP BY gender, category;

# Best Selling Month Analysis
Calculate the average sale for each month and find the best-selling month of each year:

SELECT year, month, avg_sale FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year, EXTRACT(MONTH FROM sale_date) AS month, AVG(total_sale) AS avg_sale,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
    FROM sales GROUP BY month, year ORDER BY year, avg_sale DESC
)
WHERE rank = 1;

# Top 5 Customers by Total Sales
Find the top 5 customers based on the highest total sales:

SELECT customer_id, SUM(total_sale) AS total_amount FROM sales GROUP BY customer_id ORDER BY total_amount DESC LIMIT 5;


# Transaction Time-Based Analysis (Shift Segmentation)
Create and count the number of orders for different shifts (morning, afternoon, evening):

WITH hrs_sales AS (
    SELECT *,
           CASE 
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
               ELSE 'evening'
           END AS shift
    FROM sales
)
SELECT shift, COUNT(*) AS total_order FROM hrs_sales GROUP BY shift;





