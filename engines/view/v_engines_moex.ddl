CREATE OR REPLACE VIEW v_engines_moex AS
WITH read_json AS (
	SELECT t."rep_dt",
              t.js ->> 0 AS "id",
	       t.js ->> 1 AS "name_dict_eng",
	       t.js ->> 2 AS "name_dict"
	FROM (
		SELECT em.rep_dt, json_array_elements((em.json_method -> 'engines'::TEXT) -> 'data'::text) AS js
		FROM engines_moex em
	) t
)
SELECT j."rep_dt"::date,
       j."id"::int2,
       j."name_dict_eng"::text,
       j."name_dict"::text
FROM read_json j;