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

