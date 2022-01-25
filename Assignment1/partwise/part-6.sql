with
raceTopScore as
(
select raceid, max(points) as score from constructorresults group by raceid
),
raceWiners as
(
select constructorresults.constructorid, constructorresults.raceid
from constructorresults
inner join raceTopScore
on constructorresults.raceid = raceTopScore.raceid AND constructorresults.points = raceTopScore.score
),
winCounts as
(
select constructors.constructorid, name, result.num_wins
from
(select constructorid, count(distinct raceid) as num_wins
from raceWiners group by constructorid) as result, constructors
where constructors.constructorid = result.constructorid
)
select * from winCounts where
num_wins = (select max(num_wins) from winCounts)
order by name, constructorid
;

