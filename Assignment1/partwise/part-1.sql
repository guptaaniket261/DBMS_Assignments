with monaco2017 as
(
SELECT raceid from races where year = 2017
and circuitid in (
select circuitid from circuits where country = 'Monaco'
)
),
req_laps as(
SELECT drivers.driverid, forename, surname, nationality, milliseconds as time
FROM laptimes, drivers
WHERE laptimes.driverid = drivers.driverid
and raceid in (select raceid from monaco2017)
)
select driverid, forename, surname, nationality, time
from req_laps
where time = (select max(time) from req_laps)
ORDER BY forename, surname, nationality;

