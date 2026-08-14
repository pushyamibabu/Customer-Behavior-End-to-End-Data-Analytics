CREATE DATABASE customer_behavior_analytics;
USE customer_behavior_analytics;

SELECT * 
FROM customer_shopping_behavior;

#1.How many customers do we have
SELECT COUNT(*) AS total_customers
FROM customer_shopping_behavior;

#2.How many male and female customers are there
SELECT Gender,
       COUNT(*) AS total_customers
FROM customer_shopping_behavior
GROUP BY Gender;

#3.What is the average age of customers
SELECT ROUND(AVG(Age),2) AS average_age
FROM customer_shopping_behavior;

#4.What is the minimum and maximum age
SELECT
MIN(Age) AS minimum_age,
MAX(Age) AS maximum_age
FROM customer_shopping_behavior;

#5.Which product category is purchased the most
SELECT Category,
       COUNT(*) AS total_orders
FROM customer_shopping_behavior
GROUP BY Category
ORDER BY total_orders DESC;

#6.What is the total revenue generated
SELECT SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer_shopping_behavior;

#7.What is the average purchase amount
SELECT ROUND(AVG(`Purchase Amount (USD)`),2) AS average_purchase
FROM customer_shopping_behavior;

#8.Which category generates the highest revenue
SELECT Category,
       SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer_shopping_behavior
GROUP BY Category
ORDER BY total_revenue DESC;

#9.Which products are purchased the most
SELECT `Item Purchased`,
       COUNT(*) AS total_orders
FROM customer_shopping_behavior
GROUP BY `Item Purchased`
ORDER BY total_orders DESC;

#10.Which products generate the highest revenue
SELECT `Item Purchased`,
       SUM(`Purchase Amount (USD)`) AS revenue
FROM customer_shopping_behavior
GROUP BY `Item Purchased`
ORDER BY revenue DESC;

#11.Which locations have the highest number of customers
SELECT Location,
       COUNT(*) AS total_customers
FROM customer_shopping_behavior
GROUP BY Location
ORDER BY total_customers DESC;

#12.Which locations generate the highest revenue
SELECT Location,
       SUM(`Purchase Amount (USD)`) AS total_revenue
FROM customer_shopping_behavior
GROUP BY Location
ORDER BY total_revenue DESC;

#13.Which customers used a discount but still spent more than the average purchase amount?
SELECT `Customer ID`,
       Gender,
       Age,
       `Purchase Amount (USD)`,
       `Discount Applied`
FROM customer_shopping_behavior
WHERE `Discount Applied` = 'Yes'
AND `Purchase Amount (USD)` >
(
    SELECT AVG(`Purchase Amount (USD)`)
    FROM customer_shopping_behavior
);

#14. Which are the Top 5 products with the highest average review rating
SELECT `Item Purchased`,
       ROUND(AVG(`Review Rating`),2) AS average_rating
FROM customer_shopping_behavior
GROUP BY `Item Purchased`
ORDER BY average_rating DESC
LIMIT 5;

#15. Which 5 products have the highest percentage of purchases with discounts applied?
SELECT `Item Purchased`,
       COUNT(*) AS discounted_orders
FROM customer_shopping_behavior
WHERE `Discount Applied` = 'Yes'
GROUP BY `Item Purchased`
ORDER BY discounted_orders DESC
LIMIT 5;

#16.Segment customers into New, Returning, and Loyal based on Previous Purchases.
SELECT
    CASE
        WHEN `Previous Purchases` = 0 THEN 'New'
        WHEN `Previous Purchases` BETWEEN 1 AND 5 THEN 'Returning'
        ELSE 'Loyal'
    END AS Customer_Segment,
    COUNT(*) AS Total_Customers
FROM customer_shopping_behavior
GROUP BY Customer_Segment;

#17. What are the Top 3 most purchased products within each category?
WITH ProductSales AS (
    SELECT Category,
           `Item Purchased`,
           COUNT(*) AS Total_Orders,
           DENSE_RANK() OVER(PARTITION BY Category ORDER BY COUNT(*) DESC) AS Ranking
    FROM customer_shopping_behavior
    GROUP BY Category, `Item Purchased`
)
SELECT *
FROM ProductSales
WHERE Ranking <= 3;

#18. Are repeat buyers (more than 5 previous purchases) more likely to subscribe?
SELECT `Subscription Status`,
       COUNT(*) AS Total_Customers
FROM customer_shopping_behavior
WHERE `Previous Purchases` > 5
GROUP BY `Subscription Status`;

#19.What is the revenue contribution of each age group?
SELECT 
CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END AS Age_Group,
SUM(`Purchase Amount (USD)`) AS Total_Revenue
FROM customer_shopping_behavior
GROUP BY Age_Group
ORDER BY Total_Revenue DESC;

#20. Which Age Group purchased which Items in which Season, and how much Revenue did they generate?
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    Category,
    Season,
    SUM(`Purchase Amount (USD)`) AS Total_Revenue
FROM customer_shopping_behavior
GROUP BY
    Age_Group,
    Category,
    Season
ORDER BY
    Total_Revenue DESC;