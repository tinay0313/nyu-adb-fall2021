-- to run this file, run $sqlite3 --
-- and enter command --
-- sqlite> .read q3.sql --

.mode csv

--update filepath to correct directory when running--
.import ./friends.csv friends_table
.schema friends_table

--update filepath to correct directory when running--
.import ./like.csv like_table
.schema like_table

-- person1_friends_like(person1, person2, artist) means --
-- person1 has friend person2 who likes artist a --
CREATE TABLE IF NOT EXISTS person1_friends_like AS
SELECT
    friends_table.person1,
    friends_table.person2,
    like_table.artist
FROM friends_table
INNER JOIN like_table ON
    like_table.person = friends_table.person2;

.schema person1_friends_like
--SELECT person1, person2, artist FROM person1_friends_like; --

-- person2_friends_like(person2, person1, artist) means --
-- person2 has friend person1 who likes artist a --
CREATE TABLE IF NOT EXISTS person2_friends_like AS
SELECT
    friends_table.person2,
    friends_table.person1,
    like_table.artist
FROM friends_table
INNER JOIN like_table ON
    like_table.person = friends_table.person1;

.schema person2_friends_like
-- SELECT person2, person1, artist FROM person2_friends_like; --

-- person1_dont_like(person1, artist) means --
-- person1 doesn't like artist but person1 --
-- has friends who like artist --
CREATE TABLE IF NOT EXISTS person1_dont_like AS
SELECT person1, artist
FROM person1_friends_like
EXCEPT
SELECT person, artist
FROM like_table;

.schema person1_dont_like
-- SELECT person1, artist FROM person1_dont_like; --

-- person2_dont_like(person2, artist) means --
-- person2 doesn't like artist but person2 --
-- has friends who like artist --
CREATE TABLE IF NOT EXISTS person2_dont_like AS
SELECT person2, artist
FROM person2_friends_like
EXCEPT
SELECT person, artist
FROM like_table;

.schema person2_dont_like
-- SELECT person2, artist FROM person2_dont_like; --

CREATE TABLE IF NOT EXISTS person1_should_like AS
SELECT
    person1_dont_like.person1,
    person1_friends_like.person2,
    person1_dont_like.artist
FROM person1_dont_like
INNER JOIN person1_friends_like ON
    person1_dont_like.person1 = person1_friends_like.person1
    AND person1_dont_like.artist = person1_friends_like.artist;

.schema person1_should_like
-- SELECT person1, person2, artist FROM person1_should_like; --

CREATE TABLE IF NOT EXISTS person2_should_like AS
SELECT
    person2_dont_like.person2,
    person2_friends_like.person1,
    person2_dont_like.artist
FROM person2_dont_like
INNER JOIN person2_friends_like ON
    person2_dont_like.person2 = person2_friends_like.person2
    AND person2_dont_like.artist = person2_friends_like.artist;

.schema person2_should_like
-- SELECT person2, person1, artist FROM person2_should_like; --

CREATE TABLE IF NOT EXISTS result AS
SELECT * FROM person1_should_like
UNION
SELECT * FROM person2_should_like;

.schema result

.headers ON
.output q3_result.csv
SELECT * FROM result;