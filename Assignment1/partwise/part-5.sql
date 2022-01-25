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

