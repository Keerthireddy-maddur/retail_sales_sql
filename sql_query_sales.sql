-- SQL Retail Sales Analysis 
CREATE DATABASE p1_retail_db;

-- Create Table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
	);

-- Data Cleaning
	
SELECT * FROM retail_sales WHERE 
	transactions_id IS NULL 
	OR  
	sale_date IS NULL 
	OR 
	sale_time IS NULL 
	OR 
	customer_id IS NULL 
	OR
	gender IS NULL 
	OR 
	age IS NULL 
	OR 
	category IS NULL 
	OR 
	quantity IS NULL 
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL;

DELETE FROM retail_sales WHERE 
	transactions_id IS NULL 
	OR  
	sale_date IS NULL 
	OR 
	sale_time IS NULL 
	OR 
	customer_id IS NULL 
	OR
	gender IS NULL 
	OR 
	age IS NULL 
	OR 
	category IS NULL 
	OR 
	quantity IS NULL 
	OR 
	price_per_unit	IS NULL 
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT * FROM retail_sales;

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Types of category
SELECT  distinct category FROM retail_sales;


--Data Analysis and Business Key Solutions

--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05


SELECT * FROM retail_sales WHERE sale_date ='2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022
	
SELECT * FROM retail_sales WHERE category='Clothing' 
	and quantity>= 4 and TO_CHAR(sale_date,'YYYY-MM')='2022-11';


--3.Write a SQL query to calculate the total sales (total_sale) for each category

SELECT category,SUM(quantity) total_sales FROM retail_sales GROUP BY category; 

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
	
SELECT ROUND(AVG(age),0) avg_age FROM retail_sales WHERE category ='Beauty'

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * FROM retail_sales WHERE total_sale >1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender,category,COUNT(transactions_id) AS total_trans FROM retail_sales
GROUP BY gender,category
ORDER BY category, gender,total_trans;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM 
	(SELECT EXTRACT(YEAR FROM sale_date) AS YEAR ,EXTRACT(MONTH FROM sale_date) AS MONTH , AVG(total_sale) average, 
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) FROM retail_sales 
GROUP BY EXTRACT(MONTH FROM sale_date),EXTRACT (YEAR FROM sale_date) )t1
WHERE rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category,COUNT(DISTINCT customer_id) AS count_of_unq FROM retail_sales
GROUP BY  category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
	
WITH shifts AS(
SELECT *,
	CASE WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'   
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
		 END AS shift
FROM retail_sales)

SELECT shift,count(transactions_id) FROM shifts
GROUP BY shift;



















