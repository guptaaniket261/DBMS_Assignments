with zero_hopes as
(
select destination_station_name, day_of_arrival as r_day from train_info
where train_no = 97131 and source_station_name = 'KURLA' and
day_of_departure = day_of_arrival
),
one_hopes as
(
select train_info.destination_station_name, r_day from train_info join zero_hopes
on zero_hopes.destination_station_name = train_info.source_station_name
and train_info.day_of_departure = train_info.day_of_arrival
and zero_hopes.r_day = train_info.day_of_departure
),
two_hopes as
(
select train_info.destination_station_name, r_day from train_info join one_hopes
on one_hopes.destination_station_name = train_info.source_station_name
and train_info.day_of_departure = train_info.day_of_arrival
and one_hopes.r_day = train_info.day_of_departure
)
select destination_station_name from zero_hopes
union
(
select destination_station_name from one_hopes
union select destination_station_name from two_hopes
)
order by destination_station_name;

