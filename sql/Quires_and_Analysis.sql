USE lower_customer_satisfaction_analysis;

DESC Order_items;
DESC Orders;
DESC Product;
DESC Review;

SELECT 
	COUNT(*)
FROM Review
WHERE order_id IS NULL;

# for this analysis, we use review score as a proxy of customer satisfaction

# Hypothesis 1 : Late Delivery may leads lower customer satisfaction

WITH DeliveryDates AS (
	SELECT 
		o.order_id,
		o.order_delivered_customer_date,
		o.order_estimated_delivery_date,
		CASE 
			WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
			ELSE 'On-time' 
			END 
		AS delivery_status,
		r.review_score
	FROM Orders o
	JOIN Review r
	ON o.order_id = r.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)

SELECT 
	delivery_status,
    ROUND(AVG(review_score), 2) AS AvgScore
FROM DeliveryDates
GROUP BY delivery_status
ORDER BY AvgScore DESC;

# Finding : I compared Average Review Score between Late and On-time delivery status. I noticed that On-time delivery has higher avg score (4.29) than Late delivery (2.57).

# Interpretation : The result support my hypothesis that Late delivery may contribute to lower customer satisfaction.

# Hypothesis 2: Higher freight cost may increase the lower customer satisfaction

WITH FreightValue AS (
	SELECT 
		oi.freight_category,
		r.review_score
	FROM Order_items oi
	JOIN Review r 
	ON oi.order_id = r.order_id
)

SELECT 
	freight_category,
    ROUND(AVG(review_score), 2) AS AvgScore
FROM FreightValue
GROUP BY freight_category
ORDER BY AvgScore DESC;

# FINDING: I compared average review score across all freight category. I noticed that Average review score decreased from 4.11 for low freight cost to 4.04 for medium freight cost and 3.94 for high freight cost

# Interpretation : This result support my hypothesis that higher freight cost may contribute to the lower customer satisfaction

# Hypothesis 3 : Higher product price may contribute to lower customer satisfaction

WITH PricesValue AS (
	SELECT 
		oi.price_category,
		r.review_score
	FROM Order_items oi
	JOIN Review r 
	ON oi.order_id = r.order_id
)

SELECT 
	price_category,
    ROUND(AVG(review_score), 2) AS AvgScore
FROM PricesValue
GROUP BY price_category
ORDER BY AvgScore DESC;

# FINDING: I compared average review score across all price category. I noticed that average review score is relatively same across all the price category (4.03).

# Interpretation : This result doesnot support my hypothesis which means Higher product price might not contributed to lower customer satisfaction

# Hypothesis 4: longer seller handling time may contribute to lower customer satisfaction?

WITH HandlingTime AS (
    SELECT
        o.order_id,
        DATEDIFF(
            o.order_delivered_carrier_date,
            o.order_approved_at
        ) AS handling_days,
        r.review_score
    FROM Orders o
    JOIN Review r
        ON o.order_id = r.order_id
    WHERE o.order_approved_at IS NOT NULL
      AND o.order_delivered_carrier_date IS NOT NULL
),

Quartiles AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY handling_days) AS quartile
    FROM HandlingTime
),

Categories AS (
    SELECT
        CASE
            WHEN quartile = 1 THEN 'Short'
            WHEN quartile IN (2, 3) THEN 'Medium'
            WHEN quartile = 4 THEN 'Long'
        END AS handling_category,
        review_score
    FROM Quartiles
)

SELECT
    handling_category,
    ROUND(AVG(review_score), 2) AS AvgScore
FROM Categories
GROUP BY handling_category
ORDER BY AvgScore DESC;

#Findings : The seller taking too much time to deliver got lowest avg review score (3.90) while sellers who takes less time to deliver got highest avg score (4.26)alter
    
# Interpretation : This result support my hypothesis which means, longer seller handling time may contribute to lower customer satisfaction.


/* BUSINESS RECOMMENDATION THROUGH MY HYPOTHESIS 

1. Focus more on delivery time and reduce late deliveries.
   Late delivery has a lower average review score, so the company should focus on improving delivery time and reducing late deliveries.

2. Optimize shipping costs.
   Higher freight cost is associated with lower average review scores, so the company should look for ways to optimize shipping costs.

3. Reduce seller processing time.
   Orders with longer seller handling time have lower average review scores, so sellers should try to process and hand over orders to the carrier faster.

*/
