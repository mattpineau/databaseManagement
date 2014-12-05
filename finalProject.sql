--Author: Matt Pineau--
--Date: December 2, 2014--
--Assignment: Final Project--
--Class: Database Management (Alan Labouseur)--

--This is the script for a database contains data 
--about domestic football (soccer) leagues. It creates
--the database, inserts test data, and creates views,
--stored procedures, etc.--

--Start fresh by dropping tables if they exist--

DROP TABLE IF EXISTS player_match_stats;
DROP TABLE IF EXISTS club_match_stats;
DROP TABLE IF EXISTS past_fixtures;
DROP TABLE IF EXISTS future_fixtures;
DROP TABLE IF EXISTS fixtures;
DROP TABLE IF EXISTS seasons;
DROP TABLE IF EXISTS has_managed;
DROP TABLE IF EXISTS plays;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS has_played_for;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS managers;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS clubs;
DROP TYPE IF EXISTS injury_status;
--Create Tables--


CREATE TABLE clubs (
    club_id             integer     NOT NULL,
    club_name           text        NOT NULL,
    stadium             text        NOT NULL,
    nickname            text,
    year_established    integer,
    PRIMARY KEY (club_id)
);

CREATE TABLE seasons (
    season_id   integer     NOT NULL,
    start_date  date        NOT NULL,
    end_date    date        NOT NULL,
    PRIMARY KEY (season_id)
);

CREATE TABLE fixtures (
    fixture_id      integer     NOT NULL,
    season_id       integer     NOT NULL REFERENCES seasons (season_id),
    home_club_id    integer     NOT NULL REFERENCES clubs (club_id),
    away_club_id    integer     NOT NULL REFERENCES clubs (club_id),
    fixture_date    date        NOT NULL,
    start_time_EST  time        NOT NULL,
    PRIMARY KEY (fixture_id)
);

CREATE TABLE past_fixtures (
    fixture_id  integer      NOT NULL REFERENCES fixtures (fixture_id),
    PRIMARY KEY (fixture_id)
);

CREATE TABLE future_fixtures (
    fixture_id  integer      NOT NULL REFERENCES fixtures (fixture_id),
    PRIMARY KEY (fixture_id)
);

CREATE TABLE club_match_stats (
    club_id             integer     NOT NULL REFERENCES clubs (club_id),
    fixture_id          integer     NOT NULL REFERENCES past_fixtures (fixture_id),
    percent_possession  integer     NOT NULL CHECK (percent_possession >= 0 AND percent_possession <= 100),
    num_corners         integer     NOT NULL CHECK (num_corners >= 0),
    num_throw_ins       integer     NOT NULL CHECK (num_throw_ins >= 0),
    num_free_kicks      integer     NOT NULL CHECK (num_free_kicks >= 0),
    PRIMARY KEY (club_id, fixture_id)
);

CREATE TABLE people (
    person_id        integer      NOT NULL,
    first_name       text         NOT NULL,
    last_name        text         NOT NULL,
    nick_name        text,
    dob              date         NOT NULL,
    country_of_birth text         NOT NULL,
    PRIMARY KEY (person_id)
);

CREATE TYPE injury_status AS ENUM ('fit', 'injured');

CREATE TABLE players (
    player_id       integer         NOT NULL REFERENCES people (person_id),
    injury_status   injury_status   NOT NULL DEFAULT 'fit',
    national_team   text,
    height_in       integer         NOT NULL CHECK (height_in > 0),
    weight_lbs      integer         NOT NULL CHECK (weight_lbs > 0),
    PRIMARY KEY (player_id)
);

CREATE TABLE positions (
    position_id   integer   NOT NULL,
    position_name text      NOT NULL,
    PRIMARY KEY (position_id)
);

CREATE TABLE plays (
    player_id   integer     NOT NULL REFERENCES players (player_id),
    position_id integer     NOT NULL REFERENCES positions (position_id),
    PRIMARY KEY (player_id, position_id)
);

CREATE TABLE managers (
    manager_id integer      NOT NULL REFERENCES people (person_id),
    PRIMARY KEY (manager_id)
);

CREATE TABLE has_managed (
    manager_id integer      NOT NULL REFERENCES managers (manager_id),
    club_id    integer      NOT NULL REFERENCES clubs (club_id),
    from_date  date         NOT NULL,
    to_date    date         NOT NULL DEFAULT now(),
    PRIMARY KEY (manager_id, club_id, to_date)
);

