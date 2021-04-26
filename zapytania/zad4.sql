--DROP TABLE STATION_END_A PURGE
CREATE TABLE STATION_END_A AS 
SELECT DISTINCT(s.short_name), s.station_id
FROM (
(SELECT t.end_station_id as station_id
FROM TRIPS t
GROUP BY t.end_station_id
HAVING COUNT(*) > 4) j
INNER JOIN
STATION_INFO s ON j.station_id = s.station_id
)
ORDER BY s.short_name


