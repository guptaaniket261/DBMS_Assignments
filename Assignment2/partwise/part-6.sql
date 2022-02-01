with one_train as
(
select source_station_name, destination_station_name, min(distance) as distance
from train_info group by source_station_name, destination_station_name
),
two_trains as
(
select source_station_name, destination_station_name, min(distance) as distance
from (
select o1.source_station_name, o2.destination_station_name, o1.distance + o2.distance as distance
from one_train as o1, one_train as o2
where o1.destination_station_name = o2.source_station_name
) as t
group by source_station_name, destination_station_name
),
upto_two_trains as
(
select source_station_name, destination_station_name, min(distance) as distance
from (
select * from one_train union select * from two_trains
) as t1
group by source_station_name, destination_station_name
),
upto_four_trains as
(
select source_station_name, destination_station_name, min(distance) as distance
from (
select two1.source_station_name, two2.destination_station_name, two1.distance + two2.distance as distance
from upto_two_trains two1, upto_two_trains two2 where two1.destination_station_name = two2.source_station_name
) as t2
group by source_station_name, destination_station_name
),
upto_six_trains as
(
select source_station_name, destination_station_name, min(distance) as distance
from (
select two1.source_station_name, two2.destination_station_name, two1.distance + two2.distance as distance
from upto_two_trains two1, upto_four_trains two2 where two1.destination_station_name = two2.source_station_name
) as t3
group by source_station_name, destination_station_name
)
select destination_station_name, source_station_name, min(distance) as distance from
(
select * from upto_two_trains union
select * from upto_four_trains union
select * from upto_six_trains
) as tt where not (destination_station_name = source_station_name) group by destination_station_name, source_station_name
order by destination_station_name, source_station_name;




