--1--
-- SELECT drivers.driverid, forename, surname, nationality, milliseconds
-- FROM laptimes, drivers
-- WHERE laptimes.driverid = drivers.driverid
-- and raceid in (SELECT raceid from races where year = 2017 and circuitid in (
--       select circuitid from circuits where country = 'Monaco'
--     ))
-- ORDER BY milliseconds DESC, forename, surname, nationality limit 1;

--2--
-- select name as constructor_name, constructors.constructorid, nationality, sum(points) as points
-- from (
--   constructors 
--   inner join 
--   (select * from constructorresults where raceid in (select raceid from races where year = 2012)) as temp
--   on 
--   constructors.constructorid = temp.constructorid
-- )
-- group by constructors.constructorid
-- order by points desc, constructor_name, nationality asc, constructorid asc 
-- limit 5
;

--3--
-- select drivers.driverid, forename, surname, sum(points) as points
-- from (
--   drivers
--   inner join
--   (
--     select driverid, points from results where results.raceid in (select raceid from races where races.year >= 2001 AND races.year <=2020)
--   ) as temp
--   on
--   drivers.driverid = temp.driverid
-- )
-- group by drivers.driverid
-- order by points desc, forename asc, surname asc, driverid asc limit 1
-- ;


--4--
-- select constructors.constructorid, name, nationality, sum(points) as points
-- from (
--   constructors
--   inner join
--   (
--     select * from constructorresults where raceid in (select raceid from races where races.year >= 2010 AND races.year <=2020)
--   ) as temp
--   on constructors.constructorid = temp.constructorid
-- )
-- group by constructors.constructorid
-- order by points desc, name, nationality, constructorid limit 1
-- ;

--5--
-- select drivers.driverid, forename, surname, race_wins
-- from
-- drivers
-- inner join
-- (
--   select driverid, sum(positionorder) as race_wins from (select driverid, positionorder from results where positionorder = 1) as winners group by driverid
-- ) as temp
-- on
-- temp.driverid = drivers.driverid
-- order by race_wins desc, forename, surname, driverid limit 1
-- ;

--6--
-- select constructors.constructorid, name, result.num_wins
-- from 
-- (select constructorid, count(constructorid) as num_wins 
-- from (
--   select constructorresults.constructorid, constructorresults.raceid
--   from constructorresults
--   inner join
--   (select raceid, max(points) as score from constructorresults group by raceid) as temp
--   on constructorresults.raceid = temp.raceid AND constructorresults.points = temp.score
-- ) as winners
-- group by constructorid) as result,
-- constructors
-- where constructors.constructorid = result.constructorid
-- order by num_wins desc, name, constructorid limit 1
-- ;

--7--
-- with 
-- t1 as
-- (
--   select driverid, points, year
--   from 
--   results join races
--   on results.raceid = races.raceid
-- ),
-- t2 as
-- (
--   select year, driverid, sum(points) as score
--   from t1
--   group by year, driverid
-- ),
-- t3 as
-- (
--   select year, max(score) as championscore
--   from t2
--   group by year
-- ),
-- champions as
-- (
--   select driverid, score
--   from t2, t3
--   where t2.year = t3.year and t2.score = t3.championscore
-- ),
-- careerpoints as
-- (
--   select driverid, sum(points) as score
--   from results
--   group by driverid
-- )
-- select
-- drivers.driverid, forename, surname, score
-- from careerpoints, drivers
-- where careerpoints.driverid = drivers.driverid
-- and drivers.driverid not in (select driverid from champions)
-- order by score desc, forename, surname, driverid
-- limit 3
-- ;

--8--
-- with 
-- winners as 
-- (
--   select raceid, driverid
--   from results
--   where positionorder = 1
-- ),
-- racecountry as
-- (
--   select raceid, country
--   from races join circuits
--   on races.circuitid = circuits.circuitid
-- ),
-- winnercountry as
-- (
--   select driverid, country
--   from winners join racecountry
--   on winners.raceid = racecountry.raceid
-- ),
-- numcountries as
-- (
--   select driverid, count(distinct country) as num_countries
--   from winnercountry
--   group by driverid
-- )
-- select distinct drivers.driverid, forename, surname, num_countries
-- from numcountries join drivers
-- on drivers.driverid = numcountries.driverid
-- order by num_countries desc, forename, surname, driverid
-- limit 1
-- ;

