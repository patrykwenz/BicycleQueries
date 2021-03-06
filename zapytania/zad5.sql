--DROP TABLE STATION_END_B PURGE;

CREATE TABLE STATION_END_B AS 

SELECT END_STATION_ID as STATION_ID 
FROM (
(SELECT DISTINCT(trips.end_station_id) FROM TRIPS) j

LEFT JOIN

(SELECT DISTINCT(STATION_ID)
FROM
TRIPS t INNER JOIN 
(SELECT STATION_STATUS.STATION_ID
FROM STATION_STATUS
WHERE STATION_STATUS.is_renting like '1' and STATION_STATUS.num_bikes_available > 0) j
ON t.start_station_id = j.station_id) x

ON j.end_station_id = x.station_id)
WHERE x.station_id IS NULL
ORDER BY 1

