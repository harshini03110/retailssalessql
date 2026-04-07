-- retail store database project
create database retail_store;
use retail_store;
-- tables creation

-- storing customer data
create table customers(
    customer_id int primary key,
    name varchar(100),
    city varchar(50)
);

-- storing product info
create table products(
    product_id int primary key,
    name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

-- orders placed by customers
create table orders(
    order_id int primary key,
    customer_id int,
    order_date date,
    foreign key (customer_id) references customers(customer_id)
);

-- items inside each order
create table order_details(
    order_id int,
    product_id int,
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

-- inserting some data
insert into customers values
(1,'Harshini','Hyderabad'),
(2,'Ravi','Chennai'),
(3,'Anita','Bangalore'),
(4,'Kiran','Delhi'),
(5,'Priya','Mumbai'),
(6,'Rahul','Pune');

select * from customers;

insert into products values
(101,'Laptop','Electronics',50000),
(102,'Mobile','Electronics',20000),
(103,'Shoes','Fashion',3000),
(104,'Watch','Accessories',5000),
(105,'Bag','Fashion',1500);

select * from products;

insert into orders values
(1001,1,'2025-01-10'),
(1002,2,'2025-01-12'),
(1003,1,'2025-02-05'),
(1004,3,'2025-02-20'),
(1005,4,'2025-03-01');

select * from orders;

insert into order_details values
(1001,101,1),
(1001,103,2),
(1002,102,1),
(1003,104,1),
(1004,105,3);

select * from order_details;
-- checking which products are selling more

select p.name, sum(od.quantity) total_sold
from order_details od
join products p on od.product_id = p.product_id
group by p.name
order by total_sold desc;

-- finding customers who spent more money
select c.name,
sum(p.price * od.quantity) total_spent
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by c.name
order by total_spent desc;

-- monthly revenue calculation
select month(o.order_date) m,
sum(p.price * od.quantity) revenue
from orders o
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by month(o.order_date);

-- category based sales
select p.category,
sum(p.price * od.quantity) total
from order_details od
join products p on od.product_id = p.product_id
group by p.category;

-- customers who didn’t place any orders
select c.name
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

-- city wise revenue 
select c.city,
sum(p.price * od.quantity) revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by c.city;

-- repeat customers
select customer_id, count(order_id) total_orders
from orders
group by customer_id
having count(order_id) > 1;

-- small update part
alter table customers add status varchar(10);

-- marking inactive users manually
update customers
set status = 'inactive'
where customer_id not in (select customer_id from orders);

update customers
set status = 'active'
where status is null;

select * from customers;
