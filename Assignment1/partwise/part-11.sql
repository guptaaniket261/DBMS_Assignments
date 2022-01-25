with
results_collision as
(
select raceid from results
where statusid = (select statusid from status where status.status = 'Collision')
),
collision_count as
(
select raceid, count(raceid) as num_collisions
from results_collision
group by raceid
),
max_collision as
(
select raceid, num_collisions from
collision_count where num_collisions = (select max(num_collisions) from collision_count)
),
max_collision_circuit as
(
select races.raceid, num_collisions, circuitid from
max_collision join races
on races.raceid = max_collision.raceid
)
select raceid, name, location, num_collisions
from max_collision_circuit join circuits
on max_collision_circuit.circuitid = circuits.circuitid
order by name, location, raceid
;

