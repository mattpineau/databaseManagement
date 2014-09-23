--Matt Pineau
--9/17/14
--Database Management
--Lab 3: Getting Started with SQL Queries

-- 1)
   SELECT name, city
   FROM agents
   WHERE name = 'bond';
   
-- 2)
	SELECT pid, name, quantity
	FROM products
	WHERE priceusd>0.99;
	
-- 3)
	SELECT ordno, qty
	FROM orders;

-- 4)
	SELECT name, city
	FROM customers
	WHERE city = 'Duluth';

-- 5)
	SELECT name
	FROM agents
	WHERE city != 'New York' AND city != 'London';

-- 6)
	SELECT*
	FROM products
	WHERE city != 'Dallas' AND city != 'Duluth' AND priceusd <= 1;

-- 7)
	SELECT*
	FROM orders
	WHERE mon = 'jan' OR mon = 'apr';

-- 8)
	SELECT*
	FROM orders
	WHERE mon = 'feb' AND dollars > 200;

-- 9)
	SELECT ordno
	FROM orders
	WHERE cid = 'c005';