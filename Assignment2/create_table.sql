-- CREATE table IF NOT EXISTS train_info(
--   train_no bigint NOT NULL,
--   train_name text,
--   distance bigint,
--   source_station_name text,
--   departure_time time,
--   day_of_departure text,
--   destination_station_name text,
--   arrival_time time,
--   day_of_arrival text,
--   CONSTRAINT info_key PRIMARY KEY (train_no)
-- );

CREATE table IF NOT EXISTS games(
  gameid bigint NOT NULL,
  leagueid bigint,
  hometeamid bigint,
  awayteamid bigint,
  year bigint,
  homegoals bigint,
  awaygoals bigint,
  CONSTRAINT games_key PRIMARY KEY (gameid),
  CONSTRAINT hometeams_ref FOREIGN KEY (hometeamid) references teams(teamid),
  CONSTRAINT awayteams_ref FOREIGN KEY (awayteamid) references teams(teamid)
);

CREATE table IF NOT EXISTS appearances(
  gameid bigint NOT NULL,
  playerid bigint,
  leagueid bigint,
  goals bigint,
  owngoals bigint,
  assists bigint,
  keypasses bigint,
  shots bigint
);

CREATE table IF NOT EXISTS leagues(
  leagueid bigint,
  name text,
  CONSTRAINT leagues_key PRIMARY KEY (leagueid)
);

CREATE table IF NOT EXISTS players(
  playerid bigint,
  name text,
  CONSTRAINT players_key PRIMARY KEY (playerid)
);

CREATE table IF NOT EXISTS teams(
  teamid bigint,
  name text,
  CONSTRAINT teams_key PRIMARY KEY (teamid)
);

