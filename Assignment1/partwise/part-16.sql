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