CREATE TABLE has_played_for (
    player_id  integer      NOT NULL REFERENCES players (player_id),
    club_id    integer      NOT NULL REFERENCES clubs (club_id),
    from_date  date         NOT NULL,
    to_date    date         NOT NULL DEFAULT now(),
    PRIMARY KEY (player_id, club_id, to_date)
);

CREATE TABLE player_match_stats (
    player_id               integer     NOT NULL REFERENCES players (player_id),
    fixture_id              integer     NOT NULL REFERENCES past_fixtures (fixture_id),
    num_attempted_passes    integer     NOT NULL CHECK (num_attempted_passes >= 0),
    num_completed_passes    integer     NOT NULL CHECK (num_completed_passes >= 0),
    num_shots_on_target     integer     NOT NULL CHECK (num_shots_on_target >= 0),
    num_shots_off_target    integer     NOT NULL CHECK (num_shots_off_target >= 0),
    num_goals               integer     NOT NULL CHECK (num_goals >= 0),
    num_assists             integer     NOT NULL CHECK (num_assists >= 0),
    num_crosses             integer     NOT NULL CHECK (num_crosses >= 0),
    num_fouls_committed     integer     NOT NULL CHECK (num_fouls_committed >= 0),
    num_yellow_cards        integer     NOT NULL CHECK (num_yellow_cards >= 0),
    num_red_cards           integer     NOT NULL CHECK (num_red_cards >= 0),
    num_saves               integer     NOT NULL CHECK (num_saves >= 0),
    bool_started            boolean     NOT NULL,
    PRIMARY KEY (player_id, fixture_id)
);


--Populate tables with sample data--

INSERT INTO clubs (club_id, club_name, stadium, nickname, year_established)
VALUES (1, 'Liverpool FC', 'Anfield', 'The Reds', 1882),
       (2, 'Chelsea FC', 'Stamford Bridge', 'The Blues', 1905),
       (3, 'Swansea City AFC', 'Liberty Stadium', 'The Swans', 1912),
       (4, 'Manchester United FC', 'Old Trafford', 'The Red Devils', 1878),
       (5, 'Southampton FC', 'St. Mary''s Stadium', 'The Saints', 1885),
       (6, 'Tottenham Hotspur FC', 'White Heart Lane', 'Spurs', 1882);
       

INSERT INTO seasons (season_id, start_date, end_date)
VALUES (1, '2013-08-16', '2014-05-24'),
       (2, '2014-08-16', '2015-05-24');

INSERT INTO fixtures (fixture_id, season_id, home_club_id, away_club_id, fixture_date, start_time_EST)
VALUES (1, 1, 1, 2, '2013-08-24', '144500'),
       (2, 1, 2, 3, '2013-09-01', '073000'),
       (3, 1, 3, 4, '2014-02-28', '124500'),
       (4, 1, 4, 5, '2014-05-24', '144500'),
       (5, 1, 5, 6, '2013-12-12', '080000'),
       (6, 1, 6, 1, '2013-12-26', '124500'),
       (7, 1, 1, 4, '2014-03-14', '073000'),
       (8, 1, 2, 5, '2014-04-18', '080000'),
       (9, 1, 3, 6, '2014-05-23', '070000'),
       (10, 2, 4, 2, '2014-08-16', '073000'),
       (11, 2, 5, 1, '2014-08-16', '144500'),
       (12, 2, 6, 3, '2014-12-26', '083000'),
       (13, 2, 1, 4, '2015-03-14', '123000'),
       (14, 2, 2, 3, '2014-11-30', '100000'),
       (15, 2, 3, 1, '2014-07-16', '104500'),
       (16, 2, 4, 5, '2015-05-24', '080000'),
       (17, 2, 5, 6, '2015-04-21', '073000'),
       (18, 2, 6, 2, '2015-01-13', '064500');

INSERT INTO past_fixtures (fixture_id)
VALUES (1),
       (2),
       (3),
       (4),
       (5),
       (6),
       (7),
       (8),
       (9),
       (10),
       (11),
       (14),
       (15);

INSERT INTO future_fixtures (fixture_id)
VALUES (12),
       (13),
       (16),
       (17),
       (18);

