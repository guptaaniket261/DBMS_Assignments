--1--
-- with zero_hopes as
-- (
--   select destination_station_name from train_info
--   where train_no = 97131 and source_station_name = 'KURLA'
-- ),
-- one_hopes as
-- (
--   select train_info.destination_station_name from train_info join zero_hopes
--   on zero_hopes.destination_station_name = train_info.source_station_name
-- ),
-- two_hopes as
-- (
--   select train_info.destination_station_name from train_info join one_hopes
--   on one_hopes.destination_station_name = train_info.source_station_name
-- )
-- select destination_station_name from zero_hopes
-- union
-- (
--   select destination_station_name from one_hopes
--   union select destination_station_name from two_hopes
-- )
-- order by destination_station_name;

--2--
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

--3--
-- with zero_hopes as
-- (
--   select destination_station_name, day_of_arrival as r_day, distance from train_info
--   where source_station_name = 'DADAR' and 
--   day_of_departure = day_of_arrival
-- ),
-- one_hopes as
-- (
--   select train_info.destination_station_name, r_day, zero_hopes.distance + train_info.distance as distance from train_info join zero_hopes
--   on zero_hopes.destination_station_name = train_info.source_station_name
--   and train_info.day_of_departure = train_info.day_of_arrival
--   and zero_hopes.r_day = train_info.day_of_departure
-- ),
-- two_hopes as
-- (
--   select train_info.destination_station_name, r_day, one_hopes.distance + train_info.distance as distance from train_info join one_hopes
--   on one_hopes.destination_station_name = train_info.source_station_name
--   and train_info.day_of_departure = train_info.day_of_arrival
--   and one_hopes.r_day = train_info.day_of_departure
-- )
-- select destination_station_name, distance, r_day as day from zero_hopes
-- union all
-- (
--   select destination_station_name, distance, r_day as day from one_hopes
--   union all select destination_station_name, distance, r_day as day from two_hopes
-- )
-- order by destination_station_name, distance, day;

--4--
-- with dayid (day, id) as
-- (
--   select 'Monday', 1
--   union select 'Tuesday', 2
--   union select 'Wednesday', 3
--   union select 'Thursday', 4
--   union select 'Friday', 5
--   union select 'Saturday', 6
--   union select 'Sunday', 7
-- ),
-- zero_hopes as
-- (
--   select destination_station_name, arrival_time, day_of_arrival from train_info
--   where source_station_name = 'DADAR'
-- ),
-- one_hopes as
-- (
--   select train_info.destination_station_name, train_info.arrival_time, train_info.day_of_arrival from train_info join zero_hopes
--   on zero_hopes.destination_station_name = train_info.source_station_name
--   and (((select id from dayid where day = zero_hopes.day_of_arrival) < (select id from dayid where day = train_info.day_of_departure))
--       or ((select id from dayid where day = zero_hopes.day_of_arrival) = (select id from dayid where day = train_info.day_of_departure) and train_info.departure_time > zero_hopes.arrival_time)
--   )
-- ),
-- two_hopes as
-- (
--   select train_info.destination_station_name, train_info.arrival_time, train_info.day_of_arrival from train_info join one_hopes
--   on one_hopes.destination_station_name = train_info.source_station_name
--   and (((select id from dayid where day = one_hopes.day_of_arrival) < (select id from dayid where day = train_info.day_of_departure))
--       or ((select id from dayid where day = one_hopes.day_of_arrival) = (select id from dayid where day = train_info.day_of_departure) and train_info.departure_time > one_hopes.arrival_time)
--   )
-- )
-- select count(*) from(
--   select distinct destination_station_name from 
-- (
--   (select distinct destination_station_name from zero_hopes)
--   union (select distinct destination_station_name from one_hopes)
--   union (select distinct destination_station_name from two_hopes)
-- ) as t
-- order by destination_station_name
-- ) as t1;



-- with RECURSIVE feasDest (destination_station_name, arrival_time, day_of_arrival, hops) as
-- (
--   (select destination_station_name, arrival_time, day_of_arrival, 0
--   from train_info where source_station_name = 'DADAR')
-- union all
--   (select train_info.destination_station_name, train_info.arrival_time, train_info.day_of_arrival, hops+1
--   from train_info join feasDest on
--   hops < 2 and feasDest.destination_station_name = train_info.source_station_name
--   and (((with dayid (day, id) as (select 'Monday', 1 union select 'Tuesday', 2 union select 'Wednesday', 3 union select 'Thursday', 4 union select 'Friday', 5 union select 'Saturday', 6 union select 'Sunday', 7) select id from dayid where day = train_info.day_of_departure) > (with dayid (day, id) as (select 'Monday', 1 union select 'Tuesday', 2 union select 'Wednesday', 3 union select 'Thursday', 4 union select 'Friday', 5 union select 'Saturday', 6 union select 'Sunday', 7) select id from dayid where day = feasDest.day_of_arrival)) or 
--       (((with dayid (day, id) as (select 'Monday', 1 union select 'Tuesday', 2 union select 'Wednesday', 3 union select 'Thursday', 4 union select 'Friday', 5 union select 'Saturday', 6 union select 'Sunday', 7) select id from dayid where day = train_info.day_of_departure) = (with dayid (day, id) as (select 'Monday', 1 union select 'Tuesday', 2 union select 'Wednesday', 3 union select 'Thursday', 4 union select 'Friday', 5 union select 'Saturday', 6 union select 'Sunday', 7) select id from dayid where day = feasDest.day_of_arrival)) and train_info.departure_time > feasDest.arrival_time))
--   )
-- )
-- select count(*) from (
-- select distinct destination_station_name from feasDest order by destination_station_name
-- ) as t1;

