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

