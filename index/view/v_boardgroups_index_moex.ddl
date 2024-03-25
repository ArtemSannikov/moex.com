WITH read_json AS (
       SELECT t."rep_dt",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "trade_engine_id",
              t.js ->> 2 AS "trade_engine_name",
              t.js ->> 3 AS "trade_engine_title",
              t.js ->> 4 AS "market_id",
              t.js ->> 5 AS "market_name",
              t.js ->> 6 AS "name",
              t.js ->> 7 AS "title",
              t.js ->> 8 AS "is_default",
              t.js ->> 9 AS "board_group_id",
              t.js ->> 10 AS "is_traded",
              t.js ->> 11 AS "is_order_driven",
              t.js ->> 12 AS "category"
       FROM (
              SELECT im.rep_dt, json_array_elements((im.json_method -> 'boardgroups'::text) -> 'data'::text) AS js
              FROM index_moex im
       ) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."trade_engine_id"::int2,
       j."trade_engine_name"::text,
       j."trade_engine_title"::text,
       j."market_id"::int2,
       j."market_name"::text,
       j."name"::text,
       j."title"::text,
       j."is_default"::int2,
       j."board_group_id"::int2,
       j."is_traded"::int2,
       j."is_order_driven"::int2,
       j."category"::text
FROM read_json j;