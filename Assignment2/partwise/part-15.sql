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