--9--
-- with
-- startendwinner as
-- (
--   select driverid
--   from results
--   where grid = 1 and positionorder = 1
-- ),
-- startendwinnercount as
-- (
--   select driverid, count(driverid) as num_wins
--   from startendwinner
--   group by driverid
-- )
-- select drivers.driverid, forename, surname, num_wins
-- from startendwinnercount join drivers
-- on drivers.driverid = startendwinnercount.driverid
-- order by num_wins desc, forename, surname, drivers.driverid
-- limit 3
-- ;

--10--
-- with 
-- winners as
-- (
--   select * from results
--   where positionorder = 1
-- ),
-- circuitinfo as
-- (
--   select distinct raceid, circuits.circuitid, circuits.name as name
--   from races join circuits
--   on races.circuitid = circuits.circuitid
-- ),
-- pitpluswinners as
-- (
--   select raceid, driverid, count(driverid) as num_stops
--   from
--   (
--     select pitstops.raceid, pitstops.driverid
--     from winners join pitstops on 
--     pitstops.raceid = winners.raceid and winners.driverid = pitstops.driverid
--   ) as t
--   group by raceid, driverid
-- ),
-- circuit_pit_winners as
-- (
--   select circuitinfo.raceid, driverid, circuitid, circuitinfo.name as name, num_stops
--   from pitpluswinners join circuitinfo
--   on pitpluswinners.raceid = circuitinfo.raceid
-- )
-- select raceid, num_stops, drivers.driverid, forename, surname, circuitid, circuit_pit_winners.name as name
-- from circuit_pit_winners join drivers
-- on drivers.driverid = circuit_pit_winners.driverid
-- order by num_stops desc, forename, surname, name, circuitid, driverid
-- limit 1
-- ;


--11--
-- with 
-- results_collision as
-- (
--   select raceid from results 
--   where statusid = (select statusid from status where status.status = 'Collision')
-- ),
-- collision_count as
-- (
--   select raceid, count(raceid) as num_collisions
--   from results_collision
--   group by raceid
-- ),
-- max_collision as
-- (
--   select raceid, num_collisions from
--   collision_count where num_collisions = (select max(num_collisions) from collision_count)
-- ),
-- max_collision_circuit as
-- (
--   select races.raceid, num_collisions, circuitid from
--   max_collision join races
--   on races.raceid = max_collision.raceid
-- )
-- select raceid, name, location, num_collisions
-- from max_collision_circuit join circuits
-- on max_collision_circuit.circuitid = circuits.circuitid
-- order by name, location, raceid
-- ;

--12--
-- with
-- req_winners as
-- (
--   select driverid, count(driverid) as count from
--     (select driverid
--     from results
--     where positionorder = 1 and rank = 1) as t
--   group by driverid
-- ),
-- req_driver as
-- (
--   select driverid, count from req_winners where count = (select max(count) from req_winners)
-- )
-- select drivers.driverid, forename, surname, count
-- from req_driver join drivers
-- on drivers.driverid = req_driver.driverid
-- order by forename, surname, driverid
-- ;

--13--
-- with 
-- consRaceYear as
-- (
--   select races.raceid, constructorid, points, year
--   from constructorresults join races
--   on races.raceid = constructorresults.raceid
-- ),
-- consYearly as
-- (
--   select constructorid, year, sum(points) as points
--   from consRaceYear group by constructorid, year
-- ),
-- yearTopScore as
-- (
--   select year, max(points) as points
--   from consYearly group by year
-- ),
-- yearTopper as
-- (
--   select consYearly.year, constructorid, consYearly.points
--   from consYearly join yearTopScore
--   on consYearly.year = yearTopScore.year and consYearly.points = yearTopScore.points
-- ),
-- yearRunnerUp as
-- (
--   select year, constructorid, points
--   from consYearly c1
--   where points >= all (select points from consYearly c2 where year = c1.year and points < (select points from yearTopScore where year = c1.year))
-- ),
-- yearTopperFinal as
-- (
--   select year, constructors.constructorid, points, name as constructor1_name
--   from yearTopper join constructors on
--   yearTopper.constructorid = constructors.constructorid
-- ),
-- yearRunnerUpFinal as
-- (
--   select year, constructors.constructorid, points, name as constructor2_name
--   from yearRunnerUp join constructors on
--   yearRunnerUp.constructorid = constructors.constructorid
-- )
-- select yearTopperFinal.year, yearTopperFinal.points - yearRunnerUpFinal.points as point_diff, yearTopperFinal.constructorid as constructor1_id, constructor1_name, yearRunnerUpFinal.constructorid as constructor2_id, constructor2_name
-- from yearTopperFinal join yearRunnerUpFinal
-- on yearRunnerUpFinal.year = yearTopperFinal.year
-- order by point_diff desc, constructor1_name, constructor2_name, constructor1_id, constructor2_id
-- limit 1
-- ;

