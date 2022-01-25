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

