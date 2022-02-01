with zero_hopes as
(
select destination_station_name, day_of_arrival as r_day, distance from train_info
where source_station_name = 'DADAR' and
day_of_departure = day_of_arrival
),
one_hopes as
(
select train_info.destination_station_name, r_day, zero_hopes.distance + train_info.distance as distance from train_info join zero_hopes
on zero_hopes.destination_station_name = train_info.source_station_name
and train_info.day_of_departure = train_info.day_of_arrival
and zero_hopes.r_day = train_info.day_of_departure
),
two_hopes as
(
select train_info.destination_station_name, r_day, one_hopes.distance + train_info.distance as distance from train_info join one_hopes
on one_hopes.destination_station_name = train_info.source_station_name
and train_info.day_of_departure = train_info.day_of_arrival
and one_hopes.r_day = train_info.day_of_departure
),
answer as
(
select distinct destination_station_name, distance, r_day as day from zero_hopes
union
select distinct destination_station_name, distance, r_day as day from one_hopes
union
select distinct destination_station_name, distance, r_day as day from two_hopes
)
select distinct destination_station_name, distance, day from answer where not(destination_station_name = 'DADAR')
order by destination_station_name, distance, day
;

