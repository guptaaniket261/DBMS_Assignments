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



