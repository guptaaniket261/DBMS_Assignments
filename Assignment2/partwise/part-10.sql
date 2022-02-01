with recursive paths(s, d, path, len, dis) as
(
(
select source_station_name, destination_station_name, array[source_station_name, destination_station_name], 1, distance from train_info
)
union
(
select paths.s, train_info.destination_station_name, path || destination_station_name, len +1, dis+distance from
paths join train_info on train_info.source_station_name = paths.d and not (destination_station_name = any(path))
)
),
cycles as
(
select s as source_station_name, dis + distance as distance from paths join train_info on
paths.d = train_info.source_station_name and paths.s = train_info.destination_station_name
)
select source_station_name, max(distance) as distance from cycles group by source_station_name
order by source_station_name;





