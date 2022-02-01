--1--
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

--4--
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

--5--
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

--6--
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




--7--
with zero_hops as 
(
  select distinct source_station_name, destination_station_name from train_info
),
one_hops as(
  select distinct z1.source_station_name, z2.destination_station_name from zero_hops as z1 join zero_hops as z2
  on z1.destination_station_name = z2.source_station_name
),
two_hops as(
  select distinct zero_hops.source_station_name, one_hops.destination_station_name from zero_hops join one_hops
  on zero_hops.destination_station_name = one_hops.source_station_name
),
three_hops as(
  select distinct o1.source_station_name, o2.destination_station_name from one_hops as o1 join one_hops as o2
  on o1.destination_station_name = o2.source_station_name
)
select source_station_name, destination_station_name from
(
  select source_station_name, destination_station_name from zero_hops where not (source_station_name = destination_station_name)
  union select source_station_name, destination_station_name from one_hops where not (source_station_name = destination_station_name)
  union select source_station_name, destination_station_name from two_hops where not (source_station_name = destination_station_name)
  union select source_station_name, destination_station_name from three_hops where not (source_station_name = destination_station_name)
) as t
order by source_station_name, destination_station_name
;



--8--
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



--9--
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




--10--
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





--11--
with zero_hop as
(
  select source_station_name, destination_station_name from train_info where not(source_station_name = destination_station_name)
),
one_hops as
(
  select z1.source_station_name, z2.destination_station_name from zero_hop z1, zero_hop z2 where z1.destination_station_name = z2.source_station_name
  and not(z1.source_station_name = z2.destination_station_name)
),
temp as
(
  select * from zero_hop union select * from one_hops
),
counts as
(
  select source_station_name, count(distinct destination_station_name) as cnt from temp
  group by source_station_name
),
station_count as
(
  select count(distinct st) as st_count from
  (
  select source_station_name as st from train_info union select destination_station_name as st from train_info
  ) as t
)
select source_station_name from counts where cnt+1 = (select st_count from station_count)
order by source_station_name;






--12--
with opponents as
(
  select distinct awayteamid from games
  where hometeamid = (select teamid from teams where name = 'Arsenal')
),
common_against as
(
  select distinct hometeamid from games where 
  awayteamid in (select awayteamid from opponents) and not(hometeamid = (select teamid from teams where name = 'Arsenal'))
)
select distinct name as teamnames from teams where teams.teamid in (select hometeamid from common_against)
order by teamnames;



--13--
with teamgoals(id, goals) as
(
  select hometeamid, homegoals from games
  union all
  select awayteamid, awaygoals from games
),
totTeamsGoals as
(
  select id as teamid, sum(goals) as goals from teamgoals group by teamid
),
opponents as
(
  select distinct awayteamid from games
  where hometeamid = (select teamid from teams where name = 'Arsenal')
),
common_against as
(
  select hometeamid, year from games where 
  awayteamid in (select awayteamid from opponents) and not(hometeamid = (select teamid from teams where name = 'Arsenal'))
),
first_common_against as
(
  select hometeamid, min(year) as year from common_against group by hometeamid
),
first_common_against_name as
(
  select hometeamid, name, year from first_common_against join teams
  on hometeamid = teamid
),
answer as
(
  select name as teamnames, goals, year from first_common_against_name
  join totTeamsGoals on hometeamid = totTeamsGoals.teamid
)
select teamnames, goals, year from answer where goals = (select max(goals) from answer)
order by goals desc, year asc
;



--14--
with opponents as
(
  select distinct awayteamid from games
  where hometeamid = (select teamid from teams where name = 'Leicester') 
),
common_against as
(
  select distinct hometeamid from games where 
  awayteamid in (select awayteamid from opponents) and not(hometeamid = (select teamid from teams where name = 'Leicester'))
),
matches2015 as
(
  select hometeamid, homegoals - awaygoals as goals from games
  where year = 2015 and hometeamid in (select hometeamid from common_against) and homegoals - awaygoals > 3
)
select distinct name as teamnames, goals from matches2015 join teams on teams.teamid = matches2015.hometeamid
order by goals, teamnames;



