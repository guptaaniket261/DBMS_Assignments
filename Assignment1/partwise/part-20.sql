with
winner_year as
(
select results.raceid, points, driverid, year
from races join results
on results.raceid = races.raceid
),
yearTotalPoints as
(
select year , driverid, sum(points) as points
from winner_year
group by year , driverid
),
championscore as
(
select distinct year, max(points) as points
from yearTotalPoints
group by year
),
champions as
(
select distinct yearTotalPoints.year, driverid
from yearTotalPoints join championscore
on yearTotalPoints.year = championscore.year and yearTotalPoints.points = championscore.points
),
championsCount as
(
select driverid, count(distinct year) as num_champs
from champions
group by driverid
)
select championsCount.driverid, forename, surname, num_champs
from championsCount join drivers
on championsCount.driverid = drivers.driverid
order by num_champs desc, forename, surname desc, driverid
limit 5;
