CREATE OR REPLACE VIEW v_durations_index_moex AS
WITH read_json AS (
       SELECT t."rep_dt",
              t.js ->> 0 AS "interval",
              t.js ->> 1 AS "duration",
              t.js ->> 2 AS "days",
              t.js ->> 3 AS "title",
              t.js ->> 4 AS "hint"
       FROM (
              SELECT im.rep_dt, json_array_elements((im.json_method -> 'durations'::text) -> 'data'::text) AS js
              FROM index_moex im
       ) t
)
SELECT j."rep_dt"::date,
       j."interval"::int2,
       j."duration"::int4,
       j."days"::int2,
       j."title"::text,
       j."hint"::text
FROM read_json j;