--15--
with opponents as
(
  select distinct awayteamid from games
  where hometeamid = (select teamid from teams where name = 'Valencia') 
),
common_against as
(
  select distinct hometeamid from games where 
  awayteamid in (select awayteamid from opponents) and not(hometeamid = (select teamid from teams where name = 'Valencia'))
),
req_matches as
(
  select gameid from games where hometeamid in (select hometeamid from common_against)
),
goal as
(
  select playerid, goals from appearances where gameid in (select gameid from req_matches)
),
tot_goals as
(
  select playerid, sum(goals) as score from goal group by playerid
),
max_tot_goals as
(
  select playerid, score from tot_goals where score = (select max(score) from tot_goals)
)
select name as playernames, score as goals from max_tot_goals join players on max_tot_goals.playerid = players.playerid
order by goals desc , playernames;



--16--
with opponents as
(
  select distinct awayteamid from games
  where hometeamid = (select teamid from teams where name = 'Everton') 
),
common_against as
(
  select distinct hometeamid from games where 
  awayteamid in (select awayteamid from opponents) and not(hometeamid = (select teamid from teams where name = 'Everton'))
),
req_matches as
(
  select gameid from games where hometeamid in (select hometeamid from common_against)
),
assist as
(
  select playerid, assists from appearances where gameid in (select gameid from req_matches)
),
tot_assists as
(
  select playerid, sum(assists) as assistscount from assist group by playerid
),
max_tot_assists as
(
  select playerid, assistscount from tot_assists where assistscount = (select max(assistscount) from tot_assists)
)
select name as playernames, assistscount from max_tot_assists join players on max_tot_assists.playerid = players.playerid
order by assistcount desc, playernames;



--17--
with matches2016 as
(
  select * from games where year = 2016
),
opponents as
(
  select distinct hometeamid from matches2016
  where awayteamid = (select teamid from teams where name = 'AC Milan') 
),
common_against as
(
  select distinct awayteamid from matches2016 where 
  hometeamid in (select hometeamid from opponents) and not(awayteamid = (select teamid from teams where name = 'AC Milan'))
),
req_matches as
(
  select gameid from matches2016 where awayteamid in (select awayteamid from common_against)
),
shot as
(
  select playerid, shots from appearances where gameid in (select gameid from req_matches)
),
tot_shots as
(
  select playerid, sum(shots) as shotscount from shot group by playerid
),
max_tot_shots as
(
  select playerid, shotscount from tot_shots where shotscount = (select max(shotscount) from tot_shots)
)
select name as playernames, shotscount from max_tot_shots join players on max_tot_shots.playerid = players.playerid
order by shotscount desc, playernames;


--18--
with opponents as 
(
  select distinct awayteamid from games where hometeamid = (select teamid from teams where name = 'AC Milan')
),
common_against as 
(
  select distinct hometeamid from games where 
  awayteamid in (select awayteamid from opponents) and not(hometeamid = (select teamid from teams where name = 'AC Milan'))
),
req_goals as
(
  select awayteamid, awaygoals from games where hometeamid in (select hometeamid from common_against) and year = 2020
),
tot_goals as
(
  select awayteamid, sum(awaygoals) as goal from req_goals group by awayteamid
),
req_teams as
(
  select awayteamid from tot_goals where goal = 0
),
answer(teamname, year) as
(
  select name, 2020 from teams join req_teams on req_teams.awayteamid = teams.teamid
)
select * from answer order by teamname limit 5;


