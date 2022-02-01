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


