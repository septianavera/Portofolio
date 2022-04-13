/*

Topic : Create and insert table about Brazilian E-Commerce Public Dataset by Olist

*/
-- Create table 
-- Table 1 Query :
create table customers
		(customer_id varchar,
		 customer_unique_id varchar,
		 customeer_zip_code_prefix varchar,
		 customer_city varchar,
		 customer_state varchar
		);
		
-- Table 2 Query :
create table geolocation
		(geolocation_zip_code_prefix varchar(5),
		 geolocation_lat varchar,
		 geolocation_lng varchar,
		 geolocation_city varchar,
		 geolocation_state varchar
		);
		
		
-- Table 3 Query :
create table order_items
		(order_id varchar,
		 order_item_id numeric,
		 product_id varchar,
		 seller_id varchar,
		 shipping_limit_date timestamp,
		 price numeric,
		 freight_value numeric
		 );
		 
-- Table 4 Query :
create table order_payments
		(order_id varchar,
		 payment_sequential numeric,
		 payment_type varchar,
		 payment_installments numeric,
		 payment_value numeric
		 )	;
		 
-- Table 5 Query :
create table order_review
		(review_id varchar,
		 order_id varchar,
		 review_score numeric,
		 review_comment_title varchar,
		 review_comment_message varchar,
		 review_creation_date timestamp,
		 review_answer_timestamp timestamp
		 )
		 ;

-- Table 6 Query 
create table orders 
		(order_id varchar,
		 customer_id varchar,
		 order_status varchar,
		 order_purchase_timestamp timestamp,
		 order_approved_at timestamp,
		 order_delivered_carrier_date timestamp,
		 order_delivered_customer_date timestamp,
		 order_estimated_delivery_date timestamp
		 )
		 ;

-- Table 7 Query 
create table products
		(product_id varchar,
		 product_category_name varchar,
		 product_name_lenght numeric,
		 product_description_lenght numeric,
		 product_photos_qty numeric,
		 product_weight_g numeric,
		 product_length_cm numeric,
		 product_height_cm numeric,
		 product_width_cm numeric
		)
		;

-- Table 8 Query 
create table sellers
		(seller_id varchar,
		 seller_zip_code_prefix varchar(5),
		 seller_city varchar,
		 seller_state varchar
		)
		;
		
-- Table 9 Query 
create table product_category_name
		(product_category_name varchar,
		 product_category_name_english varchar
		)