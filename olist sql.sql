create database olist;
use olist;
select * from olist_payments;
select * from olist_orders;
alter table olist_orders add column day_type varchar(10);
set sql_safe_updates=0;
update olist_orders set day_type = case when dayofweek(order_purchase_timestamp) in(1,7) then 'weekend' else 'weekday' end;
alter table olist_orders add column delivery_time int;
update olist_orders set delivery_time = datediff(order_delivered_customer_date,order_purchase_timestamp) where order_delivered_customer_date is not null;
-- TOTAL REVENUE --
select sum(payment_value) as total_revenue from olist_payments;
-- TOTAL ORDERS --
select count(order_id) as total_orders from olist_orders;
-- TOTAL CUSTOMERS --
select count(customer_id) as total_customers from olist_customers;
-- AVG FREIGHT COST PER ORDER --
select avg(freight_value) as avg_freight_cost from olist_items;
-- CUSTOMER REPEAT RATE --
select round(100*count(*)/(select count(distinct customer_id)from olist_customers),2) as repeated_customer_rate from (select customer_id from olist_orders group by customer_id having count(order_id)>1) as repeat_customers;
-- AVG PAYMENT VALUE BY PAYMENT TYPE --
select payment_type,round(avg(payment_value),2) as avg_payment_value from olist_payments group by payment_type;
-- AVG REVIEW SCORE --
select avg(review_score) as avg_review_score from olist_reviews;
-- AVG REVIEW SCORE BY PRODUCT --
select p.product_category_name, round(avg(r.review_score),2) as avg_review_score from olist_products p join olist_items i on p.product_id = i.product_id 
join olist_reviews r on i.order_id = r.order_id group by p.product_category_name order by avg_review_score desc;
-- CANCELLED ORDER RATE--
select round(100*count(*)/(select count(*)from olist_orders),2) as cancelled_order_rate from olist_orders where order_status = 'cancelled';