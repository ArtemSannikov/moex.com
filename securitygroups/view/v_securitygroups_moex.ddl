CREATE OR REPLACE VIEW v_securitygroups_moex AS
WITH read_json AS (
	SELECT t."rep_dt",
              t.js ->> 0 AS "id",
	       t.js ->> 1 AS "name",
	       t.js ->> 2 AS "title",
	       t.js ->> 3 AS "is_hidden"
	FROM (
		SELECT em.rep_dt, json_array_elements((em.json_method -> 'securitygroups'::TEXT) -> 'data'::text) AS js
		FROM securitygroups_moex em
	) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."name"::text,
       j."title"::text,
       j."is_hidden"::int2
FROM read_json j;