INSERT INTO club_match_stats (club_id, fixture_id, percent_possession, num_corners, num_throw_ins, num_free_kicks)
VALUES (1, 1, 55, 4, 20, 8),
       (2, 1, 45, 3, 17, 16),
       (2, 2, 51, 6, 16, 20),
       (3, 2, 49, 1, 22, 10),
       (3, 3, 60, 5, 15, 15),
       (4, 3, 40, 5, 20, 14),
       (4, 4, 52, 8, 25, 5),
       (5, 4, 68, 5, 19, 8),
       (5, 5, 55, 4, 22, 9),
       (6, 5, 45, 1, 22, 4),
       (6, 6, 41, 0, 20, 12),
       (1, 6, 59, 6, 21, 14),
       (1, 7, 67, 2, 15, 14),
       (4, 7, 33, 2, 17, 16),
       (2, 8, 50, 8, 17, 12),
       (5, 8, 50, 5, 20, 12),
       (3, 9, 44, 4, 21, 7),
       (6, 9, 66, 4, 14, 6),
       (4, 10, 53, 3, 30, 6),
       (2, 10, 47, 2, 12, 9),
       (5, 11, 47, 1, 14, 9),
       (1, 11, 53, 6, 15, 9),
       (2, 14, 70, 7, 17, 0),
       (3, 14, 30, 4, 17, 15),
       (3, 15, 51, 8, 20, 12),
       (1, 15, 49, 7, 22, 10);
   
INSERT INTO people (person_id, first_name, last_name, nick_name, dob, country_of_birth)
VALUES (1, 'Brendan', 'Rodgers', DEFAULT, '1973-01-26', 'Northern Ireland'),
       (2, 'Jose', 'Mourinho', DEFAULT, '1963-01-26', 'Portugal'),
       (3, 'Mauricio', 'Pochettino', DEFAULT, '1972-03-02', 'Argentina'),
       (4, 'Ronald', 'Koeman', DEFAULT, '1963-03-21', 'Netherlands'),
       (5, 'Garry', 'Monk', DEFAULT, '1979-03-06', 'England'),
       (6, 'Louis', 'van Gaal', DEFAULT, '1951-08-08', 'Netherlands'),
       (7, 'Simon', 'Mignolet', DEFAULT, '1988-03-06', 'Belgium'),
       (8, 'Steven', 'Gerrard', DEFAULT, '1980-05-30', 'England'),
       (9, 'Adam', 'Lallana', DEFAULT, '1988-05-10', 'England'),
       (10, 'Joe', 'Allen', DEFAULT, '1990-03-14', 'Wales'),
       (11, 'Daniel', 'Sturridge', DEFAULT, '1989-09-01', 'England'),
       (12, 'Thibaut', 'Courtois', DEFAULT, '1992-05-11', 'Belgium'),
       (13, 'Eden', 'Hazard', DEFAULT, '1991-01-07', 'Belgium'),
       (14, 'Didier', 'Drogba', DEFAULT, '1978-03-11', 'Ivory Coast'),
       (15, 'Cesc', 'Fabregas', DEFAULT, '1987-05-04', 'Spain'),
       (16, 'Willian', 'da Silva', 'Willian', '1988-08-09', 'Brazil'),
       (17, 'David', 'De Gea', DEFAULT, '1990-11-07', 'Spain'),
       (18, 'Wayne', 'Rooney', DEFAULT, '1985-10-24', 'England'),
       (19, 'Angel', 'Di Maria', DEFAULT, '1988-02-14', 'Argentina'),
       (20, 'Juan', 'Mata', DEFAULT, '1988-04-28', 'Spain'),
       (21, 'Marcos', 'Rojo', DEFAULT, '1990-03-20', 'Argentina'),
       (22, 'Erik', 'Lamela', DEFAULT, '1992-03-04', 'Argentina'),
       (23, 'Jan', 'Vertonghen', DEFAULT, '1987-04-24', 'Belgium'),
       (24, 'Hugo', 'Lloris', DEFAULT, '1986-12-26', 'France'),
       (25, 'Christian', 'Eriksen', DEFAULT, '1992-02-14', 'Denmark'),
       (26, 'Roberto', 'Soldado', DEFAULT, '1985-05-27', 'Spain'),
       (27, 'Lukasz', 'Fabianski', DEFAULT, '1985-04-18', 'Poland'),
       (28, 'Ashley', 'Williams', DEFAULT, '1984-08-23', 'England'),
       (29, 'Gylfi', 'Sigurdsson', DEFAULT, '1989-09-08', 'Iceland'),
       (30, 'Nathan', 'Dyer', DEFAULT, '1989-11-29', 'England'),
       (31, 'Wilfried', 'Bony', DEFAULT, '1988-12-10', 'Ivory Coast'),
       (32, 'Fraser', 'Foster', DEFAULT, '1988-03-17', 'England'),
       (33, 'Jay', 'Rodriguez', DEFAULT, '1989-07-29', 'England'),
       (34, 'Morgan', 'Schneiderlin', DEFAULT, '1989-11-08', 'France'),
       (35, 'Dusan', 'Tadic', DEFAULT, '1988-11-20', 'Serbia'),
       (36, 'Toby', 'Alderweireld', DEFAULT, '1989-03-02', 'Belgium');

