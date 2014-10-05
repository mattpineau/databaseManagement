--Author: Matt Pineau--
--Date:8/1/14--
--Course: Database Management--
--Assignment: Lab 5--


--1--
select distinct agents.city
from agents,
     orders,
     customers
where agents.aid = orders.aid
and   orders.cid = customers.cid
and   customers.name = 'Tiptop';

--2***--


--3--
select name
from customers
where cid not in (select cid
                  from orders);

--4***--
select distinct customers.name
from customers
full outer join orders
on customers.cid = orders.cid
where customers.cid is null
or orders.cid is null;

--5--
select distinct customers.name as customer_name, agents.name as agent_name
from customers,
     orders,
     agents
where customers.cid = orders.cid
and orders.aid = agents.aid
and customers.city = agents.city;

--6--
select distinct customers.name as customer_name, agents.name as agent_name
from customers,
     agents
where customers.city = agents.city;

--7--



