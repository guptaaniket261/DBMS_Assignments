with
lapLeader as
(
select driverid from laptimes where position = 1
),
lapLeaderNum as
(
select driverid, count(driverid) as num_laps
from lapLeader
group by driverid
),
winner as
(
select driverid, num_laps from lapLeaderNum
where num_laps = (select max(num_laps) from lapLeaderNum)
)
select drivers.driverid, forename, surname, num_laps
from winner join drivers
on drivers.driverid = winner.driverid
order by forename, surname, driverid
;

