USE lower_customer_satisfaction_analysis;

DESC Order_items;
DESC Orders;
DESC Product;
DESC Review;
DESC Customers;

ALTER TABLE Orders
ADD COLUMN delivery_category Varchar(40);

SET SQL_SAFE_UPDATES = 0;

UPDATE Orders
SET delivery_category = 
	CASE 
		WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
		ELSE 'On-time'
	END
WHERE order_delivered_customer_date IS NOT NULL 
AND order_estimated_delivery_date IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

# for this analysis, we use review score as a proxy of customer satisfaction

# Hypothesis 1 : Late Delivery may leads lower customer satisfaction

WITH DeliveryReview AS (
	SELECT
		o.delivery_category,
        r.review_score
	FROM Orders o
    JOIN Review r
    ON o.order_id = r.order_id
    WHERE delivery_category IS NOT NULL
)

SELECT 
	delivery_category,
    ROUND(AVG(review_score), 2) AS Avg_review
FROM DeliveryReview
GROUP BY delivery_category;

# Finding : I compared Average Review Score between Late and On-time delivery status. I noticed that On-time delivery has higher avg score (4.29) than Late delivery (2.57).

# Interpretation : The result support my hypothesis that Late delivery may contribute to lower customer satisfaction.

-- -------------------------------------------------------------------------------------------------------------------------------------------
# Hypothesis 2: Higher freight cost may increase the lower customer satisfaction

WITH FreightReview AS (
	SELECT
		oi.freight_category,
        r.review_score
	FROM Order_items oi
    JOIN Review r
    ON oi.order_id = r.order_id
    WHERE freight_category IS NOT NULL
) 

SELECT
	freight_category,
    ROUND(AVG(review_score), 2) AS Avg_review
FROM FreightReview
GROUP BY freight_category;

# FINDING: I compared average review score across all freight category. I noticed that Average review score decreased from 4.11 for low freight cost to 4.04 for medium freight cost and 3.94 for high freight cost

# Interpretation : This result support my hypothesis that higher freight cost may contribute to the lower customer satisfaction

-- -------------------------------------------------------------------------------------------------------------------------------------------------
# Hypothesis 3 : Higher product price may contribute to lower customer satisfaction

WITH PriceReview AS (
	SELECT
		oi.price_category,
        r.review_score
	FROM Order_items oi
    JOIN Review r
    ON oi.order_id = r.order_id
    WHERE price_category IS NOT NULL
) 

SELECT
	price_category,
    ROUND(AVG(review_score), 2) AS Avg_review
FROM PriceReview
GROUP BY price_category;

# FINDING: I compared average review score across all price category. I noticed that average review score is relatively same across all the price category (4.03).

# Interpretation : This result doesnot support my hypothesis which means Higher product price might not contributed to lower customer satisfaction

-- --------------------------------------------------------------------------------------------------------------------------------------------
# Hypothesis 4: longer seller handling time may contribute to lower customer satisfaction?

WITH SellerHandlingReview AS (
	SELECT
		o.handling_category,
        r.review_score
	FROM Orders o
    JOIN Review r
    ON o.order_id = r.order_id
    WHERE handling_category IS NOT NULL
)

SELECT 
	handling_category,
    ROUND(AVG(review_score), 2) AS Avg_review
FROM SellerHandlingReview
GROUP BY handling_category;

#Findings : The seller taking too much time to deliver got lowest avg review score (3.69) while sellers who takes less time to deliver got highest avg score (4.26)
    
# Interpretation : This result support my hypothesis which means, longer seller handling time may contribute to lower customer satisfaction.

-- --------------------------------------------------------------------------------------------------------------------------
# Hypothesis 5: Extreme delivery delays are mainly caused by the seller or the carrier.

WITH DeliveryTime AS (
    SELECT
        order_id,
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        ) AS total_delivery_days,
        DATEDIFF(
            order_delivered_carrier_date,
            order_approved_at
        ) AS seller_handling_days,
        DATEDIFF(
            order_delivered_customer_date,
            order_delivered_carrier_date
        ) AS shipping_days
    FROM Orders
    WHERE order_purchase_timestamp IS NOT NULL
      AND order_approved_at IS NOT NULL
      AND order_delivered_carrier_date IS NOT NULL
      AND order_delivered_customer_date IS NOT NULL
),

Ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY total_delivery_days DESC
        ) AS rn,
        COUNT(*) OVER () AS total_orders
    FROM DeliveryTime
),

ExtremeDelays AS (
    SELECT *
    FROM Ranked
    WHERE rn <= CEIL(total_orders * 0.01)
)

SELECT
    ROUND(AVG(seller_handling_days), 2) AS AvgSellerHandling,
    ROUND(AVG(shipping_days), 2) AS AvgCarrierShipping,
    ROUND(
        AVG(seller_handling_days) /
        (AVG(seller_handling_days) + AVG(shipping_days)) * 100,
        2
    ) AS SellerContributionPct,
    ROUND(
        AVG(shipping_days) /
        (AVG(seller_handling_days) + AVG(shipping_days)) * 100,
        2
    ) AS CarrierContributionPct
FROM ExtremeDelays;

#Finding: I analyzed the top 1% of orders with the longest delivery times.I noticed that the average carrier shipping time was 53.31 days, while seller handling took only 8.58 days.

#Interpretation: This suggests that the carrier/shipping stage is the main bottleneck in extreme delivery delays, accounting for approximately 86% of the total average processing time.

# Hypothesis 6: Which geographic area has the highest average delivery time?

SELECT
    c.customer_state,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ), 2
    ) AS AvgDeliveryDays
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY AvgDeliveryDays DESC;

#Finding: I compared average delivery time across different states.I noticed:that ES state has the highest average delivery time of 29.34 days.

#Interpretation: This suggests that customers in ES stae area may experience longer delivery times, possibly due to distance or logistics constraints.
-- --------------------------------------------------------------------------------------------------------------------------------------------
/* BUSINESS RECOMMENDATION THROUGH MY HYPOTHESIS 

1. Focus more on delivery time and reduce late deliveries.
	Late delivery has a lower average review score, so the company should focus on improving delivery time and reducing late deliveries.

2. Optimize shipping costs.
	Higher freight cost is associated with lower average review scores, so the company should look for ways to optimize shipping costs.

3. Reduce seller processing time.
	Orders with longer seller handling time have lower average review scores, so sellers should try to process and hand over orders to the carrier faster.

4. Improve carrier performance
	Carrier shipping takes much longer than seller handling in extreme-delay orders, so the company should focus on reducing the time orders spend in the shipping stage.

5. Investigate high-delay geographic areas
	The company should focus on areas with longer delivery times and find ways to reduce delivery delays.

*/
