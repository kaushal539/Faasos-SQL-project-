
create database rolls;

use rolls;

CREATE TABLE driver (
    driver_id INTEGER,
    reg_date DATE
);



CREATE TABLE ingredients (
    ingredients_id INTEGER,
    ingredients_name VARCHAR(60)
);

CREATE TABLE rolls (
    roll_id INTEGER,
    roll_name VARCHAR(30)
);


CREATE TABLE rolls_recipes (
    roll_id INTEGER,
    ingredients VARCHAR(24)
);



CREATE TABLE driver_order (
    order_id INTEGER,
    driver_id INTEGER,
    pickup_time DATETIME,
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);



CREATE TABLE customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    roll_id INTEGER,
    not_include_items VARCHAR(4),
    extra_items_included VARCHAR(4),
    order_date DATETIME
);



INSERT INTO driver (driver_id, reg_date) 
VALUES 
    (1, '2021-01-01'),
    (2, '2021-03-01'),
    (3, '2021-08-01'),
    (4, '2021-01-15');
    
    
    
    
INSERT INTO ingredients (ingredients_id, ingredients_name) 
VALUES 
    (1, 'BBQ Chicken'),
    (2, 'Chilli Sauce'),
    (3, 'Chicken'),
    (4, 'Cheese'),
    (5, 'Kebab'),
    (6, 'Mushrooms'),
    (7, 'Onions'),
    (8, 'Egg'),
    (9, 'Peppers'),
    (10, 'Schezwan Sauce'),
    (11, 'Tomatoes'),
    (12, 'Tomato Sauce');
    
    
    INSERT INTO rolls (roll_id, roll_name) 
VALUES 
    (1, 'Non Veg Roll'),
    (2, 'Veg Roll');



INSERT INTO rolls_recipes (roll_id, ingredients) 
VALUES 
    (1, '1,2,3,4,5,6,8,10'),
    (2, '4,6,7,9,11,12');




