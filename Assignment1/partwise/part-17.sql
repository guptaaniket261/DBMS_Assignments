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

