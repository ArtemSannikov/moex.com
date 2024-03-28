CREATE OR REPLACE VIEW v_stock_zcyc_moex AS
WITH read_json AS (
	SELECT (t.js ->>0)::date AS "tradedate",
           (t.js ->> 1)::time AS "tradetime",
           (t.js ->> 2)::float8 AS "b1",
           (t.js ->> 3)::float8 AS "b2",
           (t.js ->> 4)::float8 AS "b3",
           (t.js ->> 5)::float8 AS "t1",
           (t.js ->> 6)::float8 AS "g1",
           (t.js ->> 7)::float8 AS "g2",
           (t.js ->> 8)::float8 AS "g3",
           (t.js ->> 9)::float8 AS "g4",
           (t.js ->> 10)::float8 AS "g5",
           (t.js ->> 11)::float8 AS "g6",
           (t.js ->> 12)::float8 AS "g7",
           (t.js ->> 13)::float8 AS "g8",
           (t.js ->> 14)::float8 AS "g9"
	FROM (
		SELECT json_array_elements((zc.json_method -> 'params'::text) -> 'data'::text) AS js
		FROM stock_zcyc_moex zc
	) t
)
SELECT j."tradedate",
       j."tradetime",
       j."b1",
       j."b2",
       j."b3",
       j."t1",
       j."g1",
       j."g2",
       j."g3",
       j."g4",
       j."g5",
       j."g6",
       j."g7",
       j."g8",
       j."g9"
FROM read_json j;