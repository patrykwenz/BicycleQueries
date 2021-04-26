SELECT o.ctr,o.station_name, o.region, o.time_delta_avg as time_delta_avg_in_s  
FROM (
(SELECT COUNT(*) AS ctr, s.name AS station_name , r.name AS region,round( AVG((t.END_DATE - t.START_DATE)*60*60*24),2) AS time_delta_avg
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.START_STATION_ID= s.STATION_ID)
GROUP BY s.name, r.name) o 

INNER JOIN 

(SELECT MAX(x.ctr) AS ctr, x.region AS region
FROM (
SELECT COUNT(*) AS ctr, s.name, r.name AS region
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.START_STATION_ID= s.STATION_ID)
GROUP BY s.name, r.name)x
GROUP BY x.region) p
ON o.ctr = p.ctr AND o.region = p.region) 
ORDER BY o.ctr DESC
