with
consRaceYear as
(
select races.raceid, constructorid, points, year
from constructorresults join races
on races.raceid = constructorresults.raceid
),
consYearly as
(
select constructorid, year, sum(points) as points
from consRaceYear group by constructorid, year
),
yearTopScore as
(
select year, max(points) as points
from consYearly group by year
),
yearTopper as
(
select consYearly.year, constructorid, consYearly.points
from consYearly join yearTopScore
on consYearly.year = yearTopScore.year and consYearly.points = yearTopScore.points
),
yearRunnerUp as
(
select year, constructorid, points
from consYearly c1
where points >= all (select points from consYearly c2 where year = c1.year and points < (select points from yearTopScore where year = c1.year))
and points not in (select points from yearTopScore where year = c1.year)
),
yearTopperFinal as
(
select year, constructors.constructorid, points, name as constructor1_name
from yearTopper join constructors on
yearTopper.constructorid = constructors.constructorid
),
yearRunnerUpFinal as
(
select year, constructors.constructorid, points, name as constructor2_name
from yearRunnerUp join constructors on
yearRunnerUp.constructorid = constructors.constructorid
),
details as(
select yearTopperFinal.year, yearTopperFinal.points - yearRunnerUpFinal.points as point_diff, yearTopperFinal.constructorid as constructor1_id, constructor1_name, yearRunnerUpFinal.constructorid as constructor2_id, constructor2_name
from yearTopperFinal join yearRunnerUpFinal
on yearRunnerUpFinal.year = yearTopperFinal.year
)
select * from details
where point_diff = (select max(point_diff) from details)
order by constructor1_name, constructor2_name, constructor1_id, constructor2_id
;