INSERT INTO players (player_id, injury_status, national_team, height_in, weight_lbs)
VALUES (7, DEFAULT, 'Belgium', 77, 202),
       (8, DEFAULT, 'England', 72, 183),
       (9, DEFAULT, 'England', 69, 175),
       (10, DEFAULT, 'Wales', 66, 160),
       (11, 'injured', 'England', 73, 188),
       (12, DEFAULT, 'Belgium', 79, 205),
       (13, DEFAULT, 'Belgium', 67, 160),
       (14, DEFAULT, DEFAULT, 74, 190),
       (15, DEFAULT, 'Spain', 70, 177),
       (16, DEFAULT, 'Brazil', 68, 169),
       (17, DEFAULT, DEFAULT, 78, 190),
       (18, DEFAULT, 'England', 66, 185),
       (19, DEFAULT, 'Argentina', 68, 176),
       (20, DEFAULT, 'Spain', 66, 160),
       (21, DEFAULT, 'Argentina', 73, 189),
       (22, 'injured', 'Argentina', 68, 159),
       (23, DEFAULT, 'Belgium', 73, 195),
       (24, DEFAULT, 'France', 76, 210),
       (25, DEFAULT, 'Denmark', 71, 180),
       (26, DEFAULT, 'Spain', 74, 175),
       (27, DEFAULT, 'Poland', 75, 210),
       (28, DEFAULT, 'Wales', 74, 201),
       (29, DEFAULT, 'Iceland', 72, 190),
       (30, DEFAULT, DEFAULT, 70, 181),
       (31, DEFAULT, 'Ivory Coast', 74, 200),
       (32, DEFAULT, 'England', 74, 195),
       (33, DEFAULT, 'England', 69, 174),
       (34, DEFAULT, 'France', 70, 187),
       (35, DEFAULT, 'Serbia', 68, 159),
       (36, 'injured', 'Belgium', 75, 204);

INSERT INTO positions (position_id, position_name)
VALUES (1, 'Forward'),
       (2, 'Midfielder'),
       (3, 'Defender'),
       (4, 'Goalkeeper');

INSERT INTO plays (player_id, position_id)
VALUES (7, 4),
       (8, 2),
       (9, 2),
       (10, 2),
       (11, 1),
       (12, 4),
       (13, 1),
       (13, 2),
       (14, 1),
       (15, 2),
       (16, 1),
       (16, 2),
       (17, 4),
       (18, 1),
       (18, 2),
       (19, 1),
       (19, 2),
       (20, 2),
       (21, 3),
       (22, 2),
       (22, 1),
       (23, 3),
       (24, 4),
       (25, 2),
       (26, 1),
       (27, 4),
       (28, 3),
       (29, 2),
       (30, 2),
       (31, 1),
       (32, 4),
       (33, 1),
       (33, 2),
       (34, 2),
       (35, 2),
       (36, 3);

INSERT INTO managers (manager_id)
VALUES (1),
       (2),
       (3),
       (4),
       (5),
       (6);

INSERT INTO has_managed (manager_id, club_id, from_date, to_date)
VALUES (1, 1, '2012-08-16', DEFAULT),
       (1, 3, '2010-08-16', '2012-05-24'),
       (2, 2, '2004-08-16', '2007-05-24'),
       (2, 2, '2013-05-16', DEFAULT),
       (3, 5, '2013-08-16', '2014-05-24'),
       (3, 6, '2014-08-16', DEFAULT),
       (4, 4, '2014-08-16', DEFAULT),
       (5, 5, '2014-08-16', DEFAULT),
       (6, 6, '2014-08-16', DEFAULT);

