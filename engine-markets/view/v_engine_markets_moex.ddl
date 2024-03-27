CREATE OR REPLACE VIEW v_engine_markets_moex AS
WITH read_json AS (
       SELECT t."rep_dt",
              t."engine",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "name",
              t.js ->> 2 AS "title"
       FROM (
              SELECT em.rep_dt, em.engine, json_array_elements((em.json_method -> 'markets'::text) -> 'data'::text) AS js
              FROM engine_markets_moex em
       ) t
)
SELECT j."rep_dt"::date,
       j."engine"::text,
       j."id"::int2,
       j."name"::text,
       j."title"::text
FROM read_json j;