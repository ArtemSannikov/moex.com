CREATE OR REPLACE VIEW v_securitycollections_index_moex AS
WITH read_json AS (
       SELECT t."rep_dt",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "name",
              t.js ->> 2 AS "title",
              t.js ->> 3 AS "security_group_id"
       FROM (
              SELECT im.rep_dt, json_array_elements((im.json_method -> 'securitycollections'::text) -> 'data'::text) AS js
              FROM index_moex im
       ) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."name"::text,
       j."title"::text,
       j."security_group_id"::int2
FROM read_json j;