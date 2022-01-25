with
podiums as
(
select distinct raceid, driverid from
results where
(positionorder = 1 or positionorder = 2 or positionorder = 3)
),
podiumCounts as
(
select driverid, count(raceid) as count
from podiums group by
driverid
),
details as
(
select drivers.driverid, forename, surname, count
from podiumCounts join drivers
on podiumCounts.driverid = drivers.driverid
)
select driverid, forename, surname, count
from details
where count = (select max(count) from details)
order by forename, surname desc, driverid
;

