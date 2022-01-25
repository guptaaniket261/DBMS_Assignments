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

