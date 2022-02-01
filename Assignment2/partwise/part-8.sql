with recursive reachable (destination_station_name, day, path) as
(
(
select destination_station_name, day_of_arrival, array[destination_station_name] as path
from train_info
where source_station_name = 'SHIVAJINAGAR' and
day_of_arrival = day_of_departure and
not (destination_station_name = 'SHIVAJINAGAR')
)
union all
(
select train_info.destination_station_name, train_info.day_of_arrival, reachable.path || train_info.destination_station_name
from train_info join reachable on
reachable.destination_station_name = train_info.source_station_name and
train_info.day_of_arrival = train_info.day_of_departure and
train_info.day_of_arrival = reachable.day and
not (train_info.destination_station_name = ANY(reachable.path)) and
not (train_info.destination_station_name = 'SHIVAJINAGAR')
)
)
select distinct destination_station_name, day from reachable
order by destination_station_name, day
;



