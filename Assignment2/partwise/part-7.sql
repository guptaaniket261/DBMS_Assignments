with zero_hops as
(
select distinct source_station_name, destination_station_name from train_info
),
one_hops as(
select distinct z1.source_station_name, z2.destination_station_name from zero_hops as z1 join zero_hops as z2
on z1.destination_station_name = z2.source_station_name
),
two_hops as(
select distinct zero_hops.source_station_name, one_hops.destination_station_name from zero_hops join one_hops
on zero_hops.destination_station_name = one_hops.source_station_name
),
three_hops as(
select distinct o1.source_station_name, o2.destination_station_name from one_hops as o1 join one_hops as o2
on o1.destination_station_name = o2.source_station_name
)
select source_station_name, destination_station_name from
(
select source_station_name, destination_station_name from zero_hops where not (source_station_name = destination_station_name)
union select source_station_name, destination_station_name from one_hops where not (source_station_name = destination_station_name)
union select source_station_name, destination_station_name from two_hops where not (source_station_name = destination_station_name)
union select source_station_name, destination_station_name from three_hops where not (source_station_name = destination_station_name)
) as t
order by source_station_name, destination_station_name
;



