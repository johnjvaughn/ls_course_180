# 2
SELECT name AS "Bid on Items" 
FROM items i 
WHERE i.id IN (SELECT DISTINCT b.item_id FROM bids b);

# 3
SELECT name AS "Not Bid on" 
FROM items i 
WHERE i.id NOT IN (SELECT DISTINCT b.item_id FROM bids b);

# 4
SELECT name
FROM bidders 
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);

SELECT DISTINCT name
FROM bidders
INNER JOIN bids ON bids.bidder_id = bidders.id;

# 5
SELECT name AS "Highest Bid Less Than 100 Dollars" 
FROM items
WHERE items.id != ANY
(SELECT bids.item_id FROM bids WHERE bids.item_id = items.id AND bids.amount > 100);

SELECT name AS "Highest Bid Less Than 100 Dollars" 
FROM items
WHERE 100.00 > ALL (SELECT bids.amount FROM bids WHERE bids.item_id = items.id);

SELECT name AS "Highest Bid Less Than 100 Dollars" 
FROM items
WHERE EXISTS (SELECT bids.amount FROM bids WHERE bids.item_id = items.id)
AND 100.00 > ALL (SELECT bids.amount FROM bids WHERE bids.item_id = items.id);

#6
SELECT MAX(bid_counts.count)
FROM (SELECT COUNT(*) FROM bids GROUP BY bidder_id) AS bid_counts;

#7
SELECT name, (SELECT count(*) FROM bids WHERE bids.item_id = items.id)
FROM items;

SELECT items.name, count(bids.item_id)
FROM items
LEFT OUTER JOIN bids ON bids.item_id = items.id
GROUP BY items.name;

#8
SELECT id FROM items 
WHERE CONCAT(name, '|', initial_price, '|', sales_price) = 'Painting|100.00|250.00';

#9
EXPLAIN ANALYZE SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);

#10
EXPLAIN ANALYZE
SELECT name,
(SELECT COUNT(item_id) FROM bids WHERE item_id = items.id)
FROM items;
# produces:
--                                                  QUERY PLAN
-- ------------------------------------------------------------------------------------------------------------
--  Seq Scan on items  (cost=0.00..909.80 rows=880 width=40) (actual time=0.055..0.119 rows=6 loops=1)
--    SubPlan 1
--      ->  Aggregate  (cost=1.00..1.01 rows=1 width=8) (actual time=0.014..0.014 rows=1 loops=6)
--            ->  Seq Scan on bids  (cost=0.00..1.00 rows=1 width=4) (actual time=0.006..0.009 rows=4 loops=6)
--                  Filter: (item_id = items.id)
--                  Rows Removed by Filter: 22
--  Planning time: 0.209 ms
--  Execution time: 0.178 ms
-- (8 rows)

EXPLAIN ANALYZE
SELECT items.name, count(bids.item_id)
FROM items
LEFT OUTER JOIN bids ON bids.item_id = items.id
GROUP BY items.name;
#produces:
--                                                    QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------
--  HashAggregate  (cost=27.52..29.52 rows=200 width=40) (actual time=0.150..0.153 rows=6 loops=1)
--    Group Key: items.name
--    ->  Hash Left Join  (cost=1.01..23.12 rows=880 width=36) (actual time=0.109..0.122 rows=27 loops=1)
--          Hash Cond: (items.id = bids.item_id)
--          ->  Seq Scan on items  (cost=0.00..18.80 rows=880 width=36) (actual time=0.032..0.033 rows=6 loops=1)
--          ->  Hash  (cost=1.00..1.00 rows=1 width=4) (actual time=0.047..0.047 rows=26 loops=1)
--                Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                ->  Seq Scan on bids  (cost=0.00..1.00 rows=1 width=4) (actual time=0.020..0.032 rows=26 loops=1)
--  Planning time: 0.298 ms
--  Execution time: 0.268 ms
-- (10 rows)


