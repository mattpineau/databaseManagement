------Start fresh by dropping necessary tables if they exist-------

DROP TABLE IF EXISTS acting_credits;
DROP TABLE IF EXISTS directing_credits;
DROP TABLE IF EXISTS actors;
DROP TABLE IF EXISTS directors;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS people;

-------------------------Create the tables--------------------------

--People--

CREATE TABLE people  (
    pid         varchar (4) not null,
    first_name  text,
    last_name   text,
    nick_name   text,
    address     text,
    date_birth  date,
    primary key (pid)
);

--Movies--

CREATE TABLE movies  (
    movie_id                    varchar(4) not null,
    title                       text not null,
    year_released               smallint not null,
    dom_box_office_sales_usd    bigint,
    for_box_office_sales_usd    bigint,
    dvd_bluray_sales_usd        bigint,
    primary key (movie_id)
);

--Actors--

CREATE TABLE actors  (
    pid             varchar(4) not null references people(pid),
    hair_color      text,
    eye_color       text,
    height_in       int,
    weight_lbs      int,
    SAG_anniversary date default null,
    net_worth_usd   bigint,
    primary key (pid)
);

--Directors--

CREATE TABLE directors  (
    pid             varchar(4) not null references people(pid),
    film_school     text,
    DG_anniversary  date,
    primary key (pid)
);

--Acting Credits--

CREATE TABLE acting_credits  (
    pid         varchar(4) not null references people(pid),
    movie_id    varchar(4) not null references movies(movie_id),
    character   text not null,
    primary key (pid, movie_id, character)
);

--Directing Credits--

CREATE TABLE directing_credits  (
    pid         varchar(4) not null references people(pid),
    movie_id    varchar(4) not null references movies(movie_id),
    primary key (pid, movie_id)
);


-----------------------Start Populating Tables---------------------

INSERT INTO people (pid, first_name, last_name, date_birth)
    VALUES  ('p007', 'Sean', 'Connery', '1930-08-25'),
            ('p001', 'Robert', 'Downey Jr.', '1965-04-04'),
            ('p002', 'Joseph', 'Wiseman', '1918-05-15'),
            ('p003', 'Christopher', 'Walken', '1943-03-31'),
            ('p004', 'Uma', 'Thurman', '1970-04-29'),
            ('p005', 'Quentin', 'Tarantino', '1963-03-27'),
            ('p006', 'Frankie', 'Muniz', '1985-12-05'),
            ('p008', 'Lucy', 'Liu', '1968-12-02'),
            ('p009', 'Val', 'Kilmer', '1959-12-31'),
            ('p010', 'Stanley', 'Kubrick', '1928-07-26'),
            ('p011', 'Terence', 'Young', '1915-06-20'),
            ('p012', 'Guy', 'Hamilton', '1922-09-16');

INSERT INTO actors (pid, hair_color, eye_color, height_in,                  weight_lbs, net_worth_usd, SAG_anniversary)
    VALUES  ('p007', 'white', 'brown', 74, 210, 300000000, null),
            ('p001', 'brown', 'brown', 69, 187, 170000000, null),
            ('p002', 'black', 'brown', 72, 190, null, null),
            ('p003', 'brown', 'brown', 72, 185, 245000000, null),
            ('p004', 'blonde', 'blue', 71, 142, 45000000, null),
            ('p005', 'brown', 'brown', 73, 196, 100000000, null),
            ('p006', 'brown', 'blue', 65, 155, 40000000, null),
            ('p008', 'black', 'brown', 63, 133, 16000000, null),
            ('p009', 'brown', 'brown', 72, 208, 25000000, null);

INSERT INTO directors (pid, film_school, DG_anniversary)
    VALUES  ('p005', 'none', null),
            ('p010', 'none', null),
            ('p011', null, null),
            ('p012', null, null);

INSERT INTO movies (movie_id, title, year_released,                                             dom_box_office_sales_usd, for_box_office_sales_usd,                         dvd_bluray_sales_usd)
    VALUES  ('m001', 'Dr. No', 1962, 16067035, 43500000, null), 
            ('m002', 'Goldfinger', 1964, 51081062, 73800000, null), 
            ('m003', 'Pulp Fiction', 1994, 107928762, 213928762, null), 
            ('m004', 'Kill Bill: Vol. 1', 2003, 70099045, 180949045, null), 
            ('m005', 'Seven Psychopaths', 2012, 15024049, 4422261, null), 
            ('m006', 'Big Fat Liar', 2002, 47811275, null, null), 
            ('m007', 'Kiss Kiss Bang Bang', 2005, 4243756, 11325713, null), 
            ('m008', 'Dr. Strangelove or: How I Learned to Stop Worrying and Love the Bomb', 1964, 9440272, null, null), 
            ('m009', 'Charlie Bartlett', 2007, 3950294, null, null), 
            ('m010', 'Django Unchained', 2012, 162805434, 263500000, null), 
            ('m011', 'The League of Extraordinary Gentlemen', 2003, 66465204, 113400000, null), 
            ('m012', 'The Shining', 1980, 44017374, null, null);

INSERT INTO acting_credits (pid, movie_id, character)
    VALUES  ('p007', 'm001', 'James Bond'),
            ('p007', 'm002', 'James Bond'),
            ('p007', 'm011', 'Allan Quatermain'),
            ('p001', 'm005', 'Harry Lockhart'),
            ('p001', 'm007', 'Nathan Gardner'),
            ('p002', 'm001', 'Dr. No'),
            ('p003', 'm003', 'Captain Koons'),
            ('p003', 'm005', 'Hans'),
            ('p004', 'm003', 'Mia Wallace'),
            ('p004', 'm004', 'The Bride'),
            ('p005', 'm003', 'Jimmie Dimmick'),
            ('p005', 'm010', 'The LeQuit Dickey Mining Co. Employee'),
            ('p005', 'm010', 'Robert (Bag Head)'),
            ('p006', 'm006', 'Jason Shepherd'),
            ('p008', 'm004', 'O-ren Ishii'),
            ('p009', 'm007', 'Gay Perry');

INSERT INTO directing_credits (pid, movie_id)
    VALUES  ('p005', 'm003'),
            ('p005', 'm004'),
            ('p005', 'm010'),
            ('p010', 'm008'),
            ('p010', 'm012'),
            ('p011', 'm001'),
            ('p012', 'm002');

-----------------Sean Connery Query---------------------------------


SELECT first_name, last_name, people.pid
FROM people
INNER JOIN directing_credits
ON people.pid = directing_credits.pid
INNER JOIN movies
ON directing_credits.movie_id = movies.movie_id
WHERE movies.movie_id in (SELECT acting_credits.movie_id
                          FROM   acting_credits
                          WHERE  acting_credits.pid = 'p007');


