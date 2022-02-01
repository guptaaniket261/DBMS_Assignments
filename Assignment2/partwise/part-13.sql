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



