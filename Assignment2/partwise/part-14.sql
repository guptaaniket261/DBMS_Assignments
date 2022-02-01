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



