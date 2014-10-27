--Matt Pineau--
--October 22, 2014--
--Database Management--
--Lab 6--

--1--##To Come Back To##
with custs_from_top_producing_cities as(
select customers.name, customers.city
from customers
inner join products on customers.city = products.city
group by customers.name, customers.city, products.city
having products.city = max(products.city)
)

select *
from custs_from_top_producing_cities
;

--2--
select customers.name, customers.city
from customers
inner join products on customers.city = products.city
group by customers.name, customers.city, products.city
having products.city = max(products.city);

--3--
select pid
from products
where priceUSD > (select avg(priceUSD)
		          from products);

--4--
select customers.name, orders.pid, orders.dollars
from customers
inner join orders on customers.cid = orders.cid
order by orders.dollars asc;

--5--
select customers.name, coalesce(orders.dollars, 0)
from customers
full outer join orders
on customers.cid = orders.cid
order by customers.name;

--6--
select customers.name, agents.name, products.name
from customers
inner join orders
on customers.cid = orders.cid
inner join products
on orders.pid = products.pid
inner join agents
on orders.aid = agents.aid
where agents.city = 'New York';

--7--
select *
from orders
inner join products
on orders.pid =  products.pid
where orders.dollars != products.priceUSD*orders.qty;