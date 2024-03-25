CREATE OR REPLACE VIEW v_boards_index_moex AS
WITH read_json AS (
	SELECT t."rep_dt",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "board_group_id",
              t.js ->> 2 AS "engine_id",
              t.js ->> 3 AS "market_id",
              t.js ->> 4 AS "boardid",
              t.js ->> 5 AS "board_title",
              t.js ->> 6 AS "is_traded",
              t.js ->> 7 AS "has_candles",
              t.js ->> 8 AS "is_primary"
	FROM (
		SELECT im.rep_dt, json_array_elements((im.json_method -> 'boards'::text) -> 'data'::text) AS js
		FROM index_moex im
	) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."board_group_id"::int2,
       j."engine_id"::int2,
       j."market_id"::int2,
       j."boardid"::text,
       j."board_title"::text,
       j."is_traded"::int2,
       j."has_candles"::int2,
       j."is_primary"::int2
FROM read_json j;