INSERT INTO has_played_for (player_id, club_id, from_date, to_date)
VALUES (7, 1, '2013-08-16', DEFAULT),
       (8, 1, '1998-08-16', DEFAULT),
       (9, 1, '2014-08-16', DEFAULT),
       (10, 1, '2013-08-16', DEFAULT),
       (11, 1, '2013-08-16', DEFAULT),
       (12, 2, '2013-08-16', DEFAULT),
       (13, 2, '2012-08-16', DEFAULT),
       (14, 2, '2014-08-16', DEFAULT),
       (15, 2, '2014-08-16', DEFAULT),
       (16, 2, '2013-08-16', DEFAULT),
       (17, 4, '2011-08-16', DEFAULT),
       (18, 4, '2008-08-16', DEFAULT),
       (19, 4, '2014-08-16', DEFAULT),
       (20, 4, '2014-01-02', DEFAULT),
       (21, 4, '2014-08-16', DEFAULT),
       (22, 6, '2012-08-16', DEFAULT),
       (23, 6, '2010-08-16', DEFAULT),
       (24, 6, '2011-08-16', DEFAULT),
       (25, 6, '2013-08-16', DEFAULT),
       (26, 6, '2013-08-16', DEFAULT),
       (27, 3, '2010-08-16', DEFAULT),
       (28, 3, '2010-08-16', DEFAULT),
       (29, 3, '2014-08-16', DEFAULT),
       (30, 3, '2009-08-16', DEFAULT),
       (31, 3, '2011-08-16', DEFAULT),
       (32, 5, '2009-08-16', DEFAULT),
       (33, 5, '2011-08-16', DEFAULT),
       (34, 5, '2012-08-16', DEFAULT),
       (35, 5, '2014-08-16', DEFAULT),
       (36, 5, '2014-08-16', DEFAULT),
       (14, 2, '2004-08-16', '2012-05-24'),
       (29, 6, '2012-08-16', '2014-05-24'),
       (11, 2, '2009-08-16', '2013-05-24'),
       (20, 2, '2011-08-16', '2014-01-01'),
       (9, 5, '2006-08-16', '2014-05-24'),
       (10, 3, '2007-08-16', '2012-05-24');

