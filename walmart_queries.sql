-- create the schema
CREATE SCHEMA walmart_sales;

USE walmart_sales;

-- create the table and import the data using the Table Data Import Wizard

-- view the whole table
SELECT *
FROM sales;

-- renaming the tax_pct accordingly, as it is actually a flat added VAT amount, not a percentage
ALTER TABLE sales
RENAME COLUMN tax_pct TO added_vat;


 -- --------------adding features-------------
 -- time_of_day column --
 -- experiment with how we want this potential column to look
 SELECT time,
	(CASE
    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN time BETWEEN "12:00:01" AND "18:00:00" THEN "Afternoon"
    ELSE "Evening"
    END
    ) AS time_of_day
 FROM sales;
 
 -- add an empty column to the table
 ALTER TABLE sales 
 ADD time_of_day VARCHAR(20);
 
 -- populate the values in this empty column
 UPDATE sales
 SET time_of_day =
	(CASE
    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN time BETWEEN "12:00:01" AND "18:00:00" THEN "Afternoon"
    ELSE "Evening"
    END
    );
    
-- double-check that this has worked
SELECT *
FROM sales;

-- day_of_week column --
SELECT date, DAYNAME(date) AS day_of_week
FROM sales;

ALTER TABLE sales ADD day_of_week VARCHAR(20);

UPDATE sales
SET day_of_week = DAYNAME(date);

SELECT *
FROM sales;

-- day_of_week column --
SELECT date, MONTHNAME(date) AS month
FROM sales;

ALTER TABLE sales ADD month VARCHAR(20);

UPDATE sales
SET month = MONTHNAME(date);

SELECT *
FROM sales;


-- -------------- answering questions -----------------
-- Generic Questions --
-- How many unique cities does the data have?
SELECT COUNT(DISTINCT(city)) AS unique_cities
FROM sales;
-- 3

-- In which city is each branch?
SELECT DISTINCT branch, city
FROM sales
ORDER BY branch;
-- Branch A is in Yangon, B in Mandaly, C in Naypyitaw

-- Product --
-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) AS num_unique_product_lines
FROM sales;
-- 6

-- What is the most common payment method?
SELECT payment, COUNT(payment) AS num_payment
FROM sales
GROUP BY payment
ORDER BY num_payment DESC;
-- The most common payment method is Cash, with 344 instances.

-- What is the most selling product line?
SELECT product_line, SUM(quantity) AS num_product_line
FROM sales
GROUP BY product_line
ORDER BY num_product_line DESC;
-- The top selling product line is Electronic accessories, with 961 total purchases.

-- What is the total revenue by month?
SELECT month, SUM(total) AS revenue
FROM sales
GROUP BY month
ORDER BY revenue DESC;

-- What month had the largest COGS?
SELECT month, SUM(cogs) AS cogs_by_month
FROM sales
GROUP BY month
ORDER BY cogs_by_month DESC;
-- January had the largest COGS, with 110754.16.

-- What product line had the largest revenue?
SELECT product_line, SUM(total) AS revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;
-- Food and beverages had the largest revenue, with 56144.84 (2 decimals)

-- What is the city with the largest revenue?
SELECT city, SUM(total) AS revenue
FROM sales
GROUP BY city
ORDER BY revenue DESC;
-- Naypyitaw has the largest revenue, with 110490.78

-- What product line had the largest VAT?
SELECT product_line, AVG(added_vat) AS avg_vat
FROM sales
GROUP BY product_line
ORDER BY avg_vat DESC;
-- Home and lifestyle had the largest average VAT, with 16.03 (flat, not %).

-- Fetch each product line and add a column to those product lines showing "Good", "Bad". Good if it’s greater than average sales.
-- This question is not well-defined. So I decide to take the average revenue that an order on each product line makes, 
-- and make the comparison with that value.
SET @overall_avg_revenue=
	(SELECT AVG(total)
	FROM sales
    );

SELECT product_line, AVG(total) AS avg_revenue,
	(CASE
    WHEN AVG(total) > @overall_avg_revenue THEN "Good"
    ELSE "Bad"
    END
    ) AS good_bad
FROM sales
GROUP BY product_line;

-- Which branch sold more products than the average product sold?
-- Again, this is not well-defined. I decide to leave this question out.

-- What is the most common product line by gender?
SELECT gender, product_line, SUM(quantity) AS total_sold
FROM sales
GROUP BY gender, product_line
ORDER BY total_sold DESC;
-- In terms of quantity sold, females most frequently bought fashion accessories, 
-- whereas males most frequently bought health and beauty products.

-- What is the average rating of each product line?
SELECT product_line, AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Sales --
-- Number of sales made in each time of the day per weekday
SELECT day_of_week, time_of_day, SUM(quantity) AS num_sales
FROM sales
GROUP BY day_of_week, time_of_day
ORDER BY num_sales DESC;
-- In terms of quantity sold, Wednesday afternoons made the most sales

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;
-- Members brought more total revenue, at 163625.10.

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(added_vat) AS avg_added_vat
FROM sales
GROUP BY city
ORDER BY avg_added_vat DESC;
-- Naypyitaw has the largest average VAT, at 16.09 (flat, not percentage).

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(added_vat) AS avg_added_vat
FROM sales
GROUP BY customer_type
ORDER BY avg_added_vat DESC;
-- Members paid more VAT on average.

SELECT *
FROM sales;

-- Customer --
-- How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS num_unique_customer_types
FROM sales;
-- 2

-- How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) AS num_unique_payment_methods
FROM sales;
-- 3

-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS num_customer_type
FROM sales
GROUP BY customer_type
ORDER BY num_customer_type DESC;
-- Members are the most common customer type at 499, in terms of number of orders made.

-- Which customer type buys the most?
SELECT customer_type, SUM(quantity) AS qty_sold
FROM sales
GROUP BY customer_type
ORDER BY qty_sold DESC;
-- In terms of quantity sold, members buy the most, at 2773 total units sold.

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) AS num_gender
FROM sales
GROUP BY gender
ORDER BY num_gender DESC;
-- Most customers are male, at 498.

-- What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender;

-- Which time of the day do customers give most ratings?
-- Every order comes with a rating, so this is equivalent to just finding which time of day has most orders.
SELECT time_of_day, COUNT(*) AS num_ratings
FROM sales
GROUP BY time_of_day
ORDER BY num_ratings DESC;
-- Afternoons see the most ratings, at 527.

-- Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(*) AS num_ratings
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, num_ratings DESC;
-- For all 3 branches, customers give most ratings in the afternoon.

-- Which day of the week has the best avg ratings?
SELECT day_of_week, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_of_week
ORDER BY avg_rating DESC;
-- Mondays have the best average ratings, at 7.13.

-- Which day of the week has the best average ratings per branch?
SELECT branch, day_of_week, AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, day_of_week
ORDER BY branch, avg_rating DESC;
-- Fridays for A, Mondays for B, Saturdays for C.