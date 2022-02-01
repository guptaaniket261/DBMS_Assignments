with zero_hop as
(
select source_station_name, destination_station_name from train_info where not(source_station_name = destination_station_name)
),
one_hops as
(
select z1.source_station_name, z2.destination_station_name from zero_hop z1, zero_hop z2 where z1.destination_station_name = z2.source_station_name
and not(z1.source_station_name = z2.destination_station_name)
),
temp as
(
select * from zero_hop union select * from one_hops
),
counts as
(
select source_station_name, count(distinct destination_station_name) as cnt from temp
group by source_station_name
),
station_count as
(
select count(distinct st) as st_count from
(
select source_station_name as st from train_info union select destination_station_name as st from train_info
) as t
)
select source_station_name from counts where cnt+1 = (select st_count from station_count)
order by source_station_name;






