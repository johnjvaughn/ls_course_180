#2
SELECT DISTINCT c.* FROM customers c
INNER JOIN customers_services cs ON cs.customer_id = c.id;

#3
SELECT DISTINCT c.* FROM customers c
LEFT JOIN customers_services cs ON cs.customer_id = c.id
GROUP BY c.id HAVING count(cs.customer_id) = 0;
#or
SELECT DISTINCT c.* FROM customers c
LEFT JOIN customers_services cs ON cs.customer_id = c.id
WHERE cs.service_id IS NULL;
#further expl.
SELECT DISTINCT c.*, s.* FROM customers c 
LEFT JOIN customers_services cs ON cs.customer_id = c.id 
FULL JOIN services s ON s.id = cs.service_id
WHERE cs.service_id IS NULL or cs.customer_id IS NULL;

#4
SELECT s.description FROM customers_services cs
RIGHT OUTER JOIN services s ON s.id = cs.service_id
WHERE cs.customer_id IS NULL;

#5
SELECT c.name, string_agg(s.description, ', ')
FROM customers c
LEFT JOIN customers_services cs ON cs.customer_id = c.id
LEFT JOIN services s ON s.id = cs.service_id
GROUP BY c.name;
#further expl.
SELECT CASE WHEN c.name = lag(c.name) OVER (ORDER BY c.name) 
         THEN NULL
       ELSE c.name
       END,
       s.description
FROM customers c
LEFT JOIN customers_services cs ON cs.customer_id = c.id
LEFT JOIN services s ON s.id = cs.service_id;

#6
SELECT s.description, count(cs.customer_id)
FROM services s
INNER JOIN customers_services cs ON cs.service_id = s.id
GROUP BY s.id
HAVING count(cs.customer_id) >= 3
ORDER BY s.description;

#7
SELECT SUM(s.price) as gross
FROM services s
INNER JOIN customers_services ON service_id = s.id;

#8
INSERT INTO customers (name, payment_token)
VALUES ('John Doe', 'EYODHLCN');
#and
INSERT INTO customers_services (customer_id, service_id)
VALUES (7, 1), (7, 2), (7, 3);

#9
SELECT SUM(s.price)
FROM customers_services cs
LEFT JOIN services s ON cs.service_id = s.id
WHERE s.price > 100.00;
#and
SELECT SUM(s.price)
FROM customers
CROSS JOIN services s 
WHERE s.price > 100.00;

#10
DELETE FROM customers_services WHERE service_id = 7;
DELETE FROM services WHERE description = 'Bulk Email';
DELETE FROM customers WHERE name = 'Chen Ke-Hua';

