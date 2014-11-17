--Start fresh by dropping necessary tables if they exist--

DROP TABLE IF EXISTS eligibilities;
DROP TABLE IF EXISTS ac_positions;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS assistant_coaches;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS head_coaches;
DROP TABLE IF EXISTS age_groups;
DROP TABLE IF EXISTS ac_rosters;
DROP TABLE IF EXISTS coaches;
DROP TABLE IF EXISTS people;

--Now create the tables--

CREATE TABLE people (
    pid         varchar(4) not null,
    first_name  text,
    last_name   text,
    address     text,
    dob         date not null,
    primary key (pid)
);

CREATE TABLE age_groups (
    ag_id               varchar(4) not null,
    age_range_start     int not null unique,
    age_range_end       int not null unique,
    primary key         (ag_id)
);

CREATE TABLE coaches (
    cid                varchar(4) not null references people(pid),
    num_years_coaching int,
    primary key        (cid)
);

CREATE TABLE eligibilities (
    cid         varchar(4) not null references coaches(cid),
    ag_id       varchar(4) not null references age_groups(ag_id),
    primary key (cid, ag_id)
);

CREATE TABLE head_coaches (
    hc_id       varchar(4) not null references coaches(cid),
    primary key (hc_id)
);

CREATE TABLE assistant_coaches (
    ac_id       varchar(4) not null references coaches(cid),
    primary key (ac_id)
);

CREATE TABLE ac_rosters (
    ac_roster_id    varchar(4) not null,
    primary key     (ac_roster_id)
);

CREATE TABLE ac_positions (
    ac_id           varchar(4) not null references assistant_coaches(ac_id),
    ac_roster_id    varchar(4) not null references ac_rosters(ac_roster_id),
    primary key     (ac_id, ac_roster_id)
);

CREATE TABLE teams (
    tid             varchar(4) not null,
    ag_id           varchar(4) not null references age_groups(ag_id),
    ac_roster_id    varchar(4) not null references ac_rosters(ac_roster_id),
    hc_id           varchar(4) not null references head_coaches(hc_id),
    primary key     (tid)
);

CREATE TABLE players (
    pl_id           varchar(4) not null references people(pid),
    ag_id           varchar(4) not null references age_groups(ag_id),
    tid             varchar(4) not null references teams(tid),
    primary key (pl_id)
);



--Start populating these tables--

INSERT INTO people (pid, first_name, last_name, dob)
    VALUES ('p001', 'Matthew', 'Pineau', '1994-07-16'),
           ('p002', 'Pablo', 'Sanchez', '2002-08-22'),
           ('p003', 'Pete', 'Wheeler', '2003-02-02'),
           ('p004', 'Mikal', 'Post', '1994-03-09'),
           ('p005', 'Spongebob', 'Squarepants', '2005-11-17'),
           ('p006', 'Douglas', 'Pineau', '1999-02-17'),
           ('p007', 'Steve', 'Harvey', '1959-01-17'),
           ('p008', 'Terry', 'Francona', '1959-04-22'),
           ('p009', 'Daniel', 'Craig', '1968-03-02'),
           ('p010', 'Joseph', 'Smith', '1999-01-01'),
           ('p011', 'Davey', 'Ortiz', '2009-04-30'),
           ('p012', 'Austin', 'Powers', '2000-09-09'),
           ('p013', 'Mini', 'Me', '2002-08-29');

INSERT INTO age_groups (ag_id, age_range_start, age_range_end)
    VALUES ('ag01', 0, 9),
           ('ag02', 10, 14),
           ('ag03', 15, 18);

INSERT INTO coaches (cid, num_years_coaching)
    VALUES ('p001', 2),
           ('p004', 2),
           ('p007', 10),
           ('p008', 15),
           ('p009', 1);

INSERT INTO head_coaches (hc_id)
    VALUES ('p001'),
           ('p004'),
           ('p007'),
           ('p009');

INSERT INTO assistant_coaches (ac_id)
    VALUES ('p004'),
           ('p007'),
           ('p008'),
           ('p009');

INSERT INTO ac_rosters (ac_roster_id)
    VALUES ('acr1'),
           ('acr2'),
           ('acr3'),
           ('acr4'),
           ('acr5');

INSERT INTO ac_positions (ac_id, ac_roster_id)
    VALUES  ('p004', 'acr3'),
            ('p008', 'acr3'),
            ('p008', 'acr1'),
            ('p009', 'acr2'),
            ('p008', 'acr4'),
            ('p007', 'acr1');

INSERT INTO teams (tid, ag_id, ac_roster_id, hc_id)
    VALUES ('t001', 'ag01', 'acr1', 'p001'),
           ('t002', 'ag02', 'acr2', 'p004'),
           ('t003', 'ag03', 'acr3', 'p007'),
           ('t004', 'ag02', 'acr4', 'p007'),
           ('t005', 'ag03', 'acr5', 'p009');

INSERT INTO players (pl_id, ag_id, tid)
    VALUES ('p002', 'ag02', 't002'),
           ('p003', 'ag02', 't002'),
           ('p005', 'ag01', 't001'),
           ('p006', 'ag03', 't003'),
           ('p010', 'ag03', 't005'),
           ('p012', 'ag02', 't004'),
           ('p011', 'ag02', 't004'),
           ('p013', 'ag02', 't002');

INSERT INTO eligibilities (cid, ag_id)
    VALUES ('p001', 'ag01'),
           ('p004', 'ag02'),
           ('p007', 'ag03'),
           ('p007', 'ag02'),
           ('p009', 'ag03'),
           ('p004', 'ag03'),
           ('p008', 'ag03'),
           ('p008', 'ag01'),
           ('p009', 'ag02'),
           ('p008', 'ag02'),
           ('p007', 'ag01');

