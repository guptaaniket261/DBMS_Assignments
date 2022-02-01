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


