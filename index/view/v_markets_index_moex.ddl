CREATE OR REPLACE VIEW v_markets_index_moex AS
WITH read_json AS (
	SELECT t."rep_dt",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "trade_engine_id",
              t.js ->> 2 AS "trade_engine_name",
              t.js ->> 3 AS "trade_engine_title",
              t.js ->> 4 AS "market_name",
              t.js ->> 5 AS "market_title",
              t.js ->> 6 AS "market_id",
              t.js ->> 7 AS "marketplace",
              t.js ->> 8 AS "is_otc",
              t.js ->> 9 AS "has_history_files",
              t.js ->> 10 AS "has_history_trades_files",
              t.js ->> 11 AS "has_trades",
              t.js ->> 12 AS "has_history",
              t.js ->> 13 AS "has_candles",
              t.js ->> 14 AS "has_orderbook",
              t.js ->> 15 AS "has_tradingsession",
              t.js ->> 16 AS "has_extra_yields",
              t.js ->> 17 AS "has_delay"
	FROM (
		SELECT im.rep_dt, json_array_elements((im.json_method -> 'markets'::text) -> 'data'::text) AS js
		FROM index_moex im
	) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."trade_engine_id"::int2,
       j."trade_engine_name"::text,
       j."trade_engine_title"::text,
       j."market_name"::text,
       j."market_title"::text,
       j."market_id"::int2,
       j."marketplace"::text,
       j."is_otc"::int2,
       j."has_history_files"::int2,
       j."has_history_trades_files"::int2,
       j."has_trades"::int2,
       j."has_history"::int2,
       j."has_candles"::int2,
       j."has_orderbook"::int2,
       j."has_tradingsession"::int2,
       j."has_extra_yields"::int2,
       j."has_delay"::int2
FROM read_json j;