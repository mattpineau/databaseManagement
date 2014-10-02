--Author: Matt Pineau
--Date: 9/26/14
--Class: Database Management
--Assignment: Lab 4

--1--
select city
from agent
where aid in (select aid
              from orders
              where cid in (select cid
                            from customers
                            where name = 'TipTop'));
                            
--2--
select pid
from products
where pid in (select pid
             from orders
             where aid in (select aid
                          from orders
                          where cid in (select cid
                                       from customers
                                       where city = 'Kyoto')));

--3--
select cid, name
from customers
where cid in (select cid
             from orders
             where aid != 'a04');

--4--
select cid, name
from customers
where cid in (select cid
             from orders
             where pid = 'p07')
  and cid in (select cid
	      from orders
	      where pid = 'p01');

--5--
select pid
from products
where pid in (select pid
             from orders
             where aid = 'a04');

--6--
select name, discount
from customers
where cid in (select cid
             from orders
             where aid in (select aid
                          from agents
                          where city in ('Dallas', 'Newark')));

--7--
select cid
from customers
where discount in (select discount
                  from customers
                  where city in ('Dallas', 'Kyoto'));