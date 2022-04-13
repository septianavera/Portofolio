--Select all column from superstore_product, superstore_customer, superstore_order
Select * 
from superstore_product;

select * 
from superstore_customer;

select *
from superstore_order;

--display the total order 'Same Day' which has a late delivery
Select count(order_id) as jumlah_orders
from superstore_order
where ship_mode ='Same Day'and order_date <> ship_date;

--Shows the relationship between the discount level and the average discount
select 
	case when discount < 0.2 then 'LOW'
	when discount >= 0.4 then 'HIGH'
	else 'MODERATE'
	end as level_diskon,
	avg(profit)as rata_rata_profit
from superstore_order
group by level_diskon;


--displays the average discount and profit by category and subcategory
Select  
	category, 
	subcategory, 
	avg(discount)as avg_discount,
	avg(profit) as avg_profit
from (
	select * 
	from superstore_order o
	inner join superstore_product p
	on o.product_id = p.product_id
	)subq
group by 1,2
order by category;

--displays total sales and average profit in 2016 based on customers segment in the state of California, Texas and also Georgia
select 
	segment,
	sum(sales) as total_sales,
	avg(profit) as rata_rata_profit
from (
	Select 
		order_id,
		date_part('year', order_date) as order_year,
		segment, 
		country, 
		state, 
		region, 
		sales, 
		profit
	from superstore_order o 
	join superstore_customer c
	on o.customer_id = c.customer_id
	where state in ('California','Texas','Georgia') 
	)subq
where order_year = 2016
group by 1
order by segment;

--displays the number of people/customers who have an average discount above 0.4 for each existing region
select region, count(region) as jumlah_pelanggan	
from (		
	Select 
		customer_id,
		avg(discount) as avg_disc
	from superstore_order 
	group by 1
	having avg(discount) > 0.4
	order by 2
	) subq
left join superstore_customer c
	on subq.customer_id = c.customer_id
group by region
order by jumlah_pelanggan desc;






