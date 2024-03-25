CREATE OR REPLACE VIEW v_securitygroups_index_moex AS
WITH read_json AS (
       SELECT t."rep_dt",
              t.js ->> 0 AS "id",
              t.js ->> 1 AS "name",
              t.js ->> 2 AS "title",
              t.js ->> 3 AS "is_hidden"
       FROM (
              SELECT im.rep_dt, json_array_elements((im.json_method -> 'securitygroups'::text) -> 'data'::text) AS js
              FROM index_moex im
       ) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."name"::text,
       j."title"::text,
       j."is_hidden"::int2
FROM read_json j;