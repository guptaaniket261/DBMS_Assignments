with
req_winners as
(
select driverid, count(driverid) as count from
(select driverid
from results
where positionorder = 1 and rank = 1) as t
group by driverid
),
req_driver as
(
select driverid, count from req_winners where count = (select max(count) from req_winners)
)
select drivers.driverid, forename, surname, count
from req_driver join drivers
on drivers.driverid = req_driver.driverid
order by forename, surname, driverid
;