--5--
-- with zero_hopes as
-- (
--   select destination_station_name from train_info
--   where source_station_name = 'CST-MUMBAI' and not (source_station_name = destination_station_name)
-- ),
-- one_hopes as
-- (
--   select train_info.destination_station_name from train_info join zero_hopes
--   on zero_hopes.destination_station_name = train_info.source_station_name
--   and not (zero_hopes.destination_station_name = 'VASHI')
--   and not (train_info.destination_station_name = 'CST-MUMBAI')
--   and not (train_info.source_station_name = train_info.destination_station_name)
-- ),
-- two_hopes as
-- (
--   select train_info.destination_station_name from train_info join one_hopes
--   on one_hopes.destination_station_name = train_info.source_station_name
--   and not (one_hopes.destination_station_name = 'VASHI')
--   and not (train_info.destination_station_name = 'CST-MUMBAI')
--   and not (train_info.source_station_name = train_info.destination_station_name)
-- )
-- select count(destination_station_name) as count from (
--   select destination_station_name from zero_hopes where destination_station_name = 'VASHI'
--   union all
--   select destination_station_name from one_hopes where destination_station_name = 'VASHI'
--   union all 
--   select destination_station_name from two_hopes where destination_station_name = 'VASHI'
-- ) as t;

--6--
-- with RECURSIVE shortest_paths (a, b, dis, tr_cnt) as
-- (
--   (
--     select source_station_name, destination_station_name, min(distance), 1
--     from (
--     select source_station_name, destination_station_name, distance from train_info 
--     ) as t
--     group by source_station_name, destination_station_name
--   )
--   union all
--   (
--     select a, destination_station_name, min(dis), tr_cnt from
--     (
--       select shortest_paths.a, train_info.destination_station_name, dis+train_info.distance as dis, tr_cnt+1 as tr_cnt
--       from train_info join shortest_paths on
--       shortest_paths.b = train_info.source_station_name and
--       not (shortest_paths.a = train_info.destination_station_name) and
--       tr_cnt < 6
--     ) as t1
--     group by a, destination_station_name, tr_cnt
--   )
-- )
-- select b as destination_station_name, a as source_station_name, dis as distance from
-- (
--   select a,b, min(dis) as dis
--   from shortest_paths group by 
--   a,b
-- ) as t2 order by destination_station_name, source_station_name, distance
-- ;

--7--
-- with zero_hops as 
-- (
--   select distinct source_station_name, destination_station_name from train_info
-- ),
-- one_hops as(
--   select distinct z1.source_station_name, z2.destination_station_name from zero_hops as z1 join zero_hops as z2
--   on z1.destination_station_name = z2.source_station_name
-- ),
-- two_hops as(
--   select distinct zero_hopes.source_station_name, one_hopes.destination_station_name from zero_hops join one_hops
--   on zero_hopes.destination_station_name = one_hopes.source_station_name
-- ),
-- three_hops as(
--   select distinct o1.source_station_name, o2.destination_station_name from one_hops as o1 join one_hops as o2
--   on o1.destination_station_name = o2.source_station_name
-- )
-- select source_station_name, destination_station_name from
-- (
--   select * from zero_hops
--   union select * from one_hops
--   union select * from two_hops
--   union select * from three_hops
-- ) as t
-- order by source_station_name, destination_station_name;

--8--
-- with recursive reachable (destination_station_name, day, path) as
-- (
--   (
--     select destination_station_name, day_of_arrival, array[destination_station_name] as path
--     from train_info
--     where source_station_name = 'SHIVAJINAGAR' and
--     day_of_arrival = day_of_departure and
--     not (destination_station_name = 'SHIVAJINAGAR')
--   )
--   union all
--   (
--     select train_info.destination_station_name, train_info.day_of_arrival, reachable.path || train_info.destination_station_name
--     from train_info join reachable on
--     reachable.destination_station_name = train_info.source_station_name and
--     train_info.day_of_arrival = train_info.day_of_departure and
--     train_info.day_of_arrival = reachable.day and
--     not (train_info.destination_station_name = ANY(reachable.path)) and
--     not (train_info.destination_station_name = 'SHIVAJINAGAR')
--   )
-- )
-- select * from reachable;

--9--
-- with recursive reachable (destination_station_name, day, path, distance) as
-- (
--   (
--     select destination_station_name, day_of_arrival, array[destination_station_name] as path, distance
--     from train_info
--     where source_station_name = 'SHIVAJINAGAR' and
--     day_of_arrival = day_of_departure and
--     not (destination_station_name = 'SHIVAJINAGAR')
--   )
--   union all
--   (
--     select train_info.destination_station_name, train_info.day_of_arrival, reachable.path || train_info.destination_station_name, reachable.distance + train_info.distance
--     from train_info join reachable on
--     reachable.destination_station_name = train_info.source_station_name and
--     train_info.day_of_arrival = train_info.day_of_departure and
--     train_info.day_of_arrival = reachable.day and
--     not (train_info.destination_station_name = ANY(reachable.path)) and
--     not (train_info.destination_station_name = 'SHIVAJINAGAR')
--   )
-- ),
-- reachable_min as
-- (
--   select destination_station_name, min(distance) as distance
--   from reachable
--   group by destination_station_name
-- )
-- select reachable_min.destination_station_name, reachable_min.distance, reachable.day
-- from reachable_min, reachable
-- where reachable_min.destination_station_name = reachable.destination_station_name and
-- reachable.distance = reachable_min.distance
-- order by destination_station_name;


--10--

