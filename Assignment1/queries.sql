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
select constructors.constructorid, name, result.num_wins
from 
(select constructorid, count(constructorid) as num_wins 
from (
  select constructorresults.constructorid, constructorresults.raceid
  from constructorresults
  inner join
  (select raceid, max(points) as score from constructorresults group by raceid) as temp
  on constructorresults.raceid = temp.raceid AND constructorresults.points = temp.score
) as winners
group by constructorid) as result,
constructors
where constructors.constructorid = result.constructorid
order by num_wins desc, name, constructorid limit 1
;



