--1--
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

--2--
with races2012 as
(
  select raceid from races where year = 2012
),
req2012 as
(
  select * from constructorresults where raceid in (select raceid from races2012)
)
select name as constructor_name, constructors.constructorid, nationality, sum(points) as points
from (
  constructors 
  inner join 
  req2012
  on
  constructors.constructorid = req2012.constructorid
)
group by constructors.constructorid
order by points desc, constructor_name, nationality asc, constructorid asc 
limit 5
;

--3--
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

--4--
with reqRaces as
(
  select raceid from races where races.year >= 2010 AND races.year <=2020
),
reqRes as
(
  select * from constructorresults where raceid in (select raceid from reqRaces)
),
reqResCons as
(
  select constructors.constructorid, name, nationality, sum(points) as points
  from (
    constructors
    inner join
    reqRes
    on constructors.constructorid = reqRes.constructorid
  )
  group by constructors.constructorid
)
select * from reqResCons 
where points = (select max(points) from reqResCons)
order by name, nationality, constructorid
;

--5--
with winners as
(
  select driverid, positionorder from results where positionorder = 1
),
driverRes as
(
  select driverid, sum(positionorder) as race_wins from winners group by driverid
),
reqTable as
(
  select drivers.driverid, forename, surname, race_wins
  from drivers inner join driverRes on
  driverRes.driverid = drivers.driverid
)
select * from reqTable where
race_wins = (select max(race_wins) from reqTable)
order by forename, surname, driverid
;

--6--
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

--7--
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

--8--
with 
winners as 
(
  select raceid, driverid
  from results
  where positionorder = 1
),
racecountry as
(
  select distinct raceid, country
  from races join circuits
  on races.circuitid = circuits.circuitid
),
winnercountry as
(
  select driverid, country
  from winners join racecountry
  on winners.raceid = racecountry.raceid
),
numcountries as
(
  select driverid, count(distinct country) as num_countries
  from winnercountry
  group by driverid
),
details as
(
  select distinct drivers.driverid, forename, surname, num_countries
  from numcountries join drivers
  on drivers.driverid = numcountries.driverid
)
select * from details where 
num_countries = (select max(num_countries) from details)
order by forename, surname, driverid
;

--9--
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

--10--
with 
winners as
(
  select * from results
  where positionorder = 1
),
circuitinfo as
(
  select distinct raceid, circuits.circuitid, circuits.name as name
  from races join circuits
  on races.circuitid = circuits.circuitid
),
pitpluswinners as
(
  select raceid, driverid, count(driverid) as num_stops
  from
  (
    select pitstops.raceid, pitstops.driverid
    from winners join pitstops on 
    pitstops.raceid = winners.raceid and winners.driverid = pitstops.driverid
  ) as t
  group by raceid, driverid
),
circuit_pit_winners as
(
  select circuitinfo.raceid, driverid, circuitid, circuitinfo.name as name, num_stops
  from pitpluswinners join circuitinfo
  on pitpluswinners.raceid = circuitinfo.raceid
),
details as
(
  select raceid, num_stops, drivers.driverid, forename, surname, circuitid, circuit_pit_winners.name as name
  from circuit_pit_winners join drivers
  on drivers.driverid = circuit_pit_winners.driverid
)
select * from details where 
num_stops = (select max(num_stops) from details)
order by forename, surname, name, circuitid, driverid
;

--11--
with 
results_collision as
(
  select raceid from results 
  where statusid = (select statusid from status where status.status = 'Collision')
),
collision_count as
(
  select raceid, count(raceid) as num_collisions
  from results_collision
  group by raceid
),
max_collision as
(
  select raceid, num_collisions from
  collision_count where num_collisions = (select max(num_collisions) from collision_count)
),
max_collision_circuit as
(
  select races.raceid, num_collisions, circuitid from
  max_collision join races
  on races.raceid = max_collision.raceid
)
select raceid, name, location, num_collisions
from max_collision_circuit join circuits
on max_collision_circuit.circuitid = circuits.circuitid
order by name, location, raceid
;

--12--
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

--13--
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

--14--
with 
winners as
(
  select raceid, driverid, grid from results where positionorder = 1
),
winners2018 as
(
  select races.raceid, driverid, grid from races join winners on races.raceid = winners.raceid and year = 2018
),
largestStarting as
(
  select * from winners2018 where grid = (select max(grid) from winners2018)
),
circuitinfo as
(
  select distinct raceid, circuits.circuitid, country
  from races join circuits
  on races.circuitid = circuits.circuitid
),
largestStarting_circuit as
(
  select largestStarting.driverid, circuitid, country, grid as pos
  from circuitinfo join largestStarting
  on largestStarting.raceid = circuitinfo.raceid
)
select drivers.driverid, forename, surname, circuitid, country, pos
from largestStarting_circuit join drivers
on drivers.driverid = largestStarting_circuit.driverid
order by forename desc, surname, country, driverid, circuitid;

--15--
with
reqTable as
(
  select constructorid, statusid from 
  results join races
  on races.raceid = results.raceid and year >= 2000 and statusid = 5
),
res_cons as
(
  select constructorid, count(statusid) as num
  from reqTable group by 
  constructorid
),
ans as
(
  select constructorid, num 
  from res_cons where num = (select max(num) from res_cons)
)
select constructors.constructorid, name, num
from ans join constructors
on ans.constructorid = constructors.constructorid
order by name, constructorid
;

--16--
with
winners as
(
  select * from results where positionorder = 1
),
americanDrivers as
(
  select driverid from drivers where nationality = 'American'
),
americanCircuits as
(
  select circuitid from circuits where country = 'USA'
),
req_raceid as
(
  select raceid from races where circuitid in (select circuitid from americanCircuits)
),
sol as
(
  select distinct driverid from winners 
  where driverid in (select driverid from americanDrivers)
  and raceid in (select raceid from req_raceid)
)
select drivers.driverid, forename, surname 
from drivers join sol 
on sol.driverid = drivers.driverid
order by forename, surname, driverid
limit 5
;

--17--
with
races2014 as
(
  select raceid from races where year>=2014
),
oneTwo as
(
  select raceid, constructorid, positionorder from results 
  where (positionorder = 1 or positionorder = 2) 
  and raceid in (select raceid from races2014)
),
result as
(
  select O1.raceid, O1.constructorid
  from oneTwo as O1, oneTwo as O2
  where O1.raceid = O2.raceid 
  and O1.positionorder = 1
  and O2.positionorder = 2
  and O1.constructorid = O2.constructorid
),
resultFinal as
(
  select constructorid, count(distinct raceid) as count
  from result
  group by constructorid
),
details as
(
  select constructors.constructorid, name, count
  from constructors join resultFinal
  on constructors.constructorid = resultFinal.constructorid
)
select * from details where count = (select max(count) from details)
order by name, constructorid
;

--18--
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

--19--
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

--20--
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