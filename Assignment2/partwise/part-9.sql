with recursive reachable (destination_station_name, day, path, distance) as
(
(
select destination_station_name, day_of_arrival, array[destination_station_name] as path, distance
from train_info
where source_station_name = 'LONAVLA' and
day_of_arrival = day_of_departure and
not (destination_station_name = 'LONAVLA')
)
union all
(
select train_info.destination_station_name, train_info.day_of_arrival, reachable.path || train_info.destination_station_name, reachable.distance + train_info.distance
from train_info join reachable on
reachable.destination_station_name = train_info.source_station_name and
train_info.day_of_arrival = train_info.day_of_departure and
train_info.day_of_arrival = reachable.day and
not (train_info.destination_station_name = ANY(reachable.path)) and
not (train_info.destination_station_name = 'LONAVLA')
)
),
reachable_min as
(
select destination_station_name, min(distance) as distance
from reachable
group by destination_station_name
)
select reachable_min.destination_station_name, reachable_min.distance, reachable.day
from reachable_min, reachable
where reachable_min.destination_station_name = reachable.destination_station_name and
reachable.distance = reachable_min.distance
order by distance, destination_station_name;




