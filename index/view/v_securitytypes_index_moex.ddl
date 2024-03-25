CREATE OR REPLACE VIEW v_securitytypes_index_moex AS
WITH read_json AS (
       SELECT t."rep_dt",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "trade_engine_id",
              t.js ->> 2 AS "trade_engine_name",
              t.js ->> 3 AS "trade_engine_title",
              t.js ->> 4 AS "security_type_name",
              t.js ->> 5 AS "security_type_title",
              t.js ->> 6 AS "security_group_name",
              t.js ->> 7 AS "stock_type"
       FROM (
              SELECT im.rep_dt, json_array_elements((im.json_method -> 'securitytypes'::text) -> 'data'::text) AS js
              FROM index_moex im
       ) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."trade_engine_id"::int2,
       j."trade_engine_name"::text,
       j."trade_engine_title"::text,
       j."security_type_name"::text,
       j."security_type_title"::text,
       j."security_group_name"::text,
       j."stock_type"::text
FROM read_json j;