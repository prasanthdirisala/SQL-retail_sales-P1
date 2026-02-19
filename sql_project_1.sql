-- SQL Retail Sales Analysis - p1
-- Create a Table
create table retail_sales(
							transactions_id int primary key,
							sale_date date,
							sale_time time,
							customer_id int,
							gender varchar(20),
							age int,
							category varchar(20),
							quantiy int,
							price_per_unit float,
							cogs float,
							total_sale float
						);

select * from retail_sales;

select * from retail_sales
limit 10;

select
	count(*)
from retail_sales;

--DATA CLEANING:
	
	--checking null values--

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where 
	transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR
	quantiy is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;

--delete null records from the table--
delete from retail_sales
where
	transactions_id is null
	OR
	sale_date is null
	OR
	sale_time is null
	OR
	customer_id is null
	OR
	gender is null
	OR
	age is null
	OR
	category is null
	OR
	quantiy is null
	OR
	price_per_unit is null
	OR
	cogs is null
	OR
	total_sale is null;

-- data Exploration --
--how many sales we have?

select count(*) as total_sale from retail_sales;

-- How many unique customers we have?

SELECT count(distinct customer_id) as total_customer from retail_sales;

-- How many unique category's we have?

select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 write a sql query to retrive all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';
-- Q.2 write a sql query to retrive all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022
select * from retail_sales
where category = 'Clothing'
	and TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	and quantiy >= 4;
-- Q.3 write a sql query to calculate the total sales for each category
select category,
		sum(total_sale) as net_sale,
		count(*)as total_orders 
from retail_sales 
group by category;
-- Q.4 write a sql query to find the average age of customers who purchased items from the 'Beauty' category
select 
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,
		gender,
		count(*) as total_trans 
from retail_sales
group by category,
		gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.
select
	year,
	month,
	avg_sale
from
(
select
	EXTRACT(YEAR from sale_date) as year,
	EXTRACT(MONTH from sale_date) as month,
	avg(total_sale) as avg_sale,
	RANK() over(partition by EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale)DESC)as rank
from retail_sales
group by year,month
) as t1
WHERE rank=1;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id,
		Sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc 
limit 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select
	category,
	COUNT(DISTINCT customer_id) as count_of_unique_customers
from retail_sales
group by category;
-- Q.10 Write a SQL query to create each shift and number of orders
	-- (Example: Morning ≤ 12, Afternoon between 12 & 17, Evening > 17).
with hourly_sale
as
(
select * ,
	case
		WHEN EXTRACT(HOUR from sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 and 17 THEN 'Afternoun'
		else 'Evening'
	End as shift
from retail_sales
)
select
	shift,
	COUNT(*) as total_orders
from hourly_sale
GROUP By shift;

--- END OF PROJECT ---