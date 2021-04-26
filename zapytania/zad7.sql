SELECT TRIP_ID, gt.REGION_NAME FROM(
(SELECT j.*, p.*, MDSYS.sdo_geom.sdo_distance(
sdo_geometry(2001, 4326,sdo_point_type(sdo_geometry(START_CORDS).sdo_point.x, sdo_geometry(START_CORDS).sdo_point.y, NULL), NULL, NULL),
sdo_geometry(2001, 4326,sdo_point_type(sdo_geometry(FINAL_CORDS).sdo_point.x, sdo_geometry(FINAL_CORDS).sdo_point.y, NULL), NULL, NULL), 0.01, 'unit=KM')
as dist  FROM(
(SELECT STATION_ID as S_STATION_ID, STATION_GEOM as START_CORDS, r.name as REGION_NAME, END_STATION_ID, t.TRIP_ID
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.START_STATION_ID= s.STATION_ID)) j
INNER JOIN 
(SELECT DISTINCT(STATION_ID) as E_STATION_ID, STATION_GEOM as FINAL_CORDS
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.END_STATION_ID= s.STATION_ID)) p
ON j.END_STATION_ID = p.e_station_id)) gt

INNER JOIN

(SELECT j.region_name,
max(MDSYS.sdo_geom.sdo_distance(
sdo_geometry(2001, 4326,sdo_point_type(sdo_geometry(START_CORDS).sdo_point.x, sdo_geometry(START_CORDS).sdo_point.y, NULL), NULL, NULL),
sdo_geometry(2001, 4326,sdo_point_type(sdo_geometry(FINAL_CORDS).sdo_point.x, sdo_geometry(FINAL_CORDS).sdo_point.y, NULL), NULL, NULL), 0.01, 'unit=KM'))
as dist 
FROM(
(SELECT STATION_ID as S_STATION_ID, STATION_GEOM as START_CORDS, r.name as REGION_NAME, END_STATION_ID, t.TRIP_ID
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.START_STATION_ID= s.STATION_ID)) j
INNER JOIN 
(SELECT DISTINCT(STATION_ID) as E_STATION_ID, STATION_GEOM as FINAL_CORDS
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.END_STATION_ID= s.STATION_ID)) p
ON j.END_STATION_ID = p.e_station_id)
GROUP BY j.region_name) ga

ON gt.DIST = ga.DIST AND gt.region_name = ga.region_name
)
