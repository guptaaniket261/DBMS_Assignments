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




