-- COALESCE
/* 1. Our favourite manager wants a detailed long list of products, but is afraid of tables! 
We tell them, no problem! We can produce a list with all of the appropriate details. 

Using the following syntax you create our super cool and not at all needy manager a list:

SELECT 
COALESCE(product_name,'') || ', ' || 
COALESCE(product_size,'')|| ' (' || 
COALESCE(product_qty_type,'unit') || ')'
FROM product

But wait! The product table has some bad data (a few NULL values). 
Find the NULLs and then using COALESCE, replace the NULL with a 
blank for the first problem, and 'unit' for the second problem. 

HINT: keep the syntax the same, but edited the correct components with the string. 
The `||` values concatenate the columns into strings. 
Edit the appropriate columns -- you're making two edits -- and the NULL rows will be fixed. 
All the other rows will remain the same.) */




--Windowed Functions
/* 1. Write a query that selects from the customer_purchases table and numbers each customer’s  
visits to the farmer’s market (labeling each market date with a different number). 
Each customer’s first visit is labeled 1, second visit is labeled 2, etc. 

You can either display all rows in the customer_purchases table, with the counter changing on
each new market date for each customer, or select only the unique market dates per customer 
(without purchase details) and number those visits. 
HINT: One of these approaches uses ROW_NUMBER() and one uses DENSE_RANK(). */
/*
SELECT
    customer_id,
	market_date,
	row_number()OVER (PARTITION BY customer_id ORDER BY market_date) AS vist_number

From customer_purchases
*/

/*
SELECT 
    customer_id,
	market_date,
	dense_rank() over (Partition by customer_id ORDER BY market_date) AS visit_number
FROM
    customer_purchases;	
*/


/* 2. Reverse the numbering of the query from a part so each customer’s most recent visit is labeled 1, 
then write another query that uses this one as a subquery (or temp table) and filters the results to 
only the customer’s most recent visit. */
SELECT*
From(
   SELECT
       customer_id,
	   market_date,
	   row_number()OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS visit_number
    FROM
	   customer_purchases

)AS subquery
WHERE visit_number = 1;

/* 3. Using a COUNT() window function, include a value along with each row of the 
customer_purchases table that indicates how many different times that customer has purchased that product_id. */
SELECT 
    customer_id,
	product_id,
	purchase_count
From(
    SELECT  
	    customer_id,
		product_id,
		count(*) AS purchase_count,
		row_number()OVER (PARTITION BY customer_id,product_id ORDER BY customer_id) AS row_number
	FROM
	   customer_purchases
	Group BY
	   customer_id,
	   product_id
    ) As subquery
	Where row_number =1;




String manipulations
Some product names in the product table have descriptions like "Jar" or "Organic". These are separated from the product name with a hyphen. Create a column using SUBSTR (and a couple of other commands) that captures these, but is otherwise NULL. Remove any trailing or leading whitespaces. Don't just use a case statement for each product!
product_name	description
Habanero Peppers - Organic	Organic
HINT: you might need to use INSTR(product_name,'-') to find the hyphens. INSTR will help split the column.
/*
Select
    product_name,
	TRIM(SUBSTR(product_name, INSTR(product_name, '-')+1)) AS description

From product;
*/


UNION
Using a UNION, write a query that displays the market dates with the highest and lowest total sales.
HINT: There are a possibly a few ways to do this query, but if you're struggling, try the following: 1) Create a CTE/Temp Table to find sales values grouped dates; 2) Create another CTE/Temp table with a rank windowed function on the previous query to create "best day" and "worst day"; 3) Query the second temp table twice, once for the best day, once for the worst day, with a UNION binding them.
/*
with total_sales_by_date AS (
   SELECT
       market_date,
	   Sum(quantity * cost_to_customer_per_qty) as total_sales
   From customer_purchases
   Group by market_date
)
SELECT*From total_sales_by_date;
*/
WITH total_sales_by_date AS (
   SELECT
       market_date,
       SUM(quantity * cost_to_customer_per_qty) as total_sales
   FROM customer_purchases
   GROUP BY market_date
),
ranked_sales_by_date AS (
   SELECT
       market_date,
       total_sales,
       RANK() OVER (ORDER BY total_sales ASC) AS sales_rank_asc,
       RANK() OVER (ORDER BY total_sales DESC) AS sales_rank_desc
   FROM total_sales_by_date
)
SELECT market_date, total_sales
FROM ranked_sales_by_date
WHERE sales_rank_asc = 1

UNION

SELECT market_date, total_sales
FROM ranked_sales_by_date
WHERE sales_rank_desc = 1;
*/