with zero_hopes as
(
select destination_station_name from train_info
where train_no = 97131 and source_station_name = 'KURLA'
),
one_hopes as
(
select train_info.destination_station_name from train_info join zero_hopes
on zero_hopes.destination_station_name = train_info.source_station_name
),
two_hopes as
(
select train_info.destination_station_name from train_info join one_hopes
on one_hopes.destination_station_name = train_info.source_station_name
)
select destination_station_name from zero_hopes
union
(
select destination_station_name from one_hopes
union select destination_station_name from two_hopes
)
order by destination_station_name;