INSERT INTO driver_order (order_id, driver_id, pickup_time, distance, duration, cancellation) 
VALUES 
    (1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', ''),
    (2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', ''),
    (3, 1, '2021-03-01 00:12:37', '13.4km', '20 mins', 'NaN'),
    (4, 2, '2021-04-01 13:53:03', '23.4', '40', 'NaN'),
    (5, 3, '2021-08-01 21:10:57', '10', '15', 'NaN'),
    (6, 3, NULL, NULL, NULL, 'Cancellation'),
    (7, 2, '2020-08-01 21:30:45', '25km', '25mins', NULL),
    (8, 2, '2020-10-01 00:15:02', '23.4 km', '15 minute', NULL),
    (9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
    (10, 1, '2020-11-01 18:50:20', '10km', '10minutes', NULL);
    
    
    INSERT INTO customer_orders (order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date) 
VALUES 
    (1, 101, 1, '', '', '2021-01-01 18:05:02'),
    (2, 101, 1, '', '', '2021-01-01 19:00:52'),
    (3, 102, 1, '', '', '2021-02-01 23:51:23'),
    (4, 102, 2, '', 'NaN', '2021-02-01 23:51:23'),
    (5, 103, 1, '4', '', '2021-04-01 13:23:46'),
    (6, 103, 1, '4', '', '2021-04-01 13:23:46'),
    (7, 103, 2, '4', '', '2021-04-01 13:23:46'),
    (8, 104, 1, NULL, '1', '2021-08-01 21:00:29'),
    (9, 101, 2, NULL, NULL, '2021-08-01 21:03:13'),
    (10, 105, 2, NULL, '1', '2021-08-01 21:20:29'),
    (11, 102, 1, NULL, NULL, '2021-09-01 23:54:33'),
    (12, 103, 1, '4', '1,5', '2021-10-01 11:22:59'),
    (13, 104, 1, NULL, NULL, '2021-11-01 18:34:49'),
    (14, 104, 1, '2,6', '1,4', '2021-11-01 18:34:49');
    
    
    
select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from rolls;
select * from rolls_recipies;

CREATE TABLE rolls_recipes1(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes1(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');


select count(roll_id) from customer_orders;
select count(distinct customer_id) from customer_orders;

select driver_id, count(distinct order_id) from driver_order where cancellation not in ('Cancellation', 'Customer Cancellation')
group by driver_id;


select * from driver_order where cancellation not in ('Cancellation', 'Cuatomer Cancellation'); 
select * from driver_order;

SELECT *,
    CASE 
        WHEN cancellation IN ('Cancellation', 'Customer Cancellation') THEN 'c' 
        ELSE 'nc' 
    END AS order_cancel
FROM driver_order 
WHERE order_cancel_details = 'nc';

WITH order_details AS (
    SELECT *,
        CASE 
            WHEN cancellation IN ('Cancellation', 'Customer Cancellation') THEN 'c' 
            ELSE 'nc' 
        END AS order_cancel_details 
    FROM driver_order
)
SELECT *
FROM order_details
WHERE order_cancel_details = 'nc';




select roll_id, count(roll_id) from 
customer_orders where order_id in ( 
select order_id from  
( select *,case when cancellation in ('Cancellation', 'Customer Cancellation') then 'c' else 'nc' end as order_cancel_details from driver_order)a 
where order_cancel_details='nc');


SELECT roll_id, COUNT(roll_id) 
FROM customer_orders 
WHERE order_id IN (
    SELECT order_id 
    FROM (
        SELECT *,
            CASE 
                WHEN cancellation IN ('Cancellation', 'Customer Cancellation') THEN 'c' 
                ELSE 'nc' 
            END AS order_cancel_details 
        FROM driver_order
    ) AS a 
    WHERE order_cancel_details = 'nc'
)
GROUP BY roll_id;


select customer_id, roll_id, count(roll_id) 
from customer_orders
group by customer_id, roll_id;


select *, rank() over(order by cnt desc) rnk from 
( 
select order_id, count(roll_id) cnt 
from ( 
select * from customer_orders where order_id in (
select order_id from 
( select *, case when cancellation in ('Cancellation', 'Customer Cancellation') then 'c'
else 'nc' end as order_cancel_details from driver_order)a
where order_cancel_details='nc'))b 
group by order_id 
)c;

WITH temp_customer_orders (order_id, customer_id, roll_id, new_not_include_items, new_extra_items_included, order_date) AS
(
    SELECT 
        order_id, 
        customer_id, 
        roll_id, 
        CASE 
            WHEN not_include_items IS NULL OR not_include_items = ' ' THEN '0' 
            ELSE not_include_items 
        END AS new_not_include_items,
        CASE 
            WHEN extra_items_included IS NULL OR extra_items_included = ' ' OR extra_items_included = 'Nan' THEN '0' 
            ELSE extra_items_included 
        END AS new_extra_items_included,
        order_date 
    FROM customer_orders
)
SELECT * FROM temp_customer_orders;


with temp_driver_order1 (order_id, driver_id, pickup_time, distance, duration, cancellation) as
( 
select order_id, driver_id, pickup_time, distance, duration,
case when cancellation in ('Cancellation', 'Customer Cancellation') then 0 else 1 end as new_cancellation
from driver_order 
) 

select * from temp_customer_orders where order_id in (
select order_id from temp_driver_order1 where new_cancellation!=0);

select customer_id, chg_no_chg, count(order_id) from 
(

select *,case when  not_include_items='0' and extra_items_included='0' then 'no_change' else 'change' end chg_no_chg 
from temp_customer_orders where order_id in (
select order_id from temp_driver_order1 where new_cancellation!=0)) a
group by customer_id, chg_no_chg;






-- Create a temporary table for customer orders with cleaned 'not_include_items' and 'extra_items_included'
WITH temp_customer_orders AS
(
    SELECT 
        order_id, 
        customer_id, 
        roll_id, 
        COALESCE(NULLIF(TRIM(not_include_items), ''), '0') AS new_not_include_items,
        COALESCE(NULLIF(TRIM(extra_items_included), ''), '0') AS new_extra_items_included,
        order_date
    FROM customer_orders
),
-- Create a temporary table for driver orders with cancellation statuses corrected
temp_driver_order1 AS
( 
    SELECT 
        order_id, 
        driver_id, 
        pickup_time, 
        distance, 
        duration,
        CASE 
            WHEN cancellation IN ('Cancellation', 'Customer Cancellation') THEN 0 
            ELSE 1 
        END AS new_cancellation
    FROM driver_order
)
-- First query to return all valid orders (non-canceled) from customer orders
SELECT * 
FROM temp_customer_orders 
WHERE order_id IN (
    SELECT order_id 
    FROM temp_driver_order1 
    WHERE new_cancellation != 0
);

-- Second query: Group by customer_id and categorize orders as 'change' or 'no_change'
SELECT 
    customer_id, 
    chg_no_chg, 
    COUNT(order_id) AS order_count
FROM 
(
    SELECT 
        *,
        CASE 
            WHEN new_not_include_items = '0' AND new_extra_items_included = '0' 
            THEN 'no_change' 
            ELSE 'change' 
        END AS chg_no_chg 
    FROM temp_customer_orders 
    WHERE order_id IN (
        SELECT order_id 
        FROM temp_driver_order1 
        WHERE new_cancellation != 0
    )
) AS categorized_orders
GROUP BY customer_id, chg_no_chg;

-- Step 1: Create a temporary table for customer orders with corrected 'not_include_items' and 'extra_items_included'
WITH temp_customer_orders AS (
    SELECT 
        order_id, 
        customer_id, 
        roll_id, 
        CASE 
            WHEN TRIM(not_include_items) IS NULL OR TRIM(not_include_items) = '' THEN '0' 
            ELSE not_include_items 
        END AS new_not_include_items,
        CASE 
            WHEN TRIM(extra_items_included) IS NULL OR TRIM(extra_items_included) = '' OR extra_items_included = 'Nan' THEN '0' 
            ELSE extra_items_included 
        END AS new_extra_items_included,
        order_date 
    FROM customer_orders
),

-- Step 2: Create a temporary table for driver orders with new cancellation status
temp_driver_order1 AS ( 
    SELECT 
        order_id, 
        driver_id, 
        pickup_time, 
        distance, 
        duration,
        CASE 
            WHEN cancellation IN ('Cancellation', 'Customer Cancellation') THEN 0 
            ELSE 1 
        END AS new_cancellation
    FROM driver_order
)

-- Step 3: Select all valid orders from customer orders based on non-cancelled driver orders
SELECT * 
FROM temp_customer_orders 
WHERE order_id IN (
    SELECT order_id 
    FROM temp_driver_order1 
    WHERE new_cancellation != 0
);

-- Step 4: Group by customer_id and change/no-change condition, based on the new columns
SELECT customer_id, 
       chg_no_chg, 
       COUNT(order_id) AS order_count
FROM (
    SELECT 
        customer_id,
        CASE 
            WHEN new_not_include_items = '0' AND new_extra_items_included = '0' THEN 'no_change' 
            ELSE 'change' 
        END AS chg_no_chg, 
        order_id
    FROM temp_customer_orders 
    WHERE order_id IN (
        SELECT order_id 
        FROM temp_driver_order1 
        WHERE new_cancellation != 0
    )
) AS changes
GROUP BY customer_id, chg_no_chg;






select * from customer_orders;

select *,datepart(hour, order_date) hr from customer_orders;

SELECT *, HOUR(order_date) AS hr
FROM customer_orders;



SELECT 
  hours_bucket, 
  COUNT(hours_bucket) 
FROM 
  (SELECT *, 
          CONCAT(CAST(HOUR(order_date) AS CHAR), '-', CAST(HOUR(order_date) + 1 AS CHAR)) AS hours_bucket 
   FROM customer_orders) AS a
GROUP BY 
  hours_bucket; 
  
SELECT *, DAYNAME(order_date) AS dow 
FROM customer_orders;

SELECT dow, COUNT(DISTINCT order_id) 
FROM 
  (SELECT *, DAYNAME(order_date) AS dow 
   FROM customer_orders) AS a
GROUP BY dow;



select * from customer_orders;



select driver_id, sum(diff), count(order_id) from 
(select * from 
(SELECT *, 
       ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY diff) AS rnk 
FROM 
    (SELECT a.order_id, 
            a.customer_id, 
            a.roll_id, 
            a.not_include_items, 
            a.extra_items_included, 
            a.order_date, 
            b.driver_id, 
            b.pickup_time, 
            b.distance, 
            b.duration, 
            b.cancellation, 
            TIMESTAMPDIFF(MINUTE, a.order_date, b.pickup_time) AS diff  -- Assuming diff is time difference
     FROM customer_orders a 
     INNER JOIN driver_order b 
     ON a.order_id = b.order_id 
     WHERE b.pickup_time IS NOT NULL)a) b where rnk=1)c
     group by driver_id; 



     
     
     


 
 















