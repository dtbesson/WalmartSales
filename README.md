# WalmartSales
An exploratory data analysis project in SQL on the publicly available Walmart Sales dataset. I personally accessed the data on Princekrampah's Github, https://github.com/Princekrampah/WalmartSalesAnalysis/blob/master/README.md

I also used the questions posed on the above Github repository as a guide for the project. I occasionally referred to his code when learning how to create new columns, but then tackled the following questions on my own. Many of the questions are quite poorly defined, but I tried to understand them as best as I could. Regardless, they were still useful exercises in practicing constructing SQL queries.




## The Data
I noticed one serious issue with this dataset. Somewhat misleadingly, tax_pct is not the % VAT added to the purchase, but it is the flat amount of VAT. Therefore, total = quantity x unit_price + tax_pct. I go on to rename this column as added_vat later.

|Attribute|Description|
|------|------|
|invoice_id|Identification for the order.|
|branch|Branch of the Walmart.|
|city|The city in which the branch is located.|
|customer_type|Indicates whether a customer is a normal customer or a member.|
|gender|Gender of the customer.|
|product_line|The category which the ordered product falls into.|
|unit_price|The cost of one unit of the product.|
|quantity|The number of products this order contains.|
|tax_pct|The FLAT amount of added VAT to the order.|
|total|The total paid by the customer, including VAT.|
|date|The date of the order.|
|time|The time of the order.|
|payment|The method of payment used.|
|cogs|Cost of goods sold, i.e. the cost to the company.|
|gross_margin_pct|The profit percentage the company keeps, after subtracting production costs. Calculated as (gross profit/total revenue) x 100%|
|gross_income|The flat amount of profit made by the company.|
|rating|The rating of the order given by the customer.|


## The Process
- Import the data from the .csv file using the Table Data Import Wizard.
- Rename the tax_pct column to something more reflective, added_vat.
- Create new features:
  - time_of_day, by using a CASE statement to classify times as either "Morning", "Afternoon" or "Evening".
  - day_of_week, by using the DAYNAME function.
- Go on to answer the below questions, one-by-one.



## The Questions
#### Generic Questions
1. How many unique cities does the data have?
2. In which city is each branch?

#### Product
1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
7. What is the city with the largest revenue?
8. What product line had the largest VAT?
9. Fetch each product line and add a column to those product lines showing "Good", "Bad". Good if it’s greater than average sales.
10. Which branch sold more products than the average product sold?
11. What is the most common product line by gender?
12. What is the average rating of each product line?

#### Sales
1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (Value Added Tax)?
4. Which customer type pays the most in VAT?

#### Customer
1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day of the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch? 


## Points of Learning
- Usually, I would use Excel or Python to create new columns. It was interesting to understand how this can also be done quite easily within SQL.
- This involved learning how to use CASE statements, in order to classify based on other features. They are essentially equivalent to IF statements in other languages.
- This also involved learning how to use ALTER TABLE to add an empty column, then using UPDATE and SET to populate the empty column.
- In question 9 of the 'product' questions, I learnt how to use DECLARE and SET to assign a value to a variable. I needed to find the average revenue across all sales within each product line, then compare these to the average revenue across ALL sales. I used DECLARE and SET to save the value of the latter before making these comparisons.
- I also made the observation that sometimes, business questions can be poorly defined. In these situations, it is important to either interpret them as best as possible based on your own judgement, or reach out to someone to find clarity on what they meant.
- Finally, the tax_pct column in the data was very misleading. Before starting any analysis, it is important to go through each feature and make sure you understand how it is defined. This can help catch any errors in the data itself before writing any code.
