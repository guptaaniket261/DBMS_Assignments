with zero_hopes as
(
select destination_station_name from train_info
where source_station_name = 'CST-MUMBAI' and not (source_station_name = destination_station_name)
),
one_hopes as
(
select train_info.destination_station_name from train_info join zero_hopes
on zero_hopes.destination_station_name = train_info.source_station_name
and not (zero_hopes.destination_station_name = 'VASHI')
and not (train_info.destination_station_name = 'CST-MUMBAI')
and not (train_info.source_station_name = train_info.destination_station_name)
),
two_hopes as
(
select train_info.destination_station_name from train_info join one_hopes
on one_hopes.destination_station_name = train_info.source_station_name
and not (one_hopes.destination_station_name = 'VASHI')
and not (train_info.destination_station_name = 'CST-MUMBAI')
and not (train_info.source_station_name = train_info.destination_station_name)
)
select count(destination_station_name) as Count from (
select destination_station_name from zero_hopes where destination_station_name = 'VASHI'
union all
select destination_station_name from one_hopes where destination_station_name = 'VASHI'
union all
select destination_station_name from two_hopes where destination_station_name = 'VASHI'
) as t;