--14--
-- with 
-- winners as
-- (
--   select raceid, driverid, grid from results where positionorder = 1
-- ),
-- winners2018 as
-- (
--   select races.raceid, driverid, grid from races join winners on races.raceid = winners.raceid and year = 2018
-- ),
-- largestStarting as
-- (
--   select * from winners2018 where grid = (select max(grid) from winners2018)
-- ),
-- circuitinfo as
-- (
--   select distinct raceid, circuits.circuitid, country
--   from races join circuits
--   on races.circuitid = circuits.circuitid
-- ),
-- largestStarting_circuit as
-- (
--   select largestStarting.driverid, circuitid, country, grid as pos
--   from circuitinfo join largestStarting
--   on largestStarting.raceid = circuitinfo.raceid
-- )
-- select drivers.driverid, forename, surname, circuitid, country, pos
-- from largestStarting_circuit join drivers
-- on drivers.driverid = largestStarting_circuit.driverid
-- order by pos desc, forename desc, surname, country, driverid, circuitid
-- limit 10;

--15--
-- with
-- reqTable as
-- (
--   select constructorid, statusid from 
--   results join races
--   on races.raceid = results.raceid and year >= 2000 and statusid = 5
-- ),
-- res_cons as
-- (
--   select constructorid, count(statusid) as num
--   from reqTable group by 
--   constructorid
-- ),
-- ans as
-- (
--   select constructorid, num 
--   from res_cons where num = (select max(num) from res_cons)
-- )
-- select constructors.constructorid, name, num
-- from ans join constructors
-- on ans.constructorid = constructors.constructorid
-- order by name, constructorid
-- ;

--16--
-- with
-- winners as
-- (
--   select * from results where positionorder = 1
-- ),
-- americanDrivers as
-- (
--   select driverid from drivers where nationality = 'American'
-- ),
-- americanCircuits as
-- (
--   select circuitid from circuits where country = 'USA'
-- ),
-- req_raceid as
-- (
--   select raceid from races where circuitid in (select circuitid from americanCircuits)
-- ),
-- sol as
-- (
--   select distinct driverid from winners 
--   where driverid in (select driverid from americanDrivers)
--   and raceid in (select raceid from req_raceid)
-- )
-- select drivers.driverid, forename, surname 
-- from drivers join sol 
-- on sol.driverid = drivers.driverid
-- order by forename, surname, driverid
-- limit 5
-- ;

--17--
-- with
-- races2014 as
-- (
--   select raceid from races where year>=2014
-- ),
-- oneTwo as
-- (
--   select raceid, constructorid, positionorder from results 
--   where (positionorder = 1 or positionorder = 2) 
--   and raceid in (select raceid from races2014)
-- ),
-- result as
-- (
--   select O1.raceid, O1.constructorid
--   from oneTwo as O1, oneTwo as O2
--   where O1.raceid = O2.raceid 
--   and O1.positionorder = 1
--   and O2.positionorder = 2
--   and O1.constructorid = O2.constructorid
-- ),
-- resultFinal as
-- (
--   select constructorid, count(distinct raceid) as count
--   from result
--   group by constructorid
-- )
-- select constructors.constructorid, name, count
-- from constructors join resultFinal
-- on constructors.constructorid = resultFinal.constructorid
-- order by count desc, name, constructors.constructorid
-- limit 1;

--18--
-- with
-- lapLeader as
-- (
--   select driverid from laptimes where position = 1
-- ),
-- lapLeaderNum as
-- (
--   select driverid, count(driverid) as num_laps
--   from lapLeader
--   group by driverid
-- ),
-- winner as
-- (
--   select driverid, num_laps from lapLeaderNum
--   where num_laps = (select max(num_laps) from lapLeaderNum)
-- )
-- select drivers.driverid, forename, surname, num_laps
-- from winner join drivers
-- on drivers.driverid = winner.driverid
-- order by forename, surname, driverid
-- ;

--19--
-- with
-- podiums as
-- (
--   select distinct raceid, driverid from 
--   results where 
--   (positionorder = 1 or positionorder = 2 or positionorder = 3)
-- ),
-- podiumCounts as
-- (
--   select driverid, count(raceid) as count
--   from podiums group by 
--   driverid
-- ),
-- details as
-- (
--   select drivers.driverid, forename, surname, count
--   from podiumCounts join drivers
--   on podiumCounts.driverid = drivers.driverid
-- )
-- select driverid, forename, surname, count
-- from details 
-- where count = (select max(count) from details)
-- order by forename, surname desc, driverid
-- ;

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
