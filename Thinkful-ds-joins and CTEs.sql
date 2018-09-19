-- What are the three longest trips on rainy days?
WITH
	rain
AS (
	SELECT
		Date,
		PrecipitationIn
	FROM
		weather
	WHERE
		PrecipitationIn != 0
	GROUP BY 1
)

SELECT
	start_date,
	duration
FROM
	trips t
JOIN
	rain r
ON
	t.start_date = r.Date
ORDER BY duration DESC
LIMIT 3

--Which station is full most often?
SELECT
	s1.station_id,
	s1.name,
	s2.docks_available,
	COUNT(CASE WHEN s2.docks_available=0 THEN 1 END) AS docks_full
FROM
	status s2
JOIN
	stations s1
ON 
	s1.station_id = s2.station_id
GROUP BY 1,2
ORDER BY docks_full DESC


--Return a list of stations with a count of number of trips starting at that station but ordered by dock count.
SELECT
	t.start_station,
	s.dockcount,
	COUNT(*)
FROM
	trips AS t
JOIN
	stations AS s
ON
	s.name = t.start_station
GROUP BY 1,2
ORDER BY 2 DESC


--What's the length of the longest trip for each day it rains anywhere?
WITH
	rain
AS (
	SELECT
		Date
	FROM
		weather AS w
	WHERE
		PrecipitationIn != 0
	GROUP BY 1
),
longest_trip AS (
	SELECT
		start_date,
		duration
	FROM
		trips AS t
	JOIN
		rain AS r
	ON
		t.start_date = r.Date
	ORDER BY duration DESC
	)
SELECT
	l.start_date,
	duration
FROM
	longest_trip AS l
GROUP BY 1
ORDER BY duration DESC