INSERT INTO player_match_stats (player_id, fixture_id, num_attempted_passes, num_completed_passes, num_shots_on_target, num_shots_off_target, num_goals, num_assists, num_crosses, num_fouls_committed, num_yellow_cards, num_red_cards, num_saves, bool_started)
VALUES (7, 1, 10, 7, 0, 0, 0, 0, 0, 0, 0, 0, 6, true),
       (8, 1, 25, 23, 2, 2, 1, 1, 4, 1, 0, 0, 0, true),
       (9, 1, 20, 19, 2, 1, 0, 1, 3, 2, 0, 0, 0, true),
       (10, 1, 15, 14, 0, 3, 0, 0, 4, 4, 1, 0, 0, false),
       (11, 1, 17, 15, 2, 0, 2, 1, 0, 0, 0, 0, 0, true),
       (12, 1, 7, 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, true),
       (13, 1, 22, 18, 2, 1, 1, 0, 5, 2, 0, 0, 0, true),
       (15, 1, 25, 22, 0, 5, 0, 1, 3, 3, 1, 0, 0, true),
       (16, 1, 20, 19, 1, 4, 0, 0, 3, 1, 1, 0, 0, true),
       (12, 2, 5, 4, 0, 0, 0, 0, 0, 0, 0, 0, 7, true),
       (13, 2, 31, 27, 3, 3, 2, 1, 3, 2, 0, 0, 0, true),
       (14, 2, 20, 15, 1, 1, 1, 1, 2, 2, 0, 0, 0, true),
       (16, 2, 19, 18, 2, 3, 0, 0, 0, 4, 3, 2, 1, true),
       (17, 2, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 1, true),
       (18, 2, 27, 22, 3, 5, 2, 1, 3, 0, 0, 0, 0, true),
       (19, 2, 27, 24, 0, 3, 0, 1, 4, 2, 0, 0, 0, true),
       (20, 2, 21, 18, 1, 2, 1, 0, 1, 1, 1, 0, 0, true),
       (17, 3, 10, 10, 0, 0, 0, 0, 0, 1, 1, 0, 5, true),
       (18, 3, 23, 22, 0, 1, 0, 1, 3, 2, 0, 0, 0, true),
       (19, 3, 32, 25, 1, 0, 1, 0, 5, 3, 1, 0, 0, true),
       (21, 3, 30, 28, 2, 2, 0, 0, 3, 3, 0, 0, 0, true),
       (24, 3, 12, 9, 0, 0, 0, 0, 0, 0, 0, 0, 7, true),
       (22, 3, 25, 25, 1, 0, 0, 1, 3, 2, 0, 0, 0, true),
       (23, 3, 28, 25, 1, 1, 1, 0, 2, 1, 0, 0, 0, true),
       (26, 3, 30, 21, 1, 1, 0, 0, 7, 1, 1, 0, 0, true),
       (24, 4, 7, 6, 0, 0, 0, 0, 0, 1, 1, 0, 4, true),
       (23, 4, 32, 30, 1, 1, 1, 1, 1, 1, 1, 0, 0, true),
       (25, 4, 22, 20, 1, 1, 1, 1, 3, 3, 0, 0, 0, true),
       (26, 4, 25, 20, 2, 1, 0, 0, 5, 2, 1, 0, 0, true),
       (27, 4, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 3, true),
       (28, 4, 22, 21, 4, 1, 3, 1, 2, 0, 0, 0, 0, true),
       (29, 4, 30, 25, 2, 0, 1, 1, 4, 0, 0, 0, 0, true),
       (30, 4, 21, 21, 1, 1, 0, 1, 2, 2, 1, 0, 0, true),
       (31, 4, 14, 13, 0, 0, 0, 0, 0, 2, 1, 0, 0, false),
       (27, 5, 5, 4, 0, 0, 0, 0, 0, 1, 0, 0, 5, true),
       (28, 5, 20, 19, 1, 0, 1, 1, 2, 1, 0, 0, 0, false),
       (29, 5, 35, 30, 2, 3, 1, 1, 2, 0, 0, 0, 0, true),
       (30, 5, 33, 30, 0, 0, 0, 0, 5, 2, 2, 1, 0, true),
       (31, 5, 22, 19, 0, 3, 0, 0, 3, 0, 0, 0, 0, true),
       (32, 5, 15, 13, 0, 0, 0, 0, 0, 0, 0, 0, 3, true),
       (33, 5, 22, 20, 2, 1, 2, 1, 4, 2, 1, 0, 0, true),
       (34, 5, 19, 15, 2, 2, 0, 1, 5, 2, 0, 0, 0, true),
       (35, 5, 11, 11, 1, 0, 1, 0, 3, 0, 0, 0, 0, false),
       (36, 5, 25, 23, 0, 0, 0, 0, 6, 3, 1, 0, 0, true),
       (32, 6, 13, 11, 0, 0, 0, 0, 0, 0, 0, 0, 11, true),
       (33, 6, 25, 20, 0, 1, 0, 1, 2, 2, 0, 0, 0, true),
       (34, 6, 30, 22, 1, 1, 0, 0, 3, 2, 1, 0, 0, true),
       (36, 6, 22, 21, 1, 1, 1, 0, 2, 1, 1, 0, 0, true),
       (7, 6, 11, 7, 0, 0, 0, 0, 0, 2, 1, 0, 3, true),
       (8, 6, 33, 32, 1, 1, 1, 2, 7, 2, 0, 0, 0, true),
       (9, 6, 30, 28, 1, 0, 1, 1, 7, 2, 0, 0, 0, true),
       (11, 6, 19, 15, 3, 1, 1, 0, 3, 1, 1, 0, 0, true),
       (7, 7, 9, 9, 0, 0, 0, 0, 0, 1, 1, 0, 7, true),
       (8, 7, 21, 21, 1, 4, 0, 0, 2, 0, 0, 0, 0, true),
       (9, 7, 31, 29, 2, 2, 0, 0, 2, 3, 1, 0, 0, true),
       (10, 7, 30, 27, 1, 5, 0, 0, 1, 2, 0, 0, 0, true),
       (22, 7, 19, 19, 1, 1, 1, 0, 0, 1, 0, 1, 0, true),
       (23, 7, 27, 24, 0, 0, 0, 0, 1, 0, 2, 0, 0, true),
       (24, 7, 12, 11, 0, 0, 0, 0, 0, 0, 0, 0, 8, true),
       (25, 7, 29, 24, 2, 2, 0, 0, 2, 0, 0, 0, 0, true),
       (12, 8, 11, 11, 0, 0, 0, 0, 0, 0, 0, 0, 8, true),
       (13, 8, 30, 25, 2, 2, 1, 0, 4, 2, 0, 0, 0, true),
       (14, 8, 30, 26, 1, 4, 0, 1, 9, 2, 0, 0, 0, true),
       (15, 8, 25, 22, 1, 0, 1, 0, 2, 4, 1, 0, 0, true),
       (27, 8, 14, 10, 0, 0, 0, 0, 0, 1, 1, 0, 10, true),
       (29, 8, 29, 28, 3, 5, 2, 1, 1, 3, 1, 0, 0, true),
       (30, 8, 27, 25, 2, 2, 1, 1, 0, 3, 0, 0, 0, true),
       (31, 8, 32, 28, 0, 0, 0, 0, 1, 0, 0, 0, 0, true),
       (17, 9, 9, 9, 0, 0, 0, 0, 0, 1, 0, 0, 5, true),
       (18, 9, 39, 2, 2, 6, 1, 0, 2, 1, 0, 0, 0, true),
       (19, 9, 33, 1, 1, 2, 1, 1, 4, 2, 1, 0, 0, true),
       (20, 9, 30, 27, 0, 0, 0, 2, 3, 4, 1, 0, 0, true),
       (32, 9, 12, 12, 0, 0, 0, 0, 0, 0, 0, 0, 5, true),
       (33, 9, 22, 21, 1, 1, 0, 0, 3, 1, 1, 0, 0, true),
       (35, 9, 29, 25, 3, 0, 2, 0, 3, 2, 0, 0, 0, true),
       (36, 9, 32, 30, 2, 0, 0, 1, 1, 1, 0, 0, 0, true),
       (23, 10, 27, 27, 1, 2, 0, 1, 1, 3, 0, 0, 0, true),
       (24, 10, 5, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2, true),
       (25, 10, 27, 24, 1, 3, 0, 1, 5, 0, 0, 0, 0, true),
       (26, 10, 30, 19, 1, 5, 1, 0, 0, 4, 1, 0, 0, true),
       (12, 10, 15, 12, 0, 0, 0, 0, 0, 0, 0, 0, 10, true),
       (13, 10, 19, 19, 1, 5, 0, 3, 0, 2, 1, 0, 0, true),
       (15, 10, 27, 24, 4, 1, 3, 1, 0, 4, 2, 0, 1, true),
       (16, 10, 22, 22, 2, 1, 1, 0, 2, 0, 0, 0, 0, true),
       (27, 11, 5, 5, 0, 0, 0, 0, 0, 1, 1, 0, 1, true),
       (28, 11, 22, 21, 0, 0, 0, 0, 1, 0, 0, 0, 0, true),
       (29, 11, 30, 30, 1, 0, 1, 1, 2, 4, 0, 0, 0, true),
       (31, 11, 24, 20, 1, 3, 1, 1, 2, 1, 1, 0, 0, true),
       (7, 11, 10, 7, 0, 0, 0, 0, 0, 0, 0, 0, 8, true),
       (8, 11, 19, 18, 4, 2, 1, 2, 2, 1, 1, 0, 0, true),
       (9, 11, 25, 22, 1, 1, 1, 1, 1, 3, 0, 0, 0, true),
       (10, 11, 30, 25, 3, 0, 1, 0, 0, 4, 0, 0, 0, true),
       (11, 11, 22, 19, 0, 2, 0, 0, 0, 2, 1, 0, 0, false),
       (12, 14, 20, 15, 0, 0, 0, 0, 0, 0, 0, 0, 2, true),
       (13, 14, 30, 28, 0, 3, 0, 2, 5, 1, 1, 0, 0, true),
       (14, 14, 22, 19, 4, 1, 2, 0, 4, 5, 1, 0, 0, true),
       (15, 14, 20, 18, 1, 1, 1, 0, 2, 1, 0, 0, 0, true),
       (17, 14, 13, 11, 0, 0, 0, 0, 0, 0, 0, 0, 6, true),
       (18, 14, 39, 33, 3, 6, 2, 2, 2, 0, 0, 0, 0, true),
       (19, 14, 37, 29, 3, 2, 2, 2, 0, 2, 0, 0, 0, true),
       (21, 14, 28, 25, 0, 0, 0, 0, 1, 1, 1, 0, 0, true),
       (20, 14, 20, 16, 0, 0, 0, 0, 1, 1, 1, 0, 0, false),
       (17, 15, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 4, true),
       (18, 15, 19, 18, 1, 1, 0, 0, 3, 5, 1, 0, 0, true),
       (20, 15, 27, 25, 0, 3, 0, 0, 8, 5, 0, 0, 0, true),
       (21, 15, 28, 20, 1, 2, 0, 0, 3, 0, 0, 0, 0, true),
       (7, 15, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 4, true),
       (8, 15, 30, 30, 3, 0, 0, 3, 3, 2, 1, 0, 0, true),
       (10, 15, 25, 24, 2, 5, 1, 0, 1, 3, 0, 0, 0, true),
       (11, 15, 18, 14, 4, 1, 2, 0, 2, 0, 0, 0, 0, true);

