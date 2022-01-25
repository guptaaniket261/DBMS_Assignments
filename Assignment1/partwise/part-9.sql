with
startendwinner as
(
select driverid
from results
where grid = 1 and positionorder = 1
),
startendwinnercount as
(
select driverid, count(driverid) as num_wins
from startendwinner
group by driverid
)
select drivers.driverid, forename, surname, num_wins
from startendwinnercount join drivers
on drivers.driverid = startendwinnercount.driverid
order by num_wins desc, forename, surname, drivers.driverid
limit 3
;

