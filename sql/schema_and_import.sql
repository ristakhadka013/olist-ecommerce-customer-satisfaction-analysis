CREATE DATABASE lower_customer_satisfaction_analysis;

USE lower_customer_satisfaction_analysis;

CREATE TABLE Product(
	product_id VARCHAR(40) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght FLOAT,
    product_description_lenght FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/ristakhadka/Developer/DATA ANALYTICS/olist-ecommerce-customer-satisfaction-analysis/data/product.csv'
INTO TABLE Product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
	product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');
    
CREATE TABLE Orders(
	order_id VARCHAR(40) PRIMARY KEY,
    customer_id VARCHAR(40),
    order_status VARCHAR(40),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    carrier_before_approval BOOL,
    delivered_before_carrier BOOL
);

LOAD DATA LOCAL INFILE '/Users/ristakhadka/Developer/DATA ANALYTICS/olist-ecommerce-customer-satisfaction-analysis/data/orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    order_estimated_delivery_date,
    @carrier_before_approval,
    @delivered_before_carrier
)
SET 
	order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    carrier_before_approval = CASE
		WHEN @carrier_before_approval = 'True' THEN 1 
        WHEN @carrier_before_approval = 'False' THEN 0
        ELSE NULL
	END,
    delivered_before_carrier = CASE
		WHEN @carrier_before_approval = 'True' THEN 1 
        WHEN @carrier_before_approval = 'False' THEN 0
        ELSE NULL
	END;

CREATE TABLE Order_items(
	order_id VARCHAR(40),
    order_item_id INT,
    product_id VARCHAR(100),
    seller_id VARCHAR(100),
    shipping_limit_date VARCHAR(100),
    price FLOAT,
    freight_value FLOAT,
    freight_category VARCHAR(20),
    price_category VARCHAR(20),
    
    PRIMARY KEY (order_id, order_item_id)
);

LOAD DATA LOCAL INFILE '/Users/ristakhadka/Developer/DATA ANALYTICS/olist-ecommerce-customer-satisfaction-analysis/data/order_items.csv'
INTO TABLE Order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Review(
	review_id VARCHAR(40),
    order_id VARCHAR(40),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

LOAD DATA LOCAL INFILE '/Users/ristakhadka/Developer/DATA ANALYTICS/olist-ecommerce-customer-satisfaction-analysis/data/review.csv'
INTO TABLE Review
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT 
	'Product' AS TABLENAME,
    COUNT(*) AS COUNT
FROM Product
UNION ALL
SELECT 
	'Orders',
    COUNT(*)
FROM Orders
UNION ALL 
SELECT 
	'Order items',
    COUNT(*)
FROM Order_items
UNION ALL
SELECT 
	'Review',
    COUNT(*)
FROM Review;
