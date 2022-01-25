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