--Create Some Views--


CREATE VIEW career_leading_scorers
AS
SELECT people.first_name, people.last_name, SUM(player_match_stats.num_goals) AS goals
FROM people
INNER JOIN players
ON people.person_id = players.player_id
INNER JOIN player_match_stats
ON players.player_id = player_match_stats.player_id
GROUP BY people.first_name, people.last_name
ORDER BY goals DESC;



CREATE VIEW season_leading_scorers
AS
SELECT people.first_name, people.last_name, SUM(player_match_stats.num_goals) AS goals
FROM people
INNER JOIN players
ON people.person_id = players.player_id
INNER JOIN player_match_stats
ON players.player_id = player_match_stats.player_id
INNER JOIN past_fixtures
ON player_match_stats.fixture_id = past_fixtures.fixture_id
INNER JOIN fixtures
ON past_fixtures.fixture_id = fixtures.fixture_id
INNER JOIN seasons
ON fixtures.season_id = seasons.season_id
WHERE now() >= seasons.start_date AND now()<= seasons.end_date
GROUP BY people.first_name, people.last_name
ORDER BY goals DESC;

CREATE VIEW current_players
AS
SELECT clubs.club_name as current_club, people.first_name, people.last_name
FROM clubs
INNER JOIN has_played_for
ON clubs.club_id = has_played_for.club_id
INNER JOIN players
ON has_played_for.player_id = players.player_id
INNER JOIN people
ON players.player_id = people.person_id
WHERE has_played_for.to_date in (SELECT max(has_played_for.to_date)
                                        FROM has_played_for)
