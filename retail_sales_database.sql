-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

--data cleaning---

--first step checking the number of rows as compare to excel sheet--
select count(*) from retail_sales;

--second step checking nulll values from table----- 
select transaction_id from retail_sales where transaction_id is null;

-- third step checking null value from table---
select * from retail_sales 
	where
transaction_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null
or
transaction_id is null;

-- fourth step delete null data from table--
delete from retail_sales 
	where
transaction_id is null
or
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null
or
transaction_id is null;


--data exploration---

--how many sales we have?---
select count (*) from
retail_sales;

--how many unique customer we have--
select count(distinct customer_id)
from retail_sales;

--how many unique category we have--
select distinct category
from retail_sales;


-----------  Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
	where sale_date='2022-11-05' ;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select * from retail_sales where 
category='Clothing' 
	and 
	quantity >=4
	and 
	TO_CHAR(sale_date,'YYYY-MM')='2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) from retail_sales
group by category;

select * from retail_sales;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) from retail_sales 
	where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
	where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(transaction_id)
from retail_sales
group by gender,category
	order by category;

-- Interview Q.7  Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

with temp_month as(
select extract(year from sale_date) as Year,
	extract(month from sale_date)as Months,
	avg(total_sale) as average_sale,
	rank()over(partition by extract(year from sale_date)order by avg(total_sale) desc )as priority
	from retail_sales
group by year,months)
select year,months,average_sale from temp_month where priority=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale)as highest_sale 
	from retail_sales 
	group by customer_id
	order by highest_sale desc 
	limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id),category 
	from retail_sales 
	group by category;

-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with shift as(
select
	customer_id,
	case
when extract(hour from sale_time)<=12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else'Evening'
	end as shifts
from retail_sales
	)
select count(customer_id)as shifts,shifts from shift
group by shifts;


