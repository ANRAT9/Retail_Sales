--Create table to import the dataset

Create table Retail_Sales(
transactions_id	int,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(11),
quantiy int,
price_per_unit int,
cogs float,
total_sale float
);

select * from Retail_Sales

--  imported the dataset to SQL

copy  Retail_Sales(transactions_id,sale_date,sale_time,customer_id,gender,age,category,	quantiy,	price_per_unit,	cogs,	total_sale)
from  'F:\pizza_sales\SQL - Retail Sales Analysis_utf .csv'
DELIMITER ','
CSV HEADER

--Filtering and Cleaning the data
select count(*) from retail_sales
select count(distinct customer_id) from retail_sales
select distinct  category from retail_sales


SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

Delete from	retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from Retail_Sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from Retail_Sales
where category = 'Clothing'
and
To_Char(sale_date, 'yyyy-mm') = '2022-11'
and
quantiy >= 3
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(quantiy*price_per_unit) As total_sales
from Retail_Sales
group by category
order by category DESC

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) from Retail_Sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from Retail_Sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(transactions_id) as Total_order, gender, category
from Retail_Sales
group by gender, category
order by gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from 
(Select extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sales,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc)
from Retail_Sales
group by 1,2) as T1
where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select customer_id, sum(total_sale) as total_revenue
from Retail_Sales
group by customer_id
order by total_revenue desc
limit 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) as unique, category
from Retail_Sales
group by category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select 
case
 when extract(hour from sale_time) <12 then 'morning'
 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
 else 'evening'
 end as shift,
 count(transactions_id)
 from Retail_Sales
 group by shift

--Which product category generates the highest sales revenue, and which gender contributes the highest number of transactions?
select category, gender, count(transactions_id)as total_transactios,
sum(total_sale)as total_revenue
from Retail_Sales
group by 1,2
order by 3,4 desc

--Which category contributes the most revenue to the business?
select category,  sum(quantiy*price_per_unit) as total_revenue
from Retail_Sales
group by 1
 --select * from Retail_Sales
 
--Which gender makes the highest number of sales? 
select gender, sum(total_sale)
from Retail_Sales
group  by 1

--Which gender makes the highest number of purchases?
SELECT gender,
       COUNT(transactions_id) AS total_purchases
FROM Retail_Sales
GROUP BY gender
ORDER BY total_purchases DESC;


/**select category,

sum(total_sale) *100 / (select sum(total_sale from Retail_Sales)
)
from Retail_Sales
group by 1
order by**/

-- What percentage of total sales is contributed by each product category?
SELECT
    category,
    SUM(total_sale) AS category_revenue,
    
        (
            SUM(total_sale) * 100.0 /
            (SELECT SUM(total_sale) FROM Retail_Sales)
        )
     AS revenue_percentage
FROM Retail_Sales
GROUP BY category
ORDER BY revenue_percentage DESC;