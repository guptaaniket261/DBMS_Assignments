with reqRaces as
(
select raceid from races where races.year >= 2001 AND races.year <=2020
),
reqRes as
(
select driverid, points from results where raceid in (select raceid from reqRaces)
),
reqDriversRes as
(
select drivers.driverid, forename, surname, sum(points) as points
from (
drivers
inner join
reqRes
on
drivers.driverid = reqRes.driverid
)
group by drivers.driverid
)
select * from reqDriversRes where
points = (select max(points) from reqDriversRes)
order by forename asc, surname asc, driverid asc
;

