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



