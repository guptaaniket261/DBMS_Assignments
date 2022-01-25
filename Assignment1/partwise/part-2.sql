with races2012 as
(
select raceid from races where year = 2012
),
req2012 as
(
select * from constructorresults where raceid in (select raceid from races2012)
)
select name as constructor_name, constructors.constructorid, nationality, sum(points) as points
from (
constructors
inner join
req2012
on
constructors.constructorid = req2012.constructorid
)
group by constructors.constructorid
order by points desc, constructor_name, nationality asc, constructorid asc
limit 5
;