GROUP BY clubs.club_name, people.first_name, people.last_name, clubs.club_id
ORDER BY clubs.club_id;


CREATE VIEW best_career_passers
AS
SELECT people.first_name fname, people.last_name lname,         floor(cast(SUM(player_match_stats.num_completed_passes) as float)/cast(SUM(player_match_stats.num_attempted_passes) as float)*100) passPerc
FROM people
INNER JOIN players
ON people.person_id = players.player_id
INNER JOIN player_match_stats
ON players.player_id = player_match_stats.player_id
GROUP BY people.first_name, people.last_name
ORDER BY passPerc DESC;


-------------------COOL/USEFUL QUERIES--------------------

SELECT extract(year from seasons.start_date) AS "Start Year", extract(year from seasons.end_date) AS "End Year"
FROM seasons
WHERE now() > seasons.end_date;


SELECT people.first_name, people.last_name, people.dob, players.national_team, players.height_in, players.weight_lbs
FROM people
INNER JOIN players
ON people.person_id= players.player_id;
ORDER BY people.last_name ASC;


SELECT people.first_name, people.last_name, people.dob
FROM people
INNER JOIN managers
ON people.person_id = managers.manager_id
ORDER BY people.last_name ASC;

----------------STORED PROCEDURES----------------------


CREATE OR REPLACE FUNCTION getPlayersByPosition(pos text)
RETURNS TABLE("First Name" text, "Last Name" text, "Position" text)
AS
$$
BEGIN
RETURN QUERY
SELECT people.first_name AS "First Name", people.last_name AS "Last Name", positions.position_name AS "Position"
FROM people
INNER JOIN players
ON people.person_id = players.player_id
INNER JOIN plays
ON players.player_id = plays.player_id
INNER JOIN positions
ON plays.position_id = positions.position_id
WHERE positions.position_name = pos
GROUP BY people.first_name, people.last_name, positions.position_name
ORDER BY people.last_name;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getClubRoster(club text)
RETURNS TABLE("Club" text, "First Name" text, "Last Name" text)
AS
$$
BEGIN
RETURN QUERY
SELECT clubs.club_name AS "Club", people.first_name AS "First Name", people.last_name AS "Last Name"
FROM people
INNER JOIN players
ON people.person_id = players.player_id
INNER JOIN has_played_for
ON players.player_id = has_played_for.player_id
INNER JOIN clubs
ON has_played_for.club_id = clubs.club_id
WHERE club = clubs.club_name AND has_played_for.to_date in (SELECT max(has_played_for.to_date)
							                                FROM has_played_for)
GROUP BY clubs.club_name, people.first_name, people.last_name
ORDER BY people.last_name ASC;
END;
$$
LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION matchOnDate(whatDate date)
RETURNS TABLE("Date" date, "Time" time, "Home Team" text)
AS
$$
BEGIN
RETURN QUERY
SELECT fixtures.fixture_date AS "Date", fixtures.start_time_EST AS "Time", clubs.club_name AS "Home Team"
FROM fixtures
INNER JOIN clubs
ON fixtures.home_club_id = clubs.club_id
WHERE whatDate = fixtures.fixture_date
GROUP BY fixtures.fixture_date, fixtures.start_time_EST, clubs.club_name
ORDER BY fixtures.start_time_EST ASC;
END;
$$
LANGUAGE plpgsql;


--------------------SECURITY-------------------------

CREATE ROLE databaseAdmin;
GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA PUBLIC
TO databaseAdmin;

CREATE ROLE generalAdmin;
GRANT INSERT, UPDATE, SELECT
ON ALL TABLES IN SCHEMA PUBLIC
TO generalAdmin;

CREATE ROLE publicUser;
GRANT SELECT
ON ALL TABLES IN SCHEMA PUBLIC
TO publicUser