--19--
with leagueSc as
(
  select leagueid, hometeamid, sum(homegoals) as score from 
  (
    select leagueid, hometeamid, homegoals from games where year = 2019
  )as t
  group by leagueid, hometeamid
),
leagueMxSc as
(
  select leagueid, max(score) as score from leagueSc group by leagueid
),
leagueChmp as
(
  select leagueSc.leagueid, leagueSc.hometeamid, leagueSc.score from leagueMxSc join leagueSc on
  leagueMxSc.score = leagueSc.score and leagueMxSc.leagueid = leagueSc.leagueid
),
chmp as
(
  select distinct hometeamid from leagueChmp
),
opponents as
(
  select hometeamid, awayteamid from games where hometeamid in (select hometeamid from chmp)
),
common_against as
(
  select distinct opponents.hometeamid, games.hometeamid as ca from games join opponents on games.awayteamid = opponents.awayteamid
),
goal as
(
  select appearances.playerid, games.hometeamid, goals from games join appearances on games.year = 2019 and games.gameid = appearances.gameid and games.hometeamid in (select distinct ca from common_against) 
),
chmp_ca as
(
  select leagueid, leagueChmp.hometeamid, score, ca from leagueChmp join common_against on leagueChmp.hometeamid = common_against.hometeamid 
),
chmp_ca_goals as
(
  select leagueid, goal.hometeamid, score, playerid, goals from chmp_ca join goal on chmp_ca.ca = goal.hometeamid
),
answer as
(
  select leagueid, playerid, hometeamid, score, sum(goals) as playersc from chmp_ca_goals group by 
  leagueid, playerid, hometeamid, score
),
bestAns as
(
  select leagueid,  hometeamid, score, max(playersc) as playersc from answer group by 
  leagueid,  hometeamid, score
),
sol as
(
  select bestAns.leagueid, bestAns.hometeamid, bestAns.score, playerid, playersc from bestAns join chmp_ca_goals on
  chmp_ca_goals.leagueid = bestAns.leagueid and bestAns.hometeamid = chmp_ca_goals.hometeamid 
),
final as
(
  select leagues.name as leaguename, players.name as playernames, playersc as playertopscore, teams.name as teamname, score as teamtopscore
  from sol, leagues, players, teams where 
  leagues.leagueid = sol.leagueid and players.playerid = sol.playerid and teamid = hometeamid
)
select distinct leaguename, playernames, playertopscore, teamname, teamtopscore from final order by playertopscore desc, teamtopscore desc, playernames;




--20--
with recursive path (b, p) as
(
  (
    select distinct awayteamid, array[hometeamid, awayteamid] from games where hometeamid = (select teamid from teams where name = 'Manchester United')
  )
  union 
  (
    select games.awayteamid, path.p || games.awayteamid from games join path on 
    path.b = games.hometeamid and not (games.awayteamid = any(path.p)) and array_length(path.p, 1) < (select count(teamid) from teams)
  )
),
mx_path as
(
  select max(array_length(path.p, 1)) as count from path where b = (select teamid from teams where name = 'Manchester City')
)
select count from mx_path;



--21--
with recursive num_paths(dest, path, len) as
(
  (
    select distinct awayteamid, array[hometeamid, awayteamid], 1 from games where hometeamid = (select teamid from teams where name = 'Manchester United')
  )
  union
  (
    select games.awayteamid, num_paths.path || games.awayteamid, len+1 from games join num_paths on
    num_paths.dest = games.hometeamid and not (games.awayteamid = any(num_paths.path)) and len < (select count(teamid) from teams)
  )
),
path_counts as
(
  select count(dest) as count from num_paths where dest = (select teamid from teams where name = 'Manchester City')
)
select * from path_counts;



--22--
with recursive longPath(lid, s, d, path, len) as
(
  (
    select distinct leagueid, hometeamid, awayteamid, array[hometeamid, awayteamid], 1
    from games
  )
  union
  (
    select lid, s, games.awayteamid, path || games.awayteamid, len +1
    from games join longPath on
    d = games.hometeamid and not (games.awayteamid = any(path)) and len < (select count(teamid) from teams) and games.leagueid = lid
  )
),
leagueLongest as
(
  select lid, max(len) as count from longPath group by lid
),
leagueLongestPath as
(
  select longPath.lid as leagueid, s as teamA, d as teamB, len as count from leagueLongest join longPath on
  longPath.lid = leagueLongest.lid and leagueLongest.count = longPath.len
),
leagueLongestPathLname as
(
  select name as leaguename, teamA, teamB, count from leagueLongestPath join leagues on
  leagues.leagueid = leagueLongestPath.leagueid
),
llpAname as
(
  select leaguename, a1.name as teamAname, a2.name as teamBname, count from leagueLongestPathLname, teams a1, teams a2
  where a1.teamid = teamA and a2.teamid = teamB
)
select * from llpAname order by count desc, teamAname, teamBname, count;




