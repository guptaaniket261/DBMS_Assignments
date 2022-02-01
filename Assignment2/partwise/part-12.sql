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



