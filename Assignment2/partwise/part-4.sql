with dayid (day, id) as
(
select 'Monday', 1
union select 'Tuesday', 2
union select 'Wednesday', 3
union select 'Thursday', 4
union select 'Friday', 5
union select 'Saturday', 6
union select 'Sunday', 7
),
zero_hopes as
(
select destination_station_name, arrival_time, day_of_arrival from train_info
where source_station_name = 'DADAR'
and (((select id from dayid where day = day_of_arrival) > (select id from dayid where day = day_of_departure))
or ((select id from dayid where day = day_of_arrival) = (select id from dayid where day = day_of_departure) and departure_time < arrival_time)
)
),
one_hopes as
(
select train_info.destination_station_name, train_info.arrival_time, train_info.day_of_arrival from train_info join zero_hopes
on zero_hopes.destination_station_name = train_info.source_station_name
and (((select id from dayid where day = zero_hopes.day_of_arrival) < (select id from dayid where day = train_info.day_of_departure))
or ((select id from dayid where day = zero_hopes.day_of_arrival) = (select id from dayid where day = train_info.day_of_departure) and train_info.departure_time > zero_hopes.arrival_time)
)
and (((select id from dayid where day = train_info.day_of_arrival) > (select id from dayid where day = train_info.day_of_departure))
or ((select id from dayid where day = train_info.day_of_arrival) = (select id from dayid where day = train_info.day_of_departure) and train_info.departure_time < train_info.arrival_time)
)
),
two_hopes as
(
select train_info.destination_station_name, train_info.arrival_time, train_info.day_of_arrival from train_info join one_hopes
on one_hopes.destination_station_name = train_info.source_station_name
and (((select id from dayid where day = one_hopes.day_of_arrival) < (select id from dayid where day = train_info.day_of_departure))
or ((select id from dayid where day = one_hopes.day_of_arrival) = (select id from dayid where day = train_info.day_of_departure) and train_info.departure_time > one_hopes.arrival_time)
)
and (((select id from dayid where day = train_info.day_of_arrival) > (select id from dayid where day = train_info.day_of_departure))
or ((select id from dayid where day = train_info.day_of_arrival) = (select id from dayid where day = train_info.day_of_departure) and train_info.departure_time < train_info.arrival_time)
)
),
answer as
(
select distinct destination_station_name from zero_hopes
union
select distinct destination_station_name from one_hopes
union
select distinct destination_station_name from two_hopes
)
select distinct destination_station_name from answer where not(destination_station_name = 'DADAR')
order by destination_station_name;

