with
t1 as
(
select driverid, points, year
from results join races
on results.raceid = races.raceid
),
t2 as
(
select year, driverid, sum(points) as score
from t1
group by year, driverid
),
t3 as
(
select year, max(score) as championscore
from t2
group by year
),
champions as
(
select driverid, score
from t2, t3
where t2.year = t3.year and t2.score = t3.championscore
),
careerpoints as
(
select driverid, sum(points) as score
from results
group by driverid
)
select
drivers.driverid, forename, surname, score as points
from careerpoints, drivers
where careerpoints.driverid = drivers.driverid
and drivers.driverid not in (select driverid from champions)
order by points desc, forename, surname, driverid
limit 3
;

