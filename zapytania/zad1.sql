SELECT 
     r.NAME as REGION_NAME, 
CASE 
    WHEN 
    SUM(CASE WHEN UPPER(t.MEMBER_GENDER) like 'FEMALE' THEN 1 ELSE 0 END) >
    SUM(CASE WHEN UPPER(t.MEMBER_GENDER) like 'MALE' THEN 1 ELSE 0 END) 
    THEN 'Female'

    WHEN 
    SUM(CASE WHEN UPPER(t.MEMBER_GENDER) like 'FEMALE' THEN 1 ELSE 0 END) =
    SUM(CASE WHEN UPPER(t.MEMBER_GENDER) like 'MALE' THEN 1 ELSE 0 END) 
    THEN 'Even'

    ELSE 'Male' 
END MAJORITY_GENDER
FROM ((STATION_INFO s
INNER JOIN REGIONS r ON s.REGION_ID = r.REGION_ID)
INNER JOIN TRIPS t ON t.START_STATION_ID= s.STATION_ID)
WHERE t.MEMBER_GENDER IS NOT NULL
GROUP BY r.NAME